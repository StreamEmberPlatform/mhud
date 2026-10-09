# Menü ve ekranlar
Kart, klasik menü, bağlam menüsü, modal, ayar satırı, envanter ızgarası, skor tablosu, podyum, ölüm/yeniden doğma ekranı, yükleme. Düğme, giriş, sekme gibi temel parçalar için "Temel" ailesine bak.

## menu.card — Eşya kartı
Mağaza/envanter kartı: art alanı (rozet + data-weapon veya ikon), ad, alt satır, fiyat. Nadirlik: is-rare, is-epic, is-legendary; seçili is-active.
JS: `el.classList.toggle('is-active')`

```html
<div class="mh-card is-legendary is-active"><div class="mh-card__art"><span class="mh-badge mh-t-gold">Efsanevi</span><i data-weapon="sniper"></i></div><div class="mh-card__body"><span class="mh-card__name">Keskin nişancı tüfeği</span><span class="mh-card__sub">Tek atış · 900 m</span></div><div class="mh-card__foot"><span class="mh-price">$24.500</span><span class="mh-key mh-key--sm">E</span></div></div>
```

## menu.classic — Klasik menü
Dikey liste menü (GTA Online tarzı): banner, sayaç, satırlar (is-active, is-disabled), sağda ok/onay kutusu/değer, altta açıklama kutusu.
JS: `MH.mount(root)`

```html
<div class="mh-classic" style="--w:380px"> <div class="mh-classic__banner"><b>Etkileşim</b></div> <div class="mh-classic__sub"><span>Ana menü</span><span>1 / 5</span></div> <div class="mh-classic__list">
<div class="mh-classic__item is-active" data-desc="Kıyafet, aksesuar ve dövme seçenekleri."><span>Görünüm</span><em><i data-i="chev-r"></i></em></div>
<div class="mh-classic__item" data-desc="Pasif modda hasar vermez ve almazsın."><span>Pasif mod</span><em><label class="mh-check"><input type="checkbox"><span class="mh-check__box"></span></label></em></div>
<div class="mh-classic__item" data-desc="Ruh halini değiştir."><span>Ruh hali</span><em><div class="mh-stepper" data-mh-stepper="Normal|Mutlu|Sinirli|Yorgun"></div></em></div>
<div class="mh-classic__item" data-desc="Kişisel aracını yakınına çağır."><span>Aracı çağır</span><em class="mh-num">$250</em></div>
<div class="mh-classic__item is-disabled" data-desc="Seviye 50 gerekir."><span>CEO yetkileri</span><em><i data-i="lock"></i></em></div> </div>
<div class="mh-classic__desc"><i data-i="info"></i><span>Kıyafet, aksesuar ve dövme seçenekleri.</span></div> </div>
```

## menu.context — Bağlam menüsü
Küçük açılır menü: başlık, satır (ikon, ad, kısayol tuşu), ayraç, is-active, is-danger. Koddan: MH.context(x, y, [{ icon, label, key, danger, onPick }]).
JS: `MH.context(x, y, items)`

```html
<div class="mh-panel mh-context" style="position:relative"> <div class="mh-context__head"><span class="mh-kicker">NabeMedia üzerinde</span></div>
<button class="mh-context__item"><i data-i="user"></i><span>Profili gör</span><span class="mh-key mh-key--sm">P</span></button>
<button class="mh-context__item is-active"><i data-i="user-plus"></i><span>Ekibe davet et</span></button>
<button class="mh-context__item"><i data-i="cash"></i><span>Para gönder</span><small>$</small></button>
<div class="mh-context__sep"></div>
<button class="mh-context__item is-danger"><i data-i="ban"></i><span>Oyundan at</span></button> </div>
```

## menu.modal — Onay penceresi
Onay/uyarı kutusu. Tehlike için mh-t-danger. Kod: MH.confirm({ title, text, danger }) Promise<bool> döner; MH.input / MH.choose benzeri.
JS: `MH.confirm({ title:'Sil?', text:'Geri alınamaz', danger:true }).then(ok=>…)`

```html
<div class="mh-panel mh-modal mh-t-danger" style="animation:none"> <div class="mh-modal__head"><div class="mh-modal__icon"><i data-i="alert"></i></div><div class="mh-modal__titles"><div class="mh-title">Eşyayı yok et?</div><div class="mh-sub">Bu işlem geri alınamaz.</div></div></div>
<div class="mh-modal__actions"><button class="mh-btn mh-btn--ghost"><span class="mh-key mh-key--sm">ESC</span>Vazgeç</button><button class="mh-btn mh-btn--tone mh-t-danger"><span class="mh-key mh-key--sm">ENTER</span>Yok et</button></div> </div>
```

## menu.radial — Radyal menü
Daire dilimli seçim: MH.radial(el, [{ icon, label, desc, disabled }], { title, hint, size, onPick }). Fare dilime gelince merkezde ad/açıklama görünür.

```js
var host = document.createElement('div');
host.style.cssText = 'position:fixed;left:50%;top:50%;transform:translate(-50%,-50%);z-index:50';
(document.querySelector('.mh-screen') || document.body).appendChild(host);
MH.radial(host, [
  { icon: 'user', label: 'Profil', desc: 'Karakter bilgisi' },
  { icon: 'bag', label: 'Envanter', desc: 'Eşyaları aç' },
  { icon: 'pin', label: 'Konum', desc: 'Konum paylaş' },
  { icon: 'lock', label: 'Kilitli', desc: 'Seviye 50', disabled: true },
  { icon: 'car', label: 'Araç', desc: 'Aracı çağır' }
], { title: 'Hızlı menü', size: 360, onPick: function () { host.remove(); } });
```

## menu.setting — Ayar satırı
Sol metin (başlık + açıklama), sağda kontrol: mh-slider (data-out, data-unit ile değer yazılır), mh-toggle, mh-select.
JS: `MH.mount(root)`

```html
<div class="mh-setting"><div class="mh-setting__text"><b>HUD ölçeği</b><span>Tüm arayüzü büyütür veya küçültür</span></div><div class="mh-setting__control"><input type="range" class="mh-slider" min="70" max="130" value="100" data-out="#o1" data-unit="%"><b id="o1">100%</b></div></div>
```

## menu.inventory — Envanter ızgarası
--cols ile sütun sayısı. Hücre: ikon, tuş numarası (__key), adet (__count); is-active seçili, nadirlik is-rare/is-epic/is-legendary.
JS: `el.style.setProperty('--cols', 7)`

```html
<div class="mh-inv" style="--cols:6">
<div class="mh-cell is-active"><span class="mh-cell__key">1</span><i data-i="rifle"></i><span class="mh-cell__count">1</span></div>
<div class="mh-cell is-rare"><span class="mh-cell__key">2</span><i data-i="pistol"></i><span class="mh-cell__count">1</span></div>
<div class="mh-cell"><span class="mh-cell__key">3</span><i data-i="knife"></i></div>
<div class="mh-cell is-epic"><span class="mh-cell__key">4</span><i data-i="grenade"></i><span class="mh-cell__count">4</span></div>
<div class="mh-cell"><i data-i="first-aid"></i><span class="mh-cell__count">3</span></div>
<div class="mh-cell is-legendary"><i data-i="diamond"></i><span class="mh-cell__count">2</span></div>
</div>
```

## menu.standings — Sıralama listesi
Köşe sıralaması: mh-rank (is-1/2/3 madalya renkleri), ad, değer. Kendi satırın is-self.
JS: `el.querySelector('.is-self')`

```html
<div class="mh-panel mh-standings" style="--w:240px"> <div class="mh-panel__head" style="padding:10px 12px"><span class="mh-kicker">Sıralama</span><span class="mh-kicker" style="margin-left:auto">Ö / A</span></div>
<div class="mh-standing"><span class="mh-rank is-1">1</span><span>NabeMedia</span><b>14 / 3</b></div>
<div class="mh-standing is-self"><span class="mh-rank is-2">2</span><span>Amiral Router</span><b>11 / 4</b></div>
<div class="mh-standing"><span class="mh-rank is-3">3</span><span>Bandit #8</span><b>9 / 6</b></div>
<div class="mh-standing"><span class="mh-rank">4</span><span>MSK</span><b>7 / 7</b></div> </div>
```

## menu.scoreboard — Skor tablosu
Takım skor tablosu: başlık + istatistikler, takım başlığı (mh-teamhead + mh-t-team1..5), mh-table, ping çubuğu, kendi satırın is-self.
JS: `MH.mount(root)`

```html
<div class="mh-panel mh-scoreboard" style="--w:620px"> <div class="mh-scoreboard__head"><div class="mh-col" style="gap:4px;flex:1"><span class="mh-kicker mh-kicker--accent">Takım ölüm maçı</span><span class="mh-title">Skor tablosu</span></div>
<div class="mh-menu__stats"><div class="mh-stat"><span class="mh-kicker">Tur</span><b>7 / 9</b></div><div class="mh-stat"><span class="mh-kicker">Süre</span><b>01:24</b></div></div></div>
<div class="mh-scoreboard__teams"><div><div class="mh-teamhead mh-t-team1"><b>Mavi takım</b><strong>3</strong></div>
<table class="mh-table"><thead><tr><th>Oyuncu</th><th class="r">Ö</th><th class="r">A</th><th class="r">Skor</th><th class="r">Ping</th></tr></thead><tbody>
<tr><td>NabeMedia</td><td class="r mh-num">14</td><td class="r mh-num">3</td><td class="r mh-num">2.410</td><td class="r"><span class="mh-ping"><i></i><i></i><i></i><i></i></span></td></tr>
<tr class="is-self"><td>Amiral Router</td><td class="r mh-num">11</td><td class="r mh-num">4</td><td class="r mh-num">2.180</td><td class="r"><span class="mh-ping"><i></i><i></i><i></i><i></i></span></td></tr>
</tbody></table></div></div> </div>
```

## menu.podium — Podyum
İlk üç: slot sırası 2-1-3, her slotta oyuncu (avatar + ad + alt satır) ve numaralı blok. Madalya tonu mh-t-gold/silver/bronze.
JS: `—`

```html
<div class="mh-podium">
<div class="mh-podium__slot is-2"><div class="mh-podium__who"><span class="mh-avatar mh-t-silver">AR</span><b>Amiral Router</b><span class="mh-sub">11 öldürme</span></div><div class="mh-podium__block"><strong>2</strong><span>2.180 puan</span></div></div>
<div class="mh-podium__slot is-1"><div class="mh-podium__who"><i data-i="crown-f" style="width:28px;height:28px;color:rgb(var(--mh-gold-rgb))"></i><span class="mh-avatar mh-t-gold">NM</span><b>NabeMedia</b><span class="mh-badge mh-t-gold">MVP</span></div><div class="mh-podium__block"><strong>1</strong><span>2.410 puan</span></div></div>
<div class="mh-podium__slot is-3"><div class="mh-podium__who"><span class="mh-avatar mh-t-bronze">B</span><b>Bandit #8</b><span class="mh-sub">9 öldürme</span></div><div class="mh-podium__block"><strong>3</strong><span>1.760 puan</span></div></div>
</div>
```

## menu.dead — Ölüm ekranı
Büyük 'Öldün' başlığı, öldüren kartı (avatar, silah, mesafe, istatistikler) ve altta yeniden doğma halkası (data-mh-ring, --v 0..1) ile tuş ipuçları.
JS: `MH.ring(el, v)`

```html
<div class="mh-dead" style="position:relative;inset:auto;min-height:380px"> <span class="mh-kicker" style="letter-spacing:.4em">Etkisiz hale getirildin</span> <div class="mh-dead__title">Öldün</div>
<div class="mh-panel mh-killer"> <span class="mh-avatar mh-avatar--lg mh-t-team2">B</span> <div class="mh-col" style="gap:3px"><span class="mh-kicker">Öldüren</span><b style="font-size:18px">Bandit #8</b><span class="mh-sub">Pompalı tüfek · 14 m</span></div>
<div class="mh-killer__stats"><div><span class="mh-kicker">Can</span><b class="mh-tone mh-t-danger">38</b></div><div><span class="mh-kicker">Zırh</span><b>0</b></div></div> </div>
<div class="mh-respawn" style="margin-top:12px"> <div class="mh-respawn__ring" data-mh-ring style="--v:.6"><b>8</b></div> <div class="mh-col" style="gap:6px"><span class="mh-kicker">Yeniden doğma</span><div class="mh-hints"><span class="mh-hint"><span class="mh-key">E</span>Hastanede doğ</span><span class="mh-hint"><span class="mh-key">G</span>Ekibi izle</span></div></div> </div> </div>
```

## menu.results — Maç sonucu
Maç bitişi: üstte başlık (Zafer/Yenilgi) ve alt satır; podyum ayrı varyant.
JS: `—`

```html
<div class="mh-results" style="position:relative;width:auto"> <div class="mh-results__title"><span class="mh-kicker mh-kicker--accent" style="letter-spacing:.4em">Maç bitti · 5 – 3</span><b>Zafer</b><span class="mh-sub">Mavi takım Vinewood'u ele geçirdi</span></div> </div>
```

## menu.loading — Yükleme ekranı
Tam ekran: arka plan (__art), başlık/alt metin/rozetler (__main), altta ipucu ve ilerleme (__foot).
JS: `el.querySelector('.mh-bar').dataset.v = 50; MH.mount(root)`

```html
<div style="position:relative;width:960px;height:540px;overflow:hidden"><div style="position:absolute;left:0;top:0;width:1920px;height:1080px;transform:scale(.5);transform-origin:0 0"><div class="mh-loading"> <div class="mh-loading__art"></div> <div class="mh-loading__main"><span class="mh-kicker mh-kicker--accent" style="letter-spacing:.3em">Stream Ember sunar</span><div class="mh-title">Event Fabric</div><div class="mh-flex mh-gap-2"><span class="mh-badge mh-badge--pill mh-badge--dot mh-t-success">32 / 64 oyuncu</span><span class="mh-badge mh-badge--pill">Ping 18 ms</span></div></div>
<div class="mh-loading__foot"><div class="mh-loading__tip"><span class="mh-kicker">İpucu</span><p>F1 ile etkileşim menüsünü açabilirsin.</p></div> <div class="mh-loading__progress"><div class="mh-loading__status"><span>Haritalar yükleniyor</span><b>62%</b></div><div class="mh-bar mh-bar--stripe mh-t-accent" data-v="62"><i class="mh-bar__fill"></i></div></div></div> </div></div></div>
```
