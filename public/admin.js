// Balhareth Ortho admin — rich text editors for content blocks.
// Each [data-rte] wrapper holds a hidden input (the real form field, HTML)
// and an editor div seeded with the current HTML. On submit the editor's
// semantic HTML is copied back into the hidden input, so the server, the
// dashboard API, and the public pages keep working with plain HTML fields.
(function () {
  'use strict';

  var TOOLBAR = [
    [{ header: [1, 2, 3, 4, false] }],
    ['bold', 'italic', 'underline'],
    [{ list: 'ordered' }, { list: 'bullet' }],
    ['link', 'blockquote'],
    [{ direction: 'rtl' }],
    ['clean']
  ];

  function initEditor(wrap) {
    if (wrap.dataset.rteReady || typeof Quill === 'undefined') return;
    wrap.dataset.rteReady = '1';

    var hidden = wrap.querySelector('input[type=hidden]');
    var editorEl = wrap.querySelector('.rte-editor');
    if (!hidden || !editorEl) return;

    var quill = new Quill(editorEl, {
      theme: 'snow',
      modules: { toolbar: TOOLBAR },
      placeholder: wrap.dataset.placeholder || ''
    });

    if (wrap.dataset.dir === 'rtl') {
      quill.root.setAttribute('dir', 'rtl');
      quill.format('direction', 'rtl');
      quill.format('align', 'right');
    }

    var sync = function () { hidden.value = quill.getSemanticHTML(); };
    quill.on('text-change', sync);

    var form = wrap.closest('form');
    if (form) form.addEventListener('submit', sync);
  }

  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('[data-rte]').forEach(initEditor);

    // Editors inside collapsed <details> initialize fine, but re-init any
    // added later just in case.
    document.querySelectorAll('details.adm-acc').forEach(function (d) {
      d.addEventListener('toggle', function () {
        d.querySelectorAll('[data-rte]').forEach(initEditor);
      });
    });
  });
})();
