# MHud — yönergeler

- `kit/` ve `games/` tek doğru kaynaktır. `integration/mhud/html/kit` ve `html/games` kopyadır; değişiklikten sonra `npm run sync` çalıştır (kopyalar .gitignore'da).
- `dist/` derleme çıktısıdır (`npm run build`), elle düzenleme ve git'e ekleme.
- Sürüm: `CHANGELOG.md` güncelle → `npm version <x.y.z>` → `git push --follow-tags` (CI yayınlar).
- Saf HTML/CSS + küçük vanilla JS. Framework, derleme adımı, CDN yok. Yazı tipleri ve ikonlar yerel kalır.
- Önekler: sınıf `mh-`, CSS değişkeni `--mh-`, veri özniteliği `data-mh-*`. Durumlar `is-*`, tonlar `.mh-t-*`.
- Renkler token üzerinden (`rgb(var(--mh-…-rgb) / a)`); bileşende sabit renk yazma. Temaya özgü süsleme yalnızca `themes/*.css` içinde.
- `.mh-panel::before/::after` temalara ayrılmıştır; bileşenler kullanmaz.
- Değer güncellemeleri `transform`/`opacity` ile yapılır; `left/top/width` yazma (layout tetikler).
- Arayüz metinleri Türkçe (UTF-8, diakritikli); sınıf/değişken adları ve yorumlar İngilizce ya da Türkçe olabilir.
  Lua kaynak dosyaları ASCII tutulur; ekranda görünen Türkçe metin NUI (JS/HTML) tarafındadır.
- Yeni bileşen = kit CSS'ine stil + gerekiyorsa `mhud.js`'e API + ilgili `pages/*.html` demosuna örnek kart.
- Her değişiklikten sonra demo sayfalarını altı temada (modern, neon, tactical, frontier, oldwest, minimal) kontrol et.
- Yayın düzenlerini kırpmada da kontrol et: `games/<oyun>/index.html?demo=1&crop=vertical&platform=tiktok` ve `crop=square`.
- `oldwest` kâğıt yüzeyleri koyu mürekkep tokenlarını yeniden tanımlar; yeni bir panel bileşeni eklersen `themes/oldwest.css` içindeki kâğıt kapsam listesine ekle.
- İkonlar `tools/build-icons.cjs` (`npm run icons`) ile üretilir; `kit/js/mhud-icons.js` dosyasını elle düzenleme.
