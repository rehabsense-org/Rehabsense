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
