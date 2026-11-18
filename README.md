# Automate your Shopee store with Claude — one-day workshop

Leap E-commerce · hands-on, on your own store · you leave with it running.

This repo holds everything the day runs on:

| What | For whom | Where |
|---|---|---|
| **Get-ready page** (do this before the day) | Attendees | `pages/prerequisites.html` |
| **START file** (paste its link into Claude) | Attendees' Claude | `START.md` |
| **Modules** (Claude downloads them, one at a time) | Attendees' Claude | `modules/` |
| **Templates** (dashboard, rules, helper notes) | Attendees' Claude copies them | `templates/` |
| **Trainer notes** | Trainers | this README |

Attendees never read the module files. They open Claude, paste one sentence, and Claude teaches them,
asks them questions, and builds everything on their own laptop with them.

---

## How an attendee starts

1. **Before the day:** open the get-ready page and tick every step. Progress is saved in their browser.
2. **On the day:** open Claude Desktop → **Code** → choose the **Shopee HQ** folder on the Desktop → paste:

```
Please read and follow the instructions in this file to run today's Shopee workshop with me: https://raw.githubusercontent.com/gist11a/Leap-workshop/main/START.md
```

Claude then downloads the course into their Shopee HQ folder and runs it module by module.
They move on by typing the next module word (`module1`, `module2` …), never with a `/` in front.

---

## The day

| Time | Module | They leave with |
|---|---|---|
| 9:30 | Welcome (trainer, laptops closed) | Why this matters, what "Claude does it in the browser" means |
| 9:50 | **0 · Get set up** | Shopee HQ folder ready, Claude can see their Seller Centre |
| 10:20 | **1 · Your shop's brain and rules** | Shop profile, promises to buyers, chat voice + buyer FAQ, live reply test (stock, ads, cost and campaign rules are set in their own modules) |
| 11:00 | Break | |
| 11:15 | **2 · Your dashboard** | Their own dashboard, opening in their browser (empty tiles that fill up as the day goes on) |
| 11:40 | **3 · Stock and reorders** | Low-stock list + reorder amounts, saved and on the dashboard |
| 12:15 | **4 · Make it run by itself** | Claude schedules the morning stock check, runs it once, attendee approves its tools. **The guarantee is met here.** |
| 12:40 | Lunch | |
| 1:30 | **5 · Chats and reviews** | Replies drafted in their shop's voice, sent only after their YES |
| 2:15 | **6 · Ads check** | Morning ad check against their goals, wasted spend flagged |
| 2:50 | Break | |
| 3:05 | **7 · Real profit** | Profit per product after Shopee fees and their costs |
| 3:35 | **8 · Campaigns** | Products picked and priced from their rules, ready to nominate |
| 4:10 | **9 · Affiliates** | Sample requests and creators checked against their rules |
| 4:30 | **10 · Product images** | Image check per product + ready-to-use image briefs |
| 4:50 | **11 · Your daily routine + finale** | One morning routine runs every check in order (replaces the separate morning schedules), morning summary + optional Gmail draft, a personal 5-minute checklist (`MY-ROUTINE.md`), finale card |
| 5:30 | Close | |

Times are rough. A gate word keeps the room together; nobody is rushed.

---

## The system each attendee builds (all on their own laptop)

```
Desktop/Shopee HQ/
  CLAUDE.md            ← the shop's brain: who they are, the rules, how Claude works for them
  course/              ← module files, downloaded from this repo
  helpers/             ← job notes for the helper (reader and doer)
  rules/               ← their rules, as simple JSON files they can change by asking
     shop.json  store.json  chat.json  stock.json  ads.json
     campaigns.json  affiliates.json  costs.json
  data/                ← what Claude reads from Seller Centre, one file per day
     stock/  orders/  ads/  chats/  reviews/  campaigns/  affiliates/  profit/
  automations.json     ← every automation: what it does, when, needs a YES or not, last run
  approvals.json       ← things waiting for their YES (chat replies, budget changes, nominations)
  alerts.json          ← things to look at
  runs.json            ← a short log of every run
  dashboard/
     index.html        ← the dashboard template (they can change it by asking Claude)
     data.js           ← rebuilt after every run, so the dashboard opens straight from the folder
```

**Plain JSON files are the database.** No server, no accounts, no internet address.
**Data is kept for 30 days.** Every run deletes day files older than 30 days and trims the logs.

### Boss and helper (Opus and Sonnet)

- **The boss is Opus** — the chat they talk to. It asks questions, plans, checks, writes their rules and
  files, and asks for their YES. It never reads long Seller Centre pages itself.
- **The helper is Sonnet** — sent by the boss to do the browser work: open a Seller Centre page, read it,
  bring back a short summary as JSON. A second helper job, "doer", carries out **one approved change** exactly
  as written (send this reply, set this budget) and reports back.
- **Scheduled runs use Sonnet**, so the daily jobs cost little. Claude creates the schedule itself (the app's
  scheduled-tasks tool, local time) and starts a first "Run now" so the attendee can click **Always allow** once.
  A scheduled run that starts on Opus hands the whole job to a Sonnet helper (the app has no model setting per task).
- **Schedules on the day:** each module adds its own morning job (9:00 stock, 9:10 ads, 9:15 affiliates, 9:20 profit,
  9:30 campaigns, 10:00 + 15:00 chats, Mon 9:45 images). Module 11 merges the morning ones into one routine so they
  never share the browser at once. If an attendee stops before Module 11, their separate jobs can overlap.
- **A scheduled run needs the laptop on and Claude's browser open** (Seller Centre signed in). That is a stated
  requirement, not a bug: if the laptop is closed, that run is skipped. Attendees hear this in Modules 4 and 11.

### Staying inside the Claude Pro limits

Designed so one person on **Pro** gets through the day and their daily jobs fit the weekly limit:
- The boss writes short replies and copies ready-made templates instead of writing big files.
- Helpers read pages as **text**, not screenshots, and only the part they need.
- One browser helper at a time (they share one browser).
- At every gate, Claude reminds them to glance at **Settings → Usage**. Above about 70% before lunch,
  the boss switches itself to Sonnet for the rest of the morning.
- The 5-hour window resets once during the day, around lunch.

### Safety rules (said out loud, built in everywhere)

- **Read first, change never without a YES.** Anything that changes the shop (send a reply, change a
  budget, nominate a product) goes to `approvals.json` and waits for their YES.
- **Claude never types their password or one-time code.** They sign in to Seller Centre themselves, once,
  in the built-in browser; the sign-in is remembered.
- **No scripts in their browser.** Claude only reads pages and clicks like a person would.
- **Their data stays on their laptop.** Nothing goes to Leap or anywhere else.

---

## Setting up hosting (one time)

1. Push this repo to `github.com/gist11a/Leap-workshop` (public).
2. **Settings → Pages → Deploy from a branch → `main` / root → Save.**
   The get-ready page is then at `https://gist11a.github.io/Leap-workshop/pages/prerequisites.html`.
3. **Framer:** on a new page (for example `/workshop-setup`), add an **Embed** block → **URL** → paste the link
   above → set the height to fill the page. Also put the direct link under it, because some browsers (Safari)
   keep embedded-page progress separately.
