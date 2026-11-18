# Automation recipe: Campaign check

- **id:** `campaign-check` · **topic:** `campaigns` · **changes the shop:** never. Claude never nominates or
  confirms; the owner presses those buttons.
- **Saves:** `data/campaigns/<today>.json`, alerts, the run log.
- Replace `<HQ>` with the full Shopee HQ folder location (it's written in `<HQ>/CLAUDE.md`).

## 1. Get ready
Read `<HQ>/CLAUDE.md`, `rules/shop.json`, `rules/campaigns.json`. "Today" = the date in the shop's timezone.

## 2. Read the campaign list
**Who reads:** in a live chat with the owner (Opus), send ONE helper (Agent tool, `model: "sonnet"`,
`subagent_type: "general-purpose"`, prompt = the text of `<HQ>/helpers/reader.md` + the job below).
In a scheduled run you are already on Sonnet: read the page yourself, following every rule in `helpers/reader.md`.

The job:
> Open `<seller_centre>/portal/marketing/cmt/campaign`. Wait 5 seconds. Check the shop is `<shop_name>`.
> **Never click Nominate Now, Go To Confirm, View Details, Join or anything inside a campaign.** You may click the
> tabs at the top and the page numbers only.
> 1. From the tab names collect the counts: `available`, `invited`, `pending_confirmation`, `nominated`.
> 2. On **Available Campaign**, read every page (`get_page_text`, `max_chars` 6000). For each campaign collect
>    `type` (the line above the name, e.g. Big Campaign, Voucher Campaign, Shopee Flash Sale, Live Stream),
>    `campaign` (the name), `runs` (the "Campaign:" dates), `nomination_ends` (the "Earliest nomination ends in …"
>    words, exactly), `pending_confirmation` and `nominated` (the numbers on the card), and `button` (the button
>    text: "Nominate Now", "Go To Confirm" or "View Details").
> Save to `<HQ>/data/campaigns/<today>.json` as `{"read_at", "source_pages", "summary": {…the counts},
> "found": [...]}`. Reply with the number of campaigns only.

`SIGNED_OUT`: live chat → ask the owner to sign in; scheduled run → urgent alert "Seller Centre is signed out.
Please sign in in Claude's browser.", log "skipped: signed out", refresh, stop.

## 3. Work it out (you do this)
For each campaign in `found`:
- **Deadline:** turn `nomination_ends` into a date and time from `read_at` ("16 hours 52 minutes" → read time +
  16 h 52 min; "less than 5 days" → read date + 5 days, and mark it "about"). Save `deadline` as
  "20 Nov 14:20" or "about 23 Nov".
- **Fits their rules?** `type` is in `join_types` and the name isn't in `never_join`.
- **status:**
  - "Confirm price" if `button` is "Go To Confirm" or `pending_confirmation` > 0 (Shopee is waiting for them to
    accept a price: check it against the floor before they accept).
  - "Deadline soon" if it fits and the deadline is within `prepare_days_before_deadline` days.
  - "Nominated" if `nominated` > 0 and nothing is pending.
  - "Open" if it fits; "Not for you" if it doesn't.

Write the day file again with `summary` (`open_to_join` = campaigns that fit, `deadlines_this_week` = fitting ones
with a deadline within 7 days, `pending_confirmation`, `nominated`), `items` (campaigns that fit, plus any with
"Confirm price": `campaign`, `type`, `deadline`, `status`; sorted Confirm price → Deadline soon → Open → Nominated,
then by deadline), and a one-line `note`, e.g. "3 campaigns close in the next 2 days. 2 price offers wait for
your confirm."

## 4. Alerts
First remove alerts with `topic` "campaigns" dated today. Then add:
- `urgent` for each "Confirm price" campaign: "Shopee is waiting for you to confirm prices for '<campaign>'
  (deadline <deadline>). Ask me to check them against your price floor first."
- `watch` for each "Deadline soon": "'<campaign>' closes <deadline>. Want me to check which products fit?"
Keep at most 5 campaign alerts.

## 5. Finish
1. Add to `data/runs/<today>.json`: `{"time", "automation": "Campaign check", "result": "<note>", "alerts": <n>,
   "approvals": 0}`.
2. Update this automation's `last_run` and `last_result` in `automations.json`.
3. `bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"`.
4. Live chat: show it as in Module 8. Scheduled run: end with three lines, e.g.
   "2 price offers to confirm · 20 Nov BTO Sale closes today 14:20 · 6 campaigns open for you."

## Checking prices for one campaign (live chat only, when the owner asks)
1. Ask the owner to click **Nominate Now** (or **Go To Confirm**) on that campaign in Claude's browser and reply DONE.
   Don't fill anything in.
2. Send ONE helper with `reader.md` + this job: "Use `tabs_context` and read the newest Seller Centre tab (the page
   the owner just opened). Collect the campaign's requirements (minimum discount, maximum price, stock rules,
   sessions/time slots) and, for every product shown (up to 30), `product`, `variation`, `current_price`,
   `suggested_price` (Shopee's recommended or proposed campaign price, if shown), `campaign_stock` if shown.
   Click nothing on this page except tabs or page numbers. Save to `<HQ>/data/campaign-check-<campaign short>.json`."
3. Compare each product with `rules/campaigns.json` → `price_floor`: the floor is the higher of `lowest_prices`
   and `owner_lowest_prices` for that product. Products with no floor: work it out from `rules/costs.json`
   (as in Module 8) or say "no cost yet".
4. Show ✓ (at or above the floor, with the margin it leaves) / ✗ (below: "lowest you can go RM<floor>") /
   ? (no cost). Then guide the owner, one step at a time, while they nominate or confirm the ✓ ones themselves.
