(function () {
  const fallbackBranding = {
    name: "KeskOS",
    pretty_name: "KeskOS",
    layer: "",
    layer_name: "",
    brand_line: "KeskOS",
    channel: "stable",
    build_id: "dev",
    accent_color: "#ce6a35",
    home_url: "https://keskos.org",
    documentation_url: "https://docs.keskos.org",
    download_url: "https://downloads.keskos.org",
    support_url: "https://docs.keskos.org",
    bug_report_url: "https://github.com/KeskOS"
  };

  const form = document.getElementById("searchForm");
  const input = document.getElementById("searchInput");
  const hint = document.getElementById("hint");
  const clock = document.getElementById("clock");
  const topbarBrand = document.getElementById("topbarBrand");
  const brandKicker = document.getElementById("brandKicker");
  const brandLine = document.getElementById("brandLine");
  const brandSubtitle = document.getElementById("brandSubtitle");
  const footerBrand = document.getElementById("footerBrand");
  const footerNode = document.getElementById("footerNode");

  const adsBlocked = document.getElementById("adsBlocked");
  const trackersBlocked = document.getElementById("trackersBlocked");
  const fingerprintShield = document.getElementById("fingerprintShield");
  const cookieIsolation = document.getElementById("cookieIsolation");
  const httpsMode = document.getElementById("httpsMode");
  const sessionTrace = document.getElementById("sessionTrace");
  const protectionBus = document.getElementById("protectionBus");
  const protectionBusText = document.getElementById("protectionBusText");
  const uptimeText = document.getElementById("uptimeText");
  const localNode = document.getElementById("localNode");

  if (!form || !input || !hint) {
    return;
  }

  let activeBranding = fallbackBranding;
  const sessionStart = Date.now();
  const directSchemePattern = /^(https?:\/\/|file:\/\/|about:)/i;
  const localhostPattern = /^localhost(:\d+)?(\/.*)?$/i;
  const ipv4Pattern = /^(\d{1,3}\.){3}\d{1,3}(:\d+)?(\/.*)?$/;
  const hostnamePattern = /^[a-z0-9-]+(\.[a-z0-9-]+)+(:\d+)?(\/.*)?$/i;
  const probeTimeoutMs = 3500;

  const adProbeUrls = [
    "https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js",
    "https://securepubads.g.doubleclick.net/tag/js/gpt.js",
    "https://static.criteo.net/js/ld/ld.js",
    "https://cdn.taboola.com/libtrc/unip/loader.js"
  ];

  const trackerProbeUrls = [
    "https://www.google-analytics.com/analytics.js",
    "https://www.googletagmanager.com/gtm.js?id=GTM-KESKOS",
    "https://connect.facebook.net/en_US/fbevents.js",
    "https://bat.bing.com/bat.js"
  ];

  async function loadBranding() {
    try {
      const response = await fetch("./branding.json", { cache: "no-store" });
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      const payload = await response.json();
      const branding = { ...fallbackBranding, ...payload };
      if (!branding.layer_name && branding.layer) {
        branding.layer_name = `Layer ${branding.layer}`;
      }
      if (!branding.brand_line) {
        branding.brand_line = branding.pretty_name || branding.name || "KeskOS";
      }
      if (!branding.pretty_name) {
        branding.pretty_name = branding.brand_line;
      }
      return branding;
    } catch (_error) {
      return fallbackBranding;
    }
  }

  function applyBranding(branding) {
    activeBranding = branding;
    document.title = `${branding.brand_line} Net Access`;
    if (topbarBrand) {
      topbarBrand.textContent = `${branding.name.toUpperCase()}::BROWSER_GATEWAY`;
    }
    if (brandKicker) {
      brandKicker.textContent = branding.layer_name
        ? `${branding.layer_name.toUpperCase()} // WEB INTERFACE`
        : "LOCAL NODE // WEB INTERFACE";
    }
    if (brandLine) {
      brandLine.textContent = branding.brand_line;
    }
    if (brandSubtitle) {
      brandSubtitle.innerHTML = `hardened browser gateway active for <span>${branding.brand_line}</span>. enter a signal, domain, or search query below.`;
    }
    if (footerBrand) {
      footerBrand.textContent = branding.brand_line;
    }
    if (footerNode) {
      footerNode.textContent = `NODE: ${branding.name.toUpperCase()}`;
    }
  }

  function updateClock() {
    const now = new Date();
    const time = now.toLocaleTimeString([], {
      hour: "2-digit",
      minute: "2-digit"
    });
    clock.textContent = `SIGNAL READY // ${time}`;
  }

  function looksLikeUrl(value) {
    const trimmed = value.trim();

    if (directSchemePattern.test(trimmed)) {
      return true;
    }
    if (localhostPattern.test(trimmed)) {
      return true;
    }
    if (ipv4Pattern.test(trimmed)) {
      return true;
    }

    return hostnamePattern.test(trimmed);
  }

  function normalizeUrl(value) {
    const trimmed = value.trim();

    if (directSchemePattern.test(trimmed)) {
      return trimmed;
    }
    if (localhostPattern.test(trimmed) || ipv4Pattern.test(trimmed)) {
      return `http://${trimmed}`;
    }
    return `https://${trimmed}`;
  }

  function updateHintForValue(value) {
    const trimmed = value.trim();

    if (!trimmed) {
      hint.innerHTML = 'ENTER EXECUTE · URL DIRECT OPEN · QUERY DUCKDUCKGO <span class="blink">█</span>';
      return;
    }

    if (looksLikeUrl(trimmed)) {
      hint.innerHTML = 'DIRECT WEB SIGNAL DETECTED <span class="blink">█</span>';
      return;
    }

    hint.innerHTML = 'SEARCH SIGNAL ROUTED THROUGH DUCKDUCKGO <span class="blink">█</span>';
  }

  function updateStaticSignals() {
    const privacySignals = [];
    if (navigator.globalPrivacyControl === true) {
      privacySignals.push("GPC");
    }
    if (navigator.doNotTrack === "1" || window.doNotTrack === "1") {
      privacySignals.push("DNT");
    }

    fingerprintShield.textContent = privacySignals.length > 0 ? "ACTIVE" : "UNKNOWN";
    const storageAvailable = typeof localStorage !== "undefined" && typeof sessionStorage !== "undefined";
    cookieIsolation.textContent = storageAvailable ? "PROFILE" : "LIMITED";
    httpsMode.textContent = "PREFERRED";
    sessionTrace.textContent = "LIVE";

    const nodeLabel = activeBranding.brand_line || activeBranding.name || "KeskOS";
    localNode.textContent = window.location.protocol === "file:"
      ? `${nodeLabel} // LOCAL`
      : `${nodeLabel} // REMOTE`;
  }

  async function probeUrl(url) {
    const controller = new AbortController();
    const timeoutId = window.setTimeout(function () {
      controller.abort();
    }, probeTimeoutMs);

    const separator = url.includes("?") ? "&" : "?";
    const cacheBusted = `${url}${separator}kesk_probe=${Date.now()}`;

    try {
      await fetch(cacheBusted, {
        method: "GET",
        mode: "no-cors",
        cache: "no-store",
        credentials: "omit",
        signal: controller.signal
      });
      return "loaded";
    } catch (error) {
      if (error && error.name === "AbortError") {
        return "blocked";
      }
      return "blocked";
    } finally {
      window.clearTimeout(timeoutId);
    }
  }

  async function runProbeSet(urls) {
    const results = await Promise.all(urls.map(probeUrl));
    let blocked = 0;
    let loaded = 0;

    for (const result of results) {
      if (result === "loaded") {
        loaded += 1;
      } else {
        blocked += 1;
      }
    }

    return {
      total: urls.length,
      blocked,
      loaded
    };
  }

  function busBar(total, blocked) {
    const width = 10;
    const filled = total > 0 ? Math.round((blocked / total) * width) : 0;
    return `${"█".repeat(filled)}${"░".repeat(Math.max(0, width - filled))}`;
  }

  async function updateProtectionStats() {
    hint.innerHTML = 'RUNNING PROTECTION PROBES <span class="blink">█</span>';

    const [ads, trackers] = await Promise.all([
      runProbeSet(adProbeUrls),
      runProbeSet(trackerProbeUrls)
    ]);

    const total = ads.total + trackers.total;
    const blocked = ads.blocked + trackers.blocked;

    adsBlocked.textContent = String(ads.blocked).padStart(2, "0");
    trackersBlocked.textContent = String(trackers.blocked).padStart(2, "0");
    protectionBus.textContent = busBar(total, blocked);

    if (!navigator.onLine) {
      protectionBusText.textContent = "offline session detected - probe results may be inflated";
      protectionBusText.classList.add("warn");
    } else {
      protectionBusText.textContent = `${blocked}/${total} probe routes denied by the current browser protection layer`;
      protectionBusText.classList.remove("warn");
    }

    updateHintForValue(input.value);
  }

  function updateUptime() {
    const uptimeSeconds = Math.floor((Date.now() - sessionStart) / 1000);
    const minutes = Math.floor(uptimeSeconds / 60);
    const seconds = String(uptimeSeconds % 60).padStart(2, "0");
    uptimeText.textContent = `session alive ${minutes}:${seconds}`;
  }

  form.addEventListener("submit", function (event) {
    event.preventDefault();
    const query = input.value.trim();

    if (!query) {
      hint.innerHTML = 'NO SIGNAL DETECTED <span class="blink">█</span>';
      input.focus();
      return;
    }

    if (looksLikeUrl(query)) {
      window.location.assign(normalizeUrl(query));
      return;
    }

    const searchUrl = new URL("https://duckduckgo.com/");
    searchUrl.searchParams.set("q", query);
    window.location.assign(searchUrl.toString());
  });

  input.addEventListener("input", function () {
    updateHintForValue(input.value);
  });

  input.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
      input.value = "";
      updateHintForValue("");
    }
  });

  async function initialize() {
    applyBranding(await loadBranding());
    updateClock();
    updateStaticSignals();
    updateUptime();
    updateHintForValue("");
    updateProtectionStats();

    window.setInterval(updateClock, 15000);
    window.setInterval(updateUptime, 1000);
    window.setInterval(updateProtectionStats, 120000);
  }

  initialize();
})();
