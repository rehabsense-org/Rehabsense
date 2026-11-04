// RehabSense Figma Plugin - core library
// Design values come ONLY from PROJECT_HANDOFF.md section 6 (lib/core/tokens.dart).

const C = {
  brandGreen: '#006241', brandAction: '#00754A', brandDeep: '#1E3932', brandUplift: '#2B5148', brandMint: '#D4E9E2',
  accentGold: '#CBA258', accentGoldLight: '#DFC49D', accentGoldWash: '#FAF6EE', accentGoldDeep: '#7D5E22',
  surfaceCanvas: '#F2F0EB', surfaceCeramic: '#EDEBE9', surfaceCard: '#FFFFFF', surfaceCool: '#F9F9F9',
  surfaceInk: '#000000', surfaceCamera: '#101614',
  textPrimary: { c: '#000000', o: 0.87 }, textSecondary: { c: '#000000', o: 0.58 },
  textOnDark: '#FFFFFF', textOnDarkSoft: { c: '#FFFFFF', o: 0.7 }, textMutedGreen: '#33433D',
  borderInput: '#D6DBDE', borderHairline: '#E7E7E7',
  success: '#00754A', successTint: '#EAF4F0', error: '#C82014', errorTint: '#FBECEB',
  warning: '#FBBC05', warningInk: '#8A6100', warningTint: '#FEF5DA',
  scrim: { c: '#000000', o: 0.5 }, glass: { c: '#FFFFFF', o: 0.16 }
};
// [size, weight, lineHeightUnit, lineHeightValue, letterSpacingPercent]
const T = {
  displayMetric: [56, 'Semi Bold', 'AUTO', 0, -2], displayMedium: [32, 'Semi Bold', 'P', 120, 0],
  h1: [24, 'Semi Bold', 'PX', 36, 0], h2: [24, 'Regular', 'PX', 36, 0], h3: [19, 'Semi Bold', 'P', 140, 0],
  bodyLarge: [19, 'Regular', 'P', 175, 0], body: [16, 'Regular', 'P', 150, 0], bodyStrong: [16, 'Semi Bold', 'P', 150, 0],
  small: [14, 'Regular', 'P', 150, 0], smallStrong: [14, 'Semi Bold', 'P', 150, 0],
  caption: [13, 'Regular', 'P', 150, 0], captionStrong: [13, 'Semi Bold', 'P', 150, 0],
  overline: [12, 'Bold', 'P', 150, 10], btnL: [16, 'Semi Bold', 'P', 120, 0], btnM: [14, 'Semi Bold', 'P', 120, 0]
};
const R = { input: 4, card: 12, hero: 16, sheet: 24, pill: 50 };

const ICONS = {
  activity: '<polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>',
  home: '<path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>',
  book: '<path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>',
  chart: '<line x1="12" x2="12" y1="20" y2="10"/><line x1="18" x2="18" y1="20" y2="4"/><line x1="6" x2="6" y1="20" y2="16"/>',
  user: '<path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>',
  users: '<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>',
  bell: '<path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/>',
  left: '<path d="m15 18-6-6 6-6"/>', right: '<path d="m9 18 6-6-6-6"/>',
  x: '<path d="M18 6 6 18"/><path d="m6 6 12 12"/>', check: '<path d="M20 6 9 17l-5-5"/>',
  mail: '<rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>',
  lock: '<rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>',
  eye: '<path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/>',
  camera: '<path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z"/><circle cx="12" cy="13" r="3"/>',
  cameraOff: '<path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z"/><line x1="2" x2="22" y1="2" y2="22"/>',
  settings: '<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 1 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 1 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 1 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 1 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>',
  search: '<circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/>', plus: '<path d="M5 12h14"/><path d="M12 5v14"/>',
  heart: '<path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/>',
  shield: '<path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>',
  alert: '<path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4"/><path d="M12 17h.01"/>',
  file: '<path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/>',
  logout: '<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" x2="9" y1="12" y2="12"/>',
  trash: '<path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/>',
  clock: '<circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>',
  pause: '<rect width="4" height="16" x="6" y="4"/><rect width="4" height="16" x="14" y="4"/>',
  play: '<polygon points="6 3 20 12 6 21 6 3"/>',
  help: '<circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><path d="M12 17h.01"/>',
  info: '<circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/>',
  more: '<circle cx="12" cy="12" r="1"/><circle cx="19" cy="12" r="1"/><circle cx="5" cy="12" r="1"/>',
  clipboard: '<rect width="8" height="4" x="8" y="2" rx="1" ry="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/>',
  zap: '<polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/>',
  dash: '<rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/>',
  calendar: '<rect width="18" height="18" x="3" y="4" rx="2"/><path d="M16 2v4"/><path d="M8 2v4"/><path d="M3 10h18"/>',
  pin: '<path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/>',
  edit: '<path d="M17 3a2.85 2.83 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5Z"/>',
  upload: '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" x2="12" y1="3" y2="15"/>',
  refresh: '<path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"/><path d="M21 3v5h-5"/><path d="M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16"/><path d="M8 16H3v5"/>',
  cloudOff: '<path d="M17.5 19H9a7 7 0 1 1 6.71-9h1.79a4.5 4.5 0 1 1 0 9Z"/><line x1="2" x2="22" y1="2" y2="22"/>',
  ban: '<circle cx="12" cy="12" r="10"/><path d="m4.9 4.9 14.2 14.2"/>',
  award: '<circle cx="12" cy="8" r="6"/><path d="M15.48 12.89 17 22l-5-3-5 3 1.52-9.11"/>'
};

const FLAG = new Map();      // node -> layout flags
const LINKS = [];            // prototype links
const SCREENS = [];          // registered screens
const REG = {};              // id -> frame
let CUR = null;              // current screen being built
let GROUP = '';              // current group name

function rgb(h) { return { r: parseInt(h.slice(1, 3), 16) / 255, g: parseInt(h.slice(3, 5), 16) / 255, b: parseInt(h.slice(5, 7), 16) / 255 }; }
function paint(c) { if (typeof c === 'string') return { type: 'SOLID', color: rgb(c) }; return { type: 'SOLID', color: rgb(c.c), opacity: c.o }; }
function flag(n, f) { FLAG.set(n, Object.assign(FLAG.get(n) || {}, f)); return n; }
function link(node, to, o) { if (to) LINKS.push(Object.assign({ node: node, to: to, from: CUR ? CUR.id : '' }, o || {})); return node; }

// append with auto-layout flags: vertical parents stretch text/cards, horizontal parents grow text
function A(p, ...kids) {
  for (const k of kids.flat()) {
    if (!k) continue;
    p.appendChild(k);
    const f = FLAG.get(k) || {};
    if (p.layoutMode === 'VERTICAL') { if (f.st || (k.type === 'TEXT' && !f.hug)) k.layoutAlign = 'STRETCH'; if (f.grow) k.layoutGrow = 1; }
    else if (p.layoutMode === 'HORIZONTAL') { if (f.grow || (k.type === 'TEXT' && !f.hug)) k.layoutGrow = 1; }
  }
  return p;
}

function mk(name, o) {
  o = o || {};
  const f = figma.createFrame();
  f.name = name;
  f.layoutMode = o.dir === 'H' ? 'HORIZONTAL' : 'VERTICAL';
  f.itemSpacing = o.gap || 0;
  const p = o.pad || [0, 0, 0, 0];
  f.paddingTop = p[0]; f.paddingRight = p[1]; f.paddingBottom = p[2]; f.paddingLeft = p[3];
  f.primaryAxisAlignItems = o.main || 'MIN';
  f.counterAxisAlignItems = o.cross || 'MIN';
  f.fills = o.fill ? [paint(o.fill)] : [];
  f.cornerRadius = o.r || 0;
  f.clipsContent = !!o.clip;
  f.primaryAxisSizingMode = 'AUTO'; f.counterAxisSizingMode = 'AUTO';
  if (o.w || o.h) {
    f.resize(o.w || f.width, o.h || f.height);
    // resize() fixes both axes, so restore hugging on the axis that has no explicit size
    if (o.dir === 'H') { f.primaryAxisSizingMode = o.w ? 'FIXED' : 'AUTO'; f.counterAxisSizingMode = o.h ? 'FIXED' : 'AUTO'; }
    else { f.counterAxisSizingMode = o.w ? 'FIXED' : 'AUTO'; f.primaryAxisSizingMode = o.h ? 'FIXED' : 'AUTO'; }
  }
  if (o.stroke) { f.strokes = [paint(o.stroke)]; f.strokeWeight = o.sw || 1; f.strokeAlign = 'INSIDE'; }
  if (o.shadow) f.effects = [{ type: 'DROP_SHADOW', color: { r: 0, g: 0, b: 0, a: 0.07 }, offset: { x: 0, y: 1 }, radius: 4, spread: 0, visible: true, blendMode: 'NORMAL' }];
  if (o.st) flag(f, { st: true });
  if (o.grow) flag(f, { grow: true });
  return f;
}

function txt(s, st, color, o) {
  o = o || {};
  st = st || 'body';
  const sp = T[st];
  const t = figma.createText();
  t.fontName = { family: 'Inter', style: sp[1] };
  t.fontSize = sp[0];
  t.characters = String(s);
  if (sp[2] === 'P') t.lineHeight = { unit: 'PERCENT', value: sp[3] };
  else if (sp[2] === 'PX') t.lineHeight = { unit: 'PIXELS', value: sp[3] };
  t.letterSpacing = { unit: 'PERCENT', value: sp[4] };
  if (st === 'overline' && !o.keepCase) t.characters = String(s).toUpperCase();
  t.fills = [paint(color || (st === 'h1' ? C.brandGreen : C.textPrimary))];
  t.textAlignHorizontal = o.align || 'LEFT';
  t.name = o.name || String(s).slice(0, 28);
  if (o.hug) { t.textAutoResize = 'WIDTH_AND_HEIGHT'; flag(t, { hug: true }); }
  else t.textAutoResize = 'HEIGHT';
  return t;
}

function icon(name, size, color) {
  size = size || 24; color = color || '#000000';
  const col = typeof color === 'string' ? color : color.c;
  const svg = '<svg xmlns="http://www.w3.org/2000/svg" width="' + size + '" height="' + size + '" viewBox="0 0 24 24" fill="none" stroke="' + col + '" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round">' + (ICONS[name] || ICONS.info) + '</svg>';
  const n = figma.createNodeFromSvg(svg);
  n.name = 'icon/' + name;
  n.resize(size, size);
  if (typeof color === 'object' && color.o != null) n.opacity = color.o;
  return n;
}
function circle(size, fill, name) { const e = figma.createEllipse(); e.resize(size, size); e.fills = [paint(fill)]; e.name = name || 'circle'; return e; }
function iconCircle(ic, size, bg, fg) {
  const f = mk('iconCircle', { dir: 'H', main: 'CENTER', cross: 'CENTER', w: size, h: size, fill: bg || C.brandMint, r: R.pill });
  A(f, icon(ic, Math.round(size * 0.5), fg || C.brandGreen)); return f;
}

// ---- components (mirror lib/core/widgets) ----
function btn(label, o) {
  o = o || {};
  const v = o.v || 'primary', big = o.size !== 'M';
  const st = {
    primary: [C.brandAction, C.textOnDark, null], secondary: [null, C.brandAction, C.brandAction], dark: [C.surfaceInk, C.textOnDark, null],
    text: [null, C.brandAction, null], destructive: [C.error, C.textOnDark, null], destructiveOutline: [null, C.error, C.error],
    onDarkFilled: [C.textOnDark, C.brandDeep, null], onDarkOutline: [null, C.textOnDark, C.textOnDark], disabled: [C.surfaceCeramic, C.textSecondary, null]
  }[v];
  const f = mk('Button/' + label, { dir: 'H', main: 'CENTER', cross: 'CENTER', gap: 8, h: big ? 52 : 40, pad: [0, 24, 0, 24], fill: st[0], r: R.pill, stroke: st[2] });
  if (o.icon) A(f, icon(o.icon, 20, st[1]));
  A(f, txt(label, big ? 'btnL' : 'btnM', st[1], { hug: true, align: 'CENTER' }));
  if (o.full === false) { /* hug */ } else if (o.grow) flag(f, { grow: true }); else flag(f, { st: true });
  if (o.to) link(f, o.to);
  return f;
}
function iconBtn(name, to, o) {
  o = o || {};
  const f = mk('IconButton/' + name, { dir: 'H', main: 'CENTER', cross: 'CENTER', w: 48, h: 48, fill: o.fill, r: R.pill });
  A(f, icon(name, 24, o.color || C.textPrimary));
  if (to) link(f, to); return f;
}
function card(kids, o) {
  o = o || {};
  const f = mk(o.name || 'Card', { dir: o.dir || 'V', gap: o.gap == null ? 12 : o.gap, pad: o.pad || [16, 16, 16, 16], fill: o.fill || C.surfaceCard, r: o.r || R.card, stroke: o.stroke, shadow: !o.flat && !o.stroke && !o.fill, cross: o.cross });
  A(f, kids); flag(f, { st: true }); if (o.grow) flag(f, { grow: true }); if (o.to) link(f, o.to); return f;
}
function row(kids, o) {
  o = o || {};
  const f = mk(o.name || 'Row', { dir: 'H', gap: o.gap == null ? 12 : o.gap, cross: o.cross || 'CENTER', main: o.main, pad: o.pad, fill: o.fill, r: o.r });
  A(f, kids); flag(f, { st: true }); if (o.grow) flag(f, { grow: true }); if (o.to) link(f, o.to); return f;
}
function col(kids, o) {
  o = o || {};
  const f = mk(o.name || 'Column', { dir: 'V', gap: o.gap == null ? 8 : o.gap, pad: o.pad, cross: o.cross });
  A(f, kids); flag(f, { st: !o.hug }); if (o.grow) flag(f, { grow: true }); return f;
}
function input(label, o) {
  o = o || {};
  const bd = o.err ? C.error : C.borderInput;
  const f = mk('Input/' + label, { dir: 'H', cross: 'CENTER', gap: 12, h: 56, pad: [0, 16, 0, 16], fill: C.surfaceCard, r: R.input, stroke: bd, sw: o.err ? 2 : 1 });
  if (o.icon) A(f, icon(o.icon, 20, C.textSecondary));
  const c = mk('text', { dir: 'V', gap: 0 }); flag(c, { grow: true });
  A(c, txt(label, 'caption', C.textSecondary), txt(o.value || o.hint || ' ', 'body', o.value ? C.textPrimary : C.textSecondary));
  A(f, c);
  if (o.suffix) A(f, icon(o.suffix, 20, C.textSecondary));
  if (!o.err && !o.helper) { flag(f, { st: true }); return f; }
  const w = col([f, txt(o.err || o.helper, 'caption', o.err ? C.error : C.textSecondary)], { gap: 4 });
  flag(f, { st: true }); return w;
}
function area(label, value, h) {
  const f = mk('Textarea/' + label, { dir: 'V', gap: 4, h: h || 96, pad: [8, 16, 8, 16], fill: C.surfaceCard, r: R.input, stroke: C.borderInput });
  A(f, txt(label, 'caption', C.textSecondary), txt(value || ' ', 'body', value ? C.textPrimary : C.textSecondary)); flag(f, { st: true }); return f;
}
function chip(label, o) {
  o = o || {};
  const f = mk('Chip/' + label, { dir: 'H', cross: 'CENTER', gap: 6, h: 36, pad: [0, 14, 0, 14], r: R.pill, fill: o.sel ? C.brandMint : C.surfaceCard, stroke: o.sel ? C.brandAction : C.borderInput });
  if (o.sel) A(f, icon('check', 16, C.brandGreen));
  A(f, txt(label, 'btnM', o.sel ? C.brandGreen : C.textPrimary, { hug: true }));
  if (o.to) link(f, o.to); return f;
}
function chips(list, selected, to) {
  const f = mk('Chips', { dir: 'H', gap: 8, cross: 'CENTER' }); f.layoutWrap = 'WRAP'; f.counterAxisSpacing = 8;
  f.primaryAxisSizingMode = 'FIXED'; f.resize(328, 36); f.counterAxisSizingMode = 'AUTO';
  A(f, list.map(function (l, i) { return chip(l, { sel: selected === i || (Array.isArray(selected) && selected.indexOf(i) >= 0), to: to ? to[i] : null }); }));
  flag(f, { st: true }); return f;
}
function status(type, label) {
  const m = { correct: [C.successTint, C.success, 'check'], incorrect: [C.errorTint, C.error, 'x'], incomplete: [C.warningTint, C.warningInk, 'alert'], info: [C.brandMint, C.brandGreen, 'info'], pending: [C.warningTint, C.warningInk, 'clock'], neutral: [C.surfaceCeramic, C.textSecondary, 'info'], gold: [C.accentGoldWash, C.accentGoldDeep, 'award'] }[type] || [C.brandMint, C.brandGreen, 'info'];
  const f = mk('Status/' + label, { dir: 'H', cross: 'CENTER', gap: 4, h: 26, pad: [0, 10, 0, 8], fill: m[0], r: R.pill });
  A(f, icon(m[2], 14, m[1]), txt(label, 'captionStrong', m[1], { hug: true })); return f;
}
function bar(v, h, fill, track) {
  h = h || 8;
  const t = mk('ProgressBar', { dir: 'H', h: h, r: R.pill, fill: track || C.surfaceCeramic }); flag(t, { st: true });
  t.primaryAxisSizingMode = 'FIXED'; t.resize(328, h);
  const g = figma.createRectangle(); g.resize(Math.max(h, 328 * v), h); g.cornerRadius = R.pill; g.fills = [paint(fill || C.brandAction)]; g.name = 'fill';
  A(t, g); return t;
}
function banner(type, msg) {
  const m = { error: [C.errorTint, C.error, 'alert'], offline: [C.warningTint, C.warningInk, 'cloudOff'], syncPending: [C.warningTint, C.warningInk, 'refresh'], info: [C.brandMint, C.textMutedGreen, 'info'], success: [C.successTint, C.success, 'check'] }[type];
  const f = mk('Banner/' + type, { dir: 'H', gap: 12, cross: 'MIN', pad: [12, 16, 12, 16], fill: m[0], r: R.card });
  A(f, icon(m[2], 20, m[1]), txt(msg, 'small', m[1] === C.warningInk ? C.warningInk : m[1] === C.error ? C.error : C.textMutedGreen)); flag(f, { st: true }); return f;
}
function avatar(ini, size) {
  const f = mk('Avatar', { dir: 'H', main: 'CENTER', cross: 'CENTER', w: size || 40, h: size || 40, fill: C.brandMint, r: R.pill });
  A(f, txt(ini, (size || 40) > 48 ? 'h3' : 'smallStrong', C.brandGreen, { hug: true })); return f;
}
function menu(items) {
  const f = mk('MenuCard', { dir: 'V', fill: C.surfaceCard, r: R.card, shadow: true, clip: true });
  items.forEach(function (it, i) {
    const r = mk('Row/' + it.title, { dir: 'H', gap: 12, cross: 'CENTER', h: it.sub ? 64 : 56, pad: [0, 16, 0, 16] }); flag(r, { st: true });
    const ic = it.danger ? C.error : C.brandGreen;
    A(r, icon(it.icon || 'info', 22, ic));
    const c = mk('t', { dir: 'V', gap: 0 }); flag(c, { grow: true });
    A(c, txt(it.title, 'body', it.danger ? C.error : C.textPrimary)); if (it.sub) A(c, txt(it.sub, 'caption', C.textSecondary));
    A(r, c);
    if (it.badge) A(r, status('pending', it.badge));
    A(r, icon('right', 20, C.textSecondary));
    if (it.to) link(r, it.to);
    A(f, r);
    if (i < items.length - 1) { const d = figma.createRectangle(); d.resize(296, 1); d.fills = [paint(C.borderHairline)]; d.name = 'divider'; flag(d, { st: true }); A(f, d); }
  });
  flag(f, { st: true }); return f;
}
function seg(labels, sel, tos) {
  const f = mk('SegmentedControl', { dir: 'H', gap: 2, pad: [3, 3, 3, 3], fill: C.surfaceCeramic, r: R.pill, h: 44 }); flag(f, { st: true });
  f.primaryAxisSizingMode = 'FIXED'; f.resize(328, 44);
  labels.forEach(function (l, i) {
    const s = mk('Seg/' + l, { dir: 'H', main: 'CENTER', cross: 'CENTER', h: 38, r: R.pill, fill: i === sel ? C.surfaceCard : null, shadow: i === sel }); flag(s, { grow: true });
    s.counterAxisSizingMode = 'FIXED'; s.resize(60, 38);
    A(s, txt(l, 'btnM', i === sel ? C.brandGreen : C.textSecondary, { hug: true, align: 'CENTER' })); A(f, s);
    if (tos && tos[i] && i !== sel) link(s, tos[i]);
  });
  return f;
}
function stat(label, value, delta, good) {
  const f = card([txt(label, 'caption', C.textSecondary), txt(value, 'displayMedium', C.brandGreen), delta ? status(good === false ? 'incorrect' : 'correct', delta) : null], { gap: 4, grow: true });
  f.layoutGrow = 1; flag(f, { grow: true, st: false }); return f;
}
function statRow(list) { const r = row(list.map(function (s) { return stat(s[0], s[1], s[2], s[3]); }), { gap: 12, cross: 'MIN' }); return r; }
function ring(score, size, gold) {
  const g = mk('ScoreRing', { dir: 'H', main: 'CENTER', cross: 'CENTER', w: size, h: size });
  const t = figma.createEllipse(); t.resize(size, size); t.fills = []; t.strokes = [paint(C.surfaceCeramic)]; t.strokeWeight = 10; t.strokeAlign = 'INSIDE'; t.name = 'track';
  const a = figma.createEllipse(); a.resize(size, size); a.fills = []; a.strokes = [paint(gold ? C.accentGold : C.brandAction)]; a.strokeWeight = 10; a.strokeAlign = 'INSIDE'; a.strokeCap = 'ROUND'; a.name = 'arc';
  a.arcData = { startingAngle: -Math.PI / 2, endingAngle: -Math.PI / 2 + Math.PI * 2 * score / 100, innerRadius: 1 };
  const w = figma.createFrame(); w.name = 'RingWrap'; w.resize(size, size); w.fills = []; w.clipsContent = false;
  w.appendChild(t); w.appendChild(a); t.x = 0; t.y = 0; a.x = 0; a.y = 0;
  const lab = mk('score', { dir: 'V', cross: 'CENTER' }); A(lab, txt(String(score), 'displayMedium', C.brandGreen, { hug: true }), txt('Movement score', 'caption', C.textSecondary, { hug: true }));
  g.layoutMode = 'NONE'; g.appendChild(w); w.x = 0; w.y = 0; g.appendChild(lab); lab.x = (size - lab.width) / 2; lab.y = (size - lab.height) / 2;
  return g;
}
function otp(code) {
  const r = mk('OtpField', { dir: 'H', gap: 8, main: 'CENTER' }); flag(r, { st: true });
  for (let i = 0; i < 6; i++) {
    const b = mk('digit' + i, { dir: 'H', main: 'CENTER', cross: 'CENTER', w: 48, h: 56, fill: C.surfaceCard, r: R.input, stroke: i === (code || '').length ? C.brandAction : C.borderInput, sw: i === (code || '').length ? 2 : 1 });
    A(b, txt((code || '')[i] || ' ', 'h1', C.textPrimary, { hug: true })); A(r, b);
  }
  return r;
}
function slider(v, max) {
  max = max || 10;
  const w = mk('RSSlider', { dir: 'V', gap: 8 }); flag(w, { st: true });
  const t = figma.createFrame(); t.name = 'track'; t.resize(328, 36); t.fills = []; t.layoutMode = 'NONE';
  const tr = figma.createRectangle(); tr.resize(328, 8); tr.cornerRadius = 4; tr.fills = [paint(C.surfaceCeramic)]; t.appendChild(tr); tr.x = 0; tr.y = 14;
  const fl = figma.createRectangle(); fl.resize(Math.max(8, 328 * v / max), 8); fl.cornerRadius = 4; fl.fills = [paint(v >= 8 ? C.error : v >= 5 ? C.warning : C.brandAction)]; t.appendChild(fl); fl.x = 0; fl.y = 14;
  const th = circle(28, C.surfaceCard, 'thumb'); th.strokes = [paint(C.brandAction)]; th.strokeWeight = 3; t.appendChild(th); th.x = Math.min(300, 328 * v / max - 14); th.y = 4;
  A(w, t, row([txt('No pain', 'caption', C.textSecondary), txt(String(v) + ' / ' + max, 'captionStrong', C.textPrimary, { hug: true }), txt('Worst pain', 'caption', C.textSecondary, { align: 'RIGHT' })], { gap: 8 }));
  return w;
}
function doctorCard(name, role, tags, match, to) {
  const r = row([avatar(name.split(' ').slice(-2).map(function (x) { return x[0]; }).join(''), 48),
    col([txt(name, 'bodyStrong'), txt(role, 'caption', C.textSecondary), row(tags.map(function (t) { return status('info', t); }), { gap: 6 })], { gap: 4, grow: true }),
    match ? status('gold', match) : null, icon('right', 20, C.textSecondary)], { gap: 12, cross: 'MIN' });
  const c = card([r], { to: to, name: 'DoctorCard/' + name }); return c;
}
function listItem(title, sub, o) {
  o = o || {};
  const kids = [];
  if (o.icon) kids.push(iconCircle(o.icon, 40));
  if (o.avatar) kids.push(avatar(o.avatar, 40));
  kids.push(col([txt(title, 'bodyStrong'), sub ? txt(sub, 'caption', C.textSecondary) : null], { gap: 2, grow: true }));
  if (o.chip) kids.push(o.chip);
  if (o.right) kids.push(txt(o.right, 'bodyStrong', C.brandGreen, { hug: true }));
  if (o.to) kids.push(icon('right', 20, C.textSecondary));
  return card([row(kids, { gap: 12 })], { to: o.to, name: 'Item/' + title });
}
function heading(t, sub) { return col([txt(t, 'h1'), sub ? txt(sub, 'body', C.textSecondary) : null], { gap: 8 }); }
function sectionTitle(t, linkLabel, to) {
  const kids = [txt(t, 'h3', C.textPrimary)];
  if (linkLabel) { const l = txt(linkLabel, 'btnM', C.brandAction, { hug: true }); if (to) link(l, to); kids.push(l); }
  return row(kids, { main: 'SPACE_BETWEEN' });
}
function overline(t) { return txt(t, 'overline', C.textSecondary); }
function stepHeader(n, total, title) {
  return col([row([txt('Step ' + n + ' of ' + total, 'captionStrong', C.textSecondary), txt(title, 'captionStrong', C.brandGreen, { align: 'RIGHT' })], { main: 'SPACE_BETWEEN' }), bar(n / total, 6)], { gap: 8 });
}
function checkRow(label, on) {
  const b = mk('check', { dir: 'H', main: 'CENTER', cross: 'CENTER', w: 24, h: 24, r: 4, fill: on ? C.brandAction : C.surfaceCard, stroke: on ? null : C.borderInput, sw: 2 });
  if (on) A(b, icon('check', 16, C.textOnDark));
  return row([b, txt(label, 'small', C.textPrimary)], { gap: 12, cross: 'MIN' });
}
function bullet(ic, t, sub) { return row([iconCircle(ic, 40), col([txt(t, 'bodyStrong'), sub ? txt(sub, 'small', C.textSecondary) : null], { gap: 2, grow: true })], { gap: 12 }); }
function infoBox(t, tone) { return card([txt(t, 'small', C.textMutedGreen)], { fill: tone === 'warn' ? C.warningTint : C.brandMint, flat: true }); }
function kv(k, v) { return row([txt(k, 'small', C.textSecondary), txt(v, 'smallStrong', C.textPrimary, { align: 'RIGHT' })], { main: 'SPACE_BETWEEN', gap: 12 }); }
function divider() { const d = figma.createRectangle(); d.resize(328, 1); d.fills = [paint(C.borderHairline)]; d.name = 'divider'; flag(d, { st: true }); return d; }
function docTile(name, meta, ok) { return card([row([iconCircle('file', 40), col([txt(name, 'bodyStrong'), txt(meta, 'caption', C.textSecondary)], { gap: 2, grow: true }), ok ? icon('check', 20, C.success) : icon('upload', 20, C.brandAction)], { gap: 12 })], { stroke: ok ? null : C.borderInput, name: 'DocumentTile/' + name }); }
function timeline(items) {
  const c = col(items.map(function (it) {
    return row([iconCircle(it[2] ? 'check' : 'clock', 32, it[2] ? C.brandAction : C.surfaceCeramic, it[2] ? C.textOnDark : C.textSecondary), col([txt(it[0], 'bodyStrong'), txt(it[1], 'caption', C.textSecondary)], { gap: 0, grow: true })], { gap: 12 });
  }), { gap: 16 }); return card([c]);
}

// ---- screens ----
function Screen(id, name, st, o) {
  o = o || {};
  const f = figma.createFrame();
  f.name = id + ' ' + name;
  f.resize(360, 800);
  f.layoutMode = 'NONE';
  f.fills = [paint(o.bg || (o.camera ? C.surfaceCamera : C.surfaceCanvas))];
  f.clipsContent = true;
  const s = { id: id, name: name, status: st, f: f, body: null, o: o, group: o.group || GROUP };
  CUR = s;
  const topH = o.app ? 72 : 32;
  const botH = o.nav ? 80 : (o.action ? 72 : 0);
  if (!o.camera) {
    const b = mk('Body', { dir: 'V', gap: o.gap == null ? 20 : o.gap, pad: [topH + 8, 16, botH + 24, 16], w: 360 });
    f.appendChild(b); b.x = 0; b.y = 0; s.body = b;
  }
  s.add = function () { A(s.body, Array.prototype.slice.call(arguments)); return s; };
  s.abs = function (n, x, y) { f.appendChild(n); n.x = x; n.y = y; return n; };
  s.fixed = 0;
  const bars = [];
  if (o.app) bars.push(appBar(s, o.app));
  else if (!o.camera) bars.push(statusBar());
  if (o.nav) bars.push(navBar(o.nav, o.active));
  if (o.action) bars.push(actionBar(o.action));
  bars.forEach(function (b) { f.appendChild(b); });
  s.fixed = bars.length;
  s.finish = function () {
    try { f.overflowDirection = 'VERTICAL_SCROLLING'; f.numberOfFixedChildren = s.fixed; } catch (e) { }
    f.setPluginData('rsId', id); f.setPluginData('rsMeta', JSON.stringify({ id: id, name: name, status: st, group: s.group }));
  };
  SCREENS.push(s); REG[id] = f;
  return s;
}
function statusBar(dark) {
  const bar = figma.createFrame(); bar.name = 'StatusBar'; bar.resize(360, 32); bar.fills = []; bar.constraints = { horizontal: 'STRETCH', vertical: 'MIN' };
  const t = txt('9:41', 'captionStrong', dark ? C.textOnDark : C.textPrimary, { hug: true }); bar.appendChild(t); t.x = 20; t.y = 8; return bar;
}
function appBar(s, o) {
  const bar = figma.createFrame(); bar.name = 'AppBar'; bar.resize(360, 72); bar.fills = [paint(o.dark ? C.surfaceCamera : C.surfaceCanvas)]; bar.constraints = { horizontal: 'STRETCH', vertical: 'MIN' };
  const t = txt('9:41', 'captionStrong', o.dark ? C.textOnDark : C.textPrimary, { hug: true }); bar.appendChild(t); t.x = 20; t.y = 6;
  const r = mk('Row', { dir: 'H', cross: 'CENTER', gap: 0, pad: [0, 4, 0, 4], w: 360, h: 48 });
  bar.appendChild(r); r.x = 0; r.y = 24;
  if (o.back || o.close) A(r, iconBtn(o.close ? 'x' : 'left', o.back === true || !o.back ? 'BACK' : o.back, { color: o.dark ? C.textOnDark : C.textPrimary })); else { const sp = figma.createRectangle(); sp.resize(12, 1); sp.fills = []; sp.name = 'pad'; A(r, sp); }
  const ti = txt(o.title || '', 'h3', o.dark ? C.textOnDark : C.textPrimary); A(r, ti);
  (o.right || []).forEach(function (x) { A(r, iconBtn(x[0], x[1])); });
  return bar;
}
function navBar(kind, active) {
  const items = NAVS[kind];
  const bar = mk('BottomNav', { dir: 'H', main: 'SPACE_BETWEEN', cross: 'CENTER', w: 360, h: 80, fill: C.surfaceCard, pad: [0, 8, 0, 8] });
  bar.strokes = [paint(C.borderHairline)]; bar.strokeWeight = 1; bar.strokeAlign = 'INSIDE';
  bar.constraints = { horizontal: 'STRETCH', vertical: 'MAX' };
  items.forEach(function (it, i) {
    const on = i === active;
    const c = mk('Tab/' + it[1], { dir: 'V', cross: 'CENTER', gap: 4, h: 64, main: 'CENTER' }); flag(c, { grow: true });
    c.primaryAxisSizingMode = 'AUTO';
    const pill = mk('pill', { dir: 'H', main: 'CENTER', cross: 'CENTER', w: 64, h: 32, r: R.pill, fill: on ? C.brandMint : null });
    A(pill, icon(it[0], 24, on ? C.brandGreen : C.textSecondary));
    A(c, pill, txt(it[1], on ? 'captionStrong' : 'caption', on ? C.brandGreen : C.textSecondary, { hug: true, align: 'CENTER' }));
    A(bar, c); c.layoutGrow = 1; link(c, it[2]);
  });
  return bar;
}
function actionBar(a) {
  const bar = mk('ActionBar', { dir: 'H', cross: 'CENTER', gap: 12, w: 360, h: 72, fill: C.surfaceCard, pad: [0, 16, 0, 16] });
  bar.strokes = [paint(C.borderHairline)]; bar.strokeWeight = 1; bar.strokeAlign = 'INSIDE'; bar.constraints = { horizontal: 'STRETCH', vertical: 'MAX' };
  (Array.isArray(a) ? a : [a]).forEach(function (b) { const x = btn(b.label, { v: b.v, to: b.to, size: b.size, icon: b.icon, grow: true }); A(bar, x); x.layoutGrow = 1; });
  return bar;
}
const NAVS = {
  patient: [['home', 'Home', 'P-11'], ['book', 'Courses', 'P-12'], ['chart', 'Progress', 'P-23'], ['user', 'Profile', 'P-28']],
  doctor: [['home', 'Home', 'D-14'], ['users', 'Patients', 'D-17'], ['zap', 'Exercises', 'D-20'], ['user', 'Profile', 'D-26']],
  admin: [['dash', 'Dashboard', 'A-04'], ['heart', 'Doctors', 'A-10'], ['users', 'Patients', 'A-15'], ['zap', 'Exercises', 'A-17'], ['more', 'More', 'A-22']]
};

// camera surface with drawn skeleton
function skeleton(s, o) {
  o = o || {};
  const pts = { h: [180, 190], ls: [140, 260], rs: [220, 260], le: [118, 340], re: [242, 340], lh: [150, 410], rh: [210, 410], lk: [145, 520], rk: [215, 520], la: [140, 620], ra: [220, 620] };
  const bones = [['ls', 'rs'], ['ls', 'lh'], ['rs', 'rh'], ['lh', 'rh'], ['ls', 'le'], ['rs', 're'], ['lh', 'lk'], ['rh', 'rk'], ['lk', 'la'], ['rk', 'ra']];
  const d = bones.map(function (b) { return 'M ' + pts[b[0]][0] + ' ' + pts[b[0]][1] + ' L ' + pts[b[1]][0] + ' ' + pts[b[1]][1]; }).join(' ');
  const v = figma.createVector(); v.vectorPaths = [{ windingRule: 'NONE', data: d }]; v.fills = []; v.strokes = [paint(o.color || '#6EE7B7')]; v.strokeWeight = 4; v.strokeCap = 'ROUND'; v.name = 'Skeleton/bones';
  s.f.appendChild(v); v.x = 0; v.y = 0;
  Object.keys(pts).forEach(function (k) { const c = circle(12, k === 'lk' || k === 'rk' ? (o.joint || C.accentGold) : C.textOnDark, 'joint/' + k); s.f.appendChild(c); c.x = pts[k][0] - 6; c.y = pts[k][1] - 6; });
}
function glassBtn(s, ic, x, y, to, size) {
  const b = mk('Glass/' + ic, { dir: 'H', main: 'CENTER', cross: 'CENTER', w: size || 48, h: size || 48, fill: C.glass, r: R.pill });
  A(b, icon(ic, 24, C.textOnDark)); s.abs(b, x, y); if (to) link(b, to); return b;
}
function pill(s, label, x, y, w, fill, color) {
  const f = mk('Pill', { dir: 'H', main: 'CENTER', cross: 'CENTER', w: w, h: 40, fill: fill || C.glass, r: R.pill });
  A(f, txt(label, 'btnM', color || C.textOnDark, { hug: true, align: 'CENTER' })); s.abs(f, x, y); return f;
}

// dialog overlay
function dialogScreen(id, name, st, o) {
  const s = Screen(id, name, st, { bg: C.surfaceCanvas, group: o.group });
  const dim = figma.createRectangle(); dim.resize(360, 800); dim.fills = [paint(C.scrim)]; dim.name = 'Scrim'; s.f.appendChild(dim); dim.x = 0; dim.y = 0;
  const sheet = !!o.sheet;
  const box = mk('Dialog', { dir: 'V', gap: 16, pad: [24, 24, 24, 24], fill: C.surfaceCard, r: sheet ? R.sheet : R.hero, w: sheet ? 360 : 312, cross: 'CENTER' });
  A(box, iconCircle(o.icon || 'info', 56, o.destructive ? C.errorTint : C.brandMint, o.destructive ? C.error : C.brandGreen));
  A(box, txt(o.title, 'h3', C.textPrimary, { align: 'CENTER' }), txt(o.body, 'small', C.textSecondary, { align: 'CENTER' }));
  (o.extra || []).forEach(function (e) { A(box, e); });
  A(box, btn(o.primary[0], { v: o.destructive ? 'destructive' : 'primary', to: o.primary[1] }));
  if (o.secondary) A(box, btn(o.secondary[0], { v: o.destructive ? 'secondary' : 'text', to: o.secondary[1] || 'BACK' }));
  s.f.appendChild(box);
  if (sheet) { box.x = 0; box.y = 800 - box.height; box.topLeftRadius = R.sheet; box.topRightRadius = R.sheet; box.bottomLeftRadius = 0; box.bottomRightRadius = 0; }
  else { box.x = 24; box.y = (800 - box.height) / 2; }
  s.finish(); return s;
}
// centred state screen (empty / error / success)
function stateScreen(id, name, st, o) {
  const s = Screen(id, name, st, { app: o.app, nav: o.nav, active: o.active, bg: o.bg, group: o.group, gap: 16 });
  const dark = o.bg === C.brandDeep;
  const top = figma.createRectangle(); top.resize(10, o.pad == null ? 80 : o.pad); top.fills = []; top.name = 'spacer';
  s.add(top);
  const c = col([iconCircle(o.icon || 'info', 96, dark ? C.brandUplift : (o.tone === 'error' ? C.errorTint : o.tone === 'warn' ? C.warningTint : C.brandMint), dark ? C.brandMint : (o.tone === 'error' ? C.error : o.tone === 'warn' ? C.warningInk : C.brandGreen)),
    txt(o.title, 'h1', dark ? C.textOnDark : C.brandGreen, { align: 'CENTER' }), txt(o.body, 'body', dark ? C.textOnDarkSoft : C.textSecondary, { align: 'CENTER' })].concat(o.extra || []), { gap: 16, cross: 'CENTER' });
  s.add(c);
  (o.buttons || []).forEach(function (b) { s.add(btn(b[0], { v: b[2] || (dark ? 'onDarkFilled' : 'primary'), to: b[1] })); });
  s.finish(); return s;
}
// wizard: one frame per step
function wizard(idBase, name, st, o) {
  const n = o.steps.length;
  o.steps.forEach(function (stp, i) {
    const id = i === 0 ? idBase : idBase + String.fromCharCode(97 + i);
    const nextId = i < n - 1 ? idBase + String.fromCharCode(98 + i) : o.done;
    const prevId = i === 0 ? o.back : (i === 1 ? idBase : idBase + String.fromCharCode(96 + i));
    const s = Screen(id, name + ' - step ' + (i + 1), st, { app: { title: o.title, back: prevId || 'BACK' }, action: [{ label: i === n - 1 ? o.finish : 'Continue', to: stp.to || nextId }], group: o.group });
    s.add(stepHeader(i + 1, n, stp.title));
    if (stp.sub) s.add(heading(stp.head || stp.title, stp.sub));
    stp.build(s);
    s.finish();
  });
}
function listScreen(id, name, st, o) {
  const s = Screen(id, name, st, { app: o.app, nav: o.nav, active: o.active, action: o.action, group: o.group });
  if (o.head) s.add(heading(o.head[0], o.head[1]));
  if (o.seg) s.add(seg(o.seg[0], o.seg[1], o.seg[2]));
  if (o.chips) s.add(chips(o.chips[0], o.chips[1], o.chips[2]));
  (o.items || []).forEach(function (it) { s.add(it); });
  if (o.build) o.build(s);
  s.finish(); return s;
}
// PATIENT PORTAL - screen IDs follow UPDATE_BRIEF section 4
function buildPatient() {
  GROUP = 'PATIENT - Existing and Changed screens';
  let s;

  // ---------- Auth ----------
  s = Screen('P-01', 'Splash', 'CHANGED', { bg: C.brandDeep, gap: 16 });
  s.add(rectSpacer(260), col([iconCircle('activity', 96, C.brandUplift, C.brandMint), txt('RehabSense', 'displayMedium', C.textOnDark, { align: 'CENTER' }), txt('Rehab, guided by your camera', 'body', C.textOnDarkSoft, { align: 'CENTER' })], { gap: 16, cross: 'CENTER' }));
  link(s.f, 'P-02', { timeout: 1.6 }); s.finish();

  s = Screen('P-02', 'Welcome', 'CHANGED', {});
  s.add(rectSpacer(24), col([iconCircle('activity', 120), txt('Rehab, guided by your camera', 'h1', C.brandGreen, { align: 'CENTER' })], { gap: 20, cross: 'CENTER' }),
    bullet('camera', 'On-device tracking', 'Your camera video never leaves your phone.'), bullet('shield', 'Private by design', 'No video or images are stored.'), bullet('heart', 'Safe, guided exercises', 'Clear feedback on every repetition.'),
    txt('RehabSense supports your recovery. It does not replace medical advice.', 'caption', C.textSecondary, { align: 'CENTER' }),
    btn('Get started', { to: 'P-04' }), btn('I already have an account', { v: 'secondary', to: 'P-03' }),
    row([btn('I am a Doctor', { v: 'text', size: 'M', to: 'D-01', full: false }), btn('Staff login', { v: 'text', size: 'M', to: 'A-01', full: false })], { main: 'CENTER', gap: 8 }));
  s.finish();

  s = Screen('P-03', 'Login', 'CHANGED', { app: { title: '', back: 'P-02' }, gap: 16 });
  s.add(heading('Welcome back', 'Log in to continue your rehab.'), input('Email', { icon: 'mail', value: 'alex@rehab.test' }), input('Password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022', suffix: 'eye' }),
    btn('Forgot password?', { v: 'text', size: 'M', to: 'P-06', full: false }), btn('Log in', { to: 'P-11' }),
    txt('or', 'small', C.textSecondary, { align: 'CENTER' }), btn('Create account', { v: 'secondary', to: 'P-04' }),
    row([btn('Prototype: inactive account', { v: 'text', size: 'M', to: 'P-52', full: false })], { main: 'CENTER' }));
  s.finish();

  s = Screen('P-04', 'Register', 'EXISTING', { app: { title: '', back: 'P-02' }, gap: 14 });
  s.add(heading('Create your account', 'Patient account. It takes a minute.'), input('Full name', { icon: 'user', value: 'Alex Morgan' }), input('Email', { icon: 'mail', value: 'alex@rehab.test' }), input('Password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022', suffix: 'eye' }),
    card([checkRow('8 or more characters', true), checkRow('At least 1 letter', true), checkRow('At least 1 number', true)], { gap: 8, flat: true, fill: C.brandMint }),
    input('Confirm password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022' }), checkRow('I agree to the Terms and Privacy Policy', true),
    btn('Create account', { to: 'P-05' }), row([txt('Already have an account?', 'small', C.textSecondary, { hug: true }), btn('Log in', { v: 'text', size: 'M', to: 'P-03', full: false })], { main: 'CENTER', gap: 4 }));
  s.finish();

  s = Screen('P-05', 'Verify Email (OTP)', 'CHANGED', { app: { title: '', back: 'P-04' }, gap: 20 });
  s.add(rectSpacer(8), col([iconCircle('mail', 80), txt('Enter your code', 'h1', C.brandGreen, { align: 'CENTER' }), txt('We sent a 6-digit code to alex@rehab.test', 'body', C.textSecondary, { align: 'CENTER' })], { gap: 12, cross: 'CENTER' }),
    otp('482'), banner('info', 'Codes expire after 10 minutes. Check your spam folder.'), btn('Verify', { to: 'P-08' }),
    btn('Resend code (60s)', { v: 'text', to: 'P-05b' }), btn('Change email address', { v: 'text', to: 'P-04' }));
  s.finish();
  s = Screen('P-05b', 'Verify Email - wrong code', 'CHANGED', { app: { title: '', back: 'P-04' }, gap: 20 });
  s.add(rectSpacer(8), col([iconCircle('mail', 80), txt('Enter your code', 'h1', C.brandGreen, { align: 'CENTER' }), txt('We sent a 6-digit code to alex@rehab.test', 'body', C.textSecondary, { align: 'CENTER' })], { gap: 12, cross: 'CENTER' }),
    banner('error', 'That code is wrong or expired. Request a new one.'), otp('482913'), btn('Verify', { to: 'P-08' }), btn('Resend code', { v: 'text', to: 'P-05' }));
  s.finish();

  s = Screen('P-06', 'Forgot Password', 'EXISTING', { app: { title: '', back: 'P-03' }, gap: 16 });
  s.add(heading('Forgot password?', 'Enter your email and we will send a reset link.'), input('Email', { icon: 'mail', value: 'alex@rehab.test' }), btn('Send reset link', { to: 'P-06b' }), btn('Back to log in', { v: 'text', to: 'P-03' }));
  s.finish();
  stateScreen('P-06b', 'Forgot Password - sent', 'EXISTING', { app: { title: '', back: 'P-06' }, icon: 'mail', title: 'Check your email', body: 'We sent a reset link to alex@rehab.test.', pad: 40, buttons: [['Open email app', 'P-07'], ['Resend email', 'P-06b', 'secondary'], ['Back to log in', 'P-03', 'text']] });
  s = Screen('P-07', 'Reset Password', 'EXISTING', { app: { title: '', close: true, back: 'P-03' }, gap: 16 });
  s.add(heading('Create new password'), input('New password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022', suffix: 'eye' }), card([checkRow('8 or more characters', true), checkRow('At least 1 letter', true), checkRow('At least 1 number', true)], { gap: 8, flat: true, fill: C.brandMint }), input('Confirm password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022' }), btn('Update password', { to: 'P-03' }));
  s.finish();

  // ---------- Onboarding ----------
  s = Screen('P-08', 'Profile Setup', 'EXISTING', { gap: 16 });
  s.add(rectSpacer(8), stepHeader(1, 2, 'Profile'), heading('Tell us about you', 'Only what is needed. You can change it later.'), input('Display name', { icon: 'user', value: 'Alex' }), overline('Age range'),
    chips(['Under 18', '18-29', '30-44', '45-64', '65+'], 2), overline('Main goal'),
    card([row([iconCircle('activity', 40), txt('Knee recovery', 'bodyStrong')], { gap: 12 })], { stroke: C.brandAction }), card([row([iconCircle('activity', 40), txt('Shoulder mobility', 'bodyStrong')], { gap: 12 })]), card([row([iconCircle('heart', 40), txt('General', 'bodyStrong')], { gap: 12 })]),
    btn('Save and continue', { to: 'P-09' }), btn('Skip for now', { v: 'text', to: 'P-09' }));
  s.finish();

  s = Screen('P-09', 'Safety and Consent', 'EXISTING', { app: { title: '', back: 'P-08' }, gap: 14 });
  s.add(stepHeader(2, 2, 'Safety'), bullet('camera', 'On-device tracking', 'Your camera is processed on this phone only.'), bullet('shield', 'Medical privacy', 'No video or images are saved or uploaded.'), bullet('heart', 'Exercise safely', 'Stop if you feel sharp pain or dizziness.'),
    card([txt('RehabSense is a guidance tool. It is not a medical device and does not replace advice from your doctor or physiotherapist.', 'small', C.textMutedGreen)], { fill: C.brandMint, flat: true }),
    checkRow('I understand and agree', true), btn('Allow camera and continue', { to: 'P-11' }), btn('Not now', { v: 'text', to: 'P-10' }));
  s.finish();
  stateScreen('P-10', 'Camera Help', 'EXISTING', { app: { title: '', back: 'P-09' }, icon: 'cameraOff', title: 'Camera access is off', body: 'RehabSense needs your camera to count reps. Turn it on in Settings > Permissions > Camera.', pad: 24, buttons: [['Open settings', 'BACK'], ['Back to home', 'P-11', 'secondary']] });

  // ---------- Home (6 prescribed states) ----------
  const homeBase = function (id, name, st, cont, nav) {
    const s = Screen(id, name, st, { nav: 'patient', active: 0, gap: 16 });
    s.add(row([col([txt('Good morning, Alex', 'h3', C.textPrimary), txt('Ready for today\u2019s session?', 'small', C.textSecondary)], { gap: 0, grow: true }), iconBtn('bell', 'P-27'), (function () { const a = avatar('AM', 40); link(a, 'P-28'); return a; })()], { gap: 4 }));
    s.add(card([txt('Continue where you left off', 'captionStrong', C.textOnDarkSoft), txt('Mini Squats', 'h3', C.textOnDark), txt('4 of 10 reps done \u00B7 about 3 min left', 'small', C.textOnDarkSoft), bar(0.4, 8, C.brandMint, C.brandUplift), btn('Resume', { v: 'onDarkFilled', size: 'M', to: 'P-16' })], { fill: C.brandDeep, r: R.hero, gap: 10 }));
    s.add(cont);
    s.add(card([txt('Today\u2019s plan', 'captionStrong', C.textSecondary), txt('Straight-Leg Raise', 'bodyStrong'), txt('2 sets \u00B7 10 reps \u00B7 45 s rest', 'small', C.textSecondary), btn('Start', { size: 'M', to: 'P-14' })], { gap: 8, to: 'P-14' }));
    s.add(sectionTitle('Courses', 'See all', 'P-12'));
    s.add(listItem('Knee Rehabilitation', '5 exercises \u00B7 Beginner', { icon: 'activity', right: '40%', to: 'P-13' }), listItem('Shoulder Mobility', '5 exercises \u00B7 Beginner', { icon: 'activity', right: '0%', to: 'P-13' }));
    s.add(sectionTitle('Recent activity', 'View all', 'P-25'));
    s.add(listItem('Mini Squats', 'Today \u00B7 10:30 AM', { chip: status('correct', '86'), to: 'P-26' }), listItem('Heel Slide', 'Yesterday \u00B7 6:10 PM', { chip: status('incomplete', '64'), to: 'P-26' }));
    s.finish(); return s;
  };
  const presBox = function (title, body, chipEl, cta) { return card([row([iconCircle('clipboard', 40), col([txt('Prescribed by your doctor', 'captionStrong', C.brandGreen), txt(title, 'bodyStrong')], { gap: 0, grow: true }), chipEl], { gap: 12 }), body ? txt(body, 'small', C.textSecondary) : null, cta], { gap: 12, stroke: C.brandAction, name: 'PrescribedContainer' }); };
  homeBase('P-11', 'Home - Prescribed locked', 'CHANGED', presBox('Connect with a doctor', 'Get exercises made for you and let your doctor follow your progress.', status('neutral', 'Locked'), btn('Connect with a doctor', { v: 'secondary', size: 'M', to: 'P-37' })));
  homeBase('P-11b', 'Home - Request pending', 'CHANGED', presBox('Request sent to Dr. Sara Khan', 'We will tell you as soon as she responds.', status('pending', 'Pending'), btn('View request', { v: 'secondary', size: 'M', to: 'P-43' })));
  homeBase('P-11c', 'Home - Connected, no exercises', 'CHANGED', presBox('Connected with Dr. Sara Khan', 'Your doctor has not assigned exercises yet.', status('correct', 'Connected'), btn('My doctor', { v: 'secondary', size: 'M', to: 'P-46' })));
  homeBase('P-11d', 'Home - Connected, assigned', 'CHANGED', presBox('2 exercises assigned', 'Next: Mini Squats \u00B7 3 sets of 10 \u00B7 today', status('correct', 'Active'), btn('Open prescribed', { size: 'M', to: 'P-48' })));
  homeBase('P-11e', 'Home - Doctor inactive', 'CHANGED', presBox('Your doctor is not available', 'Dr. Sara Khan is no longer active on RehabSense.', status('incomplete', 'Inactive'), btn('Find another doctor', { v: 'secondary', size: 'M', to: 'P-37' })));
  s = Screen('P-11f', 'Home - Loading skeleton', 'EXISTING', { nav: 'patient', active: 0, gap: 16 });
  s.add(skel(48, 0), skel(150, 16), skel(110, 12), skel(70, 12), skel(70, 12), skel(70, 12)); link(s.f, 'P-11', { timeout: 1.2 }); s.finish();

  s = Screen('P-27', 'Notification Inbox', 'CHANGED', { app: { title: 'Notifications', back: 'BACK' }, gap: 12 });
  s.add(listItem('Request accepted', 'Dr. Sara Khan accepted your request \u00B7 2 min ago', { icon: 'check', to: 'P-44' }), listItem('New exercise assigned', 'Mini Squats was added to your plan \u00B7 1 h ago', { icon: 'clipboard', to: 'P-48' }),
    listItem('Doctor feedback', 'Great control on your last session \u00B7 Yesterday', { icon: 'heart', to: 'P-26' }), listItem('Request declined', 'Dr. Omar Sheikh could not take new patients \u00B7 2 d', { icon: 'x', to: 'P-45' }),
    listItem('Doctor not available', 'Your doctor is no longer active \u00B7 3 d', { icon: 'alert', to: 'P-37' }), listItem('Reminder', 'Time for today\u2019s exercises \u00B7 3 d', { icon: 'bell', to: 'P-11' }));
  s.finish();

  // ---------- Courses ----------
  const coursesTabs = ['P-12a', 'P-12', 'P-12b'];
  s = Screen('P-12', 'Courses - Rehab', 'CHANGED', { nav: 'patient', active: 1, gap: 16 });
  s.add(heading('Courses', 'Guided programs for your recovery.'), seg(['Wellness and Yoga', 'Rehab', 'Prescribed'], 1, coursesTabs),
    courseCard('Knee Rehabilitation', 'Beginner \u00B7 5 exercises \u00B7 about 25 min', 'Restore range of motion and strength after knee injury or surgery.', 0.4, 'P-13'), courseCard('Shoulder Mobility', 'Beginner \u00B7 5 exercises \u00B7 about 20 min', 'Gentle movements to regain shoulder motion and control.', 0, 'P-13'));
  s.finish();
  s = Screen('P-12a', 'Courses - Wellness and Yoga (empty)', 'CHANGED', { nav: 'patient', active: 1, gap: 16 });
  s.add(heading('Courses', 'Guided programs for your recovery.'), seg(['Wellness and Yoga', 'Rehab', 'Prescribed'], 0, coursesTabs), card([col([iconCircle('heart', 72), txt('Yoga poses are coming soon', 'h3', C.textPrimary, { align: 'CENTER' }), txt('Hold-pose exercises will appear here.', 'small', C.textSecondary, { align: 'CENTER' }), btn('Browse rehab courses', { v: 'secondary', size: 'M', to: 'P-12' })], { gap: 12, cross: 'CENTER' })], { pad: [32, 16, 32, 16] }));
  s.finish();
  s = Screen('P-12b', 'Courses - Prescribed (locked)', 'CHANGED', { nav: 'patient', active: 1, gap: 16 });
  s.add(heading('Courses', 'Guided programs for your recovery.'), seg(['Wellness and Yoga', 'Rehab', 'Prescribed'], 2, coursesTabs), card([col([iconCircle('lock', 72), txt('Prescribed is locked', 'h3', C.textPrimary, { align: 'CENTER' }), txt('Connect with a doctor to receive exercises made for you.', 'small', C.textSecondary, { align: 'CENTER' }), btn('Connect with a doctor', { size: 'M', to: 'P-37' })], { gap: 12, cross: 'CENTER' })], { pad: [32, 16, 32, 16] }));
  s.finish();

  s = Screen('P-13', 'Course Detail', 'EXISTING', { app: { title: 'Knee Rehabilitation', back: 'P-12' }, action: { label: 'Continue course', to: 'P-14' }, gap: 12 });
  s.add(card([txt('Beginner', 'captionStrong', C.textOnDarkSoft), txt('Knee Rehabilitation', 'h3', C.textOnDark), txt('Restore range of motion and strength after knee injury or surgery.', 'small', C.textOnDarkSoft), bar(0.4, 8, C.brandMint, C.brandUplift)], { fill: C.brandDeep, r: R.hero }),
    sectionTitle('Exercises'), listItem('1. Mini Squat', '3 sets \u00B7 10 reps', { icon: 'activity', chip: status('correct', 'Done'), to: 'P-14' }), listItem('2. Straight-Leg Raise', '2 sets \u00B7 10 reps', { icon: 'activity', to: 'P-14' }),
    listItem('3. Seated Knee Extension', '2 sets \u00B7 12 reps', { icon: 'activity', to: 'P-14' }), listItem('4. Heel Slide', '2 sets \u00B7 10 reps', { icon: 'activity', to: 'P-14' }), listItem('5. Step-Up', '2 sets \u00B7 8 reps', { icon: 'activity', to: 'P-14' }));
  s.finish();

  s = Screen('P-14', 'Exercise Detail', 'EXISTING', { app: { title: 'Mini Squat', back: 'P-13' }, action: { label: 'Start exercise', to: 'P-15' }, gap: 14 });
  s.add(card([row([iconCircle('activity', 56), col([txt('Mini Squat', 'h3'), txt('Knee Rehabilitation \u00B7 Exercise 1', 'small', C.textSecondary)], { gap: 0, grow: true })], { gap: 12 }), divider(), kv('Target', '3 sets of 10 reps'), kv('Rest', '45 seconds'), kv('Camera view', 'Side'), kv('Joint tracked', 'Knee')]),
    sectionTitle('How to do it'), card([checkRow('Stand with feet shoulder-width apart', false), checkRow('Bend knees slowly to about 30 degrees', false), checkRow('Hold for 1 second, then rise slowly', false)], { gap: 10 }),
    sectionTitle('Watch out for'), infoBox('Do not let your knee move past your toes. Stop if you feel sharp pain.', 'warn'));
  s.finish();

  s = Screen('P-15', 'Pre-Exercise Checklist', 'EXISTING', { app: { title: 'Get ready', back: 'P-14' }, action: { label: 'Continue', to: 'P-16' }, gap: 14 });
  s.add(heading('Quick checklist', 'A minute now gives you better tracking.'), card([checkRow('Clear 2 metres of space', true), checkRow('Prop your phone at hip height', true), checkRow('Wear fitted clothing', true), checkRow('Good lighting, no strong backlight', false), checkRow('Stand on a flat, non-slip surface', false)], { gap: 14 }), infoBox('Stop right away if you feel sharp pain, dizziness or chest tightness.', 'warn'), overline('Prototype shortcuts'), btn('Hold exercise tracking', { v: 'text', size: 'M', to: 'P-17H' }), btn('Invalid tracking config', { v: 'text', size: 'M', to: 'P-17x' }));
  s.finish();

  s = Screen('P-16', 'Camera Setup', 'CHANGED', { camera: true });
  skeleton(s, { color: '#FFFFFF' });
  s.abs(statusBar(true), 0, 0);
  glassBtn(s, 'left', 8, 32, 'P-15'); glassBtn(s, 'help', 304, 32, 'P-10');
  pill(s, 'Side view \u00B7 place phone to your right', 40, 92, 280);
  const guide = mk('Guide', { dir: 'V', gap: 12, pad: [16, 16, 16, 16], fill: C.brandDeep, r: R.sheet, w: 328 });
  A(guide, txt('Step into the frame', 'h3', C.textOnDark), txt('Camera view: Side. Make sure your whole body is visible.', 'small', C.textOnDarkSoft), btn('Body detected - start', { v: 'onDarkFilled', to: 'P-17' }), btn('Lost tracking?', { v: 'onDarkOutline', size: 'M', to: 'P-21' }));
  s.abs(guide, 16, 800 - guide.height - 24); s.finish();

  const live = function (id, name, st, o) {
    const s = Screen(id, name, st, { camera: true });
    skeleton(s, { color: o.color });
    s.abs(statusBar(true), 0, 0);
    glassBtn(s, 'pause', 8, 32, 'P-18'); glassBtn(s, 'x', 304, 32, id === 'P-17' ? 'P-17E' : 'P-17E');
    const top = mk('Counter', { dir: 'V', cross: 'CENTER', gap: 0, w: 360 });
    A(top, txt(o.metric, 'displayMetric', C.textOnDark, { hug: true, align: 'CENTER' }), txt(o.sub, 'bodyStrong', C.textOnDarkSoft, { hug: true, align: 'CENTER' })); s.abs(top, 0, 96);
    pill(s, o.feedback, 40, 560, 280, o.warn ? C.warning : C.glass, o.warn ? C.warningInk : C.textOnDark);
    const dock = mk('Dock', { dir: 'V', gap: 8, pad: [12, 16, 24, 16], fill: C.glass, w: 360 });
    A(dock, row([txt(o.left, 'smallStrong', C.textOnDark), txt(o.right, 'smallStrong', C.textOnDark, { align: 'RIGHT' })], { main: 'SPACE_BETWEEN' }), bar(o.prog, 8, C.brandMint, C.brandUplift), btn('Finish exercise', { v: 'onDarkFilled', size: 'M', to: 'P-19' }));
    s.abs(dock, 0, 800 - dock.height); s.finish(); return s;
  };
  live('P-17', 'Live Tracking - rep', 'CHANGED', { metric: '4', sub: 'of 10 reps \u00B7 set 1 of 3', feedback: 'Good depth. Keep your back straight.', left: 'Movement score 86', right: 'Knee angle 42\u00B0', prog: 0.4 });
  live('P-17H', 'Live Tracking - hold', 'NEW', { metric: '0:12', sub: 'hold 30 s \u00B7 attempt 2 of 3', feedback: 'Hold steady. 18 s to go.', left: 'Angle in range', right: 'Grace 2 s', prog: 0.4 });
  s = Screen('P-17x', 'Live Tracking - invalid config', 'NEW', { camera: true }); s.abs(statusBar(true), 0, 0); glassBtn(s, 'left', 8, 32, 'P-14');
  const bad = mk('Err', { dir: 'V', gap: 12, cross: 'CENTER', pad: [24, 24, 24, 24], fill: C.surfaceCard, r: R.hero, w: 312 });
  A(bad, iconCircle('alert', 56, C.warningTint, C.warningInk), txt('This exercise is not ready for tracking', 'h3', C.textPrimary, { align: 'CENTER' }), txt('Ask your doctor to review the exercise setup.', 'small', C.textSecondary, { align: 'CENTER' }), btn('Back to exercise', { to: 'P-14' }));
  s.abs(bad, 24, 280); s.finish();

  s = Screen('P-18', 'Pause', 'EXISTING', { bg: C.brandDeep, gap: 16 });
  s.add(rectSpacer(140), col([iconCircle('pause', 96, C.brandUplift, C.brandMint), txt('Paused', 'h1', C.textOnDark, { align: 'CENTER' }), txt('4 of 10 reps \u00B7 set 1 of 3', 'body', C.textOnDarkSoft, { align: 'CENTER' })], { gap: 12, cross: 'CENTER' }), btn('Resume', { v: 'onDarkFilled', to: 'P-17' }), btn('End session', { v: 'onDarkOutline', to: 'P-19' }));
  s.finish();
  dialogScreen('P-17E', 'End Confirmation Dialog', 'EXISTING', { icon: 'alert', title: 'End this session?', body: 'You have done 4 of 10 reps. You can save your progress.', primary: ['End and see summary', 'P-19'], secondary: ['Keep going', 'BACK'] });

  const summary = function (id, name, st, o) {
    const s = Screen(id, name, st, { app: { title: 'Session summary', close: true, back: 'P-19L' }, action: { label: o.save, to: o.saveTo }, gap: 16 });
    s.add(col([ring(86, 140, o.gold), txt(o.gold ? 'New personal best!' : 'Nice work, Alex', 'h3', C.textPrimary, { align: 'CENTER' })], { gap: 12, cross: 'CENTER' }));
    if (o.gold) s.add(card([txt('Personal best for Mini Squat', 'smallStrong', C.accentGoldDeep)], { fill: C.accentGoldWash, stroke: C.accentGold, flat: true }));
    s.add(statRow([['Reps', '10'], ['Correct', '7'], ['Time', '3:12']]));
    s.add(row([status('correct', '7 Correct'), status('incorrect', '1 Incorrect'), status('incomplete', '2 Incomplete')], { gap: 8 }));
    if (o.shortcuts) s.add(overline('Prototype shortcuts'), btn('Prescribed session with pain', { v: 'text', size: 'M', to: 'P-19P' }), btn('Pain 8 or more', { v: 'text', size: 'M', to: 'P-19S' }), btn('Personal best', { v: 'text', size: 'M', to: 'P-19G' }));
    if (o.pain) { s.add(sectionTitle('How was your pain?'), card([slider(o.pain), area('Comment (optional)', o.comment || '', 72)]));
      if (o.pain >= 8) s.add(banner('error', 'High pain is not normal. Stop exercising and contact your doctor or a medical professional.')); }
    s.finish(); return s;
  };
  summary('P-19', 'Session Summary', 'CHANGED', { save: 'Save result', saveTo: 'P-20', shortcuts: true });
  summary('P-19P', 'Summary - prescribed with pain', 'NEW', { save: 'Save and send to doctor', saveTo: 'P-20', pain: 3, comment: 'Slight stiffness at the end' });
  summary('P-19S', 'Summary - pain 8 or more', 'NEW', { save: 'Save and send to doctor', saveTo: 'P-20', pain: 8, comment: 'Sharp pain on the last reps' });
  summary('P-19G', 'Summary - personal best', 'EXISTING', { save: 'Save result', saveTo: 'P-20', gold: true });
  dialogScreen('P-19L', 'Leave Guard Sheet', 'EXISTING', { sheet: true, icon: 'alert', title: 'Leave without saving?', body: 'Your result has not been saved yet.', primary: ['Save result', 'P-20'], secondary: ['Discard', 'P-11'] });

  stateScreen('P-20', 'Saved', 'EXISTING', { icon: 'check', title: 'Session saved', body: 'Great work. Your progress is up to date.', buttons: [['Back to home', 'P-11'], ['See my progress', 'P-23', 'secondary'], ['View session details', 'P-26', 'text'], ['Prototype: sync failed', 'P-22', 'text'], ['Prototype: loading home', 'P-11f', 'text']] });
  stateScreen('P-21', 'Camera Error', 'EXISTING', { icon: 'cameraOff', tone: 'warn', title: 'We lost tracking', body: 'Step back so your whole body is visible, and check the lighting.', buttons: [['Try again', 'P-16'], ['Exit session', 'P-11', 'secondary']] });
  stateScreen('P-22', 'Sync Error', 'EXISTING', { icon: 'cloudOff', tone: 'error', title: 'Could not sync', body: 'Your session is saved on this phone and will upload when you are online.', buttons: [['Try again', 'P-20'], ['Back to home', 'P-11', 'secondary']] });

  // ---------- Progress ----------
  s = Screen('P-23', 'Progress Dashboard', 'EXISTING', { nav: 'patient', active: 2, gap: 16 });
  s.add(heading('Progress', 'See how you are improving.'), seg(['Week', 'Month', 'All time'], 0), statRow([['Sessions', '5', '+2'], ['Avg score', '82', '+6']]), statRow([['Reps', '86', '+14'], ['Streak', '3 d']]),
    card([txt('Movement score', 'bodyStrong'), barChart([60, 72, 66, 80, 86, 84, 90])]), sectionTitle('By exercise'),
    listItem('Mini Squat', 'Best score 92', { icon: 'activity', right: '86', to: 'P-24' }), listItem('Straight-Leg Raise', 'Best score 88', { icon: 'activity', right: '79', to: 'P-24' }), btn('Session history', { v: 'secondary', to: 'P-25' }));
  s.finish();
  s = Screen('P-24', 'Exercise Progress', 'EXISTING', { app: { title: 'Mini Squat', back: 'P-23' }, gap: 16 });
  s.add(seg(['Week', 'Month', 'All time'], 1), statRow([['Best', '92'], ['Average', '84', '+5']]), card([txt('Score over time', 'bodyStrong'), barChart([70, 74, 80, 78, 86, 90, 92])]), sectionTitle('Recent sessions'),
    listItem('Today \u00B7 10:30 AM', '10 reps \u00B7 3:12', { chip: status('correct', '86'), to: 'P-26' }), listItem('Mon \u00B7 6:00 PM', '10 reps \u00B7 3:40', { chip: status('correct', '84'), to: 'P-26' }), btn('Retry exercise', { to: 'P-14' }));
  s.finish();
  s = Screen('P-25', 'Session History', 'EXISTING', { app: { title: 'Session history', back: 'P-23' }, gap: 12 });
  s.add(input('Search sessions', { icon: 'search', hint: 'Search by exercise' }), chips(['All', 'Knee Rehab', 'Shoulder', 'This week'], 0), overline('Today'), listItem('Mini Squat', 'Knee Rehabilitation \u00B7 10:30 AM \u00B7 3:12', { chip: status('correct', '86'), to: 'P-26' }), overline('Yesterday'),
    listItem('Heel Slide', 'Knee Rehabilitation \u00B7 6:10 PM \u00B7 2:50', { chip: status('incomplete', '64'), to: 'P-26' }), listItem('Straight-Leg Raise', 'Knee Rehabilitation \u00B7 9:00 AM \u00B7 2:20', { chip: status('correct', '79'), to: 'P-26' }), btn('Prototype: show empty state', { v: 'text', to: 'P-25E' }));
  s.finish();
  stateScreen('P-25E', 'Session History - empty', 'EXISTING', { app: { title: 'Session history', back: 'P-25' }, icon: 'clock', title: 'No sessions yet', body: 'Finish your first exercise and it will show up here.', buttons: [['Start an exercise', 'P-12']] });
  s = Screen('P-26', 'Session Details', 'CHANGED', { app: { title: 'Session details', back: 'BACK' }, action: { label: 'Retry exercise', to: 'P-14' }, gap: 14 });
  s.add(card([row([ring(86, 96), col([txt('Mini Squat', 'h3'), txt('Knee Rehabilitation \u00B7 Today at 10:30 AM', 'small', C.textSecondary), status('correct', '7 of 10 correct')], { gap: 4, grow: true })], { gap: 16 })]),
    card([row([avatar('SK', 40), col([txt('Doctor feedback', 'captionStrong', C.brandGreen), txt('Dr. Sara Khan', 'bodyStrong')], { gap: 0, grow: true })], { gap: 12 }), txt('Good control on the way down. Slow the way up a little. See you next week.', 'small', C.textPrimary)], { fill: C.brandMint, flat: true, name: 'DoctorFeedbackCard' }),
    sectionTitle('Rep by rep'), repRow(1, 'correct', 'Correct', '42\u00B0'), repRow(2, 'correct', 'Correct', '40\u00B0'), repRow(3, 'incomplete', 'Incomplete', '28\u00B0'), repRow(4, 'incorrect', 'Incorrect', '55\u00B0'));
  s.finish();

  // ---------- Profile ----------
  s = Screen('P-28', 'Profile', 'CHANGED', { nav: 'patient', active: 3, gap: 16 });
  s.add(card([row([avatar('AM', 64), col([txt('Alex Morgan', 'h3'), txt('alex@rehab.test', 'small', C.textSecondary)], { gap: 0, grow: true }), iconBtn('edit', 'P-29')], { gap: 12 })]),
    menu([{ icon: 'heart', title: 'My Doctor', sub: 'Dr. Sara Khan', to: 'P-46' }, { icon: 'clipboard', title: 'My Condition', sub: 'Right knee, 6 weeks', to: 'P-51' }]),
    menu([{ icon: 'settings', title: 'Settings', to: 'P-30' }, { icon: 'bell', title: 'Notifications', to: 'P-32' }, { icon: 'help', title: 'Help and FAQ', to: 'P-33' }, { icon: 'shield', title: 'Privacy and data', to: 'P-34' }, { icon: 'info', title: 'About', to: 'P-35' }]),
    menu([{ icon: 'logout', title: 'Log out', danger: true, to: 'P-36' }]), btn('Connect with a doctor', { v: 'secondary', to: 'P-37' }));
  s.finish();
  s = Screen('P-29', 'Edit Profile', 'EXISTING', { app: { title: 'Edit profile', back: 'P-29D' }, action: { label: 'Save changes', to: 'P-28' }, gap: 14 });
  s.add(col([avatar('AM', 80)], { cross: 'CENTER' }), input('Display name', { icon: 'user', value: 'Alex Morgan' }), input('Email', { icon: 'mail', value: 'alex@rehab.test' }), overline('Age range'), chips(['Under 18', '18-29', '30-44', '45-64', '65+'], 2), overline('Main goal'), chips(['Knee recovery', 'Shoulder mobility', 'General'], 0));
  s.finish();
  dialogScreen('P-29D', 'Discard Changes Dialog', 'EXISTING', { icon: 'alert', title: 'Discard changes?', body: 'Your edits have not been saved.', primary: ['Discard', 'P-28'], secondary: ['Keep editing', 'BACK'], destructive: true });
  s = Screen('P-30', 'Settings', 'EXISTING', { app: { title: 'Settings', back: 'P-28' }, gap: 16 });
  s.add(menu([{ icon: 'lock', title: 'Change password', to: 'P-31' }, { icon: 'bell', title: 'Notification preferences', to: 'P-32' }, { icon: 'camera', title: 'Camera and audio', sub: 'Skeleton on \u00B7 Haptics on', to: 'P-10' }]));
  s.finish();
  s = Screen('P-31', 'Change Password', 'EXISTING', { app: { title: 'Change password', back: 'P-30' }, action: { label: 'Update password', to: 'P-30' }, gap: 14 });
  s.add(input('Current password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022' }), input('New password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022' }), card([checkRow('8 or more characters', true), checkRow('At least 1 letter', true), checkRow('At least 1 number', true)], { gap: 8, flat: true, fill: C.brandMint }), input('Confirm new password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022' }));
  s.finish();
  s = Screen('P-32', 'Notification Preferences', 'EXISTING', { app: { title: 'Notifications', back: 'P-28' }, action: { label: 'Save', to: 'P-28' }, gap: 14 });
  s.add(card([toggleRow('Exercise reminders', true), divider(), toggleRow('Doctor feedback', true), divider(), toggleRow('Weekly summary', true), divider(), toggleRow('Tips', false)], { gap: 12 }), input('Reminder time', { icon: 'clock', value: '9:00 AM' }), overline('Reminder days'), chips(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'], [0, 2, 4]));
  s.finish();
  s = Screen('P-33', 'Help and FAQ', 'EXISTING', { app: { title: 'Help and FAQ', back: 'P-28' }, gap: 12 });
  s.add(faq('How do I place my phone?', 'Prop it at hip height about 2 metres away and follow the camera view shown.'), faq('Is my video saved?', 'No. Tracking runs on your phone and no video or images are stored.'), faq('What if the count looks wrong?', 'Check lighting and wear fitted clothing, then try again.'), faq('When should I stop?', 'Stop right away if you feel sharp pain, dizziness or chest tightness.'));
  s.finish();
  s = Screen('P-34', 'Privacy and Data', 'EXISTING', { app: { title: 'Privacy and data', back: 'P-28' }, gap: 14 });
  s.add(banner('info', 'Your camera is processed on this phone. No video or images are stored.'), menu([{ icon: 'file', title: 'Privacy policy' }, { icon: 'shield', title: 'Data we keep', sub: 'Profile, sessions, scores' }]), menu([{ icon: 'trash', title: 'Delete account', danger: true, to: 'P-34D' }]));
  s.finish();
  dialogScreen('P-34D', 'Delete Account Dialog', 'CHANGED', { icon: 'trash', title: 'Delete your account?', body: 'Your account will be disabled and you will be logged out. Contact support to restore it.', primary: ['Delete account', 'P-02'], secondary: ['Cancel', 'BACK'], destructive: true });
  s = Screen('P-35', 'About', 'EXISTING', { app: { title: 'About', back: 'P-28' }, gap: 16 });
  s.add(col([iconCircle('activity', 96), txt('RehabSense', 'h1', C.brandGreen, { align: 'CENTER' }), txt('Version 2.0', 'small', C.textSecondary, { align: 'CENTER' })], { gap: 8, cross: 'CENTER' }), infoBox('RehabSense is a guidance tool and not a medical device. It does not replace professional medical advice.'), menu([{ icon: 'file', title: 'Terms of use' }, { icon: 'shield', title: 'Privacy policy' }]));
  s.finish();
  dialogScreen('P-36', 'Logout Dialog', 'EXISTING', { icon: 'logout', title: 'Log out?', body: 'Unsynced sessions stay on your phone and upload next time.', primary: ['Log out', 'P-02'], secondary: ['Cancel', 'BACK'] });

  // ---------- NEW: connect with doctor ----------
  GROUP = 'PATIENT - New (Connect with a doctor and Prescribed)';
  s = Screen('P-37', 'Connect Hub', 'NEW', { app: { title: 'Connect with a doctor', back: 'P-28' }, action: { label: 'Start', to: 'P-38' }, gap: 16 });
  s.add(heading('Get a plan made for you', 'Share your condition, pick a doctor and send a request.'), bullet('clipboard', '1. Tell us about your condition', 'Three short steps.'), bullet('users', '2. Choose a doctor', 'Matched to your needs.'), bullet('check', '3. Send a request', 'The doctor accepts and assigns exercises.'), infoBox('Only the doctor you request can see your condition. Doctors never see your camera.'));
  s.finish();
  wizard('P-38', 'Condition Form', 'NEW', {
    title: 'Your condition', back: 'P-37', finish: 'Find doctors', done: 'P-40', steps: [
      { title: 'Body area', head: 'Where does it hurt?', sub: 'Pick the main area.', build: function (s) { s.add(chips(['Knee', 'Shoulder', 'Hip', 'Back', 'Ankle', 'Neck'], 0), overline('How long?'), chips(['Under 2 weeks', '2-6 weeks', '6 weeks+'], 1), input('Diagnosis, if you know it', { hint: 'For example ACL repair' })); } },
      { title: 'Symptoms', head: 'Current pain', sub: 'Be honest. This helps your doctor.', build: function (s) { s.add(slider(4), overline('Do you have any of these?'), card([checkRow('Numbness or tingling', false), checkRow('Fever or swelling with heat', false), checkRow('Pain that wakes you at night', false), checkRow('Recent fall or accident', false)], { gap: 12 }), btn('Prototype: I have a red flag symptom', { v: 'text', size: 'M', to: 'P-39' })); } },
      { title: 'Goals', head: 'What do you want to achieve?', sub: 'Optional notes for your doctor.', build: function (s) { s.add(chips(['Walk without pain', 'Return to sport', 'Daily activities', 'After surgery'], [0]), area('Notes for your doctor', 'Right knee after ACL surgery 6 weeks ago.', 120)); } }]
  });
  dialogScreen('P-39', 'Safety Alert (sheet)', 'NEW', { sheet: true, icon: 'alert', destructive: true, title: 'Please see a doctor first', body: 'Some of your symptoms need medical attention before exercise. Contact a doctor or emergency services.', primary: ['I understand, continue', 'P-40'], secondary: ['Go back', 'BACK'] });
  s = Screen('P-40', 'Find Doctors', 'NEW', { app: { title: 'Find doctors', back: 'P-37' }, gap: 12 });
  s.add(chips(['Best match', 'Knee', 'Female doctor', 'Online'], 0), doctorCard('Dr. Sara Khan', 'Physiotherapist \u00B7 8 yrs', ['Knee', 'Post-surgery'], '96% match', 'P-41'), doctorCard('Dr. Omar Sheikh', 'Sports physio \u00B7 5 yrs', ['Knee', 'Sports'], '88% match', 'P-41'), doctorCard('Dr. Hina Malik', 'Orthopedic rehab \u00B7 11 yrs', ['Shoulder', 'Hip'], '71% match', 'P-41'));
  s.finish();
  s = Screen('P-41', 'Doctor Public Profile', 'NEW', { app: { title: 'Doctor profile', back: 'P-40' }, action: { label: 'Request this doctor', to: 'P-42' }, gap: 14 });
  s.add(col([avatar('SK', 96), txt('Dr. Sara Khan', 'h1', C.brandGreen, { align: 'CENTER' }), txt('Physiotherapist \u00B7 8 years', 'small', C.textSecondary, { align: 'CENTER' }), status('correct', 'Accepting patients')], { gap: 6, cross: 'CENTER' }),
    card([kv('Clinic', 'City Rehab Clinic'), kv('Languages', 'English, Urdu'), kv('City', 'Karachi')], { gap: 10 }), sectionTitle('Expertise'), chips(['Knee', 'Post-surgery', 'Sports injury'], [0, 1]), sectionTitle('About'), txt('I help patients return to daily life after knee surgery using clear, gradual plans.', 'small', C.textSecondary), sectionTitle('Approach'), txt('Small steps, honest feedback, and regular check-ins.', 'small', C.textSecondary));
  s.finish();
  s = Screen('P-42', 'Send Request (consent)', 'NEW', { app: { title: 'Send request', back: 'P-41' }, action: { label: 'Send request', to: 'P-43' }, gap: 14 });
  s.add(heading('Send to Dr. Sara Khan', 'She will see this summary of your condition.'), card([kv('Area', 'Right knee'), kv('Duration', '2-6 weeks'), kv('Pain now', '4 / 10'), kv('Goal', 'Walk without pain')], { gap: 10 }), area('Message (optional)', 'Hello doctor, I would like help after my surgery.', 96),
    card([checkRow('I agree to share my condition summary with this doctor. I can disconnect any time.', true)], { fill: C.brandMint, flat: true }));
  s.finish();
  s = Screen('P-43', 'Request Status', 'NEW', { app: { title: 'Request status', back: 'P-11b' }, gap: 16 });
  s.add(card([row([avatar('SK', 48), col([txt('Dr. Sara Khan', 'bodyStrong'), txt('Sent just now \u00B7 expires in 7 days', 'caption', C.textSecondary)], { gap: 0, grow: true }), status('pending', 'Pending')], { gap: 12 })]),
    timeline([['Request sent', 'Today, 10:42 AM', true], ['Doctor reviews', 'Usually within 2 days', false], ['Connected', 'You get a notification', false]]),
    btn('Back to home', { to: 'P-11b' }), btn('Cancel request', { v: 'destructiveOutline', to: 'P-11' }), overline('Prototype shortcuts'), btn('Doctor accepted', { v: 'text', size: 'M', to: 'P-44' }), btn('Doctor declined', { v: 'text', size: 'M', to: 'P-45' }), btn('Doctor assigned exercises', { v: 'text', size: 'M', to: 'P-11d' }), btn('Doctor became inactive', { v: 'text', size: 'M', to: 'P-11e' }));
  s.finish();
  stateScreen('P-44', 'Connected (celebration)', 'NEW', { icon: 'heart', title: 'You are connected!', body: 'Dr. Sara Khan accepted your request. Exercises will show up under Prescribed.', buttons: [['Go to home', 'P-11c'], ['See my doctor', 'P-46', 'secondary']], pad: 100 });
  stateScreen('P-45', 'Request Declined or Expired', 'NEW', { app: { title: '', back: 'P-11' }, icon: 'x', tone: 'warn', title: 'Request not accepted', body: 'Dr. Sara Khan could not take your request. You can choose another doctor.', buttons: [['Find another doctor', 'P-40'], ['Back to home', 'P-11', 'secondary']] });
  s = Screen('P-46', 'My Doctor', 'NEW', { app: { title: 'My doctor', back: 'P-28' }, gap: 14 });
  s.add(card([row([avatar('SK', 64), col([txt('Dr. Sara Khan', 'h3'), txt('Physiotherapist \u00B7 City Rehab Clinic', 'small', C.textSecondary), status('correct', 'Connected')], { gap: 4, grow: true })], { gap: 12 })]),
    menu([{ icon: 'clipboard', title: 'Prescribed exercises', sub: '2 assigned', to: 'P-48' }, { icon: 'heart', title: 'Doctor profile', to: 'P-41' }]), btn('Disconnect from doctor', { v: 'destructiveOutline', to: 'P-47' }));
  s.finish();
  dialogScreen('P-47', 'Disconnect Confirm', 'NEW', { icon: 'alert', destructive: true, title: 'Disconnect from Dr. Sara Khan?', body: 'Your doctor will no longer see your sessions. Prescribed exercises will be locked.', primary: ['Disconnect', 'P-11'], secondary: ['Stay connected', 'BACK'] });
  s = Screen('P-48', 'Prescribed List', 'NEW', { app: { title: 'Prescribed', back: 'P-12' }, gap: 12 });
  s.add(seg(['Wellness and Yoga', 'Rehab', 'Prescribed'], 2, coursesTabs), card([row([avatar('SK', 40), txt('From Dr. Sara Khan', 'smallStrong', C.brandGreen)], { gap: 12 })], { fill: C.brandMint, flat: true }),
    listItem('Mini Squat', '3 sets \u00B7 10 reps \u00B7 Mon, Wed, Fri', { icon: 'activity', chip: status('pending', 'Today'), to: 'P-49' }), listItem('Straight-Leg Raise', '2 sets \u00B7 12 reps \u00B7 Tue, Thu', { icon: 'activity', to: 'P-49' }), listItem('Wall Sit hold', '3 holds \u00B7 30 s \u00B7 Mon, Fri', { icon: 'activity', to: 'P-49' }));
  s.finish();
  s = Screen('P-49', 'Prescribed Exercise Detail', 'NEW', { app: { title: 'Mini Squat', back: 'P-48' }, action: { label: 'Start exercise', to: 'P-15' }, gap: 14 });
  s.add(card([txt('Doctor\u2019s note', 'captionStrong', C.brandGreen), txt('Go slowly and stop if pain goes above 5. Rest 45 seconds between sets.', 'small', C.textPrimary)], { fill: C.brandMint, flat: true }), card([kv('Sets and reps', '3 x 10'), kv('Rest', '45 seconds'), kv('Days', 'Mon, Wed, Fri'), kv('Camera view', 'Side'), kv('Ends', '30 Nov')], { gap: 10 }), sectionTitle('How to do it'), card([checkRow('Stand with feet shoulder-width apart', false), checkRow('Bend knees slowly to about 30 degrees', false), checkRow('Rise slowly', false)], { gap: 10 }));
  s.finish();
  s = Screen('P-50', 'Enter Doctor Code (optional)', 'NEW', { app: { title: 'Doctor code', back: 'P-37' }, action: { label: 'Connect', to: 'P-43' }, gap: 16 });
  s.add(heading('Have a doctor code?', 'Optional. Hidden until invite codes are approved (D-07).'), otp('RS48'), banner('info', 'Codes come from your doctor.'));
  s.finish();
  s = Screen('P-51', 'My Condition', 'NEW', { app: { title: 'My condition', back: 'P-28' }, action: { label: 'Save', to: 'P-28' }, gap: 14 });
  s.add(overline('Body area'), chips(['Knee', 'Shoulder', 'Hip', 'Back', 'Ankle', 'Neck'], 0), input('Diagnosis', { value: 'ACL repair, right knee' }), overline('Pain now'), slider(4), area('Notes', 'Right knee after ACL surgery 6 weeks ago.', 96), infoBox('Only your connected doctor can see this.'));
  s.finish();
  stateScreen('P-52', 'Inactive Account', 'NEW', { icon: 'ban', tone: 'warn', title: 'Account inactive', body: 'Your account is disabled. Please contact support to restore it.', buttons: [['Log out', 'P-02'], ['Contact support', 'P-33', 'secondary']] });
}

// ---- patient-specific helpers ----
function rectSpacer(h) { const r = figma.createRectangle(); r.resize(10, h); r.fills = []; r.name = 'spacer'; return r; }
function skel(h, r) { const b = figma.createRectangle(); b.resize(328, h); b.cornerRadius = r || 12; b.fills = [paint(C.surfaceCeramic)]; b.name = 'Skeleton'; flag(b, { st: true }); return b; }
function courseCard(name, meta, desc, v, to) {
  return card([row([iconCircle('activity', 48), col([txt(name, 'h3'), txt(meta, 'caption', C.textSecondary)], { gap: 0, grow: true })], { gap: 12 }), txt(desc, 'small', C.textSecondary), bar(v), btn(v > 0 ? 'Continue course' : 'Start course', { size: 'M', to: to })], { to: to, name: 'CourseCard/' + name });
}
function repRow(n, type, label, angle) { return card([row([txt('Rep ' + n, 'bodyStrong'), status(type, label), txt('Knee ' + angle, 'small', C.textSecondary, { align: 'RIGHT' })], { main: 'SPACE_BETWEEN', gap: 12 })], { pad: [12, 16, 12, 16] }); }
function toggleRow(label, on) {
  const t = mk('Toggle', { dir: 'H', cross: 'CENTER', w: 48, h: 28, r: R.pill, fill: on ? C.brandAction : C.borderInput, pad: [3, 3, 3, 3], main: on ? 'MAX' : 'MIN' });
  A(t, circle(22, C.surfaceCard, 'knob')); return row([txt(label, 'body'), t], { main: 'SPACE_BETWEEN' });
}
function faq(q, a) { return card([row([txt(q, 'bodyStrong'), icon('plus', 20, C.brandAction)], { main: 'SPACE_BETWEEN', gap: 12 }), txt(a, 'small', C.textSecondary)], { gap: 8 }); }
function barChart(vals) {
  const f = mk('BarChart', { dir: 'H', gap: 10, cross: 'MAX', h: 120, pad: [8, 0, 0, 0], main: 'SPACE_BETWEEN' }); flag(f, { st: true });
  vals.forEach(function (v, i) { const b = figma.createRectangle(); b.resize(28, Math.round(v * 1.1)); b.cornerRadius = 6; b.fills = [paint(i === vals.length - 1 ? C.brandAction : C.brandMint)]; b.name = 'bar ' + v; A(f, b); });
  return f;
}
// DOCTOR PORTAL - all screens NEW (UPDATE_BRIEF section 5)
function buildDoctor() {
  GROUP = 'DOCTOR PORTAL';
  let s;
  const dots = '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022';

  // ---------- Gate and onboarding ----------
  s = Screen('D-01', 'Doctor Login', 'NEW', { app: { title: '', back: 'P-02' }, gap: 16 });
  s.add(heading('Doctor login', 'Sign in to manage your patients.'), input('Email', { icon: 'mail', value: 'sara.khan@clinic.test' }), input('Password', { icon: 'lock', value: dots, suffix: 'eye' }),
    btn('Forgot password?', { v: 'text', size: 'M', to: 'D-10', full: false }), btn('Log in', { to: 'D-14' }), btn('Create doctor account', { v: 'secondary', to: 'D-02' }),
    overline('Prototype: login gate results'), btn('Pending application', { v: 'text', size: 'M', to: 'D-06' }), btn('Incomplete application', { v: 'text', size: 'M', to: 'D-07' }),
    btn('Rejected application', { v: 'text', size: 'M', to: 'D-08' }), btn('Inactive account', { v: 'text', size: 'M', to: 'D-09' }), btn('Approved, profile not set up', { v: 'text', size: 'M', to: 'D-12' }));
  s.finish();

  s = Screen('D-02', 'Register Account', 'NEW', { app: { title: '', back: 'D-01' }, gap: 14 });
  s.add(heading('Create doctor account', 'Step 1 of 3. Your application is reviewed by our team.'), input('Full name', { icon: 'user', value: 'Sara Khan' }), input('Work email', { icon: 'mail', value: 'sara.khan@clinic.test' }), input('Licence number', { icon: 'file', value: 'PMDC-48213' }), input('Degree', { value: 'DPT, Physiotherapy' }),
    input('Password', { icon: 'lock', value: dots, suffix: 'eye', helper: '8 or more characters, with a letter and a number.' }), banner('info', 'You can submit up to 3 applications.'), btn('Create account', { to: 'D-03' }));
  s.finish();
  s = Screen('D-03', 'Verify Email (OTP)', 'NEW', { app: { title: '', back: 'D-02' }, gap: 20 });
  s.add(col([iconCircle('mail', 80), txt('Enter your code', 'h1', C.brandGreen, { align: 'CENTER' }), txt('We sent a 6-digit code to sara.khan@clinic.test', 'body', C.textSecondary, { align: 'CENTER' })], { gap: 12, cross: 'CENTER' }), otp('7391'), btn('Verify', { to: 'D-04' }), btn('Resend code (60s)', { v: 'text', to: 'D-03' }), btn('Change email', { v: 'text', to: 'D-02' }));
  s.finish();
  s = Screen('D-04', 'Documents', 'NEW', { app: { title: 'Documents', back: 'D-03' }, action: { label: 'Continue', to: 'D-05' }, gap: 12 });
  s.add(stepHeader(2, 3, 'Documents'), heading('Upload your documents', 'PDF, JPG or PNG. Up to 5 MB each.'), docTile('Medical licence', 'licence.pdf \u00B7 1.2 MB', true), docTile('Degree certificate', 'degree.jpg \u00B7 2.4 MB', true), docTile('National ID', 'Tap to upload', false), banner('info', 'Documents are private. Only our review team can open them.'));
  s.finish();
  s = Screen('D-05', 'Review and Submit', 'NEW', { app: { title: 'Review', back: 'D-04' }, action: { label: 'Submit application', to: 'D-06' }, gap: 14 });
  s.add(stepHeader(3, 3, 'Review'), card([kv('Name', 'Sara Khan'), kv('Email', 'sara.khan@clinic.test'), kv('Licence', 'PMDC-48213'), kv('Degree', 'DPT, Physiotherapy'), kv('Attempt', '1 of 3')], { gap: 10 }), docTile('Medical licence', 'licence.pdf', true), docTile('Degree certificate', 'degree.jpg', true), docTile('National ID', 'id.png', true), btn('Edit documents', { v: 'text', to: 'D-04' }));
  s.finish();
  s = Screen('D-06', 'Submitted', 'NEW', { gap: 16 });
  s.add(rectSpacer(48), col([iconCircle('clock', 96), txt('Application submitted', 'h1', C.brandGreen, { align: 'CENTER' }), txt('We will email you after review. This usually takes 1 to 3 days.', 'body', C.textSecondary, { align: 'CENTER' })], { gap: 14, cross: 'CENTER' }),
    timeline([['Submitted', 'Today', true], ['Under review', 'In progress', false], ['Decision by email', 'Soon', false]]), btn('Back to login', { to: 'D-01' }), btn('Prototype: approved', { v: 'text', size: 'M', to: 'D-12' }));
  s.finish();
  s = Screen('D-07', 'Resume Application', 'NEW', { app: { title: '', back: 'D-01' }, gap: 16 });
  s.add(rectSpacer(24), col([iconCircle('file', 96), txt('Finish your application', 'h1', C.brandGreen, { align: 'CENTER' }), txt('You have not submitted your documents yet.', 'body', C.textSecondary, { align: 'CENTER' })], { gap: 14, cross: 'CENTER' }), bar(0.66), btn('Continue', { to: 'D-04' }));
  s.finish();
  s = Screen('D-08', 'Application Rejected', 'NEW', { app: { title: '', back: 'D-01' }, gap: 16 });
  s.add(col([iconCircle('x', 96, C.errorTint, C.error), txt('Application not approved', 'h1', C.brandGreen, { align: 'CENTER' })], { gap: 14, cross: 'CENTER' }), card([txt('Reason', 'captionStrong', C.error), txt('The licence photo is not readable. Please upload a clearer copy.', 'small')], { fill: C.errorTint, flat: true }), kv('Attempts used', '1 of 3'), btn('Edit and resubmit', { to: 'D-04' }), btn('Back to login', { v: 'text', to: 'D-01' }));
  s.finish();
  stateScreen('D-09', 'Inactive Account', 'NEW', { app: { title: '', back: 'D-01' }, icon: 'ban', tone: 'warn', title: 'Account inactive', body: 'Your account is suspended. Please contact support.', buttons: [['Back to login', 'D-01'], ['Contact support', 'D-29', 'secondary']] });
  s = Screen('D-10', 'Forgot Password', 'NEW', { app: { title: '', back: 'D-01' }, gap: 16 });
  s.add(heading('Forgot password?', 'We will send a reset link.'), input('Email', { icon: 'mail', value: 'sara.khan@clinic.test' }), btn('Send reset link', { to: 'D-11' }), btn('Back to login', { v: 'text', to: 'D-01' }));
  s.finish();
  s = Screen('D-11', 'Reset Password', 'NEW', { app: { title: '', close: true, back: 'D-01' }, gap: 16 });
  s.add(heading('Create new password'), input('New password', { icon: 'lock', value: dots, suffix: 'eye' }), input('Confirm password', { icon: 'lock', value: dots }), btn('Update password', { to: 'D-01' }));
  s.finish();

  // ---------- Profile setup ----------
  wizard('D-12', 'Profile Setup', 'NEW', {
    title: 'Set up your profile', back: 'D-01', finish: 'Preview', done: 'D-13', steps: [
      { title: 'Basics', head: 'The basics', sub: 'Patients see this on your profile.', build: function (s) { s.add(input('Title', { value: 'Physiotherapist' }), input('Clinic', { icon: 'pin', value: 'City Rehab Clinic' }), input('Phone', { value: '+92 300 0000000' }), input('City', { value: 'Karachi' }), input('Languages', { value: 'English, Urdu' })); } },
      { title: 'Expertise', head: 'Your expertise', sub: 'Pick at least 1 tag.', build: function (s) { s.add(chips(['Knee', 'Shoulder', 'Hip', 'Back', 'Ankle', 'Neck', 'Post-surgery', 'Sports injury'], [0, 6]), input('Years of experience', { value: '8' })); } },
      { title: 'About', head: 'About you', sub: 'At least 30 characters.', build: function (s) { s.add(area('Bio', 'I help patients return to daily life after knee surgery with clear, gradual plans.', 120), area('Your approach', 'Small steps, honest feedback and regular check-ins.', 96), txt('78 / 500', 'caption', C.textSecondary, { align: 'RIGHT' })); } },
      { title: 'Availability', head: 'Availability', sub: 'You can change this any time.', build: function (s) { s.add(card([toggleRow('Accepting new patients', true)]), input('Max patients', { value: '30' }), overline('Working days'), chips(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'], [0, 1, 2, 3, 4])); } }]
  });
  s = Screen('D-13', 'Preview and Go Live', 'NEW', { app: { title: 'Preview', back: 'D-12d' }, action: [{ label: 'Edit', v: 'secondary', to: 'D-12' }, { label: 'Go live', to: 'D-14' }], gap: 14 });
  s.add(banner('info', 'This is how patients will see your profile.'), card([row([avatar('SK', 64), col([txt('Dr. Sara Khan', 'h3'), txt('Physiotherapist \u00B7 8 yrs', 'small', C.textSecondary), status('correct', 'Accepting patients')], { gap: 4, grow: true })], { gap: 12 }), chips(['Knee', 'Post-surgery']), txt('I help patients return to daily life after knee surgery.', 'small', C.textSecondary)]),
    card([txt('Listing checklist', 'bodyStrong'), checkRow('Approved by admin', true), checkRow('At least 1 expertise tag', true), checkRow('Bio of 30+ characters', true), checkRow('Clinic added', true), checkRow('Accepting patients', true)], { gap: 10 }));
  s.finish();

  // ---------- Main ----------
  s = Screen('D-14', 'Home', 'NEW', { nav: 'doctor', active: 0, gap: 16 });
  s.add(row([col([txt('Good morning, Dr. Khan', 'h3'), txt('Here is what needs you today.', 'small', C.textSecondary)], { gap: 0, grow: true }), iconBtn('bell', 'D-25')], { gap: 4 }),
    statRow([['New requests', '3'], ['Active patients', '12']]), statRow([['Pain alerts', '1', null, false], ['Inactive 3d+', '2']]),
    card([row([iconCircle('alert', 40, C.errorTint, C.error), col([txt('Pain alert', 'bodyStrong'), txt('Ali R. reported pain 8 after Mini Squat', 'small', C.textSecondary)], { gap: 0, grow: true }), icon('right', 20, C.textSecondary)], { gap: 12 })], { stroke: C.error, to: 'D-23' }),
    sectionTitle('New requests', 'See all', 'D-15'), listItem('Alex Morgan', 'Right knee \u00B7 after surgery', { avatar: 'AM', chip: status('pending', 'New'), to: 'D-16' }), listItem('Hira Aslam', 'Shoulder \u00B7 6 weeks', { avatar: 'HA', chip: status('pending', 'New'), to: 'D-16' }),
    sectionTitle('Recent sessions'), listItem('Ali R. \u00B7 Mini Squat', 'Today \u00B7 score 78', { avatar: 'AR', to: 'D-23' }));
  s.finish();
  s = Screen('D-15', 'Requests', 'NEW', { nav: 'doctor', active: 1, gap: 12 });
  s.add(heading('Requests', '3 waiting for your answer.'), seg(['Pending', 'Accepted', 'Declined'], 0), listItem('Alex Morgan', 'Right knee \u00B7 expires in 6 d', { avatar: 'AM', chip: status('pending', 'Pending'), to: 'D-16' }), listItem('Hira Aslam', 'Shoulder \u00B7 expires in 4 d', { avatar: 'HA', chip: status('pending', 'Pending'), to: 'D-16' }), listItem('Bilal Noor', 'Hip \u00B7 expires in 1 d', { avatar: 'BN', chip: status('incomplete', '1 d left'), to: 'D-16' }), btn('View my patients', { v: 'text', to: 'D-17' }));
  s.finish();
  s = Screen('D-16', 'Request Detail', 'NEW', { app: { title: 'Request', back: 'D-15' }, action: [{ label: 'Decline', v: 'secondary', to: 'D-16D' }, { label: 'Accept', to: 'D-18' }], gap: 14 });
  s.add(card([row([avatar('AM', 56), col([txt('Alex Morgan', 'h3'), txt('Request sent today \u00B7 expires in 7 d', 'caption', C.textSecondary)], { gap: 0, grow: true })], { gap: 12 })]), sectionTitle('Condition summary'),
    card([kv('Area', 'Right knee'), kv('Duration', '2-6 weeks'), kv('Pain now', '4 / 10'), kv('Goal', 'Walk without pain'), kv('Red flags', 'None reported')], { gap: 10 }), area('Message from patient', 'Hello doctor, I would like help after my surgery.', 80), infoBox('Condition details are visible to you only while this request is pending or accepted.'));
  s.finish();
  dialogScreen('D-16D', 'Decline Request', 'NEW', { sheet: true, icon: 'x', destructive: true, title: 'Decline this request?', body: 'The patient will be told and can choose another doctor.', extra: [chips(['Not my specialty', 'No capacity', 'Other'], 0)], primary: ['Decline request', 'D-15'], secondary: ['Cancel', 'BACK'] });
  s = Screen('D-17', 'My Patients', 'NEW', { nav: 'doctor', active: 1, gap: 12 });
  s.add(heading('My patients', '12 active'), input('Search patients', { icon: 'search', hint: 'Search by name' }), chips(['All', 'Active today', 'Needs attention'], 0), listItem('Alex Morgan', 'Right knee \u00B7 last session today', { avatar: 'AM', chip: status('correct', 'On track'), to: 'D-18' }), listItem('Ali Raza', 'Left knee \u00B7 pain 8 reported', { avatar: 'AR', chip: status('incorrect', 'Pain'), to: 'D-18' }), listItem('Sana Iqbal', 'Shoulder \u00B7 no session for 3 d', { avatar: 'SI', chip: status('incomplete', 'Inactive'), to: 'D-18' }), btn('Requests', { v: 'text', to: 'D-15' }));
  s.finish();

  const patientTabs = ['D-18', 'D-18b', 'D-18c', 'D-18d'];
  const pHead = function (s, active) { s.add(card([row([avatar('AM', 56), col([txt('Alex Morgan', 'h3'), txt('Right knee \u00B7 connected 3 weeks', 'caption', C.textSecondary)], { gap: 0, grow: true }), status('correct', 'Active')], { gap: 12 })]), seg(['Overview', 'Plan', 'Sessions', 'Condition'], active, patientTabs)); };
  s = Screen('D-18', 'Patient Detail - Overview', 'NEW', { app: { title: 'Patient', back: 'D-17' }, gap: 14 }); pHead(s, 0);
  s.add(statRow([['Adherence', '86%', '+8%'], ['Avg score', '82', '+4']]), statRow([['Sessions', '9'], ['Avg pain', '3.1']]), card([txt('Score trend', 'bodyStrong'), barChart([60, 72, 66, 80, 86, 84, 90])]), btn('Assign exercise', { to: 'D-19' })); s.finish();
  s = Screen('D-18b', 'Patient Detail - Plan', 'NEW', { app: { title: 'Patient', back: 'D-17' }, action: { label: 'Assign exercise', to: 'D-19' }, gap: 12 }); pHead(s, 1);
  s.add(listItem('Mini Squat', '3 x 10 \u00B7 Mon, Wed, Fri', { icon: 'activity', chip: status('correct', 'Active') }), listItem('Straight-Leg Raise', '2 x 12 \u00B7 Tue, Thu', { icon: 'activity', chip: status('correct', 'Active') }), listItem('Wall Sit hold', '3 x 30 s \u00B7 Mon, Fri', { icon: 'activity', chip: status('neutral', 'Ended') })); s.finish();
  s = Screen('D-18c', 'Patient Detail - Sessions', 'NEW', { app: { title: 'Patient', back: 'D-17' }, gap: 12 }); pHead(s, 2);
  s.add(listItem('Mini Squat', 'Today \u00B7 pain 3 \u00B7 score 86', { chip: status('correct', 'Reviewed'), to: 'D-23' }), listItem('Straight-Leg Raise', 'Yesterday \u00B7 pain 2 \u00B7 score 79', { chip: status('pending', 'Needs feedback'), to: 'D-23' }), listItem('Mini Squat', 'Mon \u00B7 pain 8 \u00B7 score 64', { chip: status('incorrect', 'Pain'), to: 'D-23' })); s.finish();
  s = Screen('D-18d', 'Patient Detail - Condition', 'NEW', { app: { title: 'Patient', back: 'D-17' }, gap: 12 }); pHead(s, 3);
  s.add(card([kv('Area', 'Right knee'), kv('Diagnosis', 'ACL repair'), kv('Duration', '6 weeks'), kv('Pain at start', '4 / 10'), kv('Goal', 'Walk without pain')], { gap: 10 }), area('Patient notes', 'Right knee after ACL surgery 6 weeks ago.', 80), btn('End connection', { v: 'destructiveOutline', to: 'D-17' })); s.finish();

  wizard('D-19', 'Assign Exercise', 'NEW', {
    title: 'Assign exercise', back: 'D-18b', finish: 'Assign', done: 'D-18b', steps: [
      { title: 'Choose', head: 'Choose an exercise', sub: 'From the library.', build: function (s) { s.add(input('Search', { icon: 'search', hint: 'Search exercises' }), listItem('Mini Squat', 'Rehab \u00B7 rep \u00B7 side view', { icon: 'activity', chip: status('correct', 'Tested') }), listItem('Straight-Leg Raise', 'Rehab \u00B7 rep \u00B7 side view', { icon: 'activity', chip: status('correct', 'Tested') }), listItem('Wall Sit hold', 'Rehab \u00B7 hold \u00B7 side view', { icon: 'activity', chip: status('pending', 'Untested') })); } },
      { title: 'Dose', head: 'Sets and reps', sub: 'How much, and how often.', build: function (s) { s.add(input('Sets', { value: '3' }), input('Reps', { value: '10' }), input('Rest (seconds)', { value: '45' })); } },
      { title: 'Schedule', head: 'Schedule', sub: 'Pick days and dates.', build: function (s) { s.add(chips(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'], [0, 2, 4]), input('Start date', { icon: 'calendar', value: '3 Nov 2026' }), input('End date', { icon: 'calendar', value: '30 Nov 2026' }), area('Note to patient', 'Go slowly and stop if pain goes above 5.', 80)); } }]
  });

  s = Screen('D-20', 'Exercise Library', 'NEW', { nav: 'doctor', active: 2, gap: 12 });
  s.add(row([txt('Exercises', 'h1', C.brandGreen), btn('New', { v: 'primary', size: 'M', icon: 'plus', to: 'D-21', full: false })], { main: 'SPACE_BETWEEN' }), input('Search', { icon: 'search', hint: 'Search exercises' }), chips(['All', 'Rehab', 'Yoga', 'Mine'], 0),
    listItem('Mini Squat', 'Rehab \u00B7 rep \u00B7 side', { icon: 'activity', chip: status('correct', 'Tested'), to: 'D-22' }), listItem('Wall Sit hold', 'Rehab \u00B7 hold \u00B7 side \u00B7 Private', { icon: 'activity', chip: status('pending', 'Untested'), to: 'D-22' }), listItem('Warrior II hold', 'Yoga \u00B7 hold \u00B7 front', { icon: 'activity', chip: status('correct', 'Tested'), to: 'D-22' }));
  s.finish();
  wizard('D-21', 'Exercise Builder', 'NEW', {
    title: 'New exercise', back: 'D-20', finish: 'Save exercise', done: 'D-20', steps: [
      { title: 'Basics', head: 'Basics', sub: 'Name and category. Doctor exercises are always private.', build: function (s) { s.add(input('Name', { value: 'Wall Sit' }), overline('Category'), chips(['Rehab', 'Yoga', 'General'], 0), area('Steps for the patient', 'Lean against a wall and slide down until knees are bent.', 96), banner('info', 'Visibility: Private. Only you and assigned patients can see it.')); } },
      { title: 'Camera and kind', head: 'Camera and kind', sub: 'How the patient will be tracked.', build: function (s) { s.add(overline('Type'), seg(['Rep', 'Hold'], 1), overline('Camera view'), seg(['Side', 'Front'], 0), banner('info', 'Tracking uses 2D angles only. No video or images are stored.')); } },
      { title: 'Tracking config', head: 'Tracking config', sub: 'Angle range and hold time.', build: function (s) { s.add(input('Joint', { value: 'Right knee' }), input('Angle range (degrees)', { value: '80 to 100' }), input('Hold time (seconds)', { value: '30' }), input('Grace period (seconds)', { value: '2' }), btn('Test on camera', { v: 'secondary', to: 'D-22' })); } },
      { title: 'Review', head: 'Review', sub: 'Check everything before saving.', build: function (s) { s.add(card([kv('Name', 'Wall Sit'), kv('Category', 'Rehab'), kv('Type', 'Hold'), kv('Camera', 'Side'), kv('Range', '80 to 100\u00B0'), kv('Hold', '30 s'), kv('Visibility', 'Private')], { gap: 10 }), status('pending', 'Untested - run a test on camera')); } }]
  });
  s = Screen('D-22', 'Test Exercise on Camera', 'NEW', { camera: true });
  skeleton(s, { color: '#FFFFFF' }); s.abs(statusBar(true), 0, 0); glassBtn(s, 'x', 8, 32, 'D-20'); pill(s, 'TEST MODE \u00B7 nothing is saved', 60, 40, 240);
  const tc = mk('Counter', { dir: 'V', cross: 'CENTER', w: 360 }); A(tc, txt('0:22', 'displayMetric', C.textOnDark, { hug: true, align: 'CENTER' }), txt('Hold 30 s \u00B7 Wall Sit', 'bodyStrong', C.textOnDarkSoft, { hug: true })); s.abs(tc, 0, 96);
  pill(s, 'Angle in range: 92\u00B0', 60, 560, 240);
  const td = mk('Dock', { dir: 'V', gap: 8, pad: [12, 16, 24, 16], fill: C.glass, w: 360 }); A(td, btn('Mark as tested', { v: 'onDarkFilled', size: 'M', to: 'D-20' }), btn('Back to builder', { v: 'onDarkOutline', size: 'M', to: 'D-21c' })); s.abs(td, 0, 800 - td.height); s.finish();

  s = Screen('D-23', 'Session Review and Feedback', 'NEW', { app: { title: 'Session review', back: 'D-18c' }, action: { label: 'Send feedback', to: 'D-18c' }, gap: 14 });
  s.add(card([row([ring(78, 96), col([txt('Mini Squat', 'h3'), txt('Ali Raza \u00B7 Today 10:30 AM', 'small', C.textSecondary), status('incorrect', 'Pain 8')], { gap: 4, grow: true })], { gap: 16 })]),
    banner('error', 'Patient reported pain 8 of 10: "Sharp pain on the last reps".'), statRow([['Reps', '10'], ['Correct', '6']]), sectionTitle('Rep by rep'), repRow(1, 'correct', 'Correct', '42\u00B0'), repRow(2, 'incomplete', 'Incomplete', '28\u00B0'), repRow(3, 'incorrect', 'Incorrect', '55\u00B0'),
    area('Your feedback', 'Thanks for reporting this. Please pause squats and call the clinic.', 96), txt('72 / 500', 'caption', C.textSecondary, { align: 'RIGHT' }));
  s.finish();

  s = Screen('D-25', 'Notifications', 'NEW', { app: { title: 'Notifications', back: 'D-14' }, gap: 12 });
  s.add(listItem('New request', 'Alex Morgan wants to connect \u00B7 5 min ago', { icon: 'users', to: 'D-16' }), listItem('Pain alert', 'Ali Raza reported pain 8 \u00B7 1 h ago', { icon: 'alert', to: 'D-23' }), listItem('Request expiring', 'Bilal Noor\u2019s request expires in 24 h', { icon: 'clock', to: 'D-16' }), listItem('Patient inactive', 'Sana Iqbal has not trained for 3 days', { icon: 'bell', to: 'D-18' }), listItem('Application approved', 'You are now listed for patients', { icon: 'check', to: 'D-14' }));
  s.finish();
  s = Screen('D-26', 'Profile', 'NEW', { nav: 'doctor', active: 3, gap: 16 });
  s.add(card([row([avatar('SK', 64), col([txt('Dr. Sara Khan', 'h3'), txt('Physiotherapist \u00B7 City Rehab Clinic', 'small', C.textSecondary), status('correct', 'Listed')], { gap: 4, grow: true })], { gap: 12 })]),
    menu([{ icon: 'edit', title: 'Edit profile and expertise', to: 'D-27' }, { icon: 'file', title: 'Update credentials', to: 'D-28' }, { icon: 'settings', title: 'Settings', to: 'D-29' }, { icon: 'bell', title: 'Notifications', to: 'D-25' }]), menu([{ icon: 'logout', title: 'Log out', danger: true, to: 'D-30' }]));
  s.finish();
  s = Screen('D-27', 'Edit Profile and Expertise', 'NEW', { app: { title: 'Edit profile', back: 'D-26' }, action: { label: 'Save changes', to: 'D-26' }, gap: 14 });
  s.add(input('Title', { value: 'Physiotherapist' }), input('Clinic', { icon: 'pin', value: 'City Rehab Clinic' }), overline('Expertise'), chips(['Knee', 'Shoulder', 'Hip', 'Back', 'Post-surgery'], [0, 4]), area('Bio', 'I help patients return to daily life after knee surgery.', 96), card([toggleRow('Accepting new patients', true)]), input('Max patients', { value: '30' }));
  s.finish();
  s = Screen('D-28', 'Update Credentials', 'NEW', { app: { title: 'Credentials', back: 'D-26' }, action: { label: 'Submit for review', to: 'D-26' }, gap: 14 });
  s.add(banner('info', 'Changing credentials sends your profile back to review. You stay listed until a decision.'), input('Licence number', { value: 'PMDC-48213' }), input('Degree', { value: 'DPT, Physiotherapy' }), docTile('Medical licence', 'licence.pdf', true), docTile('Degree certificate', 'degree.jpg', true));
  s.finish();
  s = Screen('D-29', 'Settings', 'NEW', { app: { title: 'Settings', back: 'D-26' }, gap: 14 });
  s.add(menu([{ icon: 'lock', title: 'Change password', to: 'D-11' }, { icon: 'bell', title: 'Notification preferences', to: 'D-25' }, { icon: 'help', title: 'Help and support' }]), card([toggleRow('Email alerts for requests', true), divider(), toggleRow('Pain alerts', true), divider(), toggleRow('Inactive patient alerts', true)], { gap: 12 }));
  s.finish();
  dialogScreen('D-30', 'Logout Dialog', 'NEW', { icon: 'logout', title: 'Log out?', body: 'You can log back in any time.', primary: ['Log out', 'D-01'], secondary: ['Cancel', 'BACK'] });
  s = Screen('D-24', 'Invite Code (optional)', 'NEW', { app: { title: 'Invite code', back: 'D-26' }, action: { label: 'Generate code', to: 'D-24' }, gap: 16 });
  s.add(heading('Invite a patient', 'Optional. Hidden until invite codes are approved (D-07).'), card([col([txt('RS48-K2P9', 'displayMedium', C.brandGreen, { align: 'CENTER' }), txt('Expires in 7 days', 'caption', C.textSecondary, { align: 'CENTER' })], { gap: 4 })]));
  s.finish();
}
// ADMIN PORTAL - all screens NEW (UPDATE_BRIEF section 6)
function buildAdmin() {
  GROUP = 'ADMIN PORTAL';
  let s;
  const dots = '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022';

  s = Screen('A-01', 'Admin Login', 'NEW', { app: { title: '', back: 'P-02' }, gap: 16 });
  s.add(col([iconCircle('shield', 72)], { cross: 'CENTER' }), heading('Staff login', 'Admin accounts are created by the team. There is no sign up.'), input('Email', { icon: 'mail', value: 'admin@rehabsense.test' }), input('Password', { icon: 'lock', value: dots, suffix: 'eye' }),
    btn('Forgot password?', { v: 'text', size: 'M', to: 'A-02', full: false }), btn('Log in', { to: 'A-04' }), btn('Prototype: wrong portal (not an admin)', { v: 'text', size: 'M', to: 'A-25' }));
  s.finish();
  s = Screen('A-02', 'Forgot Password', 'NEW', { app: { title: '', back: 'A-01' }, gap: 16 });
  s.add(heading('Forgot password?', 'We will send a reset link.'), input('Email', { icon: 'mail', value: 'admin@rehabsense.test' }), btn('Send reset link', { to: 'A-03' }), btn('Back to login', { v: 'text', to: 'A-01' }));
  s.finish();
  s = Screen('A-03', 'Reset Password', 'NEW', { app: { title: '', close: true, back: 'A-01' }, gap: 16 });
  s.add(heading('Create new password'), input('New password', { icon: 'lock', value: dots, suffix: 'eye' }), input('Confirm password', { icon: 'lock', value: dots }), btn('Update password', { to: 'A-01' }));
  s.finish();

  s = Screen('A-04', 'Dashboard', 'NEW', { nav: 'admin', active: 0, gap: 16 });
  s.add(row([col([txt('Dashboard', 'h1', C.brandGreen), txt('Overview of RehabSense', 'small', C.textSecondary)], { gap: 0, grow: true }), iconBtn('bell', 'A-20')], { gap: 4 }),
    statRow([['Pending applications', '4', null], ['Active doctors', '18']]), statRow([['Patients', '246', '+12'], ['Sessions today', '83']]),
    sectionTitle('Pending applications', 'See all', 'A-05'), listItem('Sara Khan', 'Physiotherapist \u00B7 submitted today', { avatar: 'SK', chip: status('pending', 'Pending'), to: 'A-06' }), listItem('Omar Sheikh', 'Sports physio \u00B7 submitted 2 d ago', { avatar: 'OS', chip: status('pending', 'Pending'), to: 'A-06' }),
    sectionTitle('Quick links'), menu([{ icon: 'heart', title: 'Manage doctors', to: 'A-10' }, { icon: 'users', title: 'Manage patients', to: 'A-15' }, { icon: 'file', title: 'Audit log', to: 'A-21' }]));
  s.finish();

  s = Screen('A-05', 'Applications List', 'NEW', { app: { title: 'Applications', back: 'A-04' }, gap: 12 });
  s.add(seg(['Pending', 'Rejected', 'Approved'], 0), listItem('Sara Khan', 'PMDC-48213 \u00B7 attempt 1 of 3', { avatar: 'SK', chip: status('pending', 'Pending'), to: 'A-06' }), listItem('Omar Sheikh', 'PMDC-39120 \u00B7 attempt 1 of 3', { avatar: 'OS', chip: status('pending', 'Pending'), to: 'A-06' }), listItem('Hina Malik', 'PMDC-51007 \u00B7 attempt 2 of 3', { avatar: 'HM', chip: status('pending', 'Pending'), to: 'A-06' }), listItem('Zaid Ahmed', 'PMDC-22764 \u00B7 attempt 1 of 3', { avatar: 'ZA', chip: status('pending', 'Pending'), to: 'A-06' }));
  s.finish();
  s = Screen('A-06', 'Application Detail', 'NEW', { app: { title: 'Application', back: 'A-05' }, action: [{ label: 'Reject', v: 'destructiveOutline', to: 'A-09' }, { label: 'Approve', to: 'A-08' }], gap: 14 });
  s.add(card([row([avatar('SK', 56), col([txt('Dr. Sara Khan', 'h3'), txt('sara.khan@clinic.test', 'caption', C.textSecondary), status('pending', 'Pending')], { gap: 4, grow: true })], { gap: 12 })]),
    card([kv('Licence', 'PMDC-48213'), kv('Degree', 'DPT, Physiotherapy'), kv('Attempt', '1 of 3'), kv('Submitted', 'Today, 9:12 AM')], { gap: 10 }), sectionTitle('Documents'),
    card([row([iconCircle('file', 40), col([txt('Medical licence', 'bodyStrong'), txt('PDF \u00B7 1.2 MB', 'caption', C.textSecondary)], { gap: 0, grow: true }), icon('right', 20, C.textSecondary)], { gap: 12 })], { to: 'A-07' }),
    card([row([iconCircle('file', 40), col([txt('Degree certificate', 'bodyStrong'), txt('JPG \u00B7 2.4 MB', 'caption', C.textSecondary)], { gap: 0, grow: true }), icon('right', 20, C.textSecondary)], { gap: 12 })], { to: 'A-07' }),
    btn('Resend decision email', { v: 'text', size: 'M', to: 'A-05' }));
  s.finish();
  s = Screen('A-07', 'Document Viewer', 'NEW', { app: { title: 'Medical licence', back: 'A-06', dark: false }, gap: 14 });
  const page = mk('Document', { dir: 'V', gap: 10, pad: [24, 24, 24, 24], fill: C.surfaceCard, r: R.card, shadow: true }); flag(page, { st: true });
  A(page, txt('MEDICAL LICENCE', 'captionStrong', C.textSecondary), txt('Dr. Sara Khan', 'h3'), txt('Licence no. PMDC-48213', 'small'), txt('Valid until 2029', 'small', C.textSecondary), divider(), skel(160, 8));
  s.add(banner('info', 'This secure link expires in 60 seconds. Reopen the document if it stops loading.'), page, btn('Reopen secure link', { v: 'secondary', to: 'A-07' }), btn('Back to application', { v: 'text', to: 'A-06' }));
  s.finish();
  dialogScreen('A-08', 'Approve Dialog', 'NEW', { icon: 'check', title: 'Approve Dr. Sara Khan?', body: 'She will be able to log in and set up her profile. This is saved in the audit log.', primary: ['Approve', 'A-05'], secondary: ['Cancel', 'BACK'] });
  dialogScreen('A-09', 'Reject Sheet', 'NEW', { sheet: true, icon: 'x', destructive: true, title: 'Reject application', body: 'Choose a reason. The doctor will see it and can resubmit.', extra: [chips(['Unreadable document', 'Licence not found', 'Mismatch', 'Other'], 0), area('Note to doctor', 'The licence photo is not readable. Please upload a clearer copy.', 72)], primary: ['Reject application', 'A-05'], secondary: ['Cancel', 'BACK'] });

  s = Screen('A-10', 'Doctors List', 'NEW', { nav: 'admin', active: 1, gap: 12 });
  s.add(row([txt('Doctors', 'h1', C.brandGreen), btn('Add', { size: 'M', icon: 'plus', to: 'A-14', full: false, v: 'secondary' })], { main: 'SPACE_BETWEEN' }), input('Search doctors', { icon: 'search', hint: 'Name or licence' }), chips(['All', 'Active', 'Suspended'], 0),
    listItem('Dr. Sara Khan', '12 patients \u00B7 Knee', { avatar: 'SK', chip: status('correct', 'Active'), to: 'A-11' }), listItem('Dr. Omar Sheikh', '8 patients \u00B7 Sports', { avatar: 'OS', chip: status('correct', 'Active'), to: 'A-11' }), listItem('Dr. Hina Malik', '0 patients \u00B7 Shoulder', { avatar: 'HM', chip: status('incomplete', 'Suspended'), to: 'A-11' }));
  s.finish();
  s = Screen('A-11', 'Doctor Detail', 'NEW', { app: { title: 'Doctor', back: 'A-10' }, action: [{ label: 'Suspend', v: 'destructiveOutline', to: 'A-13' }, { label: 'Edit', to: 'A-12' }], gap: 14 });
  s.add(card([row([avatar('SK', 64), col([txt('Dr. Sara Khan', 'h3'), txt('Physiotherapist \u00B7 City Rehab Clinic', 'small', C.textSecondary), status('correct', 'Active and listed')], { gap: 4, grow: true })], { gap: 12 })]),
    statRow([['Patients', '12'], ['Exercises', '5']]), card([kv('Licence', 'PMDC-48213'), kv('Expertise', 'Knee, Post-surgery'), kv('Accepting patients', 'Yes'), kv('Joined', '12 Oct 2026')], { gap: 10 }), infoBox('Admins cannot see patient sessions, pain or conditions.'));
  s.finish();
  s = Screen('A-12', 'Edit Doctor', 'NEW', { app: { title: 'Edit doctor', back: 'A-11' }, action: { label: 'Save changes', to: 'A-11' }, gap: 14 });
  s.add(input('Title', { value: 'Physiotherapist' }), input('Clinic', { icon: 'pin', value: 'City Rehab Clinic' }), overline('Expertise'), chips(['Knee', 'Shoulder', 'Hip', 'Post-surgery'], [0, 3]), card([toggleRow('Listed to patients', true)]), banner('info', 'Every change is written to the audit log.'));
  s.finish();
  dialogScreen('A-13', 'Suspend or Reactivate', 'NEW', { icon: 'ban', destructive: true, title: 'Suspend Dr. Sara Khan?', body: 'She will be signed out and her patients will be told she is not available. You can reactivate her any time.', primary: ['Suspend doctor', 'A-10'], secondary: ['Cancel', 'BACK'] });
  s = Screen('A-14', 'Add Doctor (optional)', 'NEW', { app: { title: 'Add doctor', back: 'A-10' }, action: { label: 'Create doctor', to: 'A-10' }, gap: 14 });
  s.add(banner('info', 'Optional. Creates an approved doctor who sets a password by email.'), input('Full name', { icon: 'user', hint: 'Dr. name' }), input('Work email', { icon: 'mail', hint: 'name@clinic.com' }), input('Licence number', { icon: 'file', hint: 'PMDC-00000' }));
  s.finish();

  s = Screen('A-15', 'Patients List', 'NEW', { nav: 'admin', active: 2, gap: 12 });
  s.add(heading('Patients', '246 accounts'), input('Search patients', { icon: 'search', hint: 'Name or email' }), chips(['All', 'Active', 'Disabled'], 0), listItem('Alex Morgan', 'alex@rehab.test', { avatar: 'AM', chip: status('correct', 'Active'), to: 'A-16' }), listItem('Ali Raza', 'ali.raza@mail.test', { avatar: 'AR', chip: status('correct', 'Active'), to: 'A-16' }), listItem('Sana Iqbal', 'sana@mail.test', { avatar: 'SI', chip: status('incomplete', 'Disabled'), to: 'A-16' }));
  s.finish();
  s = Screen('A-16', 'Patient Detail (account only)', 'NEW', { app: { title: 'Patient', back: 'A-15' }, action: { label: 'Disable account', v: 'destructive', to: 'A-13' }, gap: 14 });
  s.add(card([row([avatar('AM', 64), col([txt('Alex Morgan', 'h3'), txt('alex@rehab.test', 'small', C.textSecondary), status('correct', 'Active')], { gap: 4, grow: true })], { gap: 12 })]), card([kv('Joined', '2 Nov 2026'), kv('Last active', 'Today'), kv('Email verified', 'Yes'), kv('Connected doctor', 'Yes')], { gap: 10 }),
    banner('info', 'Account info only. Sessions, pain and conditions are private and not shown to admins.'));
  s.finish();

  s = Screen('A-17', 'Exercise Library', 'NEW', { nav: 'admin', active: 3, gap: 12 });
  s.add(row([txt('Exercises', 'h1', C.brandGreen), btn('New', { size: 'M', icon: 'plus', to: 'A-18', full: false })], { main: 'SPACE_BETWEEN' }), chips(['All', 'Public', 'Private', 'Archived'], 0), listItem('Mini Squat', 'Rehab \u00B7 rep \u00B7 Public', { icon: 'activity', chip: status('correct', 'Tested'), to: 'A-19' }), listItem('Warrior II hold', 'Yoga \u00B7 hold \u00B7 Public', { icon: 'activity', chip: status('correct', 'Tested'), to: 'A-19' }), listItem('Tree pose hold', 'Yoga \u00B7 hold \u00B7 Public', { icon: 'activity', chip: status('pending', 'Untested'), to: 'A-19' }), listItem('Wall Sit', 'Rehab \u00B7 hold \u00B7 Private (Dr. Khan)', { icon: 'activity', chip: status('pending', 'Untested'), to: 'A-19' }));
  s.finish();
  wizard('A-18', 'Exercise Builder', 'NEW', {
    title: 'New exercise', back: 'A-17', finish: 'Publish', done: 'A-17', steps: [
      { title: 'Basics', head: 'Basics', sub: 'Name, category and visibility.', build: function (s) { s.add(input('Name', { value: 'Tree pose' }), overline('Category'), chips(['Rehab', 'Yoga', 'General'], 1), overline('Visibility'), seg(['Public', 'Private'], 0), area('Steps for the patient', 'Stand tall and lift one foot to the opposite thigh.', 80)); } },
      { title: 'Camera and kind', head: 'Camera and kind', sub: 'How patients will be tracked.', build: function (s) { s.add(overline('Type'), seg(['Rep', 'Hold'], 1), overline('Camera view'), seg(['Side', 'Front'], 1), banner('info', 'No video or images are stored.')); } },
      { title: 'Tracking config', head: 'Tracking config', sub: 'Angle range and hold time.', build: function (s) { s.add(input('Joint', { value: 'Standing knee' }), input('Angle range (degrees)', { value: '60 to 90' }), input('Hold time (seconds)', { value: '20' }), btn('Test on camera', { v: 'secondary', to: 'A-19' })); } },
      { title: 'Review', head: 'Review', sub: 'Publishing is saved in the audit log.', build: function (s) { s.add(card([kv('Name', 'Tree pose'), kv('Category', 'Yoga'), kv('Type', 'Hold'), kv('Camera', 'Front'), kv('Visibility', 'Public')], { gap: 10 })); } }]
  });
  s = Screen('A-19', 'Test on Camera', 'NEW', { camera: true });
  skeleton(s, { color: '#FFFFFF' }); s.abs(statusBar(true), 0, 0); glassBtn(s, 'x', 8, 32, 'A-17'); pill(s, 'TEST MODE \u00B7 nothing is saved', 60, 40, 240);
  const ac = mk('Counter', { dir: 'V', cross: 'CENTER', w: 360 }); A(ac, txt('0:14', 'displayMetric', C.textOnDark, { hug: true, align: 'CENTER' }), txt('Hold 20 s \u00B7 Tree pose', 'bodyStrong', C.textOnDarkSoft, { hug: true })); s.abs(ac, 0, 96);
  const ad = mk('Dock', { dir: 'V', gap: 8, pad: [12, 16, 24, 16], fill: C.glass, w: 360 }); A(ad, btn('Mark as tested', { v: 'onDarkFilled', size: 'M', to: 'A-17' }), btn('Back to builder', { v: 'onDarkOutline', size: 'M', to: 'A-18c' })); s.abs(ad, 0, 800 - ad.height); s.finish();

  s = Screen('A-20', 'Notifications', 'NEW', { app: { title: 'Notifications', back: 'A-04' }, gap: 12 });
  s.add(listItem('New application', 'Sara Khan submitted documents \u00B7 5 min ago', { icon: 'file', to: 'A-06' }), listItem('Resubmission', 'Hina Malik resubmitted (attempt 2 of 3)', { icon: 'refresh', to: 'A-06' }), listItem('Credentials changed', 'Omar Sheikh updated his licence', { icon: 'alert', to: 'A-11' }));
  s.finish();
  s = Screen('A-21', 'Audit Log', 'NEW', { app: { title: 'Audit log', back: 'A-22' }, gap: 12 });
  s.add(banner('info', 'Read-only. Every admin action is recorded here.'), chips(['All', 'Approvals', 'Suspensions', 'Exercises'], 0),
    listItem('Approved doctor', 'admin@rehabsense.test \u00B7 Sara Khan \u00B7 today 9:30', { icon: 'check' }), listItem('Rejected application', 'admin@rehabsense.test \u00B7 Hina Malik \u00B7 yesterday', { icon: 'x' }), listItem('Published exercise', 'admin@rehabsense.test \u00B7 Tree pose \u00B7 2 d ago', { icon: 'zap' }), listItem('Suspended doctor', 'admin@rehabsense.test \u00B7 Zaid Ahmed \u00B7 5 d ago', { icon: 'ban' }));
  s.finish();
  s = Screen('A-22', 'Profile (More)', 'NEW', { nav: 'admin', active: 4, gap: 16 });
  s.add(card([row([avatar('AD', 64), col([txt('Admin', 'h3'), txt('admin@rehabsense.test', 'small', C.textSecondary)], { gap: 0, grow: true })], { gap: 12 })]),
    menu([{ icon: 'bell', title: 'Notifications', to: 'A-20' }, { icon: 'file', title: 'Audit log', to: 'A-21' }, { icon: 'lock', title: 'Change password', to: 'A-23' }]), menu([{ icon: 'logout', title: 'Log out', danger: true, to: 'A-24' }]));
  s.finish();
  s = Screen('A-23', 'Change Password', 'NEW', { app: { title: 'Change password', back: 'A-22' }, action: { label: 'Update password', to: 'A-22' }, gap: 14 });
  s.add(input('Current password', { icon: 'lock', value: dots }), input('New password', { icon: 'lock', value: dots }), input('Confirm new password', { icon: 'lock', value: dots }));
  s.finish();
  dialogScreen('A-24', 'Logout Dialog', 'NEW', { icon: 'logout', title: 'Log out?', body: 'You will return to the welcome screen.', primary: ['Log out', 'P-02'], secondary: ['Cancel', 'BACK'] });
  stateScreen('A-25', 'Blocked or Wrong Portal', 'NEW', { app: { title: '', back: 'A-01' }, icon: 'ban', tone: 'error', title: 'No access', body: 'This account is not an admin account. Use the patient or doctor app instead.', buttons: [['Back to welcome', 'P-02'], ['Try another account', 'A-01', 'secondary']] });
}
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
