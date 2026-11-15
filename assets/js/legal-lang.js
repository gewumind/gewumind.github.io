(function () {
  var KEY = 'gewumind-lang';
  var path = window.location.pathname;
  if (!/\.html$/.test(path)) return;

  var saved = null;
  try {
    saved = localStorage.getItem(KEY);
  } catch (e) {}

  if (saved !== 'zh' && saved !== 'en') saved = null;
  var browser = (navigator.language || navigator.userLanguage || 'en').toLowerCase();
  var lang = saved || (browser.indexOf('zh') === 0 ? 'zh' : 'en');
  var isZh = /\.zh\.html$/.test(path);
  var target = isZh
    ? path.replace(/\.zh\.html$/, '.html')
    : path.replace(/\.html$/, '.zh.html');

  if ((lang === 'zh' && !isZh) || (lang === 'en' && isZh)) {
    window.location.replace(target + window.location.search + window.location.hash);
    return;
  }

  document.documentElement.lang = lang === 'zh' ? 'zh-CN' : 'en';

  document.addEventListener('click', function (event) {
    var link = event.target.closest('[data-lang-link]');
    if (!link) return;
    try {
      localStorage.setItem(KEY, link.getAttribute('data-lang-link'));
    } catch (e) {}
  });

  // Preserve query parameters (e.g. Creem checkout_id) when switching language.
  function preserveQueryOnLangLinks() {
    var links = document.querySelectorAll('[data-lang-link]');
    for (var i = 0; i < links.length; i++) {
      var href = links[i].getAttribute('href');
      if (!href || href.charAt(0) === '#') continue;
      if (href.indexOf('?') >= 0 || href.indexOf('#') >= 0) continue;
      links[i].setAttribute('href', href + window.location.search + window.location.hash);
    }
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', preserveQueryOnLangLinks);
  } else {
    preserveQueryOnLangLinks();
  }
})();
