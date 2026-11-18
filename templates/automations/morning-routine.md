# Automation recipe: Daily routine (morning: everything in order · afternoon: chats)

- **id:** `morning-routine` · **changes the shop:** never. Every change still waits in `approvals.json`.
- **The only scheduled task after Module 11.** It runs twice a day: in the morning it runs every check in order and
  writes a summary; in the afternoon (any run that starts after 12:00) it runs only the chat and review check.
  On Mondays the morning run also does the weekly image check.
- One task means one browser user at a time and one "Always allow". Each check runs in its **own fresh helper**,
  so this conversation stays small (kind to the Claude allowance).
- Replace `<HQ>` with the full Shopee HQ folder location (it's written in `<HQ>/CLAUDE.md`).

## 1. Get ready (once)
Read `<HQ>/CLAUDE.md` and `<HQ>/automations.json` only. Don't read the recipes yourself: each helper reads its own.
"Today" = the date in the shop's timezone. Afternoon run = the local time is after 12:00.

## 2. Run the checks, one at a time
The list:
- **Morning run:** `stock-check`, `ads-check`, `affiliate-check`, `profit-check` (after ads and affiliates, so their
  numbers are in), `campaign-check`, `chat-review-check`, and on Mondays `image-check`.
- **Afternoon run:** `chat-review-check` only.

For each one, **only if** its entry in `automations.json` exists and its `status` is "on":
1. Start ONE helper: Agent tool, `model: "sonnet"`, `subagent_type: "general-purpose"`, with this prompt (filled in):
   > You are a scheduled run for the Shopee shop <shop_name>. Its Shopee HQ folder is <HQ>. Read <HQ>/CLAUDE.md
   > and <HQ>/helpers/reader.md, then follow <HQ>/automations/<id>.md **to its last step** as a scheduled run:
   > you read the Seller Centre pages yourself with the built-in browser, following every rule in reader.md.
   > <For image-check add: "Do the weekly check only.">
   > Read only: never change anything in the shop, never type a password or code, never run JavaScript.
   > Reply in at most 3 lines; start with SIGNED_OUT if Seller Centre asked for a login.
2. **Wait for it to finish** before starting the next one (they share one browser).
3. If it replied `SIGNED_OUT`: make sure there is one urgent alert "Seller Centre is signed out. Please sign in in
   Claude's browser.", add `{"time", "automation": "Daily routine", "result": "skipped: signed out"}` to
   `data/runs/<today>.json`, run the refresh step, and **stop the whole routine**.
4. If it failed or got stuck: add `{"time", "automation": "<name>", "result": "failed: <reason in a few words>"}` to
   `data/runs/<today>.json` and go on with the next check.

## 3. The morning summary (morning run only)
After the last check, read today's day files that the checks wrote (only their `summary` and `note`) and
`approvals.json` (count `waiting`). Write **five lines at most**, in the owner's style (`rules/shop.json` →
`how_to_talk_to_me`), most important first, leading with the number that matches their `main_goal`. Example:
```
Good morning! Yesterday: RM1,284 sales, about RM221 profit (17%).
Order today: Kopi O Drip Bag (144) · Hazelnut is out of stock.
Ads: RM51 wasted on 2 ads, pause suggested (waiting for your YES).
Shopee wants a price confirm for December Campaign Pacing (about 23 Nov).
4 chat replies ready. Say "what needs my YES?" in Claude.
```
- Save it as an `info` alert dated today with `topic` "morning" (replace any earlier one from today).
- If `rules/shop.json` has `morning_email: true` and an `alert_email`: create a **draft** email in Gmail to that
  address, subject "Shopee morning · <date>", body = the summary + "Open your dashboard for details." Never send it.
  (Gmail not connected: skip silently.)

## 4. Finish (every run)
1. Add `{"time", "automation": "Daily routine", "result": "<first summary line, or 'afternoon: <chat note>'>",
   "alerts": <alerts added today>, "approvals": <waiting>}` to `data/runs/<today>.json`.
2. Set `last_run` / `last_result` on `morning-routine` in `automations.json`.
3. `bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"`.
4. End with the summary (morning) or the chat helper's reply (afternoon) as your last message.
