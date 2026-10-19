(function () {
  var root = document.documentElement;
  var KEY = 'gewumind-lang';

  function currentLang() {
    return root.getAttribute('data-lang') === 'en' ? 'en' : 'zh';
  }
  function syncVideoLang(lang) {
    var durs = document.querySelectorAll('.video-d');
    for (var i = 0; i < durs.length; i++) {
      var d = durs[i].getAttribute('data-dur-' + lang);
      if (d) durs[i].textContent = d;
    }
    var thumbs = document.querySelectorAll('.video-item');
    for (var j = 0; j < thumbs.length; j++) {
      var img = thumbs[j].querySelector('img');
      var p = thumbs[j].getAttribute(lang === 'en' ? 'data-poster-en' : 'data-poster');
      if (img && p) img.src = p;
    }
    var vlist = document.getElementById('videoList');
    var v = document.getElementById('tutorialVideo');
    if (!vlist || !v) return;
    var active = vlist.querySelector('.video-item.is-active') || vlist.querySelector('.video-item');
    if (!active) return;
    var src = active.getAttribute(lang === 'en' ? 'data-src-en' : 'data-src') || active.getAttribute('data-src');
    var poster = active.getAttribute(lang === 'en' ? 'data-poster-en' : 'data-poster') || active.getAttribute('data-poster');
    if (!src) return;
    var wasPlaying = !v.paused && v.currentTime > 0;
    v.pause();
    v.setAttribute('src', src);
    if (poster) v.setAttribute('poster', poster);
    v.load();
    if (wasPlaying) v.play().catch(function () {});
  }

  function apply(lang) {
    lang = lang === 'en' ? 'en' : 'zh';
    root.setAttribute('data-lang', lang);
    root.setAttribute('lang', lang === 'en' ? 'en' : 'zh-CN');
    try { localStorage.setItem(KEY, lang); } catch (e) {}
    var heads = document.querySelectorAll('[data-i18n]');
    for (var i = 0; i < heads.length; i++) {
      var el = heads[i];
      if (!el.hasAttribute('data-i18n-zh')) {
        el.setAttribute('data-i18n-zh', el.tagName === 'TITLE' ? el.textContent : el.getAttribute('content'));
      }
      var v = lang === 'en' ? el.getAttribute('data-i18n') : el.getAttribute('data-i18n-zh');
      if (el.tagName === 'TITLE') { el.textContent = v; } else { el.setAttribute('content', v); }
    }
    syncVideoLang(lang);
  }

  // initial: saved -> browser language -> zh
  var saved = null;
  try { saved = localStorage.getItem(KEY); } catch (e) {}
  if (!saved) {
    saved = (navigator.language || '').toLowerCase().indexOf('zh') === 0 ? 'zh' : 'en';
  }
  apply(saved);

  var btn = document.getElementById('langSwitch');
  if (btn) {
    btn.addEventListener('click', function () {
      apply(root.getAttribute('data-lang') === 'zh' ? 'en' : 'zh');
    });
  }

  var year = document.getElementById('year');
  if (year) { year.textContent = String(new Date().getFullYear()); }

  // 视频教程：点击选集切换主播放器
  var list = document.getElementById('videoList');
  if (list) {
    var vid = document.getElementById('tutorialVideo');
    var ep = document.getElementById('videoEp');
    var title = document.getElementById('videoTitle');
    var desc = document.getElementById('videoDesc');
    list.addEventListener('click', function (e) {
      var btn = e.target.closest('.video-item');
      if (!btn) return;
      var items = list.querySelectorAll('.video-item');
      for (var i = 0; i < items.length; i++) items[i].classList.remove('is-active');
      btn.classList.add('is-active');
      vid.pause();
      var lng = currentLang();
      vid.setAttribute('src', btn.getAttribute(lng === 'en' ? 'data-src-en' : 'data-src') || btn.getAttribute('data-src'));
      vid.setAttribute('poster', btn.getAttribute(lng === 'en' ? 'data-poster-en' : 'data-poster') || btn.getAttribute('data-poster'));
      ep.textContent = btn.getAttribute('data-ep');
      title.innerHTML = '<span data-zh></span><span data-en></span>';
      title.children[0].textContent = btn.getAttribute('data-zh-title');
      title.children[1].textContent = btn.getAttribute('data-en-title');
      desc.innerHTML = '<span data-zh></span><span data-en></span>';
      desc.children[0].textContent = btn.getAttribute('data-zh-desc');
      desc.children[1].textContent = btn.getAttribute('data-en-desc');
      vid.load();
      vid.play().catch(function () {});
    });
  }
})();
