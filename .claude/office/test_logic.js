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

// ── whole team starts at their desks; only the guest is out ─────────────
for (const n of MAP.agents) {
  const a = office.agents[n];
  if (n === "guest") assert(!a.present && a.state === "off", "guest starts out of office");
  else assert(a.present && a.state === "working" && !a.busy, n + " starts idle at desk");
}

office.handle({ event: "UserPromptSubmit", desc: "run /review on STORY-012" }, now);
assert(office.agents.manager.bubble.includes("STORY-012"), "manager bubble on prompt");

office.handle({ event: "PreToolUse", tool: "Agent", agent_type: "qa-agent", desc: "quality gate" }, now);
const qa = office.agents["qa-agent"];
assert(qa.busy && qa.state === "working", "qa activates at her desk (no walk-in)");
assert(office.activeStack.length === 1 && office.activeStack[0] === "qa-agent", "qa on active stack");

office.handle({ event: "PreToolUse", tool: "Agent", agent_type: "not-a-real-type" }, now);
assert(office.agents.guest.present && office.agents.guest.state === "walking", "unknown type -> guest walks in");
office.handle({ event: "PostToolUse", tool: "Agent", agent_type: "not-a-real-type" }, now);

office.handle({ event: "PreToolUse", tool: "Agent", agent_type: "agile-team:dev-agent", desc: "ns test" }, now);
assert(office.agents["dev-agent"].busy, "plugin-namespaced agent_type resolves");
office.handle({ event: "PostToolUse", tool: "Agent", agent_type: "agile-team:dev-agent" }, now);

office.handle({ event: "PostToolUse", tool: "Read", desc: "BACKLOG.md" }, now);
assert(logs.some(l => l.startsWith("qa-agent|Read")), "tool event attributed to qa");

office.handle({ event: "PostToolUse", tool: "Agent", agent_type: "qa-agent" }, now);
assert(!qa.busy && qa.state === "walking" && qa.next === "reporting", "qa heads to manager");
assert(office.activeStack.length === 0, "stack empty after finish");

runUntilIdle(30000);
assert(qa.state === "reporting", "qa reporting at manager desk");

office.housekeeping(now);            // stamps reportT
office.housekeeping(now + 4000);     // > 3.5s later -> coffee break or back to desk
assert(qa.state === "walking" && (qa.next === "working" || qa.next === "hangout"), "qa dismissed");
runUntilIdle(30000);
if (qa.state === "hangout") {
  office.housekeeping(now + 4100);   // stamps hangT
  office.housekeeping(now + 15000);  // break over -> desk
  runUntilIdle(30000);
}
office.housekeeping(now + 20000);
assert(qa.state === "working" && qa.present && !qa.busy, "qa back at her desk, idle");
assert(qa.x === qa.home.x && qa.y === qa.home.y, "qa at her own seat");

office.handle({ event: "Stop" }, now + 6000);   // past the bubble's min display time
assert(office.agents.manager.bubble === "all done ✓", "manager idle bubble");

// min display time: an immediate follow-up say must NOT replace a fresh bubble
office.handle({ event: "PostToolUse", tool: "Read", desc: "x.md" }, now + 6100);
assert(office.agents.manager.bubble === "all done ✓", "fresh bubble survives rapid follow-up");

// ── ceremony: /standup gathers the whole team in the conference room ────
office.handle({ event: "UserPromptSubmit", desc: "/standup daily sync" }, now);
assert(office.ceremony === true, "ceremony mode on");
const mgr = office.agents.manager;
assert(mgr.state === "walking" && mgr.next === "meeting", "manager heads to conference");
const team = MAP.agents.filter(n => n !== "guest");
assert(team.every(n => office.agents[n].next === "meeting" || office.agents[n].state === "meeting"),
  "entire team heads to conference");

office.handle({ event: "PreToolUse", tool: "Agent", agent_type: "dev-agent", desc: "standup report" }, now);
const dev = office.agents["dev-agent"];
assert(dev.busy && dev.next === "meeting", "spawn during ceremony keeps dev in the meeting");
runUntilIdle(90000);
const seated = team.filter(n => office.agents[n].state === "meeting");
assert(seated.length === team.length, `everyone seated, got ${seated.length}/${team.length}`);
assert(new Set(seated.map(n => office.agents[n].x + "," + office.agents[n].y)).size === seated.length,
  "distinct conference seats");

office.handle({ event: "PostToolUse", tool: "Agent", agent_type: "dev-agent" }, now);
assert(dev.state === "meeting", "dev stays seated during ceremony");

office.handle({ event: "Stop" }, now);
assert(office.ceremony === false, "ceremony mode off");
assert(dev.next === "working" && mgr.next === "working", "team returns to desks after ceremony");
runUntilIdle(90000);
office.housekeeping(now + 20000);
assert(team.every(n => {
  const a = office.agents[n];
  return a.state === "working" && a.x === a.home.x && a.y === a.home.y;
}), "post-ceremony: whole team back at their desks");

console.log("logic.js: all assertions passed (" + logs.length + " log lines)");
