-- ==========================================================================
-- MHud - kanal yoneticisi (sunucu)
-- "Kanal" = ayni sunucuda ayri bir dunya. FiveM/RedM routing bucket kullanir:
-- ayni bucket'taki oyuncular birbirini, araclarini ve olusturdugu nesneleri gorur;
-- baska bucket'takiler gorunmez ve etkilesemez. Ana dunya = bucket 0.
--
-- NUI'den gelen eylemler (client -> TriggerServerEvent('mhud:social', action, data)):
--   ui:open, channel:create, channel:join, channel:leave, channel:invite,
--   channel:update, channel:close, invite:accept, invite:decline
-- Diger eylemler (crew:*, vault:*, armory:*, friend:*, trade:*, player:*) bu dosyada
-- islenmez; oyun modun dinlesin:
--   AddEventHandler('mhud:socialAction', function(src, action, data) ... end)
--
-- Exportlar:
--   exports.mhud:GetPlayerChannel(src)          -> kanal id ('main' = ana dunya)
--   exports.mhud:SetPlayerChannel(src, id)      -> true/false, hata
--   exports.mhud:CreateChannel(opts, ownerSrc)  -> id   opts: { name, mode, max, password, persistent }
--   exports.mhud:CloseChannel(id)
--   exports.mhud:GetChannels()                  -> tablo
-- Kaynak ASCII tutulur; ekranda gorunen Turkce metin NUI tarafindadir.
-- ==========================================================================

if not Config.Channels or not Config.Channels.Enabled then return end

local C = Config.Channels
local channels = {}      -- id -> { id, name, mode, max, password, owner, ownerName, bucket, members = { [src] = true }, persistent, hidden, crew }
local playerChan = {}    -- src -> id
local invites = {}       -- src -> { [inviteId] = { channel = id, expires = os.time() } }
local nextBucket, nextId, nextInvite = 1000, 1, 1

local MODES = { free = true, deathmatch = true, race = true, survival = true, heist = true, event = true, private = true, western = true }

local function count(t) local n = 0 for _ in pairs(t) do n = n + 1 end return n end
local function trim(s, n) s = tostring(s or ''):gsub('^%s+', ''):gsub('%s+$', '') return s:sub(1, n or 28) end
local function toast(src, tone, icon, title, text)
  TriggerClientEvent('mhud:call', src, 'toast', { tone = tone, icon = icon, title = title, text = text, duration = 3200 })
end

local function mainCount()
  local n = 0
  for _, id in ipairs(GetPlayers()) do if (playerChan[tonumber(id)] or 'main') == 'main' then n = n + 1 end end
  return n
end

-- NUI'ye giden liste (sifreler gonderilmez)
local function listFor(src)
  local cur = playerChan[src] or 'main'
  local list = { { id = 'main', mode = 'free', players = mainCount(), max = GetConvarInt('sv_maxclients', 48), system = true } }
  for id, ch in pairs(channels) do
    if not ch.hidden or id == cur or ch.owner == src then
      local item = { id = id, name = ch.name, mode = ch.mode, players = count(ch.members), max = ch.max, locked = ch.password ~= nil and ch.password ~= '',
        owner = ch.ownerName, crew = ch.crew or nil }
      if id == cur then
        item.members = {}
        for m in pairs(ch.members) do item.members[#item.members + 1] = { name = GetPlayerName(m), host = (m == ch.owner) or nil } end
      end
      list[#list + 1] = item
    end
  end
  table.sort(list, function(a, b) if a.system then return true elseif b.system then return false end return (a.players or 0) > (b.players or 0) end)
  return list
end

local function push(src)
  TriggerClientEvent('mhud:socialPatch', src, { channels = { current = playerChan[src] or 'main', list = listFor(src), anyoneCanCreate = C.AllowCreate } })
end
local function pushAll() for _, id in ipairs(GetPlayers()) do push(tonumber(id)) end end

local function moveEntityToBucket(src, bucket)
  SetPlayerRoutingBucket(src, bucket)
  if C.MoveVehicle then
    local ped = GetPlayerPed(src)
    local veh = ped and GetVehiclePedIsIn(ped, false) or 0
    if veh and veh ~= 0 then SetEntityRoutingBucket(veh, bucket) end
  end
end

local function deleteChannel(id)
  local ch = channels[id]; if not ch then return end
  for m in pairs(ch.members) do
    playerChan[m] = 'main'
    moveEntityToBucket(m, 0)
    TriggerEvent('mhud:channelChanged', m, 'main', id)
  end
  channels[id] = nil
end

local function setChannel(src, id, password, force)
  id = id or 'main'
  local old = playerChan[src] or 'main'
  if old == id then return true end
  local ch = channels[id]
  if id ~= 'main' then
    if not ch then return false, 'yok' end
    if not force and count(ch.members) >= ch.max then return false, 'dolu' end
    if not force and ch.password and ch.password ~= '' and ch.password ~= password then return false, 'sifre' end
  end
  if old ~= 'main' and channels[old] then
    channels[old].members[src] = nil
    if count(channels[old].members) == 0 and not channels[old].persistent then channels[old] = nil
    elseif channels[old].owner == src then
      local heir = next(channels[old].members)
      channels[old].owner = heir; channels[old].ownerName = heir and GetPlayerName(heir) or nil
    end
  end
  if id == 'main' then moveEntityToBucket(src, 0) else ch.members[src] = true; moveEntityToBucket(src, ch.bucket) end
  playerChan[src] = id
  TriggerEvent('mhud:channelChanged', src, id, old)
  TriggerClientEvent('mhud:channelChanged', src, id)
  pushAll()
  return true
end

local function createChannel(opts, owner)
  if count(channels) >= C.MaxChannels then return nil, 'limit' end
  local id = opts.id or ('ch' .. nextId); nextId = nextId + 1
  local bucket = nextBucket; nextBucket = nextBucket + 1
  local mode = MODES[opts.mode] and opts.mode or 'private'
  channels[id] = {
    id = id, name = trim(opts.name, 28), mode = mode, max = math.max(2, math.min(tonumber(opts.max) or 8, C.MaxPlayers)),
    password = (opts.password and opts.password ~= '') and tostring(opts.password):sub(1, 16) or nil,
    owner = owner, ownerName = owner and GetPlayerName(owner) or nil, bucket = bucket, members = {},
    persistent = opts.persistent == true, hidden = opts.hidden == true, crew = opts.crew == true
  }
  SetRoutingBucketPopulationEnabled(bucket, C.Population == true)
  SetRoutingBucketEntityLockdownMode(bucket, C.LockdownMode or 'relaxed')
  return id
end

local function sendInvite(from, to, chId)
  local ch = channels[chId]; if not ch then return end
  invites[to] = invites[to] or {}
  local iid = 'chi' .. nextInvite; nextInvite = nextInvite + 1
  invites[to][iid] = { channel = chId, expires = os.time() + C.InviteSeconds }
  TriggerClientEvent('mhud:socialInvite', to, { id = iid, kind = 'channel', from = GetPlayerName(from), target = ch.name,
    mode = ch.mode, players = count(ch.members), max = ch.max, expires = C.InviteSeconds, total = C.InviteSeconds })
end

local function errorToast(src, why)
  local map = { yok = 'kanal_yok', dolu = 'kanal_dolu', sifre = 'sifre_yanlis', limit = 'kanal_limiti', yetki = 'yetki_yok' }
  -- Metin NUI tarafinda Turkcelestirilir (app.js -> MHUD_ERRORS); burada yalnizca anahtar gider
  TriggerClientEvent('mhud:socialError', src, map[why] or tostring(why))
end

-- Hazir kanallar
for _, p in ipairs(C.Presets or {}) do
  createChannel({ id = p.id, name = p.name, mode = p.mode, max = p.max, password = p.password, persistent = true })
end

RegisterNetEvent('mhud:social', function(action, data)
  local src = source
  data = type(data) == 'table' and data or {}
  if action == 'ui:open' or action == 'ui:section' then
    if action == 'ui:open' or data.section == 'channels' then push(src) end

  elseif action == 'channel:create' then
    if not C.AllowCreate then return errorToast(src, 'yetki') end
    if #trim(data.name) < 3 then return end
    local id, err = createChannel({ name = data.name, mode = data.mode, max = data.max, password = data.password, hidden = data.hidden, crew = data.crew }, src)
    if not id then return errorToast(src, err) end
    setChannel(src, id, nil, true)
    if data.crew then TriggerEvent('mhud:channelCrewMove', src, id) end   -- oyun modu ekip uyelerini davet etsin

  elseif action == 'channel:join' then
    local ok, err = setChannel(src, tostring(data.id), data.password)
    if not ok then return errorToast(src, err) end
    if data.crew then TriggerEvent('mhud:channelCrewMove', src, tostring(data.id)) end

  elseif action == 'channel:leave' then
    setChannel(src, 'main')

  elseif action == 'channel:invite' then
    local chId = data.id or playerChan[src]
    if not chId or chId == 'main' or not channels[chId] then return end
    for _, target in ipairs(data.ids or {}) do
      target = tonumber(target)
      if target and GetPlayerName(target) then sendInvite(src, target, chId) end
    end

  elseif action == 'channel:update' then
    local ch = channels[data.id]
    if not ch or ch.owner ~= src then return errorToast(src, 'yetki') end
    ch.name = trim(data.name or ch.name, 28)
    ch.mode = MODES[data.mode] and data.mode or ch.mode
    ch.max = math.max(count(ch.members), math.min(tonumber(data.max) or ch.max, C.MaxPlayers))
    if data.password ~= nil then ch.password = data.password ~= '' and tostring(data.password):sub(1, 16) or nil end
    ch.hidden = data.hidden == true
    pushAll()

  elseif action == 'channel:close' then
    local ch = channels[data.id]
    if not ch or ch.owner ~= src then return errorToast(src, 'yetki') end
    deleteChannel(data.id); pushAll()

  elseif action == 'invite:accept' and type(data.id) == 'string' and data.id:sub(1, 3) == 'chi' and invites[src] and invites[src][data.id] then
    local inv = invites[src][data.id]; invites[src][data.id] = nil
    if inv.expires < os.time() then return errorToast(src, 'yok') end
    local ok, err = setChannel(src, inv.channel, nil, false)
    if not ok and err == 'sifre' then ok, err = setChannel(src, inv.channel, nil, true) end   -- davetli sifresiz girer
    if not ok then errorToast(src, err) end

  elseif action == 'invite:decline' and invites[src] and type(data.id) == 'string' then
    invites[src][data.id] = nil

  else
    TriggerEvent('mhud:socialAction', src, action, data)
  end
end)

AddEventHandler('playerDropped', function()
  local src = source
  local id = playerChan[src]
  if id and channels[id] then
    channels[id].members[src] = nil
    if count(channels[id].members) == 0 and not channels[id].persistent then channels[id] = nil
    elseif channels[id].owner == src then
      local heir = next(channels[id].members)
      channels[id].owner = heir; channels[id].ownerName = heir and GetPlayerName(heir) or nil
    end
  end
  playerChan[src], invites[src] = nil, nil
  pushAll()
end)

exports('GetPlayerChannel', function(src) return playerChan[tonumber(src)] or 'main' end)
exports('SetPlayerChannel', function(src, id) return setChannel(tonumber(src), id, nil, true) end)
exports('CreateChannel', function(opts, owner) return createChannel(opts or {}, owner) end)
exports('CloseChannel', function(id) deleteChannel(id); pushAll() end)
exports('GetChannels', function() return channels end)
