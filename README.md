# MHud

[![npm](https://img.shields.io/npm/v/@streamemberplatform/mhud?color=f5b83d&label=npm)](https://www.npmjs.com/package/@streamemberplatform/mhud)
[![jsDelivr](https://img.shields.io/jsdelivr/npm/hm/@streamemberplatform/mhud?color=f5b83d)](https://www.jsdelivr.com/package/npm/@streamemberplatform/mhud)
[![license](https://img.shields.io/badge/license-MIT-f5b83d)](LICENSE)

Oyun modları ve canlı yayın oyunları için temalı, bağımlılıksız HUD ve arayüz kiti — FiveM, RedM, OBS tarayıcı kaynağı
ve her HTML5 oyunu. Aynı HTML işaretlemesi altı temaya bürünür: GTA V'in modern dili (`modern`, `neon`, `tactical`,
`minimal`), RDR2'nin western dili (`frontier`) ve eski zamanların kâğıt-mürekkep-ahşap dünyası (`oldwest`).

**Canlı demo:** https://streamemberplatform.github.io/mhud/

## Kurulum

**CDN (her projede, derleme gerekmez):**

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@streamemberplatform/mhud@1.2.0/dist/mhud.min.css">
<script src="https://cdn.jsdelivr.net/npm/@streamemberplatform/mhud@1.2.0/dist/mhud.min.js"></script>
```

`dist/mhud.min.js` ikonları, çekirdeği (`window.MH`) ve sosyal menüyü (`MH.Social`, `MH.trade`) içerir.
Oyun düzenleri katmanı ayrıdır: `dist/mhud-game.min.js` + `dist/mhud-game.min.css`. Aynı dosyalar unpkg'de de vardır
(`https://unpkg.com/@streamemberplatform/mhud@1.2.0/dist/mhud.min.css`). **Her zaman tam sürüm yazın** — `@latest`
güncellemede tüm projelerin görünümünü habersizce değiştirir.

**npm:**

```bash
npm i @streamemberplatform/mhud
```

```js
import '@streamemberplatform/mhud/css';   // dist/mhud.css
import '@streamemberplatform/mhud';       // dist/mhud.js → window.MH
```

**Oyun resource'larında (FiveM/RedM NUI) CDN kullanmayın:** dosyaları resource'un içine koyun (`node_modules/@streamemberplatform/mhud/dist`
ya da hazır resource zip'i: GitHub Releases). Oyun içi arayüz internet ve CDN gecikmesine bağlı kalmamalı.

## Geliştirme

```bash
npm install        # esbuild + @mdi/svg
npm run serve      # demo: http://localhost:5173
npm run build      # dist/ (tek dosya CSS/JS, küçültülmüş)
npm run sync       # kit/ + games/ → integration/mhud/html (FiveM/RedM resource)
npm run icons      # kit/js/mhud-icons.js'i yeniden üret
```

**Sürüm yayınlamak:** `CHANGELOG.md`'yi güncelle, sonra
`npm version 1.2.1 -m "v%s"` → `git push --follow-tags`. `v*` etiketi GitHub Actions'ta derler, npm'e yayınlar
(`NPM_TOKEN` gizli anahtarı) ve resource zip'ini Release'e ekler. `main`'e her itme demo sitesini GitHub Pages'e yayınlar.

---

## Klasör yapısı

```
mhud/
├─ package.json · CHANGELOG.md · LICENSE · .github/workflows (release, pages)
├─ dist/                      → `npm run build` çıktısı (git'e girmez, npm paketinde var)
├─ index.html                 → demo ana sayfası (tarayıcıda aç, sunucu gerekmez)
├─ pages/                     → kategori başına bir demo sayfası
│  ├─ hud.html                  oyuncu HUD'u
│  ├─ vehicle.html              araç & binek
│  ├─ combat.html               çatışma
│  ├─ mode.html                 oyun modu, skor tablosu, QTE/beceri, ko-op hayatta kalma
│  ├─ world.html                isim etiketleri, işaretçiler, istemler
│  ├─ notifications.html        bildirimler
│  ├─ stream.html               yayın & hediyeler
│  ├─ menus.html                menüler (istatistikler, etkinlikler dahil)
│  ├─ social.html               ekip & kanallar: veri güdümlü sosyal menü + modal sistemi
│  ├─ broadcast.html            kare/dikey yayın kırpması + yayıncı istatistikleri
│  ├─ games.html                oyun ön ayarları vitrini + veri protokolü
│  ├─ western.html              Old West: afiş, damga, telgraf, gazete, tabela
│  ├─ interaction.html          radial, bağlam, modal
│  ├─ screens.html              ölüm, tur sonu, yükleme
│  └─ components.html           temel bileşen kataloğu, gruplu/aranabilir ikonlar, silüetler
├─ games/                     → HAZIR OYUN DÜZENLERİ (yayına uygun HUD'lar)
│  ├─ shared/mhgame.js          ortak veri bağlama (game:set, data-g-*), URL parametreleri
│  ├─ gta5/ · rdr2/ · l4d2/ · arena/   her biri tek index.html
│  └─ README.md                 protokol ve alan listesi
├─ kit/                       → ASIL KİT (tek doğru kaynak)
│  ├─ css/mhud.css              giriş dosyası (diğerlerini sırayla içe aktarır)
│  ├─ css/mhud.tokens.css       tasarım tokenları (varsayılan = modern)
│  ├─ css/mhud.base.css         sıfırlama, çapalar, panel, buton, bar, halka, form…
│  ├─ css/mhud.hud.css          oyuncu HUD'u, araç, mod, savaş, istemler
│  ├─ css/mhud.feed.css         toast, akış, hediye, duyuru, şerit
│  ├─ css/mhud.world.css        isim etiketi, işaretçi, hasar sayısı
│  ├─ css/mhud.menu.css         menüler, skor tablosu, modal, radial, tam ekranlar
│  ├─ css/mhud.stream.css       oylama, hedef, destekçiler, kuyruk
│  ├─ css/mhud.print.css        kâğıt/mürekkep: afiş, damga, telgraf, gazete, defter, kupon, tabela
│  ├─ css/mhud.broadcast.css    kırpma, kılavuz, yayıncı istatistikleri, düşman sayacı, G/M
│  ├─ css/mhud.extras.css       seri, alan, beceri, QTE, meydan okuma, hediye haritası, ganimet, grafikler
│  ├─ css/mhud.survival.css     hayatta kalanlar, özel düşman, sürü, kurtarma, eşya yuvaları
│  ├─ css/mhud.social.css       sosyal menü, davet kartları, kasa, kanal kartları, takas
│  ├─ css/mhud.tones.css        ton sınıfları (.mh-t-*)
│  ├─ css/themes/*.css          modern, neon, tactical, frontier, oldwest, minimal
│  ├─ css/mhud.accents.css      vurgu rengi seçenekleri
│  ├─ js/mhud-icons.js          337 ikon + 21 takma ad + 7 silah silüeti (SVG sprite, gruplu)
│  ├─ js/mhud.js                davranış katmanı + NUI köprüsü (window.MH)
│  ├─ js/mhud-social.js         isteğe bağlı: ekip/davet/kasa/cephanelik/rütbe/kanal/arkadaş/gelen kutusu/takas menüsü
│  ├─ fonts/                    yerel yazı tipleri (çevrimdışı çalışır)
│  └─ LICENSES.md
├─ integration/mhud/          → FiveM + RedM'de çalışan hazır resource
│  ├─ fxmanifest.lua            games { 'gta5', 'rdr3' }
│  ├─ config.lua
│  ├─ client/main.lua           yaşam/araç/konum döngüleri, etiketler, exportlar, sosyal menü köprüsü
│  ├─ server/channels.lua       kanal yöneticisi (routing bucket): kur, katıl, davet, ayrıl
│  └─ html/                     index.html, app.js, app.css, kit/ + games/ (kopya)
├─ demo/                      → yalnızca tarayıcı demosu (oyuna taşınmaz)
└─ tools/
   ├─ build.mjs                 dist/ üretir (esbuild)
   ├─ sync-resource.mjs         kit/ + games/ → integration/mhud/html kopyalar
   └─ build-icons.cjs           ikon setini MDI + özel ikonlardan yeniden üretir
```

---

## Hızlı başlangıç

**Demoya bakmak için:** `index.html`'i tarayıcıda aç. Soldan tema, vurgu rengi ve arka plan sahnesi değişir.
Sahneler 1920×1080 tuvalde çizilip pencereye sığdırılır; oyundaki gerçek ölçüyü görürsün.

**Oyunda kullanmak için:** `npm run sync` çalıştır (ya da Releases'tan hazır zip'i indir), `integration/mhud` klasörünü sunucunun `resources/` klasörüne kopyala,
`server.cfg`'ye `ensure mhud` ekle. FiveM'de `modern`, RedM'de `oldwest` teması otomatik seçilir.

```
/mhud_demo                 → bildirim vitrini
/mhud_menu                 → klasik menü örneği (↑↓ ←→ Enter, Backspace kapatır)
/mhud_theme oldwest        → tema + vurgu değiştir
/mhud_crop vertical tiktok → dikey yayın kırpması (none | square | vertical | portrait)
```

**Hazır yayın düzeni için:** `fxmanifest.lua`'da `ui_page 'html/games/gta5/index.html'` (ya da `rdr2`, `l4d2`, `arena`)
yap; sayıları `exports.mhud:SetStats({ kills = 3, onScreen = 12, queued = 40 })` ile gönder. Resource'un otomatik
can/para/silah mesajlarını düzenler de anlar. Ayrıntı: `games/README.md`.

**HTML arayüzü olmayan oyunlar (Left 4 Dead vb.):** düzeni OBS'te 1920×1080 saydam tarayıcı kaynağı olarak aç,
veriyi WebSocket'ten ver: `games/l4d2/index.html?ws=ws://127.0.0.1:8787`.

**Kendi resource'unda kullanmak için:** `kit/` klasörünü NUI klasörüne kopyala.

```html
<html class="mh-nui">
<link rel="stylesheet" href="kit/css/mhud.css">
<body class="mh" data-mh-theme="frontier" data-mh-accent="">
  <div class="mh-screen">
    <div class="mh-anchor mh-tr"><div class="mh-toasts" data-mh="toasts"></div></div>
    …
  </div>
  <script src="kit/js/mhud-icons.js"></script>
  <script src="kit/js/mhud.js"></script>
</body>
```

---

## Ekip & kanallar (sosyal menü)

`kit/js/mhud-social.js` veri güdümlü bir menüdür: oyun durumu gönderir, menü çizer, oyuncunun her eylemi
`MH.post('social', { action, data })` ile geri gelir. Menü kendi başına hiçbir şeyi değiştirmez.

| Bölüm | İçerik |
|---|---|
| Genel bakış | üyeler (rütbe, durum, can, konum, başka kanalda mı), yardım et (ayağa kaldır, ilk yardım, zırh, cephane, işaretle, ışınlan, izle), para gönder, mesaj, rütbe ver, at; ekip duyurusu; ekiple kanala geç; ayrıl |
| Davetler | gelen (ekip, kanal, arkadaş, takas, düello, etkinlik; süre çubuğu) / gönderilen (geri al); davet tercihleri |
| Ekip kasası | bakiye, yatır / çek / üyelere dağıt, günlük çekme sınırı, hareket kaydı |
| Cephanelik | silah ve teçhizat kartları, rütbeye göre kilit, al / bırak |
| Rütbeler & izinler | rütbe × izin tablosu (davet, at, kasa, cephanelik, rütbe ver, kanal kur, duyuru) |
| Kanallar | kanal listesi (mod, doluluk, şifre, arkadaşlar), kur / katıl / ayrıl / davet / ayarlar |
| Arkadaşlar | çevrimiçi durumu ve kanalı, kanalına git, ekibe/kanala davet, takas, mesaj, çıkar/engelle |
| Gelen kutusu | ekip duyuruları, sunucu bildirimleri, eylem düğmeli mesajlar |
| Takas | `MH.trade` — iki taraflı pencere, eşya + para, iki taraf “Hazırım” deyince tamamlanır |

```lua
exports.mhud:OpenSocial(state, 'crew')      -- state biçimi: pages/social.html › Protokol
exports.mhud:PatchSocial({ crew = crew })   -- yalnız değişen anahtar
exports.mhud:SocialInvite({ id = 'c9', kind = 'crew', from = 'kaan', target = 'Kızıl Kurtlar', expires = 60, total = 60 })
exports.mhud:OpenTrade({ partner = { name = 'MSK' }, mine = {...}, theirs = {...}, inventory = {...}, cash = 1200 })
AddEventHandler('mhud:social', function(action, data) end)              -- istemci
AddEventHandler('mhud:socialAction', function(src, action, data) end)   -- sunucu (kanal dışı eylemler)
```

**Kanal = routing bucket.** Aynı sunucuda ayrı bir dünya: aynı kanaldakiler birbirini, araçlarını ve oluşturduğu
nesneleri görür; diğer kanallar görünmez. `server/channels.lua` bunu hazır yapar (kur, şifre, kapasite, davet,
kurucu devri, oyuncu çıkınca boş kanalı silme, araçla birlikte taşıma). Ayarlar `Config.Channels`, menü tuşu
`Config.Social.Key` (F5) / `/mhud_social`. Ekip, kasa, cephanelik ve arkadaşlık verisi oyun moduna aittir
(kalıcılık için veritabanı gerekir); MHud yalnız arayüzü ve olay sözleşmesini verir.

**Modal sistemi:** `MH.modal({ title, kicker, who, icon, body, actions, validate })` yığınlanır (ESC/Enter en
üstteki modala gider), formdaki `[name]` alanlarını toplar; `MH.choose` aranabilir tekli/çoklu seçim,
`MH.amount` tutar/adet seçici, `MH.confirm` ve `MH.input` bunların üstüne kurulu.

---

## Temalar

| Tema | Ne zaman | Karakter |
|---|---|---|
| `modern` *(varsayılan)* | FiveM, genel | GTA Online: koyu cam paneller, ince çizgiler, amber vurgu |
| `neon` | Arena, yayın modları | Camgöbeği + magenta, parlayan kenarlar, köşe çentiği |
| `tactical` | Askerî / hayatta kalma | Keskin köşe, köşe braketleri, mono etiketler, sinyal yeşili |
| `frontier` | RedM / western | RDR2: panelsiz HUD, serif, altın saç çizgi + baklava, çekirdek halkaları |
| `oldwest` | RedM, eski zaman havası | Kâğıt doku, mürekkep çerçeve, köşe süsleri, Rye/Old Standard yazıları, ahşap tabela; dünya üstü HUD krem-sepya |
| `minimal` | Düşük FPS, kalabalık sunucu | Bulanıklık/parlama yok, düz yüzey: en ucuz render |

Vurgu rengi temanın rengini ezer: `amber`, `crimson`, `mint`, `ice`, `violet`, `rose`, `cyan`, `lime`, `gold`, `tiktok`.

```html
<body data-mh-theme="neon" data-mh-accent="tiktok">
```
```js
MH.theme('frontier'); MH.accent('gold');
```

Temalar iç içe de çalışır (`data-mh-theme` herhangi bir kapsayıcıya verilebilir).

### Yeni tema eklemek

1. `kit/css/themes/benim.css` oluştur, `[data-mh-theme="benim"] { … }` içinde yalnızca farklı olan tokenları ez
   (`--mh-font-*`, `--mh-surface-rgb`, `--mh-accent-rgb`, `--mh-r-panel`, `--mh-blur`, `--mh-glow-a` …).
2. Gerekirse panel süslemesi için `.mh-panel::before/::after` kullan — bu iki sözde eleman temalara ayrılmıştır.
3. `kit/css/mhud.css` içine tema importunu ekle (vurgu dosyasından önce).

Renkler `r g b` üçlüsüdür; her ton saydamlıkla kullanılabilir: `rgb(var(--mh-accent-rgb) / .4)`.

---

## Resource: mesajlar ve exportlar

### Exportlar (client)

```lua
exports.mhud:Toast({ tone = 'success', title = 'Görev tamamlandı', text = '+$5.000' })
exports.mhud:Gift({ from = 'NabeMedia', name = 'Aslan', art = '🦁', tier = 'legendary', count = 1, coins = 29999, effect = 'Boss geldi' })
exports.mhud:Kill({ actor = 'NabeMedia', victim = 'Bandit', weapon = 'sniper', headshot = true })
exports.mhud:Announce({ kicker = 'Yeni dalga', title = 'Dalga 8' })
exports.mhud:Banner({ title = 'Görev tamamlandı', rewards = { { value = '+$25.000', label = 'Ödeme', tone = 'success' } } })
exports.mhud:LevelUp({ level = 43, unlocks = { 'Ağır zırh' } })
exports.mhud:Achievement({ name = 'Keskin nişancı', points = '+50' })
exports.mhud:Pickup({ icon = 'bullets', name = 'Tüfek mermisi', amount = 30 })
exports.mhud:Subtitle({ speaker = 'Lester', text = '…' })
exports.mhud:Countdown(3)

exports.mhud:SetMoney(cash, bank)               -- para çerçeveden bağımsız; ESX/QB/VORP olayına bağla
exports.mhud:SetObjective({ kicker, title, timer, steps = { { text, done, active, count } }, progress })
exports.mhud:SetMarkers({ { id, x, y, icon, label, dist, tone, pulse } })   -- x/y: 0-1 ekran oranı
exports.mhud:SetTheme('neon', 'cyan')
exports.mhud:SetVisible(false)

exports.mhud:Progress({ label = 'Kilit açılıyor', icon = 'pick', duration = 3000 }, function(ok) end)
exports.mhud:Confirm({ title = 'Emin misin?', text = '…', danger = true }, function(ok) end)
exports.mhud:OpenMenu({ title = 'Garaj', subtitle = 'Araçlar', items = {
  { id = 'car1', label = 'Zentorno', desc = '…', right = '$250' },
  { id = 'paint', label = 'Renk', options = { 'Siyah', 'Beyaz' } },
  { id = 'neon', label = 'Neon', check = false },
} }, function(id, value) end, function() --[[ kapandı ]] end)
exports.mhud:Call('fn', ...)                    -- MH[fn](...) — izinli liste: MH.rpcAllow

-- v1.1 · SetStats / SetTeam / SetQueue hazır oyun düzenleri (games/) içindir
exports.mhud:SetStats({ level = 24, kills = 132, deaths = 3, wins = 5, losses = 2, onScreen = 14, queued = 37 })
exports.mhud:SetTeam({ { name = 'Amiral Router', hp = 64, temp = 12, self = true, items = { 'first-aid' } } })
exports.mhud:SetQueue({ { icon = 'skull', text = 'Boss · NabeMedia', tone = 'danger', running = true } })
exports.mhud:SetCrop('vertical', 'tiktok')
exports.mhud:Poster({ name = 'Amiral Router', crime = 'Banka soygunu', reward = '$500', stamp = 'Aranıyor' })
exports.mhud:Telegram({ from = 'Dutch', to = 'Amiral Router', text = 'Rhodes ta is var STOP Gece yarisi', stamp = 'Acil' })
exports.mhud:Headline({ title = 'Valentine Bankası Soyuldu!', deck = '…', body = { '…' } })
exports.mhud:Sign({ kicker = 'Hoş geldiniz', title = 'Valentine', sub = 'Nüfus 312' })
exports.mhud:Social({ kind = 'follow', name = 'RAPAFI' })
exports.mhud:Loot({ tier = 'epic', art = 'w:shotgun', name = 'Pompalı tüfek' })
exports.mhud:Infected({ name = 'Tank', boss = true }); exports.mhud:Horde({ title = 'Sürü geliyor!' })
```

Sunucudan: `TriggerClientEvent('mhud:call', src, 'toast', { tone = 'info', title = '…' })`.

### Kendi NUI'n için mesaj sözleşmesi (Lua → NUI)

| action | data |
|---|---|
| `mhud` | `{ fn = 'toast', args = { {...} } }` — genel çağrı |
| `mhud:config` | `{ theme, accent, scale, game, compass, location, unit, crop, platform }` |
| `mhud:vitals` | `{ health, armor, stamina, oxygen?, cores? = { health, stamina, deadeye } }` (0-100) |
| `mhud:money` | `{ cash, bank }` |
| `mhud:weapon` | `{ name, clip, clipMax, reserve, reloading }` ya da `false` |
| `mhud:vehicle` | `{ speed, rpm, gear, fuel, engine, lights, locked, name, plate }` ya da `false` |
| `mhud:location` / `mhud:heading` | `{ street, zone, cross }` / derece |
| `mhud:nametags` | `[{ id, x, y, scale, alpha, name, sid, health, armor, talking, dead, dist }]` |
| `mhud:menu` | `{ open, menu }` → NUI `menuSelect {id, value}` / `menuClose` gönderir |
| `game:*` | hazır oyun düzenlerinin protokolü — `games/README.md` |

`client/main.lua` değişmeyen veriyi tekrar göndermez (JSON imza karşılaştırması).

---

## JS API (window.MH)

```js
// Tema & ölçek
MH.theme('neon'); MH.accent('cyan'); MH.autoScale({ base: 1080, scale: 1 })

// Değerler
MH.bar('#hp', 64, { critical: 25, max: 100 })    // transform: scaleX — layout yok; hayalet katman otomatik
MH.ring(el, .8)                                  // 0..1
MH.core('#core', { value: 80, core: 60 })        // RDR2 çekirdeği
MH.pips('#clip', 24, 30)
MH.count(el, 15200)                              // sayarak geçer (tr-TR biçimi)
MH.money('#cash', 15200)                         // + "+$1.000" farkı
MH.compass('#compass', heading, [{ bearing, icon, tone }])
MH.speedo('#speedo', { speed, max, rpm, gear })
MH.timer('#timer', 90, { urgent: 10, onEnd })

// Akışlar
MH.toast({ tone, icon, title, text, meta, duration, actions: [{ label, key, primary, onClick }] })
MH.kill({ actor, victim, weapon, headshot, self, death, actorTeam, victimTeam })
MH.gift({ from, name, art, count, coins, tier, effect, key })    // aynı key → kombo
MH.announce({ kicker, title, sub }); MH.banner({ title, sub, rewards, fail })
MH.levelUp({ level, unlocks }); MH.achievement({ name, points, icon })
MH.pickup({ icon, name, amount }); MH.subtitle({ speaker, text, color, boxed })
MH.countdown(3, { go: 'Başla' })

// Etkileşim
await MH.progress({ label, icon, duration })     // true / false; .cancel()
MH.hold('#hold', { duration, onDone }).start()
await MH.confirm({ title, text, danger }); await MH.input({ title, label, value })
MH.radial(el, items, { size, title, onPick }); MH.context(x, y, items, { title })
MH.listNav('#menu', { onChange, onSelect, onBack })

// Dünya
var tags = MH.Nametags('#world'); tags.update(list); tags.clear()
var marks = MH.Markers('#world'); marks.update(list)
MH.damageNumber(world, { x, y, value, kind: 'crit' | 'heal' | 'armor' })
MH.hit(screen, 'head' | 'kill'); MH.damageFrom(screen, angle); MH.vignette(el, health); MH.flash(screen, true)

// Yayın (v1.1)
MH.crop('vertical', { platform: 'tiktok', guide: false })   // 'square' | 'vertical' | 'portrait' | 'wide' | sayı (oran)
MH.enemies(el, { onScreen, queued, max }); MH.stat(kök, 'deaths', 3); MH.history(el, 'WWLWD')
MH.streak(el, 6, { decay: 6000, hot: 5 }); MH.social({ kind: 'follow', name })
MH.sparkline(el, [..]); MH.bars(el, [{ label, value, max, tone }]); MH.columns(el, [{ label, value }])

// Mod parçaları (v1.1)
await MH.skillCheck(el, { key: 'SPACE' })        // 'great' | 'good' | 'miss'
await MH.qte(el, ['W', 'A', 'S', 'D'], { duration: 4000 })   // true / false
MH.zone(el, 60, { warn: 15, onEnd }); MH.loot({ tier, art, name, desc, amount })
MH.infected({ name, icon, boss, hint }); MH.horde({ title, sub })

// Eski Batı / baskı (v1.1)
MH.poster({ name, crime, reward, photo, icon, stamp }); MH.stamp(hedef, 'Ödendi', { tilt: -12 })
MH.telegram({ from, to, text: '… STOP …', stamp }); MH.headline({ mast, date, title, deck, body: [..], icon })
MH.sign({ kicker, title, sub })

// NUI & köprü
MH.on('action', fn); MH.post('callback', data); MH.route({ action, data })
MH.connect('ws://127.0.0.1:8787')                // WebSocket: aynı {action, data} mesajları; MH.post da sokete gider

// Yardımcılar
MH.icon('heart'); MH.weapon('carbine'); MH.fmt(12480); MH.time(84); MH.compact(182000)
```

Bildirimsel (JS yazmadan): `<i data-i="heart">`, `<i data-weapon="carbine">`, `data-mh-ring`, `.mh-bar[data-v]`,
`data-pips="7/10"`, `data-mh-tabs`, `data-mh-seg`, `data-mh-stepper="A|B|C"`, `.mh-slider[data-out]`.
Sonradan HTML eklediysen `MH.mount(kök)` çağır.

---

## Sınıf kuralları

- Tüm sınıflar `mh-` önekli; CSS değişkenleri `--mh-`; veri öznitelikleri `data-mh-*`. Mevcut CSS'inle çakışmaz.
- Blok/eleman/değiştirici: `.mh-weapon__clip`, `.mh-btn--primary`. Durumlar `is-*`: `is-active`, `is-low`, `is-dead`…
- Renk: ton sınıfları `.mh-t-success | info | warn | danger | accent | legendary | gold | health | armor | team1…5 | friend | enemy`.
- Yerleşim: `.mh-screen` (tıklamaları geçirir) › `.mh-anchor .mh-tl | tc | tr | ml | mc | mr | bl | bc | br`.
  Tıklanması gereken her şeye `.mh-catch` ekle.
- İngilizce özel isimler (marka, araç adı) büyük harfe dönüşürken `i → İ` olmasın diye `lang="en"` ver.

---

## Performans

- Barlar `transform: scaleX`, isim etiketleri `translate3d` ile yazılır; layout hesaplanmaz, yalnız compositor çalışır.
- `MH.Nametags` düğüm havuzu tutar; `sig` alanı değişmeyen etiketin HTML'ini yeniden çizmez.
- `Config.NameTagDistance` en büyük kaldıraçtır; `NameTagEveryFrames = 3` gözle fark edilmez, maliyeti üçe böler.
- `backdrop-filter` NUI'de pahalıdır. `minimal`, `frontier` ve `oldwest` temaları bulanıklığı kapatır.
- Kâğıt dokusu tek bir SVG `feTurbulence` veri URL'idir (görsel dosya yok); `oldwest` panelleri bunu kullanır.
- Yazı tipleri ve ikonlar yereldir; ağ isteği yoktur.
- Menü açıkken isim etiketleri boşaltılır. `SetNuiFocus(false, false)` menü kapanırken çağrılır.

## Notlar

- Minimap çerçevesi (`.mh-minimap`) yalnızca süsleme ve etiketlerdir; oyunun kendi minimap'i NUI'nin altında çizilir.
  `--w` / `--h` değerlerini oyundaki minimap boyutuna eşitle.
- RedM çekirdek ve stamina değerleri `Citizen.InvokeNative` ile okunur (`0x36731AC041289BB1`, `0x775A1CA7893AA8B5`,
  `0xCB42AFE2B613EE55`); RedM sürümüne göre canlı oyunda doğrula.
- Silah paneli ve hız göstergesi FiveM natifleriyle beslenir; RedM için kendi döngünü `exports.mhud:Send('mhud:weapon', …)` ile bağla.
- `kit/` ve `games/` tek doğru kaynaktır. Değişiklikten sonra `npm run sync` ile resource'a kopyala (kopyalar git'e girmez).
- Kit `:is()` seçicisi ve CSS `zoom` kullanır: Chromium 88+ gerekir (güncel FiveM/RedM CEF ve OBS tarayıcı kaynağı uygundur).
- İkonlar: Material Design Icons (Apache 2.0) + MHud'a özel çizimler; ayrıntı `kit/LICENSES.md`. İkon eklemek için
  `tools/build-icons.cjs` içindeki gruba `['ad', 'mdi-dosya-adı']` satırı ekle, `npm run icons`.
