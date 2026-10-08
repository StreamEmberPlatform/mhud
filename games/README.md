# MHud — hazır oyun düzenleri

Her klasör, canlı yayında kullanılmaya hazır tek sayfalık bir HUD'dur. Hepsi `kit/`'i kullanır ve **aynı veri protokolünü** konuşur.

| Düzen | Tema | Öne çıkanlar | Nerede çalışır |
|---|---|---|---|
| `gta5/` | modern | seviye/leş/ölüm/G-M şeridi, para, aranma, etki kuyruğu, düşman sayacı, büyük can, silah | FiveM NUI |
| `rdr2/` | oldwest | rütbe şeridi, saat, $ kuruşlu para, ödül, çekirdekler, tabela/telgraf/afiş/gazete | RedM NUI |
| `l4d2/` | tactical + crimson | hayatta kalan kartları, özel düşman, sürü, kurtarma sayacı, ayağa kaldırma, eşya yuvaları | OBS + WebSocket |
| `arena/` | neon | skor + kombo, can kalpleri, boss barı, sıralama, meydan okuma, hediye haritası | her HTML oyun / OBS |

## URL parametreleri

| Parametre | Örnek | Anlamı |
|---|---|---|
| `demo` | `?demo=1` | sahne arka planı + sahte veri akışı (tarayıcıda denemek için) |
| `theme`, `accent` | `?theme=frontier&accent=gold` | düzenin varsayılan temasını ezer |
| `crop`, `platform`, `guide` | `?crop=vertical&platform=tiktok&guide=1` | yayın kırpması (`square`, `vertical`, `portrait`) |
| `ws` | `?ws=ws://127.0.0.1:8787` | WebSocket köprüsüne bağlanır (otomatik yeniden dener) |
| `scale`, `noscale` | `?scale=1.1` | 1080p referansına ek ölçek / ölçeklemeyi kapat |

## Mesajlar

Kaynak ne olursa olsun mesaj `{ action, data }` biçimindedir:

- FiveM/RedM: `SendNUIMessage({ action = 'game:set', data = { hp = 80 } })` ya da `exports.mhud:SetStats({ hp = 80 })`
- WebSocket: `{"action":"game:set","data":{"hp":80}}`
- Aynı sayfada / iframe: `MH.route({...})` · `iframe.contentWindow.postMessage({...}, '*')`

### `game:set` — sayılar (yalnız değişenleri gönder)

`level xp xpMax` · `hp hpMax armor` · `onScreen queued maxEnemies` · `kills specials deaths wins losses` ·
`streak combo score lives` · `wave chapter rescue(saniye)` · `cash bank gold wanted bounty clock weather region` ·
`health stamina deadeye horse` (`{ value, core }`) · `boss bossName bossHp bossHpMax` · `challenge challengeMax challengeTitle` ·
`reviving revive reviveLabel reviver` · `history: 'WWLD'`.

### Olaylar

| action | data |
|---|---|
| `game:kill` | `{ actor, victim, weapon, headshot, self }` |
| `game:gift` | `{ from, name, art, tier, coins, count, effect, effectIcon }` |
| `game:social` | `{ kind: join\|follow\|share\|like\|sub, name }` |
| `game:weapon` | `{ name, label, clip, clipMax, reserve, reloading }` — `clip` yoksa yakın dövüş |
| `game:queue` | `[{ icon, text, tone, time, running }]` |
| `game:objective` | `{ kicker, title, timer, steps: [{ text, done, active, failed, count }], progress }` |
| `game:leaderboard` | `[{ name, value, icon, self, avatar }]` |
| `game:team` | `[{ name, hp, hpMax, temp, state: down\|bw\|dead, self, items, avatar }]` |
| `game:loadout` | `[{ key, art: 'w:shotgun' \| 'i:pills', label, active, empty }]` |
| `game:infected` / `game:horde` | `{ name, icon, boss, hint, kicker }` / `{ title, sub }` |
| `game:poster` `telegram` `headline` `sign` | Eski Batı baskı nesneleri (kit API'siyle aynı seçenekler) |
| `game:toast` `announce` `banner` `levelUp` `achievement` `pickup` `loot` `countdown` `subtitle` | kit bildirimleri |
| `game:hit` / `game:damage` | `{ head, kill }` / `{ angle }` |
| `game:crop` `game:theme` `game:visible` `game:scale` | `{ mode, platform, guide }` · `{ theme, accent }` · `{ show }` · `{ scale }` |

Düzenler `integration/mhud` resource'unun kendi mesajlarını (`mhud:config`, `mhud:vitals`, `mhud:money`, `mhud:wanted`,
`mhud:weapon`, `mhud:objective`) da anlar; resource'un `ui_page`'ini bir düzene çevirmek yeterlidir.

## Kendi düzenini yapmak

```html
<html class="mh-nui"><link rel="stylesheet" href="../../kit/css/mhud.css"><link rel="stylesheet" href="../shared/mhgame.css">
<body class="mh"><div class="mh-screen">
  <b data-g="kills">0</b>                                     <!-- sayı -->
  <div class="mh-bar mh-t-health" data-g-bar="hp"><i class="mh-bar__fill"></i></div>
  <div data-g-level="wanted"><i data-i="star"></i>…</div>    <!-- ilk N çocuğa .on -->
  <div data-g-show="boss">…</div>  <div data-g-hide="dead">…</div>
  <div class="mh-panel mh-enemy" data-g-enemies>…</div>       <!-- onScreen / queued -->
  <div data-g-team></div> <div data-g-loadout></div> <div data-g-queue="4"><div data-g-queue-list></div></div>
</div>
<script src="../../kit/js/mhud-icons.js"></script><script src="../../kit/js/mhud.js"></script><script src="../shared/mhgame.js"></script>
<script>MHGame.boot({ game: 'benim', theme: 'neon', defaults: { hp: 100 }, demo: function (G) { /* ?demo=1 */ } })</script>
```

Sayı biçimleri: `data-decimals="2"` (212,40), `data-compact` (12,4 B), `data-raw`, `data-instant` (animasyonsuz).
Kırpmada gizle/göster: `mh-hide-crop`, `mh-hide-vertical`, `mh-only-crop`, `mh-only-vertical`; dikeyde kaydır: `mh-v-offset` + `--mh-v-offset`.

## WebSocket köprüsü (HTML arayüzü olmayan oyunlar)

Sayfa açılınca köprüye `{ action: 'hello', data: { client: 'mhud', version } }` gönderir ve kopunca 1,5 sn arayla yeniden bağlanır.
Köprü; bir SourceMod eklentisinin, oyun günlüğünün ya da TikTok/EulerStream olaylarının ürettiği satırları yukarıdaki JSON biçimine çevirip yayınlar.
`MH.post(...)` çağrıları da (ör. menü seçimi) aynı soket üzerinden geri gider.
