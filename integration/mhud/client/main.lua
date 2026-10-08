-- ==========================================================================
-- MHud - istemci tarafi (FiveM + RedM)
-- Lua <-> NUI koprusu, yasam/arac/konum donguleri, isim etiketleri, exportlar.
-- Kaynak dosyasi ASCII tutulur; ekranda gorunen Turkce metinler NUI tarafindadir.
-- ==========================================================================

local IS_REDM = GetGameName() == 'redm'
local nuiReady = false
local hudVisible = true
local menuOpen = false

-- --------------------------------------------------------------------------
-- NUI gonderimi: degismeyen veriyi tekrar gondermez
-- --------------------------------------------------------------------------
local last = {}

local function encode(t)
  -- yalnizca degisiklik karsilastirmasi icin ucuz bir imza
  return json.encode(t)
end

local function send(action, data, force)
  if not nuiReady then return end
  if not force and data ~= nil then
    local sig = encode(data)
    if last[action] == sig then return end
    last[action] = sig
  end
  SendNUIMessage({ action = action, data = data })
end

-- Kitin genel cagrisi: MH[fn](...) (yalnizca izin verilen fonksiyonlar)
local function call(fn, ...)
  if not nuiReady then return end
  SendNUIMessage({ action = 'mhud', fn = fn, args = { ... } })
end

local function resolveTheme()
  if Config.Theme == 'auto' or Config.Theme == '' or Config.Theme == nil then
    return IS_REDM and 'oldwest' or 'modern'
  end
  return Config.Theme
end

local function pushConfig()
  send('mhud:config', {
    theme = resolveTheme(),
    accent = Config.Accent,
    scale = Config.Scale,
    game = IS_REDM and 'redm' or 'fivem',
    compass = Config.ShowCompass,
    location = Config.ShowLocation and not IS_REDM,
    unit = Config.SpeedUnit,
    crop = Config.Crop,
    platform = Config.CropPlatform
  }, true)
end

RegisterNUICallback('ready', function(_, cb)
  nuiReady = true
  pushConfig()
  cb({ ok = true })
end)

-- --------------------------------------------------------------------------
-- Yasam gostergeleri
-- --------------------------------------------------------------------------
local function round(v) return math.floor(v + 0.5) end
local function clamp(v, a, b) if v < a then return a elseif v > b then return b end return v end

local function readVitalsFiveM(ped, pid)
  local maxHp = GetEntityMaxHealth(ped)
  local hp = GetEntityHealth(ped)
  -- FiveM'de can 100 (olu) ile max (genelde 200) arasindadir
  local health = clamp(round((hp - 100) / math.max(1, maxHp - 100) * 100), 0, 100)
  local armor = clamp(GetPedArmour(ped), 0, 100)
  -- dogal deger "harcanan" stamina'dir; kalan = 100 - deger
  local stamina = clamp(round(100 - GetPlayerSprintStaminaRemaining(pid)), 0, 100)
  local oxygen = nil
  if IsPedSwimmingUnderWater(ped) then
    oxygen = clamp(round(GetPlayerUnderwaterTimeRemaining(pid) / 10.0 * 100), 0, 100)
  end
  return { health = health, armor = armor, stamina = stamina, oxygen = oxygen }
end

local function readVitalsRedM(ped)
  local maxHp = GetEntityMaxHealth(ped)
  local hp = GetEntityHealth(ped)
  local health = clamp(round(hp / math.max(1, maxHp) * 100), 0, 100)
  -- cekirdek degerleri (0-100): 0 = can, 1 = stamina, 2 = dead eye
  local coreHealth  = Citizen.InvokeNative(0x36731AC041289BB1, ped, 0, Citizen.ResultAsInteger())
  local coreStamina = Citizen.InvokeNative(0x36731AC041289BB1, ped, 1, Citizen.ResultAsInteger())
  local coreDeadeye = Citizen.InvokeNative(0x36731AC041289BB1, ped, 2, Citizen.ResultAsInteger())
  local st    = Citizen.InvokeNative(0x775A1CA7893AA8B5, ped, Citizen.ResultAsFloat()) or 0.0
  local stMax = Citizen.InvokeNative(0xCB42AFE2B613EE55, ped, Citizen.ResultAsFloat()) or 0.0
  local stamina = stMax > 0 and clamp(round(st / stMax * 100), 0, 100) or 100
  return {
    health = health, hp = hp, maxHp = maxHp, stamina = stamina,
    cores = { health = coreHealth or 100, stamina = coreStamina or 100, deadeye = coreDeadeye or 100 }
  }
end

CreateThread(function()
  while true do
    Wait(Config.VitalsInterval)
    if nuiReady and hudVisible then
      local ped, pid = PlayerPedId(), PlayerId()
      if IS_REDM then
        send('mhud:vitals', readVitalsRedM(ped))
      else
        send('mhud:vitals', readVitalsFiveM(ped, pid))
        send('mhud:wanted', { level = GetPlayerWantedLevel(pid) })
      end
    end
  end
end)

-- --------------------------------------------------------------------------
-- Silah (FiveM)
-- --------------------------------------------------------------------------
-- NUI tarafi bu isimleri etiket + silueti ile eslestirir (app.js -> WEAPONS)
local WEAPON_NAMES = {
  'WEAPON_PISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_PISTOL50', 'WEAPON_HEAVYPISTOL', 'WEAPON_REVOLVER',
  'WEAPON_MICROSMG', 'WEAPON_SMG', 'WEAPON_ASSAULTSMG', 'WEAPON_COMBATPDW',
  'WEAPON_ASSAULTRIFLE', 'WEAPON_CARBINERIFLE', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_BULLPUPRIFLE',
  'WEAPON_PUMPSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_HEAVYSHOTGUN',
  'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_MARKSMANRIFLE', 'WEAPON_MUSKET'
}
local WEAPON_BY_HASH = {}
for _, n in ipairs(WEAPON_NAMES) do WEAPON_BY_HASH[GetHashKey(n)] = n end
local UNARMED = GetHashKey('WEAPON_UNARMED')

local function readWeapon(ped)
  local hash = GetSelectedPedWeapon(ped)
  if hash == UNARMED or hash == 0 then return false end
  local _, clip = GetAmmoInClip(ped, hash)
  local total = GetAmmoInPedWeapon(ped, hash)
  local clipMax = GetMaxAmmoInClip(ped, hash, true)
  return {
    name = WEAPON_BY_HASH[hash] or 'UNKNOWN',
    clip = clip or 0,
    clipMax = clipMax or 0,
    reserve = math.max(0, (total or 0) - (clip or 0)),
    reloading = IsPedReloading(ped)
  }
end

-- --------------------------------------------------------------------------
-- Arac (FiveM)
-- --------------------------------------------------------------------------
local function readVehicle(ped)
  local veh = GetVehiclePedIsIn(ped, false)
  if veh == 0 then return false end
  local mult = Config.SpeedUnit == 'mph' and 2.236936 or 3.6
  local _, lightsOn, highbeams = GetVehicleLightsState(veh)
  local model = GetEntityModel(veh)
  return {
    speed = round(GetEntitySpeed(veh) * mult),
    rpm = GetVehicleCurrentRpm(veh),
    gear = GetVehicleCurrentGear(veh),
    fuel = round(GetVehicleFuelLevel(veh)),
    engine = clamp(round(GetVehicleEngineHealth(veh) / 10), 0, 100),
    lights = lightsOn == 1 or highbeams == 1,
    locked = GetVehicleDoorLockStatus(veh) >= 2,
    name = GetLabelText(GetDisplayNameFromVehicleModel(model)),
    plate = GetVehicleNumberPlateText(veh)
  }
end

CreateThread(function()
  while true do
    local sleep = 500
    if nuiReady and hudVisible and not IS_REDM then
      local ped = PlayerPedId()
      if Config.ShowWeapon then send('mhud:weapon', readWeapon(ped)) end
      if Config.ShowVehicle then
        local v = readVehicle(ped)
        send('mhud:vehicle', v)
        if v then sleep = Config.VehicleInterval end
      end
      if sleep == 500 then sleep = 150 end
    end
    Wait(sleep)
  end
end)

-- --------------------------------------------------------------------------
-- Konum, yon, saat
-- --------------------------------------------------------------------------
CreateThread(function()
  while true do
    Wait(Config.LocationInterval)
    if nuiReady and hudVisible then
      local data = { hours = GetClockHours(), minutes = GetClockMinutes() }
      if not IS_REDM and Config.ShowLocation then
        local c = GetEntityCoords(PlayerPedId())
        local s1, s2 = GetStreetNameAtCoord(c.x, c.y, c.z)
        data.street = GetStreetNameFromHashKey(s1)
        data.cross = s2 ~= 0 and GetStreetNameFromHashKey(s2) or nil
        data.zone = GetLabelText(GetNameOfZone(c.x, c.y, c.z))
      end
      send('mhud:location', data)
    end
  end
end)

-- Pusula daha sik guncellenir (yalnizca kamera yonu)
CreateThread(function()
  while true do
    Wait(50)
    if nuiReady and hudVisible and Config.ShowCompass then
      local rot = GetGameplayCamRot(2)
      local heading = round((360.0 - rot.z) % 360.0)
      send('mhud:heading', heading)
    end
  end
end)

-- --------------------------------------------------------------------------
-- Isim etiketleri
-- --------------------------------------------------------------------------
CreateThread(function()
  local frame = 0
  while true do
    if not (Config.NameTags and nuiReady and hudVisible) or menuOpen then
      if last['mhud:nametags'] ~= '[]' then send('mhud:nametags', {}) end
      Wait(500)
    else
      Wait(0)
      frame = frame + 1
      if frame % Config.NameTagEveryFrames == 0 then
        local me = PlayerId()
        local myPos = GetEntityCoords(PlayerPedId())
        local list = {}
        for _, pid in ipairs(GetActivePlayers()) do
          if pid ~= me or Config.NameTagShowSelf then
            local ped = GetPlayerPed(pid)
            local pos = GetEntityCoords(ped)
            local dist = #(pos - myPos)
            if dist <= Config.NameTagDistance and HasEntityClearLosToEntity(PlayerPedId(), ped, 17) then
              local onScreen, sx, sy = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z + 1.05)
              if onScreen then
                local k = 1.0 - dist / Config.NameTagDistance
                local hp = GetEntityHealth(ped)
                local maxHp = GetEntityMaxHealth(ped)
                local health = IS_REDM and round(hp / math.max(1, maxHp) * 100) or round((hp - 100) / math.max(1, maxHp - 100) * 100)
                list[#list + 1] = {
                  id = GetPlayerServerId(pid),
                  sid = GetPlayerServerId(pid),
                  name = GetPlayerName(pid),
                  x = sx, y = sy,
                  scale = 0.75 + k * 0.35,
                  alpha = 0.45 + k * 0.55,
                  health = clamp(health, 0, 100),
                  armor = IS_REDM and 0 or GetPedArmour(ped),
                  talking = NetworkIsPlayerTalking(pid),
                  dead = IsPedDeadOrDying(ped, true),
                  dist = round(dist)
                }
              end
            end
          end
        end
        -- etiket konumu her karede degisir; imza kontrolunu atla
        send('mhud:nametags', list, true)
        last['mhud:nametags'] = #list == 0 and '[]' or nil
      end
    end
  end
end)

-- --------------------------------------------------------------------------
-- FiveM: varsayilan HUD parcalarini gizle
-- --------------------------------------------------------------------------
if not IS_REDM then
  CreateThread(function()
    local minimap = nil
    if Config.HideGtaHealthBars then
      minimap = RequestScaleformMovie('minimap')
      while not HasScaleformMovieLoaded(minimap) do Wait(0) end
      SetRadarBigmapEnabled(true, false)
      Wait(0)
      SetRadarBigmapEnabled(false, false)
    end
    while true do
      Wait(0)
      if hudVisible then
        for _, id in ipairs(Config.HideGtaComponents) do HideHudComponentThisFrame(id) end
        if minimap then
          BeginScaleformMovieMethod(minimap, 'SETUP_HEALTH_ARMOUR')
          ScaleformMovieMethodAddParamInt(3)
          EndScaleformMovieMethod()
        end
      end
    end
  end)
end

-- --------------------------------------------------------------------------
-- Istek/yanit (ilerleme, onay, menu)
-- --------------------------------------------------------------------------
local pending, seq = {}, 0
local function request(action, data, cb)
  seq = seq + 1
  data = data or {}
  data.id = seq
  pending[seq] = cb
  send(action, data, true)
  return seq
end
local function resolve(id, ...)
  local cb = pending[id]
  pending[id] = nil
  if cb then cb(...) end
end

RegisterNUICallback('progressDone', function(d, cb) resolve(d.id, d.ok == true) cb({}) end)
RegisterNUICallback('confirmResult', function(d, cb) SetNuiFocus(false, false) resolve(d.id, d.ok == true) cb({}) end)

local menuSelectCb, menuCloseCb = nil, nil
local function closeMenu()
  if not menuOpen then return end
  menuOpen = false
  SetNuiFocus(false, false)
  send('mhud:menu', { open = false }, true)
  if menuCloseCb then local f = menuCloseCb; menuCloseCb = nil; f() end
end
RegisterNUICallback('menuSelect', function(d, cb) if menuSelectCb then menuSelectCb(d.id, d.value) end cb({}) end)
RegisterNUICallback('menuClose', function(_, cb) closeMenu() cb({}) end)


-- --------------------------------------------------------------------------
-- Sosyal menu: ekip, davetler, kasa, cephanelik, kanallar, arkadaslar, takas
--   exports.mhud:OpenSocial(state, 'channels')   -- state: pages/social.html protokolu
--   Oyuncu eylemleri: AddEventHandler('mhud:social', function(action, data) end)  (istemci)
--                     RegisterNetEvent('mhud:social') ... (sunucu, Config.Social.Server)
-- --------------------------------------------------------------------------
local socialOpen = false

local function closeSocial()
  if not socialOpen then return end
  socialOpen = false
  SetNuiFocus(false, false)
  send('social:close', {}, true)
  TriggerEvent('mhud:socialClosed')
end

local function openSocial(state, section)
  if not Config.Social.Enabled then return end
  socialOpen = true
  SetNuiFocus(true, true)
  send('social:open', { state = state, section = section }, true)
  if Config.Social.Server then TriggerServerEvent('mhud:social', 'ui:open', { section = section }) end
end

RegisterNUICallback('social', function(d, cb)
  cb({})
  local action, data = d.action, d.data or {}
  TriggerEvent('mhud:social', action, data)
  if Config.Social.Server then TriggerServerEvent('mhud:social', action, data) end
end)
RegisterNUICallback('socialClose', function(_, cb) closeSocial() cb({}) end)

RegisterNetEvent('mhud:socialState', function(state) send('social:state', state, true) end)
RegisterNetEvent('mhud:socialPatch', function(patch) send('social:patch', patch, true) end)
RegisterNetEvent('mhud:socialInvite', function(invite) send('social:invite', invite, true) end)
RegisterNetEvent('mhud:socialTrade', function(trade) send('social:trade', trade, true) end)
RegisterNetEvent('mhud:socialOpen', function(state, section) openSocial(state, section) end)
RegisterNetEvent('mhud:socialClose', closeSocial)
RegisterNetEvent('mhud:socialError', function(key) send('social:error', { key = key }, true) end)
RegisterNetEvent('mhud:channelChanged', function(id) send('social:channelChanged', { id = id }, true) end)

-- --------------------------------------------------------------------------
-- Exportlar
--   exports.mhud:Toast({ tone = 'success', title = '...', text = '...' })
--   exports.mhud:Progress({ label = '...', duration = 3000 }, function(ok) end)
-- --------------------------------------------------------------------------
local RPC = { 'toast', 'kill', 'gift', 'announce', 'banner', 'levelUp', 'achievement', 'pickup', 'countdown', 'subtitle', 'hit', 'damageFrom', 'flash',
  'social', 'loot', 'poster', 'telegram', 'headline', 'sign', 'infected', 'horde' }
for _, fn in ipairs(RPC) do
  local name = fn:sub(1, 1):upper() .. fn:sub(2)
  exports(name, function(...) call(fn, ...) end)
end

exports('Call', call)
exports('Send', function(action, data) send(action, data, true) end)
exports('SetTheme', function(theme, accent)
  Config.Theme = theme or Config.Theme
  if accent ~= nil then Config.Accent = accent end
  pushConfig()
end)
exports('SetVisible', function(show)
  hudVisible = show and true or false
  send('mhud:visible', { show = hudVisible }, true)
end)
-- Yayin istatistikleri / hazir duzenler: alan adlari games/README.md'de
exports('SetStats', function(tbl) send('game:set', tbl or {}, true) end)
exports('SetTeam', function(list) send('game:team', list or {}, true) end)
exports('SetQueue', function(list) send('game:queue', list or {}, true) end)
exports('SetCrop', function(mode, platform)
  Config.Crop = mode or 'none'
  if platform ~= nil then Config.CropPlatform = platform end
  pushConfig()
end)
exports('SetMoney', function(cash, bank) send('mhud:money', { cash = cash, bank = bank }) end)
exports('SetObjective', function(obj) send('mhud:objective', obj or false, true) end)
exports('SetMarkers', function(list) send('mhud:markers', list or {}, true) end)
exports('Progress', function(opts, cb) return request('mhud:progress', opts, cb) end)
exports('CancelProgress', function(id) send('mhud:progressCancel', { id = id }, true) end)
exports('Confirm', function(opts, cb)
  SetNuiFocus(true, true)
  return request('mhud:confirm', opts, cb)
end)
exports('OpenMenu', function(menu, onSelect, onClose)
  menuSelectCb, menuCloseCb = onSelect, onClose
  menuOpen = true
  SetNuiFocus(true, false)  -- klavye NUI'de, fare oyunda kalsin
  send('mhud:menu', { open = true, menu = menu }, true)
end)
exports('CloseMenu', closeMenu)

exports('OpenSocial', openSocial)
exports('CloseSocial', closeSocial)
exports('IsSocialOpen', function() return socialOpen end)
exports('SetSocial', function(state) send('social:state', state or {}, true) end)
exports('PatchSocial', function(patch) send('social:patch', patch or {}, true) end)
exports('SocialInvite', function(invite) send('social:invite', invite, true) end)
exports('OpenTrade', function(trade) SetNuiFocus(true, true) send('social:trade', trade, true) end)
exports('UpdateTrade', function(trade) send('social:trade', trade, true) end)
exports('CloseTrade', function() send('social:trade', { close = true }, true) if not socialOpen then SetNuiFocus(false, false) end end)
exports('IsMenuOpen', function() return menuOpen end)

-- Sunucudan tetikleme: TriggerClientEvent('mhud:call', src, 'toast', { ... })
RegisterNetEvent('mhud:call', function(fn, ...) call(fn, ...) end)
RegisterNetEvent('mhud:money', function(cash, bank) send('mhud:money', { cash = cash, bank = bank }) end)

-- --------------------------------------------------------------------------
-- Komutlar
-- --------------------------------------------------------------------------
if Config.CommandTheme and Config.CommandTheme ~= '' then
  RegisterCommand(Config.CommandTheme, function(_, args)
    Config.Theme = args[1] or 'auto'
    Config.Accent = args[2] or Config.Accent
    pushConfig()
  end, false)
end

RegisterCommand('mhud_crop', function(_, args)
  Config.Crop = args[1] or 'none'
  Config.CropPlatform = args[2] or Config.CropPlatform
  pushConfig()
end, false)

if Config.CommandDemo and Config.CommandDemo ~= '' then
  RegisterCommand(Config.CommandDemo, function()
    send('mhud:demo', { game = IS_REDM and 'redm' or 'fivem' }, true)
  end, false)
end

if Config.Social.Command and Config.Social.Command ~= '' then
  RegisterCommand(Config.Social.Command, function()
    if socialOpen then closeSocial() return end
    -- Bos durumla acilir; kanallar sunucudan (server/channels.lua), ekip verisi oyun modundan gelir.
    openSocial({ me = { id = GetPlayerServerId(PlayerId()), name = GetPlayerName(PlayerId()), cash = 0 } }, 'channels')
  end, false)
  if Config.Social.Key and Config.Social.Key ~= '' then
    RegisterKeyMapping(Config.Social.Command, 'MHud: ekip ve kanal menusu', 'keyboard', Config.Social.Key)
  end
end

if Config.CommandMenu and Config.CommandMenu ~= '' then
  RegisterCommand(Config.CommandMenu, function()
    -- etiketler NUI tarafinda (app.js -> DEMO_MENU) Turkce olarak tanimli
    exports.mhud:OpenMenu({ demo = true }, function(id, value)
      call('toast', { tone = 'accent', title = tostring(id), text = value and tostring(value) or nil, duration = 2000 })
    end)
  end, false)
end

AddEventHandler('onResourceStop', function(res)
  if res == GetCurrentResourceName() and (menuOpen or socialOpen) then SetNuiFocus(false, false) end
end)
