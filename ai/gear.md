# Ekipman ve ekip
Silah ve cephane, yuva şeridi, envanter ızgarası, ekip kartları, ses ve bağlantı göstergeleri.

## gear.weapon — Silah paneli
Sağ alt köşe: silah adı, çizimi, şarjör/yedek, şarjör segmentleri, yan eşyalar. is-low şarjör kırmızı, is-reloading soluk.
JS: `MH.pips(el.querySelector('.mh-pips'), 24, 30); el.querySelector('.mh-weapon__clip').textContent = 24`

```html
<div class="mh-weapon">
  <div class="mh-weapon__name"><span class="mh-weapon__reload mh-hidden">Şarjör değişiyor</span><span class="mh-badge">Otomatik</span><span class="mh-kicker">Karabina tüfeği</span></div>
  <div class="mh-weapon__main">
    <i data-weapon="carbine" class="mh-weapon__art"></i>
    <div class="mh-weapon__ammo"><span class="mh-weapon__clip">24</span><span class="mh-weapon__reserve">/ 180</span></div>
  </div>
  <div class="mh-pips" data-pips="24/30" style="gap:2px"></div>
  <div class="mh-weapon__extra"><span><i data-i="grenade"></i>3</span><span><i data-i="first-aid"></i>2</span><span><i data-i="bullets"></i>Zırh delici</span></div>
</div>
```

## gear.ammo — Mermi sayacı
Silah çizimi olmadan yalnız şarjör / yedek. is-low şarjörü kırmızıya çevirir.
JS: `el.querySelector('b').textContent = 24`

```html
<div class="mh-flex" style="gap:26px">
  <div class="mh-ammo"><b>24</b><span>/ 180</span></div>
  <div class="mh-ammo is-low"><b>3</b><span>/ 12</span></div>
</div>
```

## gear.hotbar — Yuva şeridi
Numaralı hızlı yuvalar: is-active seçili, is-cooldown (--cd oran) bekleme, is-empty boş; sayı ve dayanıklılık çubuğu isteğe bağlı.
JS: `el.children[0].classList.add('is-active')`

```html
<div class="mh-hotbar">
  <div class="mh-slot is-active"><span class="mh-slot__key">1</span><i data-i="rifle"></i><span class="mh-slot__count">24</span></div>
  <div class="mh-slot"><span class="mh-slot__key">2</span><i data-i="pistol"></i><span class="mh-slot__count">12</span></div>
  <div class="mh-slot"><span class="mh-slot__key">3</span><i data-i="knife"></i></div>
  <div class="mh-slot is-cooldown" style="--cd:.6"><span class="mh-slot__key">4</span><i data-i="grenade"></i><span class="mh-slot__count">3</span></div>
  <div class="mh-slot is-empty"><span class="mh-slot__key">5</span><i data-i="box"></i></div>
</div>
```

## gear.inventory — Envanter ızgarası
Eşya hücreleri; --cols sütun sayısı. Nadirlik is-rare|is-epic|is-legendary, seçili is-active.

```html
<div class="mh-inv" style="--cols:6;width:300px">
  <div class="mh-cell is-active"><span class="mh-cell__key">1</span><i data-i="rifle"></i><span class="mh-cell__count">1</span></div>
  <div class="mh-cell is-rare"><span class="mh-cell__key">2</span><i data-i="pistol"></i><span class="mh-cell__count">1</span></div>
  <div class="mh-cell"><span class="mh-cell__key">3</span><i data-i="knife"></i></div>
  <div class="mh-cell is-epic"><span class="mh-cell__key">4</span><i data-i="grenade"></i><span class="mh-cell__count">4</span></div>
  <div class="mh-cell"><i data-i="bullets"></i><span class="mh-cell__count">180</span></div>
  <div class="mh-cell is-legendary"><i data-i="diamond"></i><span class="mh-cell__count">2</span></div>
</div>
```

## gear.party — Ekip kartları
Sol kenar ekip listesi: avatar, ad, mesafe, can/zırh ince barları. is-talking konuşuyor, is-down yerde, is-dead ölü.
JS: `MH.bar(el.querySelector('.mh-bar'), 54)`

```html
<div class="mh-party">
  <div class="mh-member is-talking">
    <span class="mh-avatar mh-avatar--sm mh-t-team1">N</span>
    <div class="mh-member__name"><i data-i="crown-f" style="color:var(--mh-warn)"></i><span>NabeMedia</span></div>
    <span class="mh-member__dist">24 m</span>
    <div class="mh-member__bars"><div class="mh-bar mh-t-health" data-v="86"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="40"><i class="mh-bar__fill"></i></div></div>
  </div>
  <div class="mh-member is-down">
    <span class="mh-avatar mh-avatar--sm mh-t-team2">S</span>
    <div class="mh-member__name"><i data-i="heartbeat"></i><span>Serkan_TV · yerde</span></div>
    <span class="mh-member__dist">12 m</span>
    <div class="mh-member__bars"><div class="mh-bar mh-t-danger" data-v="12"><i class="mh-bar__fill"></i></div></div>
  </div>
</div>
```

## gear.squad-rings — Ekip halkaları
Yan yana avatarlar, çevresinde can halkası. Çok oyunculu ekipte en az yer tutan gösterim.
JS: `MH.ring(el, 0.8)`

```html
<div class="mh-flex" style="gap:8px">
  <div class="mh-ringval mh-t-health" data-mh-ring style="--v:.86;width:40px;height:40px"><span class="mh-avatar mh-avatar--sm mh-t-team1">N</span></div>
  <div class="mh-ringval mh-t-health" data-mh-ring style="--v:.54;width:40px;height:40px"><span class="mh-avatar mh-avatar--sm mh-t-team2">M</span></div>
  <div class="mh-ringval mh-t-danger" data-mh-ring style="--v:.12;width:40px;height:40px"><span class="mh-avatar mh-avatar--sm mh-t-team3">S</span></div>
</div>
```

## gear.voice — Ses
Ses menzili çubukları (is-talking konuşurken yeşil) ve konuşanlar listesi; is-radio telsiz.
JS: `el.classList.toggle('is-talking')`

```html
<div class="mh-col mh-gap-2" style="align-items:flex-start">
  <div class="mh-voice-range is-talking"><span class="mh-voice-range__bars"><i class="on"></i><i class="on"></i><i></i></span><span>Normal</span><span class="mh-eq"><i></i><i></i><i></i><i></i></span></div>
  <div class="mh-voice">
    <div class="mh-speaker"><i data-i="mic-f"></i>NabeMedia<span class="mh-eq"><i></i><i></i><i></i><i></i></span></div>
    <div class="mh-speaker is-radio"><i data-i="broadcast"></i>MSK · Telsiz 1</div>
  </div>
</div>
```

## gear.ping — Bağlantı kalitesi
4 çubuklu ping göstergesi: iyi (varsayılan), is-mid orta, is-bad kötü.
JS: `el.classList.add('is-bad')`

```html
<div class="mh-flex" style="gap:18px"><span class="mh-ping"><i></i><i></i><i></i><i></i></span><span class="mh-ping is-mid"><i></i><i></i><i></i><i></i></span><span class="mh-ping is-bad"><i></i><i></i><i></i><i></i></span></div>
```

## gear.teamhead — Takım başlığı
Skor tablosu takım başlığı: ad + büyük sayı; ton mh-t-team1..5.
JS: `el.querySelector('strong').textContent = 3`

```html
<div class="mh-teamhead mh-t-team1" style="width:240px"><b>Mavi takım</b><strong>3</strong></div>
```
