// plexgear-plugin.js
(function () {
  function applyPlexgearKeys() {
    if (!window.Reveal || !Reveal.configure) return;
    Reveal.configure({
      keyboard: {
        37: 'prev',  // Left
        38: 'prev',  // Up
        39: 'next',  // Right
        40: 'next'   // Down
      }
    });
  }

  if (window.Reveal && typeof Reveal.on === 'function') {
    if (Reveal.isReady && Reveal.isReady()) {
      applyPlexgearKeys();
    } else {
      Reveal.on('ready', applyPlexgearKeys);
    }
  } else {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', applyPlexgearKeys);
    } else {
      applyPlexgearKeys();
    }
  }
})();
