# MHud — yönergeler

- `kit/` tek doğru kaynaktır. `dist/` derleme çıktısıdır (`npm run build`), elle düzenleme ve git'e ekleme.
- `catalog/<aile>.html` bileşen kataloğudur: her `<section data-id data-title data-use [data-js]>` bir varyant. `npm run site` (build + catalog) galeriyi `_site/` içine, `AI.md` ve `ai/*.md` dosyalarını üretir. Bu üç çıktıyı elle düzenleme; `AI.md` ve `ai/` git'e girer (npm paketiyle yayınlanır), CI güncelliğini denetler.
- Yeni bileşen veya varyant = `kit/css`'e stil + gerekiyorsa `mhud.js`'e API + ilgili `catalog/<aile>.html`'e bölüm. Katalogda olmayan bileşen yapay zekanın göremeyeceği bileşendir. Katalog derlemesi, parçadaki her `mh-*` sınıfının CSS'te var olduğunu doğrular.
- Sürüm: `CHANGELOG.md` güncelle → `npm version <x.y.z>` → `git push --follow-tags` (CI yayınlar).
- Saf HTML/CSS + küçük vanilla JS. Framework, derleme adımı, CDN yok. Yazı tipleri ve ikonlar yerel kalır.
- Önekler: sınıf `mh-`, CSS değişkeni `--mh-`, veri özniteliği `data-mh-*`. Durumlar `is-*`, tonlar `.mh-t-*`.
- Renkler token üzerinden (`rgb(var(--mh-…-rgb) / a)`); bileşende sabit renk yazma. Temaya özgü süsleme yalnızca `themes/*.css` içinde.
- Temalar: modern, tactical, frontier, oldwest. Bileşen HTML'i temadan bağımsızdır; tema yalnız `data-mh-theme` ile seçilir.
- `.mh-panel::before/::after` temalara ayrılmıştır; bileşenler kullanmaz.
- Değer güncellemeleri `transform`/`opacity` ile yapılır; `left/top/width` yazma (layout tetikler).
- Arayüz metinleri Türkçe (UTF-8, diakritikli); sınıf/değişken adları ve yorumlar İngilizce ya da Türkçe olabilir.
- Her değişiklikten sonra galeriyi dört temada kontrol et (`npm run site`, `npm run serve`).
- `oldwest` kâğıt yüzeyleri koyu mürekkep tokenlarını yeniden tanımlar; yeni bir panel bileşeni eklersen `themes/oldwest.css` içindeki kâğıt kapsam listesine ekle. Temalar segment (`.mh-pips > i`) gibi temel parçaların geometrisini ezer; yeni varyant bunu aşmalıdır (bkz. `.mh-pips--hearts`).
- İkonlar `tools/build-icons.cjs` (`npm run icons`) ile üretilir; `kit/js/mhud-icons.js` dosyasını elle düzenleme.
- `pages/` (+ `demo/` kabuğu) sunum sayfalarıdır: bileşenlerin bir arada kullanımı, sol menülü. Yalnız galeri sitesine kopyalanır, npm paketine girmez. Bileşenin tek kaynağı yine `catalog/`; büyük bileşen bölümüne `data-wide="1"` ver (galeride tam satır).
