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
Please run today's Shopee workshop with me. First download this file word for word with curl, then follow it exactly: https://raw.githubusercontent.com/gist11a/Leap-workshop/main/START.md
```

Claude then downloads the course into their Shopee HQ folder and runs it module by module. ("word for word with
curl" stops Claude from reading START.md through a summarising web reader, which could drop details.) The same line
is on the get-ready page's "On the day" card with a Copy button. After a break or a new chat: open a session in the
same Shopee HQ folder and type **continue the workshop**.
They move on by typing the next module word (`module2`, `module3` …), never with a `/` in front.

---

## The day

| Time | Module | They leave with |
|---|---|---|
| 9:30 | Welcome (trainer, laptops closed) | Why this matters, what "Claude does it in the browser" means |
| 9:50 | **1 · Get set up** | Shopee HQ folder ready, Claude can see their Seller Centre |
| 10:20 | **2 · Your shop's brain and rules** | Shop profile, promises to buyers, chat voice + buyer FAQ, live reply test (stock, ads, cost and campaign rules are set in their own modules) |
| 11:00 | Break | |
| 11:15 | **3 · Your dashboard** | Their own dashboard, opening in their browser (empty tiles that fill up as the day goes on) |
| 11:40 | **4 · Stock and reorders** | Low-stock list + reorder amounts, saved and on the dashboard |
| 12:15 | **5 · Make it run by itself** | Claude schedules the morning stock check, runs it once, attendee approves its tools. **The guarantee is met here.** |
| 12:40 | Lunch | |
| 1:30 | **6 · Chats and reviews** | Replies drafted in their shop's voice, sent only after their YES |
| 2:15 | **7 · Ads check** | Morning ad check against their goals, wasted spend flagged |
| 2:50 | Break | |
| 3:05 | **8 · Real profit** | Profit per product after Shopee fees, shipping, packing and their costs |
| 3:35 | **9 · Campaigns** | Products picked and priced from their rules, ready to nominate |
| 4:10 | **10 · Affiliates** | Sample requests and creators checked against their rules |
| 4:30 | **11 · Product images** | Image check per product + ready-to-use image briefs |
| 4:50 | **12 · Your daily routine + finale** | One morning routine runs every check in order (replaces the separate morning schedules), morning summary + optional Gmail draft, a personal 5-minute checklist (`MY-ROUTINE.md`), finale card |
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
     shop-profile.md   ← what Claude learned from the Shop Scan (Module 2, optional, with their OK)
  data/                ← what Claude reads from Seller Centre, one file per day
     stock/  orders/  ads/  chats/  reviews/  campaigns/  affiliates/  profit/
  automations/         ← one recipe per check, the Shop Scan, and extras.md (optional ready-made extras)
  automations.json     ← every automation: what it does, when, extras switched on, last run
  approvals.json       ← things waiting for their YES (chat replies, budget changes, nominations)
  alerts.json          ← things to look at
  runs.json            ← a short log of every run
  dashboard/
     index.html        ← the dashboard template (they can change it by asking Claude)
     data.js           ← rebuilt after every run, so the dashboard opens straight from the folder
     progress.html     ← the workshop map: 12 badges, lights up by itself after each module
  progress.json        ← which modules are done (Claude updates it at every gate)
```

**New in this version**
- **Modules are numbered 1 to 12** (`module1` … `module12`).
- **Shopee's policy is always in force.** `store.json` → `shopee_policy` (returns and refunds through Shopee, the
  Shopee Guarantee, cancellations, payments inside Shopee) can't be removed; owners only add extras on top
  (`my_extra_policies`: warranty, exchanges, freebies…). An "extra" that takes something away becomes a hand-over.
- **Draft replies on the dashboard.** Each waiting chat or review reply opens to show the buyer's message (phone
  numbers and emails masked), the draft, a check against their rules (outside apps and links, delivery-day promises,
  never-say words, "original" claims, gifts for reviews, length, greeting) and Copy buttons for "YES to C4" /
  "change C4: …" / "NO to C4". The page never sends anything.
- **Progress with badges.** `dashboard/progress.html` (opened in Module 1) polls `data.js` every 4 seconds and
  celebrates each new badge with confetti; the chat shows a progress card at every gate. Bonus badges: Shop
  Scanner, First YES, Power User.
- **Shop Scan (Module 2).** With the owner's OK, three background helper trips read sales, orders, the top
  products in detail, stock, ads, reviews, chat settings and up to 10 past (already read) chats of their own shop, then write
  `rules/shop-profile.md`. The interview still runs; the scan lets Claude confirm instead of ask, and use real
  buyer questions and the shop's own answers for the FAQ.
- **Real stock speed.** Shopee's My Inventory rounds sales averages up to whole numbers (anything that sold shows at
  least "1 a day"), which made reorder amounts far too high in a real run. The stock check now reads real units sold
  from Business Insights → Product → Performance once a week (`data/sales-speed/`), ignores Shopee's Days of Supply,
  and holds back reorder amounts if the speeds add up to more than twice what the shop really sells. Module 4 tells
  the owner what Shopee does and what we do about it.
- **Puzzle checks need a person.** Opening chats can make Shopee show a slide puzzle; Claude never touches it.
  Helpers reply `VERIFY`, the run stops safely, and the owner is told: a dashboard alert plus their choice from
  Module 6 (an email to their own address, or a Slack message). Those notices are the only messages Claude sends
  by itself.
- **Shopee know-how.** `knowledge/shopee-basics.md` (structure, what the numbers mean, timing, chat/ads/campaign/
  fee/listing rules, SG vs MY) is copied into every Shopee HQ. Each module names the section it uses; checks apply
  the rules (ads "still learning" for 7 days, chat Due Soon at 9h and no replies after 7 days, campaign price rules,
  shipping by the next working day, SG shops can't set their own return terms).
- **True profit, the calculator's way.** Module 8 and `tools/shopee-fees.json` follow Leap's takeaway calculator
  (fees matched to real SG and MY income statements): fees are worked out on the price after the shop's own
  voucher (a RM5 voucher costs about RM4), the transaction fee on what the buyer paid, MY's RM0.54 is taken out of
  the "Service Fee" line, SG seller shipping goes by parcel weight, and instalment, pre-order and campaign-day
  orders are kept out of the average. The owner adds packing or warehouse fees (with their tax), optional monthly
  running costs per order, and SG GST registration; each product gets a break-even ROAS and the most ads may cost
  per order. The daily profit check and campaign floors use the same numbers.
- **Optional extras.** `automations/extras.md` has 20 ready-made extras (slow movers, order-by dates, FAQ learner,
  review themes, ads stock guard, loss makers, month-end report, campaign stock cover, sample sorter, listing health,
  Friday weekly review…). Modules 4 and 6–12 offer theirs as a menu. Each rides on an existing check, so no new
  schedule or "Always allow".

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
- **Schedules on the day:** Modules 6–11 create their jobs (offsets from the owner's morning time: stock +0, ads +15,
  affiliates +25, profit +35, campaigns +45, chats +60, images Mondays +55) **without** a test run. Module 12 replaces
  them all with ONE task, "Shopee · Daily routine" (morning: every check in order, each in a fresh Sonnet helper,
  plus a summary; 15:xx: chats only), which gets the only "Always allow" besides Module 5's stock check. Attendees
  who leave before Module 12 should run Module 12 Steps 3–5 at home (or approve each job's first run).
- **A scheduled run needs the laptop on and Claude's browser open** (Seller Centre signed in). That is a stated
  requirement, not a bug: if the laptop is closed, that run waits and happens
  when Claude next opens. Attendees hear this in Modules 5 and 12.

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
