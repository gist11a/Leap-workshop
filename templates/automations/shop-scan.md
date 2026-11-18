# Recipe: Full Shop Scan (once, in the background, with the owner's OK)

- **id:** `shop-scan` · **topic:** `scan` · **changes the shop:** never (read only). Not a scheduled job.
- **When:** Module 2 offers it (owner says YES first). Afterwards, any time they say **"scan my shop"** (once a month
  is plenty).
- **Cost:** in the rehearsal the three parts took about 7 minutes and a large helper share of the allowance (roughly
  two modules' worth). If their Settings → Usage bar is already past half, offer the basics instead.
- **Why:** so Claude knows the shop from its real data (orders, ads, products, stock, reviews, past chats), not only
  from the interview. The interview still happens: the scan shows what the shop *does*, the questions say what the
  owner *wants*.
- **Saves:** `data/scan/<today>.json` (numbers) and `rules/shop-profile.md` (what Claude learned, in plain words).
- Replace `<HQ>` with the full Shopee HQ folder location, `<seller_centre>` and `<shop_name>` from `rules/shop.json`.

## How the boss runs it
Three helper trips, **one after another** (they share one browser), each a fresh helper so none gets too big for the
Claude allowance. Each: Agent tool, `model: "sonnet"`, `subagent_type: "general-purpose"`, prompt = the text of
`<HQ>/helpers/reader.md` + "Shop Scan part <n>" below. **Start it in the background** (if the Agent tool has a
`run_in_background` option, set it to true) and carry on talking with the owner. When you're told a part finished,
start the next part straight away, then carry on.

- **Nothing else uses the browser while the scan runs.** If a step needs the browser, say "My helper is finishing
  your shop scan. One minute," and wait for it to finish.
- A part replies `SIGNED_OUT` → stop the scan, ask the owner to sign in (Module 1 Step 6), then restart that part.
- A part replies `VERIFY` (Shopee showed a slide puzzle) → stop the scan. Show them the browser and say: "Shopee wants
  a quick check that you're a person. Please do the little puzzle in my browser yourself. Reply DONE after." Don't
  restart that part today: keep what it saved (opening many chats is what makes Shopee ask).
- A part fails or gets stuck → skip it, note "part <n> not read" in `rules/shop-profile.md`, go on.
- All three done → read `rules/shop-profile.md` (only that, not the day file), tell the owner what you learned
  (Module 2 says how), add `"shop-scan"` to `bonus` in `progress.json`, refresh.
- Every part: **read only, never type anything into a chat box, never press Reply, Send, Update, Delist, Edit or any
  switch.** No buyer names, phone numbers or addresses anywhere in the files: products, order numbers, numbers and
  patterns only.

## Shop Scan part 1 · Sales, orders, products and stock
> Seller Centre: `<seller_centre>`. Check "Current Shop" says `<shop_name>`; if not, stop and say `WRONG_SHOP`.
> Read each page with `get_page_text` (`max_chars` 6000 unless said otherwise). Text only: no screenshots here.
> 1. **Business Insights** `/datacenter/overview`. Open the **Data Period** picker (top of the page; scroll to it, it
>    may need a click on its words) and pick **Past 30 Days** (no OK button). Collect `sales_30d`, `orders_30d`,
>    `visitors_30d`, `conversion_30d` (percent as a number), `buyers_30d`, `sales_per_order_30d`.
>    It says **No Data** before Shopee loads the day (often until about 10am): then pick **Past 7 Days** and save
>    those as `sales_7d`, `orders_7d`, `visitors_7d`, `conversion_7d` instead. Still nothing: save `null`s and say so.
>    Never press Enable Now, Auto Top-up or anything else on this page.
> 2. **Home page** `/`: collect `to_ship`, `return_refund_cancel` (the "to do" numbers).
>    **My Orders** `/portal/sale/order`: from the first page (up to 20 orders) collect, per order: `products` (short
>    names), `items`, `total`, `courier`, `status`. The list shows buyer usernames: never save them. Never press Arrange
>    Shipment, Ship or Split Order.
> 3. **Product AI Optimiser** `/portal/product-ai-optimiser-v2` (it may move to a "to be improved" list; products
>    sorted by sales, 12 a page, with Item IDs). From page 1 collect the top 12: `product` (first 60 characters),
>    `item_id`, `sold` (the "Sales" column). It shows no price; that's fine.
> 4. **The 3 best sellers, in detail:** open `/portal/product/<item id>` for each (wait 3 seconds; `max_chars` 6000).
>    Prices, stock and weight sit in boxes the text doesn't show; take a price only from lines like "1 Box ~$40".
>    Collect `category`, `price_note` (any price lines shown, else null), `variations` (names), `has_video` (a video
>    length like "00:32" is shown), `description` (first 300 characters), and the facts a buyer asks about (size,
>    ingredients, how to use, expiry or shelf life, halal, origin, guarantees) as `facts`. If Shopee shows a
>    **wrong category** warning, note it as `category_warning: true`. **Never press Update, Delist, Save, Confirm,
>    Appeal or Adopt Suggestion; don't change any field.** Leaving the page may ask "Leave site?": choose Leave.
> 5. **My Inventory** `/portal/inventory`. Collect `live_skus`, `shopee_out_of_stock`, `shopee_low_stock` from the
>    top, then the first **2 pages** of rows (10 a page; `?page=2` works): `product`, `stock`, `l30d_avg`,
>    `days_of_supply`. Read as `<HQ>/automations/stock-check.md` step 2 explains, but watch for rows that show "-"
>    for Days of Supply, Threshold or Lead Time, or have no Location: then the numbers aren't 8 per row, so take
>    each product's numbers with `find` on its name instead. SKUs ending in another market's code (e.g. `_MY` on a
>    Singapore shop) are linked copies: list them under `other_market` and leave them out of the counts.
> Save `<HQ>/data/scan/<today>.json`: `{"read_at", "source_pages", "summary": {the numbers above},
> "items": [top 12 products: product, sold, stock (if seen)], "orders_sample": [...], "best_sellers": [the
> 3 detailed products], "note": "one plain line"}`.
> Then write `<HQ>/rules/shop-profile.md` with these sections, short plain lines, at most 40 lines in all:
> `# What I learned about <shop_name> (shop scan, <today>)`, `## The shop in numbers` (say which period),
> `## Best sellers`, `## Product facts` (one line per best seller: the facts a buyer asks about),
> `## Stock` (what's out or about to run out), `## Orders and delivery` (usual basket, couriers seen in the orders,
> cancellations that stand out).
> Reply in 5 lines: sales and orders (say the period), the top 3 products, anything odd.

## Shop Scan part 2 · Ads, reviews and chat numbers
> Seller Centre: `<seller_centre>`. Check "Current Shop" says `<shop_name>`. Text only (`get_page_text`); take a
> screenshot only if a number you need isn't in the text, at `scale: 0.4`.
> 1. **Shopee Ads** `/portal/marketing/pas/index`. If the period isn't **Past 1 week**, pick it. Collect the totals:
>    `ad_spend_7d` (shown as "Expense"), `ad_sales_7d`, `ad_roas_7d`. Then the table under it (separate ads, or for a
>    **GMV Max** shop ad, the products inside it): up to 10 rows with `name` (first 50 characters), `spend`, `sales`,
>    `roas`. The text lists **all names first, then the numbers row by row** (Impressions, Clicks, CTR, Expense,
>    Sales, Conversions, Items Sold, ROAS…). If the number of rows of numbers doesn't match the names, save the totals
>    only and say so: never guess which numbers belong to which name. Never touch a switch, budget, Top Up, Join
>    Now, Create, Apply Setting, Adopt Now, Rapid Boost or ROAS Protection.
> 2. **Review Management** `/portal/settings/shop/rating`. Collect `shop_rating` (and the period it covers) and the
>    count for each star. Stars per review aren't in the text, so use the **star filter**: pick **1 star**, read up
>    to 10 reviews that have text (`product`, `review` first 100 characters), then **2 star**, then **3 star**; then
>    **5 star** for up to 10 happy ones. Count bad (1–3 star) reviews still showing a **Reply** button as
>    `unreplied_bad`. Never press Reply.
> 3. **Chat Management** `/portal/chat-management`. Collect `chat_enquiries_30d`, `chat_response_rate` (number),
>    `response_time` (as shown). Don't press Start or Edit.
> Add these to `"summary"` in `<HQ>/data/scan/<today>.json` (keep what part 1 saved) and add `"ads_top"` and
> `"reviews_sample"`. Also save the three chat numbers, plus `couriers_seen` (the couriers in part 1's orders), under
> `"summary"` in `<HQ>/data/shop/<today>.json`.
> In `<HQ>/rules/shop-profile.md` add: `## Ads` (spend, sales per S$1/RM1, the biggest spender, anything wasting
> money), `## Reviews` (rating, what buyers praise, what they complain about, how many bad reviews have no reply).
> Reply in 5 lines.

## Shop Scan part 3 · Past chats
> Seller Centre: `<seller_centre>`. Open `<seller_centre>/webchat/conversations`. Wait 5 seconds.
> - **The chat list mixes every shop on this login.** First use the shop filter at the top of the list (it says
>   **All Shops**) and pick `<shop_name>` only. If you can't, read only rows whose shop label is `<shop_name>`.
>   Never read another shop's chats.
> - **Only open chats with no unread number** (the red badge), so nothing new is marked as read. Count the unread
>   badges before you start and again at the end; both numbers must match.
> - Skip rows that only say "The conversation has been automatically closed" with nothing else.
> - Open **at most 10** chats, newest first, waiting 3 seconds after each click (click on the row's words; if a
>   click by reference misses, click on the row's position on screen). Read with `get_page_text` (`max_chars`
>   12000: the chat list comes first, the open chat is at the end). Messages have no sender names: the shop's own
>   lines are usually the long, polite ones, and "Off-Work Auto-Reply" lines are automatic.
> - Note for each chat: the topic of the buyer's question (original/authentic, delivery time, size or variant, stock,
>   price or discount, how to use / expiry, return or refund, damaged or wrong item, other) and, if the shop answered,
>   how (one line, no names).
> - **If a verification puzzle appears** (a slider, "Verification", a picture to drag), stop at once, don't touch
>   it, save what you have, and reply `VERIFY`. Never type in the message box, never press Send, Restart
>   Conversation, Invite Order, Serving Mode or any switch.
> Then write, no buyer names or usernames anywhere:
> - in `"summary"` of `<HQ>/data/scan/<today>.json`: `chats_read`, `top_question_topics` (e.g.
>   `{"delivery time": 4, "halal": 2}`), `shop_answered_percent`, `unread_before`, `unread_after`;
> - in `<HQ>/rules/shop-profile.md`: `## What buyers ask most` (the questions in the buyers' own words, shortened,
>   with how often), `## How the shop replies now` (language, tone, emoji or not, greeting and sign-off, typical
>   length, any auto-reply), `## Answers the shop already gives` (up to 8 question → answer pairs from the shop's
>   real replies, cleaned of names), `## Complaints in chat` (themes only). With fewer than 5 real chats, say so
>   ("only 3 real chats: too few to rank") instead of ranking.
> Reply in 5 lines: chats read, the top questions, the shop's reply style, unread before/after.
