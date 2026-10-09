# Temel parçalar
Her yerde kullanılan yapı taşları: panel, düğme, rozet, çip, tuş ipucu, form alanları, sekme, tablo, avatar. Önce bunları kullan; yeni stil yazma.

## base.panel — Panel
Temel kutu. Başlık için .mh-panel__head (kicker + sağda mh-count). Dar kutu için style=&quot;--w:300px&quot;.
JS: `—`

```html
<div class="mh-panel" style="--w:280px"><div class="mh-panel__head" style="padding:10px 14px"><span class="mh-kicker">Başlık</span><span class="mh-count" style="margin-left:auto">3</span></div><div style="padding:0 14px 14px" class="mh-sub">İçerik buraya.</div></div>
```

## base.button — Düğme
Varyantlar: --primary (ana), varsayılan, --ghost (hafif), --tone + mh-t-* (renkli). Boyut --sm. Tuş ipucu için içine mh-key koy.
JS: `el.disabled = true`

```html
<div class="mh-flex mh-gap-2"><button class="mh-btn mh-btn--primary">Onayla</button><button class="mh-btn">Normal</button><button class="mh-btn mh-btn--ghost">Vazgeç</button><button class="mh-btn mh-btn--tone mh-t-danger">Sil</button><button class="mh-btn mh-btn--primary mh-btn--sm"><span class="mh-key mh-key--sm">E</span>Küçük</button></div>
```

## base.badge — Rozet
Küçük etiket: ton mh-t-*; --pill yuvarlak, --dot nokta, --live nabız. Hem metin hem durum için.
JS: `—`

```html
<div class="mh-flex mh-gap-2"><span class="mh-badge">Varsayılan</span><span class="mh-badge mh-t-success">Hazır</span><span class="mh-badge mh-t-gold">MVP</span><span class="mh-badge mh-badge--pill mh-badge--dot mh-t-info">32 / 64</span><span class="mh-badge mh-badge--dot mh-badge--live mh-t-danger">Canlı</span></div>
```

## base.chip — Çip
Filtre/seçenek hapı; seçili is-active.
JS: `el.classList.toggle('is-active')`

```html
<div class="mh-flex mh-gap-2"><button class="mh-chip is-active">Tümü</button><button class="mh-chip">Silah</button><button class="mh-chip">Araç</button></div>
```

## base.keys — Tuş ve ipucu
mh-key tek tuş (--sm/--lg); mh-hints içinde mh-hint = tuş(lar) + açıklama. Tuşlar yan yana kombinasyon olur.
JS: `—`

```html
<div class="mh-hints"><span class="mh-hint"><span class="mh-key">E</span>Kapıyı aç</span><span class="mh-hint"><span class="mh-key">SHIFT</span><span class="mh-key">E</span>Zorla</span></div>
```

## base.field — Metin alanı
Etiketli giriş: label.mh-field içinde kicker + input.mh-input. Çok satır için textarea.mh-input.mh-textarea, seçim için select.mh-input.mh-select.
JS: `input.value`

```html
<div class="mh-col" style="gap:10px;--w:280px"><label class="mh-field"><span class="mh-kicker">Oyuncu adı</span><input class="mh-input" value="Amiral Router"></label><label class="mh-field"><span class="mh-kicker">Not</span><textarea class="mh-input mh-textarea" rows="2">Merhaba</textarea></label><label class="mh-field"><span class="mh-kicker">Sunucu</span><select class="mh-input mh-select"><option>İstanbul</option><option>Frankfurt</option></select></label></div>
```

## base.toggle — Anahtar ve onay kutusu
mh-toggle (aç/kapa anahtarı) ve mh-check (kutu). İkisi de label içinde input[type=checkbox] + gösterge span.
JS: `input.checked`

```html
<div class="mh-col" style="gap:10px"><label class="mh-toggle"><input type="checkbox" checked><span class="mh-toggle__track"></span>Kırpma kılavuzu</label><label class="mh-check"><input type="checkbox" checked><span class="mh-check__box"></span>Sesli sohbet</label></div>
```

## base.slider — Kaydırıcı
input.mh-slider; data-out='#id' ve data-unit ile değeri başka öğeye yazar (MH.mount bağlar).
JS: `MH.mount(root)`

```html
<div class="mh-flex mh-gap-2" style="--w:300px"><input type="range" class="mh-slider" min="0" max="100" value="64" data-out="#sv" data-unit="%"><b class="mh-num" id="sv" style="min-width:40px;text-align:right">64%</b></div>
```

## base.stepper — Seçici (stepper)
◀ değer ▶ seçici: data-mh-stepper='A|B|C', başlangıç data-index. MH.mount oluşturur.
JS: `MH.mount(root)`

```html
<div class="mh-stepper" data-mh-stepper="Kolay|Normal|Zor|Kabus" data-index="1"></div>
```

## base.tabs — Sekmeler
data-mh-tabs butonları is-active ile çalıştırır. Butona mh-count rozeti eklenebilir.
JS: `MH.mount(root)`

```html
<div class="mh-tabs" data-mh-tabs="" style="width:100%"><button class="is-active">Silahlar</button><button>Askerler <span class="mh-count">3</span></button><button>Atlar</button></div>
```

## base.table — Tablo
mh-table: sağa hizalı sütun için th/td class='r'; sayı mh-num; satır durumu is-self (sen), is-dead; sıra mh-rank is-1/2/3.
JS: `—`

```html
<table class="mh-table" style="--w:340px"><thead><tr><th>#</th><th>Oyuncu</th><th class="r">Puan</th></tr></thead><tbody>
<tr><td><span class="mh-rank is-1">1</span></td><td>NabeMedia</td><td class="r mh-num">2.410</td></tr>
<tr class="is-self"><td><span class="mh-rank is-2">2</span></td><td>Amiral Router</td><td class="r mh-num">2.180</td></tr>
<tr class="is-dead"><td><span class="mh-rank is-3">3</span></td><td>MSK</td><td class="r mh-num">1.320</td></tr></tbody></table>
```

## base.avatar — Avatar
Baş harfli yuvarlak/kare avatar: boyut --sm/--lg, --round, ton mh-t-*; is-live canlı yayın çerçevesi.
JS: `—`

```html
<div class="mh-flex mh-gap-2"><span class="mh-avatar mh-avatar--sm">A</span><span class="mh-avatar mh-t-team1">NM</span><span class="mh-avatar mh-avatar--lg mh-avatar--round is-live">S</span></div>
```

## base.spinner — Yükleniyor
Dönen gösterge.
JS: `—`

```html
<span class="mh-spinner"></span>
```
