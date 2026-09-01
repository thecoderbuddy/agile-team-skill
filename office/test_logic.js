/* Headless test for logic.js — run: node office/test_logic.js */
const fs = require("fs");
const path = require("path");
const { createOffice } = require("./logic.js");

const MAP = JSON.parse(fs.readFileSync(path.join(__dirname, "map.json"), "utf8"));
const logs = [];
const office = createOffice(MAP, (who, text) => logs.push(who + "|" + text));

function assert(cond, msg) { if (!cond) { console.error("FAIL:", msg); process.exit(1); } }
function runUntilIdle(maxMs) {
  let t = 0;
  while (t < maxMs) {
    office.step(50); t += 50;
    if (!Object.values(office.agents).some(a => a.state === "walking")) break;
  }
  return t;
}

let now = 1000;
office.handle({ event: "UserPromptSubmit", desc: "run /review on STORY-012" }, now);
assert(office.agents.manager.bubble.includes("STORY-012"), "manager bubble on prompt");

office.handle({ event: "PreToolUse", tool: "Agent", agent_type: "qa-agent", desc: "quality gate" }, now);
const qa = office.agents["qa-agent"];
assert(qa.present && qa.state === "walking", "qa walks in");
assert(office.activeStack.length === 1 && office.activeStack[0] === "qa-agent", "qa on active stack");

office.handle({ event: "PreToolUse", tool: "Agent", agent_type: "not-a-real-type" }, now);
assert(office.agents.guest.present, "unknown agent_type resolves to guest");
office.handle({ event: "PostToolUse", tool: "Agent", agent_type: "not-a-real-type" }, now);

runUntilIdle(20000);
assert(qa.state === "working", "qa reaches desk -> working, got " + qa.state);

office.handle({ event: "PostToolUse", tool: "Read", desc: "BACKLOG.md" }, now);
assert(logs.some(l => l.startsWith("qa-agent|Read")), "tool event attributed to qa");

office.handle({ event: "PostToolUse", tool: "Agent", agent_type: "qa-agent" }, now);
assert(qa.state === "walking" && qa.next === "reporting", "qa heads to manager");
assert(office.activeStack.length === 0, "stack empty after finish");

runUntilIdle(20000);
assert(qa.state === "reporting", "qa reporting at manager desk");

office.housekeeping(now);            // stamps reportT
office.housekeeping(now + 4000);     // > 3.5s later -> dismissed (door or coffee break)
assert(qa.state === "walking" && (qa.next === "off" || qa.next === "hangout"), "qa dismissed");
runUntilIdle(20000);
if (qa.state === "hangout") {
  office.housekeeping(now + 4100);   // stamps hangT
  office.housekeeping(now + 15000);  // break over -> door
  runUntilIdle(20000);
}
office.housekeeping(now + 20000);
assert(qa.state === "off" && !qa.present, "qa left the office");

office.handle({ event: "Stop" }, now);
assert(office.agents.manager.bubble === "all done ✓", "manager idle bubble");

// ── ceremony: /standup gathers everyone in the conference room ──────────
office.handle({ event: "UserPromptSubmit", desc: "/standup daily sync" }, now);
assert(office.ceremony === true, "ceremony mode on");
const mgr = office.agents.manager;
assert(mgr.state === "walking" && mgr.next === "meeting", "manager heads to conference");

office.handle({ event: "PreToolUse", tool: "Agent", agent_type: "dev-agent", desc: "standup report" }, now);
office.handle({ event: "PreToolUse", tool: "Agent", agent_type: "po-agent", desc: "standup notes" }, now);
const dev = office.agents["dev-agent"], ceo = office.agents["po-agent"];
assert(dev.next === "meeting" && ceo.next === "meeting", "spawned agents head to conference");
runUntilIdle(60000);
assert(mgr.state === "meeting" && dev.state === "meeting" && ceo.state === "meeting",
  `everyone seated in conference, got ${mgr.state}/${dev.state}/${ceo.state}`);
assert(new Set([mgr, dev, ceo].map(a => a.x + "," + a.y)).size === 3, "distinct conference seats");

office.handle({ event: "PostToolUse", tool: "Agent", agent_type: "dev-agent" }, now);
assert(dev.state === "meeting", "dev stays seated during ceremony");

office.handle({ event: "Stop" }, now);
assert(office.ceremony === false, "ceremony mode off");
assert(mgr.next === "working" && dev.next === "off", "manager returns to desk, dev leaves");
runUntilIdle(60000);
office.housekeeping(now + 20000);
assert(mgr.state === "working" && !dev.present, "post-ceremony states settle");

console.log("logic.js: all assertions passed (" + logs.length + " log lines)");
