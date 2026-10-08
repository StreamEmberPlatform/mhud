# Değişiklik günlüğü

Sürümler [SemVer](https://semver.org/lang/tr/) izler. CDN'de her zaman tam sürüm kullanın (`@1.2.0`).

## 1.2.0 — 2026-10-08
- İlk npm sürümü: `@streamemberplatform/mhud` (dist/ tek dosya CSS ve JS, jsDelivr/unpkg).
- Ekip & kanallar menüsü (`kit/js/mhud-social.js`): ekip, davetler, kasa, cephanelik, rütbe izinleri,
  kanallar (routing bucket), arkadaşlar, gelen kutusu, takas.
- Genel modal sistemi: `MH.modal`, `MH.choose`, `MH.amount`; `MH.confirm` / `MH.input` bunun üstüne taşındı.
- FiveM/RedM resource: sosyal menü exportları, `server/channels.lua` kanal yöneticisi, F5 / `/mhud_social`.
- Görsel düzeltmeler: basılı tut halkası, Old West anahtar ve radyal menü, düğmelerde optik ortalama.

## 1.1.0
- Old West teması ve baskı nesneleri (afiş, damga, telgraf, gazete, tabela).
- Kare/dikey yayın kırpması (`MH.crop`), yayıncı istatistikleri.
- Oyun düzenleri: GTA V, Red Dead, Left 4 Dead 2, HTML5 (`games/`), WebSocket köprüsü (`MH.connect`).
- Material Design Icons tabanlı ikon seti.

## 1.0.0
- Beş temalı HUD kiti ve FiveM/RedM resource'u.
