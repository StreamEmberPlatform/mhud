-- MHud ayarlari. Tum degerler tek yerde.
Config = {}

-- Tema: 'auto' = FiveM'de modern, RedM'de oldwest.
-- Secenekler: modern | neon | tactical | frontier | oldwest | minimal
Config.Theme  = 'auto'
Config.Accent = ''          -- bos = temanin kendi rengi. amber | crimson | mint | ice | violet | rose | cyan | lime | gold | tiktok
Config.Scale  = 1.0         -- 1080p referansina gore ek olcek (0.8 - 1.2)

-- Yayin kirpmasi: yayinci oyunun ortasini kare/dikey kirpiyorsa HUD o alana toplanir.
-- none | square | vertical | portrait
Config.Crop         = 'none'
Config.CropPlatform = 'none'  -- none | tiktok | reels | shorts (dikeyde platform butonlarinin alanini bos birakir)

-- Hazir yayin duzeni kullanmak icin fxmanifest.lua'da ui_page satirini degistir:
--   ui_page 'html/games/gta5/index.html'   (ya da rdr2 / l4d2 / arena)
-- Sayilar: exports.mhud:SetStats({ kills = 3, onScreen = 12, queued = 40 })

-- Guncelleme araliklari (ms). Kucuk deger = akici ama pahali.
Config.VitalsInterval   = 150
Config.VehicleInterval  = 60
Config.LocationInterval = 500

-- Isim etiketleri
Config.NameTags          = true
Config.NameTagDistance   = 40.0   -- metre. En buyuk performans kaldiraci budur.
Config.NameTagEveryFrames = 3      -- her N karede bir guncelle (60 FPS'te ~20/sn)
Config.NameTagShowSelf   = false

-- Bilesenler
Config.ShowCompass  = true
Config.ShowLocation = true
Config.ShowWeapon   = true        -- yalnizca FiveM
Config.ShowVehicle  = true        -- yalnizca FiveM
Config.SpeedUnit    = 'kmh'       -- kmh | mph

-- FiveM: varsayilan GTA HUD parcalarini gizle
Config.HideGtaHealthBars = true   -- minimap altindaki can/zirh barlari
Config.HideGtaComponents = { 1, 2, 3, 4, 6, 7, 8, 9, 13 } -- aranma, silah ikonu, nakit, mp nakit, arac adi, bolge, sinif, sokak, para degisimi

-- Komutlar (bos birakirsan kaydedilmez)
Config.CommandTheme = 'mhud_theme'
Config.CommandDemo  = 'mhud_demo'
Config.CommandMenu  = 'mhud_menu'

-- Sosyal menu (ekip, davet, kasa, cephanelik, kanallar, arkadaslar, takas)
Config.Social = {
  Enabled = true,
  Server  = true,          -- eylemleri TriggerServerEvent('mhud:social', action, data) ile sunucuya da gonder
  Command = 'mhud_social', -- menuyu ac/kapat
  Key     = 'F5',          -- RegisterKeyMapping varsayilani (oyuncu Ayarlar > Tus atamalari'ndan degistirebilir; RedM'de bos birak)
}

-- Kanallar = routing bucket. Ayni kanaldakiler birbirini gorur; digerleri gorunmez.
Config.Channels = {
  Enabled        = true,
  AllowCreate    = true,   -- oyuncular kendi kanalini kurabilsin
  MaxChannels    = 40,     -- ayni anda en fazla kanal
  MaxPlayers     = 32,     -- kanal basina ust sinir
  Population     = false,  -- kanalda yapay zeka trafigi/yayalar (false = bos dunya)
  LockdownMode   = 'relaxed', -- 'strict' | 'relaxed' | 'inactive' (istemcinin entity olusturma izni)
  MoveVehicle    = true,   -- arac icindeyken araci da kanala tasi
  InviteSeconds  = 60,     -- kanal davetinin gecerlilik suresi
  -- Sunucu acilisinda hazir gelen kalici kanallar
  Presets = {
    -- { id = 'race1', name = 'Drift bulusmasi', mode = 'race', max = 16 },
  },
}
