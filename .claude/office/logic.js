/* Office state machine — pure logic, no DOM/PIXI. Used by index.html and test_logic.js.
   Positions are pixel foot-coordinates taken from map.json (seats/door/report/confSeats). */
(function (root, factory) {
  if (typeof module === "object" && module.exports) module.exports = factory();
  else root.OfficeLogic = factory();
})(typeof self !== "undefined" ? self : this, function () {
  "use strict";

  const CEREMONY_RE = /standup|retro|sprint[-_ ]?plan|sprint[-_ ]?close|all[-_ ]?hands/i;

  function createOffice(map, onLog) {
    const log = onLog || function () {};
    const door = { x: map.door[0], y: map.door[1] };
    const report = { x: map.report[0], y: map.report[1] };
    const confDoor = map.confDoor ? { x: map.confDoor[0], y: map.confDoor[1] } : null;
    const agents = {};
    const activeStack = [];
    const speed = (map.tile || 16) * 0.004125;   // ~4 tiles/s, in px per ms
    const office = { agents, activeStack, door, ceremony: false };
    let nextSeat = 0;

    function mkAgent(name) {
      const s = map.seats[name];
      const home = { x: s[0], y: s[1] };
      const visitor = name === "guest";   // whole team is always in; guests come and go
      return { name, home,
        present: !visitor,
        x: visitor ? door.x : home.x, y: visitor ? door.y : home.y,
        path: [], state: visitor ? "off" : "working", next: "working", busy: false,
        bubble: null, bubbleUntil: 0, typing: 0, reportT: 0, hangT: 0, sitDir: 2,
      };
    }
    for (const name of map.agents) agents[name] = mkAgent(name);

    const resolveType = t => {
      const base = (t || "").split(":").pop();   // plugin agents arrive namespaced, e.g. "agile-team:qa-agent"
      const n = (map.aliases || {})[base] || base;
      return map.seats[n] ? n : "guest";
    };

    function walkTo(a, gx, gy, next) {
      a.path = [{ x: gx, y: a.y }, { x: gx, y: gy }];
      a.state = "walking"; a.next = next || "working";
    }
    function walkVia(a, via, gx, gy, next) {
      a.path = [{ x: via.x, y: a.y }, { x: via.x, y: via.y }, { x: gx, y: via.y }, { x: gx, y: gy }];
      a.state = "walking"; a.next = next || "working";
    }
    // v-first variant: step out of a desk vertically, then follow the hallway
    function walkViaV(a, via, gx, gy, next) {
      a.path = [{ x: a.x, y: via.y }, { x: via.x, y: via.y }, { x: via.x, y: gy }, { x: gx, y: gy }];
      a.state = "walking"; a.next = next || "working";
    }
    function goHome(a, name) {
      const via = (map.vias || {})[name];
      if (via) walkVia(a, { x: via[0], y: via[1] }, a.home.x, a.home.y, "working");
      else walkTo(a, a.home.x, a.home.y, "working");
    }
    function say(a, text, now, ms) {
      a.typing = now + 1600;
      // don't flash-replace a bubble the viewer is still reading
      if (a.bubble && a.bubbleUntil > now && now < (a.bubbleMin || 0)) return;
      a.bubble = (text || "").slice(0, 90);
      a.bubbleUntil = now + (ms || 4200);
      a.bubbleMin = now + 2500;
    }
    function goToMeeting(a) {
      const seat = map.confSeats[nextSeat++ % map.confSeats.length];
      a.sitDir = seat[2];
      walkVia(a, confDoor, seat[0], seat[1], "meeting");
    }
    function leaveMeeting(a, gx, gy, next) {
      walkVia(a, confDoor, gx, gy, next);
    }

    function handle(ev, now) {
      const mgr = agents.manager;
      switch (ev.event) {
        case "UserPromptSubmit":
          say(mgr, ev.desc || "new prompt", now, 9000);
          log("manager", "prompt: " + (ev.desc || ""));
          if (confDoor && CEREMONY_RE.test(ev.desc || "")) {
            office.ceremony = true;
            nextSeat = 0;
            for (const k of map.agents) if (agents[k].present) goToMeeting(agents[k]);
            log("manager", "— ceremony: team heads to the conference room —", "sys");
          }
          break;
        case "PreToolUse":
          if (ev.tool === "Agent" || ev.tool === "Task") {
            const t = resolveType(ev.agent_type || "guest");
            const a = agents[t];
            a.present = true;
            a.busy = true;
            if (a.state === "off") { a.x = door.x; a.y = door.y; }
            if (office.ceremony) {
              if (a.state !== "meeting" && !(a.state === "walking" && a.next === "meeting"))
                goToMeeting(a);
            } else if (a.state !== "working") {
              goHome(a, t);
            }
            say(a, ev.desc || "on it", now, 6000);
            activeStack.push(t);
            log(t, "→ starts: " + (ev.desc || ""));
          }
          break;
        case "PostToolUse":
          if (ev.tool === "Agent" || ev.tool === "Task") {
            const t = resolveType(ev.agent_type || "guest");
            const i = activeStack.lastIndexOf(t);
            if (i >= 0) activeStack.splice(i, 1);
            const a = agents[t];
            a.busy = false;
            if (a.present) {
              if (office.ceremony) {
                say(a, "✓ done", now, 4000);        // stays seated until the ceremony ends
              } else {
                const via = (map.vias || {})[t];
                if (via && a.state === "working")
                  walkViaV(a, { x: via[0], y: via[1] }, report.x, report.y, "reporting");
                else walkTo(a, report.x, report.y, "reporting");
                say(a, "done — reporting ✓", now, 5000);
              }
            }
            log(t, "✓ finished");
          } else if (ev.tool) {
            const t = activeStack.length ? activeStack[activeStack.length - 1] : "manager";
            const a = agents[t];
            if (a.state !== "walking") say(a, ev.tool + (ev.desc ? ": " + ev.desc : ""), now);
            log(t, ev.tool + (ev.desc ? " · " + ev.desc : ""));
          }
          break;
        case "SubagentStop":
          log("manager", "a teammate wrapped up", "sys");
          break;
        case "Stop":
          say(mgr, "all done ✓", now, 7000);
          log("manager", "— session idle —", "sys");
          if (office.ceremony) {
            office.ceremony = false;
            for (const k of map.agents) {
              const a = agents[k];
              if (!a.present) continue;
              if (a.state === "meeting" || (a.state === "walking" && a.next === "meeting")) {
                if (k === "guest") leaveMeeting(a, door.x, door.y, "off");
                else leaveMeeting(a, a.home.x, a.home.y, "working");
              }
            }
          }
          break;
      }
    }

    function pickHangout() {
      const spots = map.hangout || [];
      return spots.length ? spots[Math.floor(Math.random() * spots.length)] : null;
    }

    function housekeeping(now) {
      for (const k in agents) {
        const a = agents[k];
        const settle = () => {   // team members return to their desk; guests leave
          if (k === "guest") walkTo(a, door.x, door.y, "off");
          else goHome(a, k);
        };
        if (a.state === "reporting" && !a.reportT) a.reportT = now;
        if (a.state === "reporting" && now - a.reportT > 3500) {
          a.reportT = 0;
          const spot = !office.ceremony && Math.random() < 0.45 ? pickHangout() : null;
          if (spot && map.hangVia)
            walkVia(a, { x: map.hangVia[0], y: map.hangVia[1] }, spot[0], spot[1], "hangout");
          else if (spot) walkTo(a, spot[0], spot[1], "hangout");
          else settle();
        }
        if (a.state === "hangout" && !a.hangT) { a.hangT = now; say(a, "☕", now, 6500); }
        if (a.state === "hangout" && now - a.hangT > 7000) {
          a.hangT = 0; settle();
        }
        if (a.state === "off" && k === "guest") a.present = false;
      }
    }

    function step(dt) {
      const sp = speed * dt;
      for (const k in agents) {
        const a = agents[k];
        if (a.state !== "walking" || !a.path.length) continue;
        let budget = sp;
        while (budget > 0 && a.path.length) {
          const tgt = a.path[0];
          const dx = tgt.x - a.x, dy = tgt.y - a.y, dist = Math.hypot(dx, dy);
          if (dist <= budget) {
            a.x = tgt.x; a.y = tgt.y; a.path.shift(); budget -= dist;
            if (!a.path.length) a.state = a.next;
          } else {
            a.x += budget * dx / dist; a.y += budget * dy / dist; budget = 0;
          }
        }
      }
    }

    office.handle = handle;
    office.housekeeping = housekeeping;
    office.step = step;
    return office;
  }

  return { createOffice };
});
