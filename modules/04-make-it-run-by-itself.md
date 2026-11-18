# Module 4 · Make it run by itself (about 25 minutes)

**They get:** the morning stock check running every day on their laptop, without them asking.
**This is the day's promise:** "at least one automation running on your own store". Make the moment land.
**Files touched:** `automations.json`, `<HQ>/CLAUDE.md`. One scheduled task in their Claude app.
**Gate at the end:** lunch, then `module5`.

Follow START.md's rules: short messages, lettered menus, one question at a time, no tech words.
The steps for scheduling are in `<HQ>/CLAUDE.md` → "How to schedule an automation". Follow them exactly.

---

## Step 1 · Open the module (one message)

Card:
```
MODULE 4 OF 11 · MAKE IT RUN BY ITSELF
──────────────────────────────────
YOU GET: your stock check, every morning, without you
```

Say, short:
- "Right now I only work when you ask. Let's change that."
- "Claude has a built-in alarm clock. At the time you choose, it opens a fresh Claude, which reads the recipe we
  wrote in Module 3 and does the stock check. Your dashboard is up to date before you sit down."
- "Reply YES when you're ready."

## Step 2 · The two things it needs (say them plainly, then pause)

- "**One: your laptop on, with Claude open, and my browser open on Seller Centre.** The alarm clock lives on
  your laptop. If the laptop is closed at 9am, the check runs the next time you open Claude."
- "**Two: a cheaper helper does the daily work,** so it hardly uses your Claude allowance."
- "Reply YES and we'll pick the time."

## Step 3 · When (two menus)

1. "You told me you like your morning check ready by **<morning_check_at>**. Keep that?"
   ```
   A) Yes ★
   B) Earlier — tell me the time
   C) Later — tell me the time
   ```
   (No `morning_check_at` yet? Ask: "What time should it be ready?" with A) 8:00 B) 9:00 ★ C) 10:00.)
   Tip, if they pick a time before they usually open the laptop: "Pick a time when the laptop is usually on.
   If it's closed, the check waits until you open Claude."
2. "Which days?"
   ```
   A) Every day ★ (buyers shop on weekends too)
   B) Monday to Friday
   C) Something else — tell me
   ```
Save `morning_check_at` in `rules/shop.json`.

## Step 4 · Set the alarm

1. Follow "How to schedule an automation" in `<HQ>/CLAUDE.md` for `stock-check`:
   - `taskId` `shopee-stock-check`, `title` "Shopee · Morning stock check",
     `description` "Reads My Inventory, flags what to reorder, updates the Shopee HQ dashboard".
   - `cronExpression` from their answers: every day 9:00 → `0 9 * * *`; Monday to Friday 9:00 → `0 9 * * 1-5`;
     8:30 → `30 8 * * *`.
   - The prompt from CLAUDE.md with every `<…>` filled in (full folder location, never `~`).
2. Update the `stock-check` entry in `automations.json`: `status` "on", `when` in plain words ("Every day at
   9:00am"), `schedule_id` "shopee-stock-check".
3. Say: "It's set. Every morning at <time>, your stock check runs by itself."

## Step 5 · Watch it run once (the first run asks permission)

1. Say:
   - "Let's run it once now, so you can see it work and give it permission."
   - "A new chat called **Shopee · Morning stock check** will appear in the left sidebar. Click on it."
   - "It will ask a few times if it may do something: read your Shopee HQ folder, use my browser, run the
     refresh step. Each time, click **Always allow**. That's only this first time; tomorrow it runs without asking."
   - "When it says it's finished, come back to this chat and reply **DONE**."
2. Start it with `run_scheduled_task` (`taskId` "shopee-stock-check").
3. If they ask what to allow: anything that reads or saves in the Shopee HQ folder, the browser, and the
   refresh step = Always allow. If it ever asks to **send, delete, or pay** for anything: click **Deny** and tell
   a trainer. (This job never needs that.)

## Step 6 · Check it worked

After DONE:
1. Check with `list_task_runs` (`taskId` "shopee-stock-check", `limit` 1).
   - `succeeded` → read today's `data/runs/<today>.json`: there should be a new "Morning stock check" line.
   - `failed` or still `running` → see "If things go wrong".
2. Say, warmly, and make it a moment:
   ```
   ✓ YOUR FIRST AUTOMATION IS RUNNING
   ──────────────────────────────────
   Morning stock check · every day at 9:00am
   Last run: just now · <its result, e.g. 2 to order today>
   ```
   "That's the promise of today kept: an automation running on **your** shop. Everything after lunch builds on this."
3. "Press **Cmd+R** / **Ctrl+R** on your dashboard. Under **Automations** it now says **On**."

## Step 7 · Three habits (one message)

- "**Leave the laptop on** when you can, plugged in. In Claude, **Settings → Desktop app → General → Keep
  computer awake** helps (we switched it on before today; check it's still on)."
- "**Keep Claude and my browser open** on Seller Centre. If Shopee signs you out, the check stops and a red
  alert on the dashboard tells you to sign in again."
- "**To stop everything,** just tell me **pause my automations**. **resume my automations** turns them back on."

## Step 8 · Close the module (and lunch)

1. Update `<HQ>/CLAUDE.md`: "Where we are: Module 4 done · next: module5". Under "The shop": "Morning stock check
   runs every day at <time>."
2. Say:
   - "Done: your first automation runs by itself."
   - Value line: "Someone checking stock every single morning, including weekends, for free."
   - "Quick check: Settings → Usage. Your allowance refills over lunch, so don't worry if it's high."
   - Gate: "That's 4 of 11 done. Enjoy lunch! After lunch: chats and reviews. Type **module5** when you're back."

## If things go wrong

- **No new chat appeared:** wait 20 seconds. Still nothing? Ask them to look in the left sidebar for the list of
  scheduled tasks, open **Shopee · Morning stock check**, and press **Run now**.
- **The run failed or got stuck asking for permission:** open the run's chat with them, read the last message in
  plain words, fix the cause, then run it again (`run_scheduled_task`). Common causes:
  - they clicked **Deny** by mistake → run again and choose **Always allow**;
  - the browser wasn't open → "Press Cmd+Shift+B (Mac) or Ctrl+Shift+B (Windows), then run again";
  - Seller Centre signed out → they sign in themselves, then run again.
- **Creating the schedule was refused, or the tool isn't there:** their Claude app may need an update. Have them
  create it by hand: in the left sidebar's scheduled tasks, add a new task, paste the prompt (you write it out for
  them in a code block), set the time, save, Run now. Wave a trainer over if stuck after 5 minutes.
- **The run used Opus:** that's fine; the prompt hands the work to a Sonnet helper. Don't change anything.
- **They want it twice a day:** fine. Use `0 9,15 * * *` (9am and 3pm) and say both times in `when`.
- **They want a different time later:** `update_scheduled_task` with a new `cronExpression`, and update `when`
  in `automations.json` and `morning_check_at`.
