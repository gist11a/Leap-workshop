# Automation recipe: Product image check

- **id:** `image-check` · **topic:** `images` · **changes the shop:** never. Claude scores photos and writes
  selling points; the owner uploads them in Shopee (Product AI Optimiser makes the poster images).
- **Saves:** `data/images/<today>.json`, alerts, the run log.
- Two depths: the **full check** (live, Module 11, or when the owner asks) looks at photos of the top 5 sellers.
  The **weekly check** (scheduled, Mondays) reads text only: how many products still lack selling points.
- Replace `<HQ>` with the full Shopee HQ folder location (it's written in `<HQ>/CLAUDE.md`).

## 1. Get ready
Read `<HQ>/CLAUDE.md`, `rules/shop.json`, `rules/chat.json` (tone), `rules/store.json` (promises: selling points
may only claim what's true). "Today" = the date in the shop's timezone.

## 2. Read
**Who reads:** in a live chat with the owner (Opus), send ONE helper (Agent tool, `model: "sonnet"`,
`subagent_type: "general-purpose"`, prompt = the text of `<HQ>/helpers/reader.md` + the job below).
In a scheduled run you are already on Sonnet: do the weekly check yourself, following `helpers/reader.md`.

**Weekly check (text only):**
> Open `<seller_centre>/portal/product-ai-optimiser-v2`. Wait 5 seconds. Collect `to_be_optimised` and
> `ai_optimised` (the two tab counts), and from the **To Be Optimised** list, the first 12 rows: `product`
> (first 60 characters), `item_id`, `sales`, `task` (e.g. "Upload Selling Points"). Never click Optimise, Upload,
> Settings or anything else except tabs and page numbers.

**Full check (adds photos):** the weekly check, then:
> For each of the **5 best-selling products** (the highest `sales` across both tabs; the boss may name them):
> open `<seller_centre>/portal/product/<item_id>`, wait 6 seconds, `find` "Product Images" and `scroll_to` it.
> Take **one** screenshot at `scale: 0.5` of that area. **This page has Update, Delist and Cancel buttons: never
> press anything.** From the screenshot and the page text, note: `image_count` (photos in the 1:1 row, out of 9),
> `has_34_images` (any 3:4 photos), `has_video`, and judge the **cover photo** (the first one):
> product clearly visible and filling the frame? clean background? readable, not cluttered with text? looks
> professional? Then the set: different angles? a photo in use (lifestyle)? size/what's-in-the-box?
> Give each product a `score` from 1 to 5 and up to 3 `issues`, each one short ("cover photo too dark",
> "only 3 photos", "no video").
> Save to `<HQ>/data/images/<today>.json` as `{"read_at", "source_pages", "summary": {"to_be_optimised",
> "ai_optimised"}, "optimiser_list": [...], "checked": [...]}`. Reply with the 5 scores only.

`SIGNED_OUT`: live chat → ask the owner to sign in; scheduled run → urgent alert "Seller Centre is signed out.
Please sign in in Claude's browser.", log "skipped: signed out", refresh, stop.

## 3. Work it out (you do this)
- `missing_selling_points` = rows in `optimiser_list` whose task mentions selling points.
- For each checked product write **one fix** in plain words, the most valuable first: e.g. "Retake the cover on a
  white background, product filling 80% of the frame", "Add 3 more photos: in use, size, what's in the box",
  "Add a 10-second video".
- Write the day file again with `summary` (`products_checked`, `need_fixing` = score ≤ 3, `missing_selling_points`,
  `to_be_optimised`), `items` (`product`, `score`, `issue` = the main issue, `fix`; sorted by score, lowest first;
  weekly check: products missing selling points, with `issue` "No selling points" and `fix` "Ask Claude for
  selling points") and a one-line `note`.

## 4. Alerts
First remove alerts with `topic` "images" dated today. Then add:
- `watch` if `need_fixing` > 0: "<n> best sellers need better photos. Top fix: <the first fix>."
- `info` if `missing_selling_points` > 0: "<n> products have no selling points, so Shopee's AI can't make poster
  images for them. Ask me to write them."

## 5. Finish
First: if this automation's entry in `automations.json` has `"extras"`, run the ones whose days match today
(`automations/extras.md` → "How it works"). Then:
1. Add to `data/runs/<today>.json`: `{"time", "automation": "Image check", "result": "<note>", "alerts": <n>,
   "approvals": 0}`.
2. Update this automation's `last_run` and `last_result` in `automations.json`.
3. `bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"`.
4. Live chat: show it as in Module 11. Scheduled run: end with three lines, e.g.
   "44 products to optimise in Shopee · 12 best sellers without selling points · say 'write my selling points'."

## Writing selling points (when the owner asks)
For each product (best sellers first, 5 at a time): 3–5 selling points, each **under 40 characters**, concrete and
true (from the product name, its page, `store.json` and what the owner tells you), no medical or "No.1" claims
unless the owner can prove them, in the shop's language(s). Show them numbered; the owner says YES or edits;
save them in `rules/my-shop-info.md` under `## Selling points`. Then guide the owner to upload them: Product AI
Optimiser → **To Be Optimised** → **Upload Selling Points** on that product → paste → save. If the box shows a
different limit than 40 characters, follow the box.
