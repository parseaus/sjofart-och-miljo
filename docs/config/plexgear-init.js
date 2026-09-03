// plexgear-init.js
// Runs after Reveal.initialize() via org-re-reveal-init-script

if (window.Reveal && Reveal.configure) {
  Reveal.configure({
    keyboard: {
      37: 'prev',  // Left
      38: 'prev',  // Up
      39: 'next',  // Right
      40: 'next'   // Down
    }
  });
}
