# Module 12 · Your daily routine + finale (about 40 minutes)

**They get:** one morning routine that runs every check in order, a morning summary (on the dashboard, and as a
Gmail draft if they want), a 5-minute daily checklist, and a clear picture of everything they built today.
**Files touched:** `automations.json`, `rules/shop.json`, `dashboard/layout.json` (a sticky note),
`MY-ROUTINE.md` (new, in their Shopee HQ), `<HQ>/CLAUDE.md`.
The recipe `automations/morning-routine.md` is already in their folder. Read it now.
**This is the last module.** Only say the day is finished at the end of Step 7.

Follow START.md's rules: short messages, lettered menus, one question at a time, no tech words.

---

## Step 1 · Open the module (one message)

Card:
```
MODULE 12 OF 12 · YOUR DAILY ROUTINE
──────────────────────────────────
YOU GET: one morning routine, and a shop that checks itself
```

Say, short:
- "Today you built up to seven checks, each with its own time. Let's make it one tidy routine."
- "Every morning I run them one after another: stock, ads, affiliates, profit, campaigns, then chats. Then I
  write you a five-line summary. At 3pm I check chats again."
- "One routine instead of several saves your Claude allowance, and the checks never get in each other's way."
- "Reply YES when you're ready."

## Step 2 · What you have (one card, from `automations.json`)

List every automation with a plain status, e.g. (EXAMPLE):
```
YOUR AUTOMATIONS
──────────────────────────────────
✓ Morning stock check      every day 9:00
✓ Ads check                every day 9:15
✓ Affiliate check          every day 9:25
✓ Profit check             every day 9:35
✓ Campaign check           every day 9:45
✓ Chat and review check    every day 10:00
✓ Image check              Mondays 9:55
○ (anything they skipped: "not set up, you can add it any time")
```

## Step 3 · Build the morning routine

1. "What time should your summary be ready?" (default `morning_check_at`; A) keep <time> ★ B) earlier C) later).
   The routine takes about 10 to 20 minutes, so **schedule it to start 20 minutes before the time they give**
   (ready at 9:00 → starts 8:40). Tell them: "I'll start at 8:40 so it's ready by 9:00."
2. "Which days?" A) Every day ★ B) Monday to Friday.
3. Follow "How to schedule an automation" in `<HQ>/CLAUDE.md` for `morning-routine`: `taskId`
   `shopee-morning-routine`, `title` "Shopee · Daily routine", description "Morning: stock, ads, affiliates,
   profit, campaigns and chats in order, plus a summary. Afternoon: chats." The cron runs at the start time **and
   at 15:<same minute>** (start 8:40 → `40 8,15 * * *`; weekdays → `40 8,15 * * 1-5`). The afternoon run does
   chats only (the recipe knows).
4. **Switch off every separate schedule** it replaces, so only this one task is left: for each of
   `shopee-stock-check`, `shopee-ads-check`, `shopee-affiliate-check`, `shopee-profit-check`,
   `shopee-campaign-check`, `shopee-chat-review-check`, `shopee-image-check` that exists,
   `update_scheduled_task` with `enabled: false`. In `automations.json` keep their `status` "on" (the routine runs
   only those that are "on"), set `schedule_id` to "shopee-morning-routine" and `when` to "In the daily routine"
   (chats: "In the daily routine, morning and 3pm"; images: "In the daily routine, Mondays").
5. Add `{"id": "morning-routine", "name": "Daily routine", "when": "<days> at <start time> and 3pm", "status": "on",
   "schedule_id": "shopee-morning-routine", "recipe": "automations/morning-routine.md", "last_run": null,
   "last_result": null}`.
6. Say: "Done: one routine, every morning (ready by <time>) and a chat check at 3pm. You can still ask me for any
   single check any time, like 'check my stock now'."

## Step 4 · The morning summary by email (optional)

1. "Want the morning summary in your Gmail too? I'll put it in your **drafts**, so you can read it on your phone.
   I never send it."
   ```
   A) Yes, as a Gmail draft ★
   B) No, the dashboard is enough
   ```
2. A → use `alert_email` if Module 2 saved one, else ask for it. Set `morning_email: true` in `rules/shop.json`.
   If Gmail isn't connected in their Claude: "Gmail isn't connected, so I'll skip this. You can connect it later in
   Settings → Connectors and tell me 'turn on my morning email'." Leave it false.

## Optional extras (2 minutes, skip if short on time)

Ready-made extras from `<HQ>/automations/extras.md`. They ride along with the daily routine, so there's nothing new to
schedule or approve, and most cost almost no allowance. Read only that file's "How it works" and this module's part.

1. "Want any extras? They run with your daily routine. Pick any, e.g. **A C**, or none."
   ```
   A) Friday weekly review  Fridays: your week in six lines (and a Gmail draft if you like)
   B) Monday top three      Mondays: the three things that matter most this week
   C) None for now ★
   D) Something else — tell me
   ```
2. Switch on each pick as "How it works" says (A = `weekly-review`, B = `monday-plan`). Ask only the setting a pick needs.
3. "Switched on. You can add or remove extras any time: just say **show my extras**."

## Step 5 · First run, together

1. "Let's run the whole routine once now, so you can see it and give it permission."
   Start it with `run_scheduled_task` (`taskId` "shopee-morning-routine"). (If it's after 12:00 the routine does
   only chats: tell them "This afternoon it only checks chats. Tomorrow morning it does everything." If they want to
   see the full morning run now, that's fine too: tell the routine in its chat "do the morning run now".)
2. Same as Module 5: a new chat **Shopee · Daily routine** appears in the left sidebar; they click it and choose
   **Always allow** for anything that reads or saves in Shopee HQ, the browser, the refresh step, and (if they chose
   it) creating a Gmail draft. **Deny** anything that would send, delete or pay.
3. While it runs (10–20 minutes), do Step 6 with them in this chat. Don't use the browser yourself meanwhile.
4. When they say it's finished, check `list_task_runs` (limit 1), then show its summary (from today's "morning"
   alert) as the routine wrote it. "That's what you'll see every morning."
5. Allowance check: "Look at Settings → Usage now and remember the number. Tomorrow after the routine, look again.
   If one morning uses more than about 5% of your **weekly** limit, tell me and we'll run it on weekdays only, or
   drop a check you don't need." Note this in `MY-ROUTINE.md`.

## Step 6 · Your 5-minute daily checklist (interactive)

1. "Last thing: your routine, on paper. Pick what you'll actually do."
   ```
   EVERY MORNING (5 minutes)
   A) Open my dashboard and read the summary ★
   B) Type "what needs my YES?" in Claude and approve replies ★
   C) Act on red alerts (stock to order, ads, price confirms) ★
   EVERY WEEK
   D) Monday: add selling points for 2 products
   E) Friday: tell Claude about new products and their costs
   EVERY MONTH
   F) Check Shopee's fees with Claude ("check my fees again")
   G) Update product costs if my supplier changed prices
   ```
   They pick letters (A B C are recommended for everyone).
2. Write `<HQ>/MY-ROUTINE.md`: a short, friendly page with their picks as a checklist, their automation times,
   the five magic phrases, and who to ask for help:
   - **what needs my YES?** · **refresh my dashboard** · **check my stock now** · **pause my automations** ·
     **resume my automations**
   - Help: "Your Leap trainer, or scale@leapecommerce.com".
3. Add a sticky note to `dashboard/layout.json` → `notes`: `{"title": "Every morning", "text": "Read the summary ·
   'what needs my YES?' · act on red alerts"}` and refresh. "Press Cmd+R / Ctrl+R: your routine is on your
   dashboard now."

## Step 7 · The finale

1. A closing card, built from their real files (EXAMPLE):
   ```
   ✓ SHOPEE HQ · KOPI & CO
   ──────────────────────────────────
   Built today by Aisha, with Claude
   7 checks running · every morning at 9:00
   Rules: your voice, your promises, your price floors
   Your shop, on one page: your dashboard
   Nothing changes in your shop without your YES
   ```
2. Say, warmly and briefly:
   - "This morning your shop needed you to check everything. From tomorrow, it checks itself and tells you what
     matters."
   - "Everything lives in your Shopee HQ folder on this laptop. It's yours. Nothing was sent to Leap."
   - "Remember the one rule: laptop on, Claude open, my browser on Seller Centre. If Shopee signs you out, the red
     alert tells you."
   - "Want to change anything later? Just open Claude in your Shopee HQ and tell me in plain words."
3. Feedback (optional, quick): "One last thing: how was today, from 1 to 5, and one thing to improve? I'll write it
   as a draft email to the Leap team, and you choose whether to send it." Draft to scale@leapecommerce.com only if
   they want and Gmail is connected; otherwise "Tell your trainer. They'd love to hear it."
4. Update `<HQ>/CLAUDE.md`: "Where we are: Workshop complete (12 of 12) · daily routine at <time>."
5. Last line: "That's 12 of 12. Congratulations, <name>! 🎉 Close the laptop lid only after you've seen tomorrow's
   summary run once; then you'll know it works."

## If things go wrong

- **The routine run takes very long or stops halfway:** look at its chat with them; most often one page was slow.
  The routine logs that check as failed and carries on. If it stopped completely, check the browser is open and
  signed in, then `run_scheduled_task` again.
- **They skipped some modules:** the routine only runs checks whose `status` is "on"; that's fine. Tell them which
  ones they can add later ("module7 any time sets up the ads check").
- **Allowance almost used up now:** skip the first run (Step 5); tell them it will run tomorrow at <time> and to check
  the dashboard after.
- **They want the old separate schedules back:** re-enable them with `update_scheduled_task` (`enabled: true`) and
  pause the routine. One or the other, never both.
- **Leaving the laptop off at night is a must for them:** pick a summary time after they usually open the laptop;
  missed runs happen when Claude opens.
