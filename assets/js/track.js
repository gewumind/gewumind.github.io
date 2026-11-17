(function () {
  function count(path) {
    if (window.goatcounter && typeof window.goatcounter.count === 'function') {
      window.goatcounter.count({ path: path, title: path, event: true });
    }
  }

  document.addEventListener('click', function (event) {
    var link = event.target.closest('[data-gc-event]');
    if (!link) return;
    var path = link.getAttribute('data-gc-event');
    if (path) count(path);
  }, true);
})();
