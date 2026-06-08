const String scriptDarkMode = '''
(function() {
  if (document.getElementById('__uolDarkStyle')) return;
  var style = document.createElement('style');
  style.id = '__uolDarkStyle';
  style.textContent = `
    /* === ROOT === */
    .dark-mode-active {
      color-scheme: dark !important;
      background-color: #121212 !important;
    }

    /* === BODY === */
    .dark-mode-active body {
      background-color: #121212 !important;
      color: #d1d5db !important;
    }

    /* === TEXTOS GERAIS === */
    .dark-mode-active p, .dark-mode-active span, .dark-mode-active li,
    .dark-mode-active td, .dark-mode-active th, .dark-mode-active figcaption,
    .dark-mode-active small, .dark-mode-active label, .dark-mode-active blockquote,
    .dark-mode-active cite, .dark-mode-active pre, .dark-mode-active code {
      color: #d1d5db !important;
    }

    /* === TÍTULOS === */
    .dark-mode-active h1, .dark-mode-active h2, .dark-mode-active h3,
    .dark-mode-active h4, .dark-mode-active h5, .dark-mode-active h6 {
      color: #f3f4f6 !important;
    }

    /* === LINKS === */
    .dark-mode-active a { color: #93c5fd !important; }
    .dark-mode-active a:hover { color: #bfdbfe !important; }

    /* === CONTAINERS PRINCIPAIS === */
    .dark-mode-active div, .dark-mode-active section, .dark-mode-active article,
    .dark-mode-active header, .dark-mode-active footer, .dark-mode-active nav,
    .dark-mode-active aside, .dark-mode-active main {
      background-color: #202020 !important;
    }

    /* === UOL: CARDS DE FOTO COM FUNDO COLORIDO === */
    .dark-mode-active [class*="headlinePhoto__content"] {
      background-color: #16213e !important;
    }
    .dark-mode-active [class*="headlinePhoto__content__title"] {
      color: #f3f4f6 !important;
    }

    /* === UOL: KICKERS (tags vermelhas "AO VIVO", "MELHORES MOMENTOS") === */
    .dark-mode-active [class*="kicker--highlight"],
    .dark-mode-active [class*="kicker--live"] {
      background-color: #7f1d1d !important;
      color: #fca5a5 !important;
    }
    .dark-mode-active [class*="kicker--default"] {
      color: #93c5fd !important;
    }
    .dark-mode-active [class*="kicker--ad"] {
      background-color: #374151 !important;
    }

    /* === UOL: PLACEHOLDER DE IMAGEM === */
    .dark-mode-active [class*="photograph__container"] {
      background-color: #2d2d3a !important;
    }

    /* === UOL: TÍTULOS DE NOTÍCIA (headlineHorizontal) === */
    .dark-mode-active [class*="headlineHorizontal__content__title"],
    .dark-mode-active [class*="title__element"],
    .dark-mode-active [class*="titleBrand__title"] {
      color: #f3f4f6 !important;
    }

    /* === UOL: MARCAS/BREADCRUMBS === */
    .dark-mode-active [class*="brand__title"] {
      color: #e5e7eb !important;
    }

    /* === UOL: FOOTER === */
    .dark-mode-active footer,
    .dark-mode-active [class*="footer"] {
      background-color: #0d0d1a !important;
    }

    /* === UOL: AD CONTAINERS === */
    .dark-mode-active [class*="cardAd"] {
      background-color: #202020 !important;
    }
    .dark-mode-active [class*="cardAd--showLabel"]::before {
      background-color: #202020 !important;
      color: #9ca3af !important;
    }

    /* === UOL: SKELETON LOADING === */
    .dark-mode-active [class*="loading__skeleton"]:empty {
      background-color: #2d2d3a !important;
    }

    /* === UOL: CHIPS/TAGS === */
    .dark-mode-active [class*="chips__link"] {
      color: #d1d5db !important;
      border-color: #4b5563 !important;
    }

    /* === UOL: BOTÃO DE SEGUIR / ALERTAS === */
    .dark-mode-active [class*="alert"] {
      background-color: #374151 !important;
      color: #f3f4f6 !important;
    }

    /* === INPUTS, BOTÕES, SELECTS === */
    .dark-mode-active input, .dark-mode-active textarea,
    .dark-mode-active select, .dark-mode-active button {
      background-color: #374151 !important;
      color: #e5e7eb !important;
      border-color: #4b5563 !important;
    }

    /* === INVERTER SVG E ÍCONES UOL (quando necessário) === */
    .dark-mode-active [class*="uolIcons"] {
      color: #d1d5db !important;
    }

    /* === NÃO MODIFICAR: imagens, vídeos, canvas === */
    img, video, canvas, svg:not([class*="uolIcons"]), iframe, picture {
      /* preserved */
    }
  `;
  document.head.appendChild(style);
})();
''';
