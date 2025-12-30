const String scriptLoadingFinished = '''
(function() {
  // Evita múltiplas verificações após página já marcada como pronta
  if (window.__uolWebViewReady) {
    return true;
  }

  const checks = {
    domReady: false,
    hasBody: false,
    hasContent: false,
    hasPaint: false,
    hasLoading: true,
    performanceAvailable: false
  };

  /* ============================================================
     1. Verifica estados básicos do DOM
  ============================================================ */
  checks.domReady = document.readyState === "complete" || document.readyState === "interactive";
  checks.hasBody = !!document.body && !!document.body.firstElementChild;

  if (document.body) {
    const bodyHeight = document.body.scrollHeight;
    const bodyWidth = document.body.scrollWidth;
    checks.hasContent = bodyHeight > 100 && bodyWidth > 100;
  }

  /* ============================================================
     2. Performance API (FCP/FP)
  ============================================================ */
  if (window.performance && window.performance.getEntriesByType) {
    checks.performanceAvailable = true;

    try {
      const paintEntries = performance.getEntriesByType("paint");
      checks.hasPaint = paintEntries.some((entry) => 
        entry.name === "first-contentful-paint" || entry.name === "first-paint"
      );
      if (checks.hasPaint) {
        const metrics = {};
        paintEntries.forEach((entry) => {
          metrics[entry.name] = Math.round(entry.startTime);
        });
        window.__uolPaintMetrics = metrics;
      }
    } catch (e) {
      checks.hasPaint = false;
    }
  }

  /* ============================================================
     3. Detecção de loading / skeleton (NOVO)
  ============================================================ */

  function detectLoadingElements() {
    // Seleciona apenas <section> com classes contendo skeleton
    const sections = Array.from(
      document.querySelectorAll("section[class*='skeleton-visible']")
    );
    // Nenhum section com skeleton encontrado → OK (sem loading)
    return sections.length !== 0;
  }

  checks.hasLoading = detectLoadingElements();

  /* ============================================================
     5. Regra final: página pronta
  ============================================================ */

  const isReady =
    checks.domReady &&
    checks.hasBody &&
    checks.hasContent &&
    checks.hasLoading === false &&
    (checks.performanceAvailable ? checks.hasPaint : true);

  if (isReady) {
    window.__uolWebViewReady = true;
  }

  return isReady;
})();
''';
