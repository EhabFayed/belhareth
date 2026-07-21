// Balhareth Ortho — behaviors ported from the Claude Design export.
(function () {
  'use strict';

  // Splash: shown on home only, once per browser session.
  function splash() {
    var el = document.getElementById('splash');
    if (!el) return;
    if (location.search.indexOf('nosplash') > -1 || sessionStorage.getItem('splashSeen')) { el.style.display = 'none'; return; }
    sessionStorage.setItem('splashSeen', '1');
    setTimeout(function () { el.classList.add('hide'); }, 2000);
  }

  // Rotating hero word.
  function heroWord() {
    var el = document.getElementById('hero-word');
    if (!el) return;
    var words = ['walking', 'working', 'playing', 'praying', 'living'];
    var i = Math.max(0, words.indexOf(el.textContent.trim()));
    setInterval(function () {
      el.classList.add('out');
      setTimeout(function () {
        i = (i + 1) % words.length;
        el.textContent = words[i];
        el.classList.remove('out');
      }, 330);
    }, 2600);
  }

  // Animated stat counters (home).
  function stats() {
    var els = document.querySelectorAll('[data-count]');
    if (!els.length) return;
    var t0 = performance.now(), dur = 1500;
    function fmt(v, el) {
      var dec = el.dataset.decimals ? parseInt(el.dataset.decimals, 10) : 0;
      var s = dec ? v.toFixed(dec) : Math.round(v).toLocaleString('en-US');
      return (el.dataset.prefix || '') + s + (el.dataset.suffix || '');
    }
    function step(t) {
      var p = Math.min(1, (t - t0) / dur), e = 1 - Math.pow(1 - p, 3);
      els.forEach(function (el) { el.textContent = fmt(parseFloat(el.dataset.count) * e, el); });
      if (p < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  }

  // Position-based scroll reveals (.rv / .rv-kids).
  function reveals() {
    function check() {
      var vh = window.innerHeight || document.documentElement.clientHeight;
      document.querySelectorAll('.rv:not(.rv-on), .rv-kids:not(.rv-on)').forEach(function (el) {
        var r = el.getBoundingClientRect();
        if (r.height === 0) return;
        if (r.top < vh * 0.92 && r.bottom > 0) {
          if (el.classList.contains('rv-kids')) {
            Array.prototype.forEach.call(el.children, function (k, i) { k.style.transitionDelay = (i * 110) + 'ms'; });
          }
          el.classList.add('rv-on');
        }
      });
    }
    window.addEventListener('scroll', check, { passive: true });
    window.addEventListener('resize', check, { passive: true });
    setInterval(check, 450);
    check();
    setTimeout(check, 150);
  }

  // Nav shadow on scroll.
  function navShadow() {
    var nav = document.getElementById('site-nav');
    if (!nav) return;
    var onScroll = function () {
      nav.style.boxShadow = (document.scrollingElement.scrollTop > 8) ? '0 10px 30px rgba(22,40,58,.1)' : 'none';
    };
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
  }

  // Booking form: no backend yet — compose a WhatsApp message to the clinic.
  function bookingForms() {
    var WA = 'https://wa.me/966583777871';
    document.querySelectorAll('[data-booking-form]').forEach(function (form) {
      form.addEventListener('submit', function (e) {
        e.preventDefault();
        var v = function (n) { var f = form.elements[n]; return f && f.value && f.value.indexOf('WHAT BRINGS') === -1 ? f.value.trim() : ''; };
        var lines = ['Appointment request from the website:'];
        if (v('name'))  lines.push('Name: ' + v('name'));
        if (v('phone')) lines.push('Mobile: ' + v('phone'));
        if (v('reason')) lines.push('Reason: ' + v('reason'));
        if (v('day'))   lines.push('Preferred day: ' + v('day'));
        if (v('notes')) lines.push('Notes: ' + v('notes'));
        window.open(WA + '?text=' + encodeURIComponent(lines.join('\n')), '_blank');
      });
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    splash();
    heroWord();
    stats();
    reveals();
    navShadow();
    bookingForms();
  });
})();
