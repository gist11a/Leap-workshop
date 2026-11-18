# Automation recipe: Morning routine (everything, one after another)

- **id:** `morning-routine` · **changes the shop:** never. Every change still waits in `approvals.json`.
- One scheduled job instead of five: one browser, one start-up, so it's kinder to the Claude allowance and the
  jobs never fight over the browser.
- Replace `<HQ>` with the full Shopee HQ folder location (it's written in `<HQ>/CLAUDE.md`).

## 1. Get ready (once)
Read `<HQ>/CLAUDE.md` and `<HQ>/automations.json`. "Today" = the date in the shop's timezone.
Read each recipe below **only when you reach it**, so the run stays small.

## 2. Run the morning checks, in this order
For each one, do it **only if** its entry in `automations.json` exists and its `status` is "on". Follow that
recipe's steps 1 to 5 exactly, as a **scheduled run** (you read the pages yourself; no helper).
1. `automations/stock-check.md`
2. `automations/ads-check.md`
3. `automations/affiliate-check.md` (it does the commission check itself on Mondays)
4. `automations/profit-check.md` (after ads and affiliates, so their numbers are in)
5. `automations/campaign-check.md`
6. `automations/chat-review-check.md` (morning drafts; the afternoon check has its own schedule)

Rules for the whole run:
- **Signed out at any step:** add the one urgent "Seller Centre is signed out" alert, log "skipped: signed out",
  refresh the dashboard, and **stop the whole routine** (don't try the other checks).
- **One check fails** (a page doesn't load after one retry, numbers don't line up): log that check as "failed:
  <reason>" in `data/runs/<today>.json`, keep going with the next one.
- Each check refreshes the dashboard at its end; that's fine (it's quick and costs no allowance).
- Use one browser tab. Don't open other sites.

## 3. The morning summary
After the last check, write **five lines at most**, in the owner's style (`rules/shop.json` → `how_to_talk_to_me`),
most important first, using only what the checks saved today. Lead with the number that matches their
`main_goal`. Example:
```
Good morning! Yesterday: RM1,284 sales, about RM221 profit (17%).
Order today: Kopi O Drip Bag (144) · Hazelnut is out of stock.
Ads: RM31 wasted on 2 ads, pause suggested (waiting for your YES).
Shopee wants a price confirm for December Campaign Pacing (about 23 Nov).
4 chat replies ready. Say "what needs my YES?" in Claude.
```
- Save it as an `info` alert dated today with `topic` "morning" (replace any earlier one from today).
- Add to `data/runs/<today>.json`: `{"time", "automation": "Morning routine", "result": "<first line>",
  "alerts": <total today>, "approvals": <total waiting>}`, and set `last_run` / `last_result` on `morning-routine`
  in `automations.json`.
- If `rules/shop.json` has `morning_email: true` and an `alert_email`: create a **draft** email in Gmail to that
  address, subject "Shopee morning · <date>", body = the summary + "Open your dashboard for details." Never send it.
  (No Gmail connected: skip silently.)
- End the run with the summary as your last message.
