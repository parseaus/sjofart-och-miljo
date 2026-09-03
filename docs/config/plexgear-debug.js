// plexgear-debug.js
(function () {
  function init() {
    const log = document.createElement('div');
    log.id = 'plexgear-log';
    log.style.cssText = `
      position: fixed;
      top: 10px;
      left: 10px;
      z-index: 9999;
      background: rgba(0,0,0,0.85);
      color: #fff;
      font: 12px monospace;
      padding: 8px 10px;
      border-radius: 4px;
      max-width: 45vw;
      max-height: 40vh;
      overflow: auto;
      white-space: pre-wrap;
    `;
    log.textContent = 'Plexgear key logger ready. Press buttons…\n';
    document.body.appendChild(log);

    function appendLine(text) {
      log.textContent += text + '\n';
      log.scrollTop = log.scrollHeight;
      console.log('[plexgear]', text);
    }

    document.addEventListener('keydown', function (e) {
      if (e.repeat) return;
      const line = [
        'keydown',
        'key:', e.key,
        'code:', e.code,
        'keyCode:', e.keyCode,
        'which:', e.which
      ].join(' ');
      appendLine(line);
    }, true); // useCapture to catch events early
  }

  // If reveal.js is already ready, init immediately; otherwise wait
  if (window.Reveal && typeof Reveal.on === 'function') {
    if (Reveal.isReady && Reveal.isReady()) {
      init();
    } else {
      Reveal.on('ready', init);
    }
  } else {
    // Fallback: try on DOMContentLoaded and load as safety
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', init);
    } else {
      init();
    }
  }
})();
