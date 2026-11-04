// ---------- plugin entry ----------
const PAGE_NAME = 'RehabSense v2 Prototype';
const STATUS_COLOR = { NEW: '#00754A', CHANGED: '#8A6100', EXISTING: '#58606A' };
figma.showUI(__html__, { width: 400, height: 680, themeColors: false });

figma.ui.onmessage = async function (msg) {
  try {
    if (msg.type === 'generate') await generate(msg);
    else if (msg.type === 'goto') await gotoNode(msg.nodeId);
    else if (msg.type === 'clear') { await removeExisting(); figma.ui.postMessage({ type: 'catalog', items: [], summary: null }); figma.notify('Generated page removed'); }
    else if (msg.type === 'scan') await scanExisting();
  } catch (e) {
    figma.ui.postMessage({ type: 'error', message: String(e && e.message ? e.message : e) });
    figma.notify('Error: ' + (e && e.message ? e.message : e), { error: true });
  }
};

async function loadFonts() {
  const styles = ['Regular', 'Semi Bold', 'Bold'];
  for (let i = 0; i < styles.length; i++) await figma.loadFontAsync({ family: 'Inter', style: styles[i] });
}
async function removeExisting() {
  const ex = figma.root.children.filter(function (p) { return p.name === PAGE_NAME; });
  for (let i = 0; i < ex.length; i++) {
    if (figma.currentPage === ex[i]) {
      let other = figma.root.children.find(function (p) { return p !== ex[i]; });
      if (!other) { other = figma.createPage(); other.name = 'Page 1'; }
      await figma.setCurrentPageAsync(other);
    }
    ex[i].remove();
  }
}
function resetState() { SCREENS.length = 0; LINKS.length = 0; FLAG.clear(); Object.keys(REG).forEach(function (k) { delete REG[k]; }); }

async function generate(msg) {
  figma.ui.postMessage({ type: 'busy', message: 'Loading fonts...' });
  await loadFonts();
  await removeExisting();
  resetState();
  const page = figma.createPage();
  page.name = PAGE_NAME;
  await figma.setCurrentPageAsync(page);
  const p = msg.portals || { patient: true, doctor: true, admin: true };
  figma.ui.postMessage({ type: 'busy', message: 'Building screens...' });
  if (p.patient) buildPatient();
  if (p.doctor) buildDoctor();
  if (p.admin) buildAdmin();
  SCREENS.forEach(function (s) { /* finish already set pluginData */ });
  figma.ui.postMessage({ type: 'busy', message: 'Arranging sections...' });
  const items = layout(msg.labels !== false);
  let made = 0, missing = [];
  if (msg.links !== false) {
    figma.ui.postMessage({ type: 'busy', message: 'Wiring prototype links...' });
    const r = await applyLinks(); made = r.made; missing = r.missing;
    setFlowStarts();
  }
  figma.viewport.scrollAndZoomIntoView(page.children.slice(0, 1));
  figma.ui.postMessage({ type: 'catalog', items: items, summary: { screens: SCREENS.length, links: made, missing: missing } });
  figma.notify('Done: ' + SCREENS.length + ' screens, ' + made + ' prototype links');
}

function layout(labels) {
  const groups = {}, order = [];
  SCREENS.forEach(function (s) { if (!groups[s.group]) { groups[s.group] = []; order.push(s.group); } groups[s.group].push(s); });
  const cols = 8, cw = 440, ch = 960;
  let y = 0;
  const items = [];
  order.forEach(function (g) {
    const list = groups[g];
    const sec = figma.createSection();
    sec.name = g;
    const rows = Math.ceil(list.length / cols);
    sec.x = 0; sec.y = y;
    sec.resizeWithoutConstraints(Math.min(list.length, cols) * cw + 80, rows * ch + 120);
    list.forEach(function (s, i) {
      const x = 60 + (i % cols) * cw, yy = 100 + Math.floor(i / cols) * ch;
      sec.appendChild(s.f);
      s.f.x = x; s.f.y = yy;
      if (labels) {
        const t = txt(s.id + '  \u00B7  ' + s.name + '  \u00B7  ' + s.status, 'smallStrong', STATUS_COLOR[s.status] || C.textSecondary, { hug: true });
        t.name = 'label ' + s.id;
        sec.appendChild(t); t.x = x; t.y = yy - 32;
      }
      items.push({ id: s.id, name: s.name, status: s.status, group: g, nodeId: s.f.id });
    });
    y += sec.height + 200;
  });
  return items;
}

async function applyLinks() {
  let made = 0;
  const missing = [];
  for (let i = 0; i < LINKS.length; i++) {
    const L = LINKS[i];
    let actions;
    if (L.to === 'BACK') actions = [{ type: 'BACK' }];
    else {
      const d = REG[L.to];
      if (!d) { missing.push(L.from + ' -> ' + L.to); continue; }
      actions = [{ type: 'NODE', destinationId: d.id, navigation: 'NAVIGATE', transition: { type: 'DISSOLVE', easing: { type: 'EASE_OUT' }, duration: 0.2 }, resetVideoPosition: false }];
    }
    const trigger = L.timeout ? { type: 'AFTER_TIMEOUT', timeout: L.timeout } : { type: 'ON_CLICK' };
    await L.node.setReactionsAsync([{ trigger: trigger, actions: actions }]);
    made++;
  }
  return { made: made, missing: missing };
}
function setFlowStarts() {
  const f = [];
  if (REG['P-01']) f.push({ nodeId: REG['P-01'].id, name: 'Patient app' });
  if (REG['D-01']) f.push({ nodeId: REG['D-01'].id, name: 'Doctor portal' });
  if (REG['A-01']) f.push({ nodeId: REG['A-01'].id, name: 'Admin portal' });
  try { figma.currentPage.flowStartingPoints = f; } catch (e) { }
}
async function gotoNode(id) {
  const n = await figma.getNodeByIdAsync(id);
  if (!n) { figma.notify('Screen not found. Generate again.'); return; }
  let p = n; while (p && p.type !== 'PAGE') p = p.parent;
  if (p && p !== figma.currentPage) await figma.setCurrentPageAsync(p);
  figma.currentPage.selection = [n];
  figma.viewport.scrollAndZoomIntoView([n]);
}
async function scanExisting() {
  const page = figma.root.children.find(function (p) { return p.name === PAGE_NAME; });
  if (!page) { figma.ui.postMessage({ type: 'catalog', items: [], summary: null }); return; }
  await page.loadAsync();
  const items = [];
  page.children.forEach(function (sec) {
    if (!sec.children) return;
    sec.children.forEach(function (f) {
      const raw = f.getPluginData ? f.getPluginData('rsMeta') : '';
      if (raw) { const m = JSON.parse(raw); m.nodeId = f.id; items.push(m); }
    });
  });
  figma.ui.postMessage({ type: 'catalog', items: items, summary: items.length ? { screens: items.length, links: null, missing: [] } : null });
}
