# Bildirim ve akış
Ekrana kısa süre düşen JS bileşenleri: toast, ölüm akışı, hediye, duyuru, görev şeridi, seviye atlama, başarım, eşya alma, geri sayım, altyazı, ilerleme. Hepsi tek çağrı; HTML yazılmaz. Kapsayıcıyı kendileri .mh-screen içinde açar.

## feed.toast — Toast
Köşe bildirimi: ton info|success|warn|danger|accent|legendary, süre ms (0 = kalıcı), en fazla 5 adet. text düz metindir; html: true ile HTML.

```js
MH.toast({ tone: 'success', title: 'Kaydedildi', text: 'Ayarların güncellendi.', meta: 'az önce', duration: 5000 });
```

## feed.toast-action — Toast + eylem
Düğmeli bildirim (davet, onay). actions: [{ label, key, primary, onClick }]; düğmeye basınca kapanır.

```js
MH.toast({ tone: 'accent', icon: 'user-plus', title: 'Ekip daveti', text: '<b>NabeMedia</b> seni ekibine davet ediyor.', html: true, duration: 9000, actions: [{ label: 'Kabul et', key: 'Y', primary: true }, { label: 'Reddet', key: 'N' }] });
```

## feed.kill — Ölüm akışı
Sağ üst akış satırı: öldüren, silah, ölen. self: true senin öldürmen (vurgulu), death: true senin ölümün (kırmızı), headshot: true. weapon: silah çizim adı.

```js
MH.kill({ actor: 'Amiral Router', victim: 'Haydut', weapon: 'carbine', headshot: true, self: true });
```

## feed.gift — Hediye kartı
Yayın hediyesi: gönderen, hediye adı, art (emoji | 'i:ikon' | resim adresi), adet, coins, tier. Aynı key canlıyken gelirse yeni kart açılmaz, kombo sayacı zıplar.

```js
MH.gift({ key: 'lion', from: 'NabeMedia', name: 'Aslan', art: '🦁', count: 1, coins: 29999, tier: 'legendary' });
```

## feed.announce — Duyuru
Ekran ortası büyük duyuru: kicker, title, sub. Yeni dalga, tur başı gibi anlar için.

```js
MH.announce({ kicker: 'Yeni dalga', title: 'Dalga 8', sub: 'Zırhlı düşmanlar yaklaşıyor', duration: 3500 });
```

## feed.banner — Görev şeridi
Görev sonu şeridi: ortadan genişler, ödüller sırayla düşer. fail: true başarısızlık.

```js
MH.banner({ title: 'Görev tamamlandı', sub: 'Konvoy baskını · 08:42', rewards: [{ value: '+$25.000', label: 'Ödeme', tone: 'success' }, { value: '+1.250', label: 'RP' }, { value: 'Altın', label: 'Derece', tone: 'gold' }] });
```

## feed.levelup — Seviye atlama
Seviye rozeti + açılan özellikler listesi.

```js
MH.levelUp({ level: 43, unlocks: ['Ağır zırh', '+1 envanter slotu'] });
```

## feed.achievement — Başarım
Alt kenardan kayan başarım bildirimi: ad, puan, ikon.

```js
MH.achievement({ name: 'Keskin nişancı', points: '+50', icon: 'trophy' });
```

## feed.pickup — Eşya alma
Sol alt köşe kısa liste: ikon, ad, miktar. Negatif miktar kırmızı (harcama).

```js
MH.pickup({ icon: 'bullets', name: 'Tüfek mermisi', amount: 30 });
```

## feed.countdown — Geri sayım
Ekran ortasında 3-2-1 + go yazısı. onTick(n) her adımda çağrılır.

```js
MH.countdown(3, { go: 'Başla' });
```

## feed.subtitle — Altyazı
Alt orta konuşma altyazısı: speaker, text, color; boxed: true kutulu (parlak sahnelerde okunur).

```js
MH.subtitle({ speaker: 'Lester', text: 'Kamyonu limana getir. Polis peşindeyse önce onlardan kurtul.', boxed: false });
```

## feed.progress — İlerleme çubuğu
İşlem çubuğu (arama, tamir, hack): label, icon, duration ms. Promise döner (bitince true, iptalde false); .cancel() iptal eder.

```js
MH.progress({ label: 'Kasa açılıyor', icon: 'lock', duration: 3000 }).then(function (ok) { console.log(ok ? 'bitti' : 'iptal'); });
```
