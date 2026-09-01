/* Headless smoke test: runs the index.html inline script with stubbed PIXI + DOM.
   Verifies init -> scene build -> event handling -> render frames without throwing.
   Run: node office/test_render.js */
const fs = require("fs");
const path = require("path");

const html = fs.readFileSync(path.join(__dirname, "index.html"), "utf8");
const scripts = [...html.matchAll(/<script>([\s\S]*?)<\/script>/g)].map(m => m[1]);
const inline = scripts[scripts.length - 1];

// ── stubs ────────────────────────────────────────────────────────────────
const chain = () => new Proxy(function () {}, {
  get: (t, k) => {
    if (k === "position" || k === "scale" || k === "anchor") return { set() {}, x: 0, y: 0 };
    if (k === "children") return [];
    if (k === "width" || k === "height" || k === "x" || k === "y" || k === "alpha" || k === "zIndex") return 0;
    return chainVal;
  },
  set: () => true,
  apply: () => chainVal,
});
let chainVal; chainVal = chain();

class Node {
  constructor(tag) { this.tag = tag; this.children = []; this.style = {}; this.classList = { toggle() {}, add() {} }; this.width = 0; this.height = 0; }
  appendChild(c) { this.children.push(c); return c; }
  removeChild(c) { this.children = this.children.filter(x => x !== c); }
  set innerHTML(v) { this._h = v; } get innerHTML() { return this._h || ""; }
  set textContent(v) { this._t = v; } get textContent() { return this._t || ""; }
  set className(v) { this._c = v; }
  getContext() { return { createRadialGradient: () => ({ addColorStop() {} }), fillRect() {}, set fillStyle(v) {} }; }
  get firstChild() { return this.children[0]; }
  get scrollHeight() { return 0; } set scrollTop(v) {}
}
const nodes = {};
global.document = {
  getElementById: id => nodes[id] || (nodes[id] = new Node("div")),
  createElement: tag => new Node(tag),
};
global.performance = { now: () => nowMs };
let nowMs = 1000;
const intervals = [];
global.setInterval = (fn, ms) => { intervals.push(fn); return intervals.length; };

class GContainer {
  constructor() { this.children = []; this.position = pt(); this.scale = pt(); this.visible = true; this.zIndex = 0; }
  addChild(...c) { this.children.push(...c); }
  removeChild(c) { this.children = this.children.filter(x => x !== c); }
}
function pt() { return { x: 0, y: 0, set() {} }; }
class GGraphics extends GContainer {
  beginFill() { return this; } endFill() { return this; } drawRect() { return this; }
  drawRoundedRect() { return this; } drawCircle() { return this; } drawEllipse() { return this; }
  clear() { return this; } lineStyle() { return this; } moveTo() { return this; }
  lineTo() { return this; } closePath() { return this; }
}
class GSprite extends GContainer {
  constructor(tex) { super(); this.texture = tex; this.anchor = pt(); this.blendMode = 0; this.alpha = 1; this.width = 0; this.height = 0; }
  destroy() {}
}
class GText extends GContainer {
  constructor(text) { super(); this._text = text || ""; this.resolution = 1; }
  set text(v) { this._text = v; } get text() { return this._text; }
  get width() { return this._text.length * 6; }
  get height() { return 18; }
}
const tickerFns = [];
global.window = { addEventListener() {} };
global.location = { search: "" };
global.Image = class {
  set src(v) { setTimeout(() => this.onload && this.onload(), 0); }
};
global.PIXI = {
  BaseTexture: { defaultOptions: {}, from: () => ({}) },
  SCALE_MODES: { NEAREST: 0 },
  BLEND_MODES: { ADD: 1 },
  Rectangle: class {},
  Texture: Object.assign(class { constructor(bt, r) { this.bt = bt; this.r = r; } }, { from: () => ({ stub: true }) }),
  Container: GContainer, Graphics: GGraphics, Sprite: GSprite, Text: GText,
  Application: class {
    constructor() {
      this.view = new Node("canvas");
      this.stage = new GContainer();
      this.ticker = { add: fn => tickerFns.push(fn), deltaMS: 16.7 };
    }
  },
  Assets: { load: async () => ({ "tiles.png": { baseTexture: {} }, "agents.png": { baseTexture: {} } }) },
};

const MAP = JSON.parse(fs.readFileSync(path.join(__dirname, "map.json"), "utf8"));
let eventsBody = "";
global.fetch = async url => {
  if (String(url).includes("map.json")) return { ok: true, json: async () => MAP };
  return { ok: true, text: async () => eventsBody };
};
global.OfficeLogic = require("./logic.js");
global.self = global;

// ── run ──────────────────────────────────────────────────────────────────
(async () => {
  new Function(inline)();
  await new Promise(r => setTimeout(r, 30));   // let init() settle

  if (!tickerFns.length) { console.error("FAIL: ticker never registered — init() likely threw"); process.exit(1); }
  if (!nodes.roster || nodes.roster.children.length !== MAP.agents.length) {
    console.error("FAIL: roster chips missing"); process.exit(1);
  }

  // frame with idle office
  tickerFns.forEach(f => f());

  // feed a /review chain through the poll path
  const evs = [
    { event: "UserPromptSubmit", desc: "/review STORY-012" },
    { event: "PreToolUse", tool: "Agent", agent_type: "qa-agent", desc: "quality gate" },
    { event: "PostToolUse", tool: "Bash", desc: "npm test" },
    { event: "PostToolUse", tool: "Agent", agent_type: "qa-agent" },
    { event: "Stop" },
  ];
  eventsBody = "";                              // first poll attaches at 0
  await intervals[0]();                         // poll (attach)
  eventsBody = evs.map(e => JSON.stringify(e)).join("\n") + "\n";
  await intervals[0]();                         // poll (consume)

  // simulate ~6s of frames + housekeeping
  for (let i = 0; i < 360; i++) {
    nowMs += 16.7;
    tickerFns.forEach(f => f());
    if (i % 30 === 0) intervals[1]();           // housekeeping
  }

  const stat = nodes.stat.textContent;
  if (!/events: 5/.test(stat)) { console.error("FAIL: expected 5 events consumed, stat=", stat); process.exit(1); }
  console.log("render smoke test passed —", stat);
})().catch(e => { console.error("FAIL:", e); process.exit(1); });
