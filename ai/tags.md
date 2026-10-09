# İsim etiketleri
Oyuncu/NPC başında görünen etiketler. Hepsi aynı .mh-tag yapısıdır (satır, barlar, alt satır); biçim .mh-tag--<biçim>, ilişki is-friend / is-enemy / mh-t-team1..5. Çok sayıda etiket için MH.Nametags(world).update(liste); her öğeye variant, role, avatar verilebilir.

## tags.default — Standart
Ad, numara, rozet, can ve zırh barı, alt satır. İlişki: is-friend yeşil, is-enemy kırmızı, takım için mh-t-team1..5. Durum: is-dead, is-talking, is-typing.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag  is-friend"><div class="mh-tag__line"><span class="mh-tag__name">NabeMedia</span><span class="mh-tag__id">12</span><span class="mh-badge mh-t-success">Dost</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div><div class="mh-tag__sub">SVY 38 · 24 M</div></div><div class="mh-tag  is-enemy"><div class="mh-tag__line"><span class="mh-tag__name">Bandit #8</span><span class="mh-tag__id">8</span><span class="mh-badge mh-t-danger">Düşman</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div><div class="mh-tag__sub">SVY 31 · 40 M</div></div><div class="mh-tag  mh-t-team1"><div class="mh-tag__line"><span class="mh-tag__name">RAPAFI</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div><div class="mh-tag__sub">Takım 1</div></div>
</div>
```

## tags.compact — Kompakt
Küçük boy: rozet ve alt satır gizli, ad 13px, bar 56px. Kalabalık sahneler.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--compact is-friend"><div class="mh-tag__line"><span class="mh-tag__name">NabeMedia</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div></div><div class="mh-tag mh-tag--compact is-enemy"><div class="mh-tag__line"><span class="mh-tag__name">Bandit #8</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div></div><div class="mh-tag mh-tag--compact mh-t-team2"><div class="mh-tag__line"><span class="mh-tag__name">MSK</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div></div>
</div>
```

## tags.plate — Plaka
variant: plate. Panel zeminli kutu, üstte ilişki rengi çizgisi; bar tam genişlikte. Okunaklılık gerektiren düz arka planlar için.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--plate is-friend"><div class="mh-tag__line"><span class="mh-tag__name">NabeMedia</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div><div class="mh-tag__sub">SVY 38 · 24 M</div></div><div class="mh-tag mh-tag--plate is-enemy"><div class="mh-tag__line"><span class="mh-tag__name">Bandit #8</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div><div class="mh-tag__sub">SVY 31 · 40 M</div></div>
</div>
```

## tags.flag — Bayrak
variant: flag. Solda tonlu şerit, sola yaslı, degrade zemin. Takım HUD hissi.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--flag is-friend"><div class="mh-tag__line"><span class="mh-tag__name">NabeMedia</span><span class="mh-tag__id">12</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div><div class="mh-tag__sub">24 M</div></div><div class="mh-tag mh-tag--flag is-enemy"><div class="mh-tag__line"><span class="mh-tag__name">Bandit #8</span><span class="mh-tag__id">8</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div><div class="mh-tag__sub">40 M</div></div><div class="mh-tag mh-tag--flag mh-t-team3"><div class="mh-tag__line"><span class="mh-tag__name">MSK</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div><div class="mh-tag__sub">55 M</div></div>
</div>
```

## tags.pill — Hap
variant: pill. Tek satır kapsül: ikon/avatar, ad, küçük can çizgisi. Avatar için öğeye avatar:'NM'.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--pill is-friend"><div class="mh-tag__line"><span class="mh-avatar mh-avatar--round">NM</span><span class="mh-tag__name">NabeMedia</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div></div><div class="mh-tag mh-tag--pill is-enemy"><div class="mh-tag__line"><span class="mh-avatar mh-avatar--round">B</span><span class="mh-tag__name">Bandit #8</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div></div><div class="mh-tag mh-tag--pill mh-t-team2"><div class="mh-tag__line"><span class="mh-avatar mh-avatar--round">MS</span><span class="mh-tag__name">MSK</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div></div>
</div>
```

## tags.line — İnce çizgi
variant: line. Yalnız ad ve altında 2px can çizgisi, kutu yok. Minimal, sade dünya.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--line is-friend"><div class="mh-tag__line"><span class="mh-tag__name">NabeMedia</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div></div><div class="mh-tag mh-tag--line is-enemy"><div class="mh-tag__line"><span class="mh-tag__name">Bandit #8</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div></div><div class="mh-tag mh-tag--line mh-t-team1"><div class="mh-tag__line"><span class="mh-tag__name">MSK</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div></div>
</div>
```

## tags.bar-only — Yalnız bar
variant: bar. Ad gizli, sadece can/zırh barı. Düşman kalabalığı ve nişan çevresi için.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--bar is-enemy"><div class="mh-tag__line"><span class="mh-tag__name"></span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div></div><div class="mh-tag mh-tag--bar is-friend"><div class="mh-tag__line"><span class="mh-tag__name"></span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div></div><div class="mh-tag mh-tag--bar mh-t-team2"><div class="mh-tag__line"><span class="mh-tag__name"></span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div></div>
</div>
```

## tags.pointer — İşaretçili
variant: pointer. Altında renkli elmas: etiketin gösterdiği noktayı belli eder. Başka biçimlerle birleşir.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--pill mh-tag--pointer is-friend"><div class="mh-tag__line"><span class="mh-avatar mh-avatar--round">NM</span><span class="mh-tag__name">NabeMedia</span></div></div><div class="mh-tag mh-tag--line mh-tag--pointer is-enemy"><div class="mh-tag__line"><span class="mh-tag__name">Bandit #8</span></div></div>
</div>
```

## tags.banner — Takım afişi
variant: banner. Eğik, ilişki renginde dolu şerit, koyu ad. Dalga ve takım modlarında en okunur biçim.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--banner is-friend"><div class="mh-tag__line"><span class="mh-tag__name">NabeMedia</span></div></div><div class="mh-tag mh-tag--banner is-enemy"><div class="mh-tag__line"><span class="mh-tag__name">Bandit #8</span></div></div><div class="mh-tag mh-tag--banner mh-t-team1"><div class="mh-tag__line"><span class="mh-tag__name">MSK</span></div></div><div class="mh-tag mh-tag--banner mh-t-team3"><div class="mh-tag__line"><span class="mh-tag__name">RAPAFI</span></div></div>
</div>
```

## tags.bracket — Köşeli
variant: bracket. Dört köşe işaretli yarı saydam kutu; hedef çerçevesi gibi. Düşman ve kilitli hedef için.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--bracket is-enemy"><div class="mh-tag__line"><span class="mh-tag__name">Bandit #8</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div><div class="mh-tag__sub">40 M</div></div><div class="mh-tag mh-tag--bracket is-friend"><div class="mh-tag__line"><span class="mh-tag__name">NabeMedia</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div><div class="mh-tag__sub">24 M</div></div>
</div>
```

## tags.role — Rol etiketli
role: üstte küçük rol yazısı (POLİS, SAĞLIK, ŞERİF…), altında ad. Rolü tonlu, mesleği olan oyunlar için.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--plate is-friend"><div class="mh-tag__role">Sağlık</div><div class="mh-tag__line"><span class="mh-tag__name">NabeMedia</span></div><div class="mh-tag__sub">24 M</div></div><div class="mh-tag mh-tag--plate is-enemy"><div class="mh-tag__role">Haydut</div><div class="mh-tag__line"><span class="mh-tag__name">Bandit #8</span></div><div class="mh-tag__sub">40 M</div></div><div class="mh-tag mh-tag--flag mh-t-team1"><div class="mh-tag__role">Şerif</div><div class="mh-tag__line"><span class="mh-tag__name">MSK</span></div><div class="mh-tag__sub">55 M</div></div>
</div>
```

## tags.boss — Boss
variant: boss. Büyük başlık fontu, 200px kalın bar. Tek bir hedefin öne çıktığı durumlar.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--boss is-enemy"><div class="mh-tag__role">Boss</div><div class="mh-tag__line"><span class="mh-tag__name">Dev Komutan</span></div><div class="mh-tag__bars"><div class="mh-bar mh-t-health" data-v="80"><i class="mh-bar__fill"></i></div><div class="mh-bar mh-t-armor" data-v="50"><i class="mh-bar__fill"></i></div></div><div class="mh-tag__sub">SVY 60</div></div>
</div>
```

## tags.npc — NPC
variant: npc. Sade, yumuşak; konuşulabilir karakter. İkon ile etkileşimi belirtir (icon:'chat').
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--npc mh-tag--line"><div class="mh-tag__line"><i class="mh-i" data-i="chat"></i><span class="mh-tag__name">Satıcı Hasan</span></div><div class="mh-tag__sub">Konuşmak için E</div></div><div class="mh-tag mh-tag--npc mh-tag--line"><div class="mh-tag__line"><i class="mh-i" data-i="cash"></i><span class="mh-tag__name">Bankacı</span></div><div class="mh-tag__sub">Konuşmak için E</div></div>
</div>
```

## tags.far — Uzaktaki
variant: far. Uzak mesafede sönük, sadece ad. Mesafeye göre alpha/scale zaten verilir.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--far is-friend"><div class="mh-tag__line"><span class="mh-tag__name">NabeMedia</span></div><div class="mh-tag__sub">180 M</div></div><div class="mh-tag mh-tag--far is-enemy"><div class="mh-tag__line"><span class="mh-tag__name">Bandit #8</span></div><div class="mh-tag__sub">210 M</div></div>
</div>
```

## tags.bounty — Ödül etiketi
variant: bounty. Kâğıt yaftası: ad ve ödül tutarı. Western modları; oldwest temasında kendi kâğıt dokusunu alır.
JS: `MH.Nametags(world).update([{ id, x, y, name, health, tone, variant }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--bounty"><div class="mh-tag__line"><span class="mh-tag__name">Amiral Router</span></div><div class="mh-tag__sub">$500 · ARANIYOR</div></div>
</div>
```

## tags.status — Konuşuyor / yazıyor / ölü
Durum sınıfları herhangi bir biçimle birleşir: is-talking (yeşil + mikrofon), is-typing (…), is-dead (sönük, üstü çizili, kuru kafa).
JS: `MH.Nametags(world).update([{ id, x, y, name, talking, typing, dead }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end">
<div class="mh-tag mh-tag--flag is-talking is-friend"><div class="mh-tag__line"><span class="mh-tag__voice"><i class="mh-i" data-i="mic"></i></span><span class="mh-tag__name">NabeMedia</span></div><div class="mh-tag__sub">Konuşuyor</div></div><div class="mh-tag mh-tag--flag is-typing is-enemy"><div class="mh-tag__line"><span class="mh-tag__name">Bandit #8</span></div><div class="mh-tag__sub">Yazıyor</div></div><div class="mh-tag mh-tag--flag is-dead mh-t-team1"><div class="mh-tag__line"><i class="mh-i" data-i="skull"></i><span class="mh-tag__name">MSK</span></div><div class="mh-tag__sub">Öldü</div></div>
</div>
```

## tags.bubble — Konuşma balonu
bubble: etiketin üstünde kısa sohbet metni (yayıncı/izleyici mesajı); 220px'e kadar kayar.
JS: `MH.Nametags(world).update([{ id, x, y, name, bubble: 'Merhaba' }])`

```html
<div class="mh-flex" style="gap:28px;align-items:flex-end"><div class="mh-tag is-friend"><div class="mh-tag__bubble">Merhaba! Yardıma geliyorum.</div><div class="mh-tag__line"><span class="mh-tag__name">NabeMedia</span></div></div></div>
```
