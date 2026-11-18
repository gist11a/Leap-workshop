# Module 4 · Stock and reorders (about 35 minutes)

**They get:** a list of what to reorder and how many, worked out from their real sales, plus a supplier message
ready to send.
**Files touched:** `rules/stock.json`, `automations.json`, `data/stock/<today>.json`, `alerts.json`.
The recipe `automations/stock-check.md` is already in their folder (copied in Module 1). Read it now: you follow
it in Step 4, and in Module 5 it runs by itself every morning.
**Gate at the end:** `module5`.

Follow START.md's rules: short messages, lettered menus, one question at a time, no tech words.

---

## Step 1 · Open the module (one message)

Card:
```
MODULE 4 OF 12 · STOCK AND REORDERS
──────────────────────────────────
YOU GET: what to reorder, and how many
```

Say, short:
- "Running out costs twice: you lose the sales, and Shopee shows your product less afterwards."
- "Ordering too much costs too: your cash sits in boxes."
- "Shopee already counts how fast each product sells. I'll read that, do the maths, and tell you what to order."
- "Reply YES when you're ready."

## Step 2 · Your stock rules (three quick menus → `rules/stock.json`)

If `rules/my-shop-info.md` has restock times or suppliers, use them and skip those questions
("You told me your supplier takes 10 days, so I'll use that.").

1. "How long does new stock take to reach you after you order?"
   ```
   A) 3 days or less
   B) About a week ★
   C) About two weeks
   D) A month or more (overseas)
   E) It depends on the product — tell me
   ```
   Save `supplier_lead_days` (3, 7, 14, 30). E → ask for the main supplier's time and note the others in
   `suppliers` (`{"name", "products", "lead_days", "how_to_order"}`).
   First answer: add "(Or just say YES and I'll use sensible defaults.)" YES → defaults ★ for all three.
2. "When should I warn you? When a product has less than…"
   ```
   A) 1 week of stock left
   B) 2 weeks left ★
   C) 3 weeks left
   ```
   Save `alert_when_days_left_below` (7, 14, 21). If it's shorter than the lead time, nudge: "Your supplier takes
   <lead> days, so warning at <alert> days is too late. Shall I use <lead + 7>?"
3. "When you reorder, how much stock do you like to buy?"
   ```
   A) Enough for 2 weeks (less cash tied up)
   B) Enough for a month ★
   C) Enough for 2 months (fewer orders)
   ```
   Save `reorder_to_cover_days` (14, 30, 60).

## Step 3 · Add it to your automations list

Add to `automations.json` (if it isn't there yet):
`{"id": "stock-check", "name": "Morning stock check", "when": "By hand for now, runs by itself after Module 5",
"status": "paused", "recipe": "automations/stock-check.md", "last_run": null, "last_result": null}`

Say: "I've written your first automation: the morning stock check. Let's run it once by hand."

## Step 4 · Run it now

0. If the Shop Scan from Module 2 is still running, wait for it first ("My helper is finishing your shop scan. One
   minute."), then show its "What I learned" card (Module 2 Step 5).
1. Say: "Sending my helper to read your **My Inventory** page. If you have lots of products this takes 2 or 3
   minutes. It only reads, it doesn't change anything."
2. Follow `automations/stock-check.md` steps 2 to 5 exactly (you're in a live chat, so use a helper for step 2).
3. While you wait, one line: "While it reads: Shopee works out 'days of supply' for each product. I check it
   against your rules, and add how many to order."

## Step 5 · Show the result, then check it with them

1. A short card, in their reporting style. Up to 5 products, most urgent first:
   ```
   STOCK CHECK · 19 NOV
   ──────────────────────────────────
   ORDER NOW
   • Kopi O Drip Bag x10: 12 left, about 3 days. Order 144.
   • Hazelnut Blend 250g: out of stock. Order 52.
   ORDER THIS WEEK
   • Robusta Beans 500g: about 10 days left. Order 85.
   Checked 46 products · 43 are fine
   ```
   (EXAMPLE numbers. Use theirs. Nothing flagged? "Good news: nothing runs out in the next <alert> days.")
2. "Does that match what you know?"
   ```
   A) Yes, looks right
   B) One of these is wrong — tell me which
   C) Some products come from a slower or faster supplier
   D) Some of these I've stopped selling
   E) Something else — tell me
   ```
   - B → ask why in a menu: "already ordered, it's on the way" (note it in `notes` with today's date; no change to
     rules), "sales were a one-off (campaign)", "the stock number is wrong in Shopee" ("Update it in Shopee when
     you can; I'll pick it up tomorrow").
   - C → add a supplier with its own `lead_days` and its products; re-work just those lines.
   - D → add to `ignore_products`.
   Fix the rule, re-work the numbers from the saved day file (**don't send the helper again**), show the updated card.
3. Hero products: "Which products must **never** run out? Pick up to five." Menu of their 8 best sellers by
   7-day sales average (`l7d` in `all_products`; `l30d` if that's 0), several letters allowed, last option "None for now".
   Save to `hero_products`. "These always show on your dashboard, and I flag them as urgent."

## Step 6 · A message for your supplier (the payoff)

"Want me to write the order message for your supplier?"
```
A) Yes, a WhatsApp or chat message I can copy ★
B) Yes, as a draft email in my Gmail
C) Not now
```
- A → one short, polite message in their tone with the Order now and Order soon products and quantities
  (product name, variation, quantity), and "Please confirm the delivery date." In a code block so it's easy to copy.
  Group by supplier if `suppliers` has more than one.
- B → ask the supplier's email (or use `how_to_order`), then create a **draft** in Gmail with the Gmail connector.
  Never send. Gmail not connected? "Gmail isn't connected, so here it is to copy instead" and do A. "It's in your Gmail drafts. Check it and press send yourself."
- Say: "From tomorrow this list is ready every morning. You just forward it."

## Step 7 · See it on the dashboard

"Press **Cmd+R** / **Ctrl+R** on your dashboard. Your stock card and the **Low on stock** box are live now."
If they look: "The red alerts at the top are the ones to act on today."

## Optional extras (2 minutes, skip if short on time)

Ready-made extras from `<HQ>/automations/extras.md`. They ride along with the stock check, so there's nothing new to
schedule or approve, and most cost almost no allowance. Read only that file's "How it works" and this module's part.

1. "Want any extras? They run with your stock check. Pick any, e.g. **A C**, or none."
   ```
   A) Slow movers            Mondays: products that haven't sold in 30 days, and the cash stuck in them
   B) Out of stock too long  every day: anything at zero for 7+ days
   C) Order-by dates         every day: "order X by Friday", using your supplier's delivery time
   D) None for now ★
   E) Something else — tell me
   ```
2. Switch on each pick as "How it works" says (A = `slow-movers`, B = `stuck-out-of-stock`, C = `order-by-date`). Ask only the setting a pick needs.
3. "Switched on. You can add or remove extras any time: just say **show my extras**."

## Step 8 · Close the module

1. Update `<HQ>/CLAUDE.md`: "Where we are: Module 4 done · next: module5". Under "The shop": one line, e.g.
   "Supplier lead time 7 days · reorder for 30 days · heroes: Kopi O Drip Bag, Robusta 500g".
2. Say:
   - "Done: you know what to reorder, and you have the message for your supplier."
   - Value line: "That's an hour of spreadsheet work, every week, and one less stock-out."
   - "Quick check: Settings → Usage. If the bar is past about 70%, tell me."
   - Gate: "That's 4 of 12 done. Next is the big one: we make this check run **by itself** every morning,
     before you sit down. Type **module5** when you're ready."

## If things go wrong

- **No "My Inventory" in their menu,** or no sales averages: read **My Products** instead
  (`/portal/product/list/live/all`, stock only). Ask: "Which 5 products sell fastest, and about how many a day?"
  Use their numbers as `sold_per_day` for those, and tell them: "Shopee didn't give me sales speed, so I'm using
  your numbers. Tomorrow's check will be better once Shopee shows it."
- **Hundreds of products (more than 20 pages):** read the first 20 pages, plus the **Low Stock** and
  **Out of Stock** tabs, and say "You have a big shop, so I checked the busy and low products first."
- **The numbers don't line up** (the helper matched a number to the wrong product): ask the helper to re-read
  that one page using `find` with the product name, then fix the row. If a number still looks odd, show it with
  "Shopee shows X. Does that look right to you?"
- **The helper takes too long:** it's reading page by page. Keep talking: explain Step 6 while it works.
- **They ask Claude to restock or change stock in Shopee:** "Not today. I only read stock. Changing stock in Shopee
  stays with you, so nothing goes wrong by accident."
