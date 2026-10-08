/* ==========================================================================
   MHud Game — oyun hazır düzenleri için ortak çalışma katmanı
   --------------------------------------------------------------------------
   Her oyun düzeni (games/<oyun>/index.html) yalnızca işaretleme + küçük bir
   MHGame.boot({...}) çağrısıdır. Bu dosya:
     • URL parametrelerini okur  (?theme ?accent ?crop ?platform ?guide ?ws ?demo ?scale)
     • tek bir veri protokolü sunar (game:set) — değerler işaretlemedeki
       data-g* özniteliklerine kendiliğinden bağlanır
     • olay mesajlarını (game:kill, game:gift…) kit API'lerine yönlendirir
     • ?demo=1 ile sahne arka planı ve sahte veri akışı başlatır

   Mesaj biçimi her kaynakta aynıdır:
     FiveM/RedM NUI  : SendNUIMessage({ action = 'game:set', data = { hp = 80 } })
     WebSocket (?ws=): {"action":"game:set","data":{"hp":80}}
     Tarayıcı içi    : MH.route({ action: 'game:set', data: { hp: 80 } })

   Bağlama öznitelikleri (anahtar = game:set içindeki alan adı):
     data-g="kills"            metni yazar (sayı ise animasyonla sayar;
                               data-decimals="2", data-compact, data-raw, data-instant)
     data-g-bar="hp"           MH.bar  — max: data alanı hpMax ya da data-max
     data-g-ring="xp"          --v = değer / max (halkalar, ihtiyaçlar)
     data-g-core="health"      MH.core — değer { value, core } ya da sayı
     data-g-pips="clip"        MH.pips — max: clipMax ya da data-max
     data-g-level="wanted"     çocuklardan ilk N tanesine .on sınıfı
     data-g-show="inVehicle"   değer doğruysa görünür (değilse .mh-hidden)
     data-g-hide="dead"        değer doğruysa gizli
     data-g-class="state"      değeri sınıf olarak yazar (is-<değer>)
     data-g-enemies            onScreen / queued / maxEnemies → MH.enemies
     data-g-history            history: 'WWLD' → MH.history
     data-g-streak             streak → MH.streak
     data-g-timer="round"      saniye → MH.timer
   ========================================================================== */
(function (root) {
  'use strict';
  var MH = root.MH, doc = document;
  var q = new URLSearchParams(location.search);
  var G = { params: q, state: {}, demo: q.has('demo') && q.get('demo') !== '0', handlers: {} };

  function $$(sel, r) { return Array.prototype.slice.call((r || doc).querySelectorAll(sel)); }
  function num(v) { return typeof v === 'number' ? v : parseFloat(v); }
  function maxOf(el, key, data) {
    var m = data[key + 'Max'];
    if (m == null) m = G.state[key + 'Max'];
    if (m == null) m = el.getAttribute('data-max');
    return num(m) || 100;
  }

  /* data-raw: biçimsiz · data-decimals="2": kuruşlu · data-compact: 12,4 B */
  function fmtOf(n) {
    if (n.hasAttribute('data-raw')) return String;
    if (n.hasAttribute('data-compact')) return MH.compact;
    var d = +n.getAttribute('data-decimals');
    return d ? function (v) { return MH.fmt(v, d); } : undefined;
  }

  /* ---------------- Genel veri bağlama ---------------- */
  G.set = function (data) {
    if (!data || typeof data !== 'object') return;
    Object.keys(data).forEach(function (k) { G.state[k] = data[k]; });
    var r = G.root || doc;
    Object.keys(data).forEach(function (k) {
      var v = data[k];
      if (/Max$/.test(k) && !$$('[data-g="' + k + '"]', r).length) return;
      $$('[data-g="' + k + '"]', r).forEach(function (n) {
        if (typeof v === 'number') {
          if (n.__gv != null && n.__gv !== v && MH.bump) MH.bump(n);
          n.__gv = v;
          MH.count(n, v, { duration: n.hasAttribute('data-instant') ? 0 : 300, format: fmtOf(n) });
        } else { n.__gv = null; n.__val = null; n.textContent = v == null ? '' : v; }
      });
      $$('[data-g-bar="' + k + '"]', r).forEach(function (n) { MH.bar(n, num(v), { max: maxOf(n, k, data), critical: num(n.getAttribute('data-critical')) || undefined }); });
      $$('[data-g-ring="' + k + '"]', r).forEach(function (n) { n.style.setProperty('--v', Math.max(0, Math.min(1, num(v) / maxOf(n, k, data)))); n.classList.toggle('is-low', num(v) / maxOf(n, k, data) <= .2); });
      $$('[data-g-core="' + k + '"]', r).forEach(function (n) { MH.core(n, typeof v === 'object' ? v : { value: num(v), core: G.state[k + 'Core'] != null ? G.state[k + 'Core'] : 100 }); });
      $$('[data-g-pips="' + k + '"]', r).forEach(function (n) { var m = maxOf(n, k, data); MH.pips(n, Math.min(num(v), 40), Math.min(m, 40)); });
      $$('[data-g-level="' + k + '"]', r).forEach(function (n) { Array.prototype.forEach.call(n.children, function (c, i) { c.classList.toggle('on', i < num(v)); }); n.classList.toggle('mh-hidden', !num(v) && n.hasAttribute('data-hide-zero')); });
      $$('[data-g-show="' + k + '"]', r).forEach(function (n) { n.classList.toggle('mh-hidden', !v); });
      $$('[data-g-hide="' + k + '"]', r).forEach(function (n) { n.classList.toggle('mh-hidden', !!v); });
      $$('[data-g-class="' + k + '"]', r).forEach(function (n) {
        if (n.__gcls) n.classList.remove(n.__gcls);
        n.__gcls = v ? 'is-' + v : null; if (n.__gcls) n.classList.add(n.__gcls);
      });
      $$('[data-g-timer="' + k + '"]', r).forEach(function (n) { MH.timer(n, num(v), { urgent: num(n.getAttribute('data-urgent')) || 10 }); });
    });
    if ('onScreen' in data || 'queued' in data || 'maxEnemies' in data) {
      $$('[data-g-enemies]', r).forEach(function (n) { MH.enemies(n, { onScreen: G.state.onScreen, queued: G.state.queued, max: G.state.maxEnemies || 20 }); });
    }
    if ('history' in data) $$('[data-g-history]', r).forEach(function (n) { MH.history(n, data.history, num(n.getAttribute('data-g-history')) || 10); });
    if ('streak' in data) $$('[data-g-streak]', r).forEach(function (n) { MH.streak(n, num(data.streak) || 0, { decay: num(n.getAttribute('data-decay')) || 0 }); });
    emit('set', data);
  };

  /* ---------------- Olay mesajları → kit API ---------------- */
  var PASS = {
    'game:toast': 'toast', 'game:kill': 'kill', 'game:gift': 'gift', 'game:announce': 'announce', 'game:banner': 'banner',
    'game:levelUp': 'levelUp', 'game:achievement': 'achievement', 'game:pickup': 'pickup', 'game:loot': 'loot', 'game:social': 'social',
    'game:subtitle': 'subtitle', 'game:countdown': 'countdown', 'game:infected': 'infected', 'game:horde': 'horde',
    'game:poster': 'poster', 'game:telegram': 'telegram', 'game:headline': 'headline', 'game:sign': 'sign'
  };
  Object.keys(PASS).forEach(function (a) { MH.on(a, function (d) { MH[PASS[a]](d || {}); }); });

  MH.on('game:set', G.set);
  MH.on('game:stats', G.set);
  MH.on('game:hit', function (d) { MH.hit(G.screen, d && d.head ? 'head' : d && d.kill ? 'kill' : null); });
  MH.on('game:damage', function (d) { if (d && d.angle != null) MH.damageFrom(G.screen, d.angle); MH.flash(G.screen, true); });
  MH.on('game:crop', function (d) { G.crop(d && d.mode, d || {}); });
  MH.on('game:theme', function (d) { if (d.theme) MH.theme(d.theme); if (d.accent != null) MH.accent(d.accent); });
  MH.on('game:visible', function (d) { doc.body.classList.toggle('is-hidden', d && d.show === false); });
  MH.on('game:scale', function (d) { if (G.scaler) G.scaler.set(num(d && d.scale) || 1); });
  MH.on('game:weapon', function (w) { G.weapon(w); });
  MH.on('game:queue', function (list) { G.queue(list); });
  MH.on('game:objective', function (o) { G.objective(o); });
  MH.on('game:leaderboard', function (list) { G.leaderboard(list); });
  MH.on('game:team', function (list) { G.team(list); });
  MH.on('game:loadout', function (list) { G.loadout(list); });

  /* ---------------- mhud resource uyumu ----------------
     integration/mhud kaynağının otomatik gönderdiği mesajlar da anlaşılır; böylece
     fxmanifest'te ui_page 'html/games/gta5/index.html' yapmak yeterlidir. */
  MH.on('mhud:config', function (c) {
    if (!q.get('theme') && c.theme) MH.theme(c.theme);
    if (!q.get('accent')) MH.accent(c.accent || '');
    if (G.scaler && c.scale) G.scaler.set(num(c.scale) || 1);
    if (c.crop && !q.get('crop')) G.crop(c.crop, { platform: c.platform });
  });
  MH.on('mhud:visible', function (d) { doc.body.classList.toggle('is-hidden', d && d.show === false); });
  MH.on('mhud:vitals', function (v) {
    var d = { hp: v.health, armor: v.armor };
    if (v.cores) {
      d.health = { value: v.health, core: v.cores.health };
      d.stamina = { value: v.stamina, core: v.cores.stamina };
      d.deadeye = { value: v.cores.deadeye, core: v.cores.deadeye };
    } else d.stamina = v.stamina;
    G.set(d);
  });
  MH.on('mhud:money', function (m) { var d = {}; if (m.cash != null) d.cash = m.cash; if (m.bank != null) d.bank = m.bank; G.set(d); });
  MH.on('mhud:wanted', function (w) { G.set({ wanted: w.level || 0 }); });
  MH.on('mhud:objective', function (o) { G.objective(o || null); });
  var WMAP = [[/KNIFE|DAGGER|MACHETE|HATCHET|AXE/, 'knife', 1], [/BAT|CROWBAR|HAMMER|WRENCH|NIGHTSTICK|UNARMED|FIST/, 'fist', 1], [/REVOLVER/, 'revolver'], [/PISTOL/, 'pistol'],
    [/SMG|PDW|MICRO/, 'smg'], [/SHOTGUN/, 'shotgun'], [/SNIPER|MARKSMAN|ROLLINGBLOCK|CARCANO/, 'sniper'], [/REPEATER|MUSKET|LANCASTER|EVANS/, 'repeater'], [/RIFLE|CARBINE|BULLPUP/, 'carbine']];
  function prettyWeapon(n) { return String(n || '').replace(/^WEAPON_(MELEE_|REVOLVER_|PISTOL_|REPEATER_|RIFLE_|SNIPERRIFLE_|SHOTGUN_)?/, '').replace(/_/g, ' ').toLowerCase().replace(/(^|\s)\S/g, function (c) { return c.toUpperCase(); }); }
  MH.on('mhud:weapon', function (w) {
    if (!w) return G.weapon(null);
    var name = String(w.name || ''), hit = WMAP.filter(function (m) { return m[0].test(name); })[0] || [null, 'carbine'];
    G.weapon({ name: hit[1], icon: hit[1], label: w.label || prettyWeapon(name), clip: hit[2] ? null : w.clip, clipMax: w.clipMax, reserve: w.reserve, reloading: w.reloading });
  });

  /* ---------------- Ortak parçalar ---------------- */
  /* Silah paneli: { name:'carbine', label:'Karabina', clip, clipMax, reserve, reloading, icon } */
  G.weapon = function (w) {
    $$('[data-g-weapon]', G.root).forEach(function (box) {
      box.classList.toggle('mh-hidden', !w);
      if (!w) return;
      var art = box.querySelector('[data-g-weapon-art]'), label = box.querySelector('[data-g-weapon-label]');
      if (art && box.__w !== (w.name || w.icon)) {
        box.__w = w.name || w.icon;
        var cls = art.getAttribute('data-cls') || 'mh-weapon__art';
        art.innerHTML = root.MH_WEAPONS && root.MH_WEAPONS[w.name] ? MH.weapon(w.name, cls) : MH.icon(w.icon || w.name || 'crosshair', cls);
      }
      if (label) label.textContent = w.label || '';
      var melee = w.clip == null;
      box.classList.toggle('is-melee', melee);
      box.classList.toggle('is-low', !melee && w.clipMax > 0 && w.clip <= Math.ceil(w.clipMax * .2));
      box.classList.toggle('is-reloading', !!w.reloading);
      G.set({ clip: melee ? '—' : w.clip, clipMax: w.clipMax || 0, reserve: melee ? '' : (w.reserve != null ? w.reserve : '∞'), reloading: !!w.reloading });
    });
  };
  /* Etki kuyruğu: [{ icon, text, tone, time, running }] */
  G.queue = function (list) {
    $$('[data-g-queue]', G.root).forEach(function (box) {
      list = list || [];
      box.classList.toggle('mh-hidden', !list.length);
      var body = box.querySelector('[data-g-queue-list]') || box;
      body.innerHTML = list.slice(0, num(box.getAttribute('data-g-queue')) || 4).map(function (it) {
        return '<div class="mh-queue__item' + (it.running ? ' is-running' : '') + ' mh-t-' + (it.tone || 'info') + '">' + MH.icon(it.icon || 'hourglass') + '<span>' + MH.esc(it.text || '') + '</span><small>' + MH.esc(it.time || (it.running ? 'şimdi' : 'sırada')) + '</small></div>';
      }).join('');
    });
  };
  /* Görev: { kicker, title, timer, steps:[{ text, done, active, failed, count }], progress } */
  G.objective = function (o) {
    $$('[data-g-objective]', G.root).forEach(function (host) {
      if (!o) { host.innerHTML = ''; return; }
      host.innerHTML = '<div class="mh-panel mh-objective"><div class="mh-objective__head"><div><span class="mh-kicker mh-kicker--accent">' + MH.esc(o.kicker || 'Görev') + '</span>' +
        '<div class="mh-title" style="margin-top:4px">' + MH.esc(o.title || '') + '</div></div>' + (o.timer ? '<span class="mh-badge mh-t-accent mh-num">' + MH.esc(o.timer) + '</span>' : '') + '</div>' +
        '<div class="mh-objective__steps">' + (o.steps || []).map(function (s) {
          return '<div class="mh-step' + (s.done ? ' is-done' : s.active ? ' is-active' : s.failed ? ' is-failed' : '') + '"><span class="mh-step__box">' + MH.icon(s.failed ? 'x' : 'check') + '</span><span>' + MH.esc(s.text) + (s.count ? ' <b>' + MH.esc(s.count) + '</b>' : '') + '</span></div>';
        }).join('') + '</div>' +
        (o.progress != null ? '<div class="mh-objective__foot"><div class="mh-bar mh-bar--sm"><i class="mh-bar__fill" style="transform:scaleX(' + (o.progress / 100) + ')"></i></div></div>' : '') + '</div>';
    });
  };
  /* Sıralama: [{ name, value, self, avatar }] */
  G.leaderboard = function (list) {
    $$('[data-g-leaderboard]', G.root).forEach(function (box) {
      var body = box.querySelector('[data-g-leaderboard-list]') || box;
      body.innerHTML = (list || []).slice(0, num(box.getAttribute('data-g-leaderboard')) || 5).map(function (p, i) {
        var rank = i < 3 ? ' is-' + (i + 1) : '';
        return '<div class="mh-leader__row' + (p.self ? ' is-self' : '') + '"><span class="mh-rank' + rank + '">' + (i + 1) + '</span>' + MH.avatar(p.name, { cls: 'mh-avatar--sm mh-avatar--round', src: p.avatar, tone: p.tone }) +
          '<span class="mh-leader__name">' + MH.esc(p.name) + '</span><span class="mh-leader__val">' + (p.icon ? MH.icon(p.icon) : '') + MH.esc(p.value) + '</span></div>';
      }).join('');
    });
  };

  /* Takım / hayatta kalanlar: [{ name, hp, hpMax, temp, state:'down'|'bw'|'dead', self, items:['first-aid','pills'], avatar, tone }] */
  G.team = function (list) {
    $$('[data-g-team]', G.root).forEach(function (box) {
      var slots = box.getAttribute('data-g-team').split(',').filter(Boolean);
      box.innerHTML = (list || []).map(function (p) {
        var max = p.hpMax || 100, hp = Math.max(0, Math.min(1, (p.hp || 0) / max)), temp = Math.max(0, Math.min(1 - hp, (p.temp || 0) / max));
        var cls = p.state ? ' is-' + p.state : hp <= .25 ? ' is-low' : hp <= .5 ? ' is-mid' : '';
        var items = slots.length ? slots.map(function (sl) { var has = (p.items || []).indexOf(sl) >= 0; return MH.icon(sl, has ? '' : 'is-empty'); }).join('') : (p.items || []).map(function (it) { return MH.icon(it); }).join('');
        return '<div class="mh-survivor' + cls + (p.self ? ' is-self' : '') + '" style="--hp:' + hp.toFixed(3) + ';--temp:' + temp.toFixed(3) + '">' +
          MH.avatar(p.name, { src: p.avatar, tone: p.tone }) +
          '<div class="mh-survivor__top"><span class="mh-survivor__name">' + MH.esc(p.name) + '</span><span class="mh-survivor__hp">' + (p.state === 'dead' ? '—' : Math.round((p.hp || 0) + (p.temp || 0))) + '</span></div>' +
          '<div class="mh-survivor__bar"><i class="hp"></i><i class="temp"></i></div>' +
          '<div class="mh-survivor__items">' + items + '</div></div>';
      }).join('');
    });
  };
  /* Eşya yuvaları: [{ key:'1', art:'w:shotgun' | 'i:first-aid', label:'8 / 56', active, empty }] */
  G.loadout = function (list) {
    $$('[data-g-loadout]', G.root).forEach(function (box) {
      box.innerHTML = (list || []).map(function (s) {
        var a = String(s.art || ''), cls = a.indexOf('w:') === 0 ? 'mh-weapon-art' : '';
        return '<div class="mh-loadout__slot' + (s.active ? ' is-active' : '') + (s.empty ? ' is-empty' : '') + '"><span class="mh-slot__key">' + MH.esc(s.key || '') + '</span>' + MH.art(a, cls) + (s.label != null ? '<small>' + MH.esc(s.label) + '</small>' : '') + '</div>';
      }).join('');
    });
  };

  /* ---------------- Kırpma ---------------- */
  G.crop = function (mode, o) {
    o = o || {};
    if (!mode || mode === 'wide' || mode === 'none') { MH.crop('wide', { target: G.screen }); return; }
    MH.crop(mode, { target: G.screen, platform: o.platform || q.get('platform') || 'none', guide: o.guide != null ? o.guide : q.has('guide') });
  };

  /* ---------------- Olay yayıcı ---------------- */
  var subs = {};
  function emit(n, d) { (subs[n] || []).forEach(function (f) { try { f(d); } catch (e) { console.error(e); } }); }
  G.on = function (n, f) { (subs[n] = subs[n] || []).push(f); return G; };

  /* ---------------- Demo yardımcıları ---------------- */
  G.rand = function (a, b) { return a + Math.random() * (b - a); };
  G.int = function (a, b) { return Math.round(G.rand(a, b)); };
  G.pick = function (a) { return a[Math.floor(Math.random() * a.length)]; };
  G.every = function (ms, fn) { fn(); return setInterval(fn, ms); };
  G.send = function (action, data) { MH.route({ action: action, data: data }); };

  /* ---------------- Başlatma ---------------- */
  G.boot = function (o) {
    o = o || {};
    G.game = o.game || 'generic';
    G.root = doc.querySelector(o.root || 'body');
    G.screen = doc.querySelector(o.screen || '.mh-screen');
    MH.theme(q.get('theme') || o.theme || 'modern');
    MH.accent(q.get('accent') != null ? q.get('accent') : (o.accent || ''));
    if (!q.has('noscale')) G.scaler = MH.autoScale({ base: 1080, scale: num(q.get('scale')) || 1 });
    doc.body.setAttribute('data-game', G.game);
    if (G.demo) {
      doc.body.classList.add('is-demo');
      var scene = q.get('scene') || o.scene;
      if (scene) doc.body.style.setProperty('--game-scene', 'url("' + (o.sceneBase || '../../demo/scenes/') + scene + '.svg")');
      $$('img[data-demo-src]').forEach(function (i) { i.src = i.getAttribute('data-demo-src'); });
    }
    if (o.defaults) G.set(o.defaults);
    if (q.get('crop')) G.crop(q.get('crop'));
    if (q.get('ws')) G.socket = MH.connect(q.get('ws'));
    if (G.demo && o.demo) o.demo(G);
    MH.post('ready', { game: G.game });
    return G;
  };

  root.MHGame = G;
})(window);
