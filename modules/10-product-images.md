# Module 10 · Product images (about 20 minutes)

**They get:** an honest score for their best sellers' photos with the one fix that matters most, a photo brief they
can hand to anyone, and selling points so Shopee's own AI can make poster images for them.
**Files touched:** `data/images/`, `rules/my-shop-info.md` (selling points), `alerts.json`, `automations.json`.
The recipe `automations/image-check.md` is already in their folder. Read it now.
**Gate at the end:** `module11`.

Follow START.md's rules: short messages, lettered menus, one question at a time, no tech words.
Be kind about photos: owners often took them themselves. Lead with what works, then the one fix.
**Claude doesn't draw the images.** Shopee's AI makes the poster images from the selling points Claude writes;
better photos come from the owner (or their photographer) using Claude's brief.

---

## Step 1 · Open the module (one message)

Card:
```
MODULE 10 OF 11 · PRODUCT IMAGES
──────────────────────────────────
YOU GET: photos and selling points that make people click
```

Say, short:
- "On Shopee, buyers decide in a second, from your first photo. A better cover photo often gets more clicks than
  a bigger ad budget."
- "I'll look at the photos of your 5 best sellers, score them, and tell you the one fix that matters most."
- "Then I'll write **selling points** for them. Shopee has a free AI tool that turns selling points into poster
  images for your listings."
- "Reply YES when you're ready."

## Step 2 · Look at the photos (one helper)

1. Add `{"id": "image-check", "name": "Image check", "when": "By hand for now", "status": "paused",
   "recipe": "automations/image-check.md", "last_run": null, "last_result": null}` to `automations.json`.
2. Say: "Sending my helper to look at your best sellers' photos. It only looks, it doesn't change anything.
   About 3 minutes."
3. Follow `automations/image-check.md`, **full check** (steps 2 to 5). If Module 3 or 7 saved best sellers, give the
   helper those 5 names so it checks the right products.

## Step 3 · Scores and the one fix

1. Show it (EXAMPLE), lowest score first, kind but clear:
   ```
   YOUR PHOTOS
   ──────────────────────────────────
   2/5  Hazelnut Blend 250g · cover is dark, only 3 photos
        Fix: retake the cover in daylight on a white background
   3/5  Robusta Beans 500g · good cover, no photo of it in use
        Fix: add a photo of a cup being made, and one showing the bag size
   5/5  Kopi O Drip Bag x10 · clear cover, 8 photos, a video. Keep it!
   ```
2. "Want a photo brief for the ones that need work? It's a short shot list you can follow on your phone or send to
   a photographer."
   ```
   A) Yes ★
   B) No thanks
   ```
   A → one brief per product, at most 6 lines each, in plain words:
   ```
   PHOTO BRIEF · HAZELNUT BLEND 250G
   1 Cover: bag front-on, white background, daylight from a window, bag fills most of the photo
   2 The coffee in a cup, top view, on a wooden table
   3 Hand holding the bag (shows the size)
   4 Back of the bag: ingredients readable
   5 Square photos (1:1). Phone is fine: wipe the lens, no flash
   ```
   Save the briefs in `rules/my-shop-info.md` under `## Photo briefs`.

## Step 4 · Selling points → Shopee's AI posters (the hands-on part)

1. "Shopee's **Product AI Optimiser** says <missing_selling_points> of your products have no selling points yet,
   so its AI can't make poster images for them. Let me write them for your best sellers."
2. Follow "Writing selling points" in `automations/image-check.md` for the top 3 products (EXAMPLE):
   ```
   KOPI O DRIP BAG X10
   1 Roasted fresh in Ipoh every week
   2 Just add hot water, no machine needed
   3 10 single-serve bags, easy to carry
   4 Strong, classic kopi-o taste
   ```
   "Reply **YES** if they're right, or tell me what to change. Only true things, please: Shopee can take down
   claims that aren't."
3. Upload one together, so they know how: "In my browser: **Product AI Optimiser** (under Product) →
   **To Be Optimised** → find **Kopi O Drip Bag x10** → **Upload Selling Points** → paste these → save."
   One step per message; have the helper read the page if they're unsure what's on screen. **They press save.**
4. "Shopee's AI uses these to make poster images for that listing. You can do the other two the same way tonight;
   the selling points are saved in your Shopee HQ."

## Step 5 · Weekly reminder

1. "Want a short check every Monday: which products still need selling points?"
   ```
   A) Yes ★
   B) Not now
   ```
2. A → follow "How to schedule an automation" in `<HQ>/CLAUDE.md`: `taskId` `shopee-image-check`, `title`
   "Shopee · Image check (Mondays)", description "Weekly: products without selling points in Shopee's Product AI
   Optimiser", Mondays 55 minutes after `morning_check_at` (9:00 → `55 9 * * 1`). In its prompt, say "do the **weekly
   check** only". Don't run it now: it gets its permission in Module 11, where one morning routine runs every check once
   together (and saves your allowance). Only if they must leave before Module 11: run it once now with
   `run_scheduled_task` and wait until it finishes before any helper uses the browser.

## Step 6 · Close the module

1. "Press **Cmd+R** / **Ctrl+R** on your dashboard: the Product images card shows your scores and fixes."
2. Update `<HQ>/CLAUDE.md`: "Where we are: Module 10 done · next: module11". One line under "The shop", e.g.
   "Photos: Hazelnut cover to retake · selling points written for top 3 (in my-shop-info)."
3. Say:
   - "Done: you know which photos to fix first, and Shopee's AI can now make posters for your best sellers."
   - Value line: "A better cover photo is free and can lift clicks for every ad and campaign you run."
   - "Quick check: Settings → Usage. If the bar is past about 70%, tell me."
   - Gate: "That's 10 of 11 done. Last one: we put it all into one daily routine, and you leave with it running.
     Type **module11** when you're ready."

## If things go wrong

- **No Product AI Optimiser in their menu** (some shops don't have it yet): skip the upload, keep the selling points
  in `my-shop-info.md`, and say "Use them in your product description, and in the first lines of your title."
- **The edit page loads slowly or the screenshot shows nothing:** wait 5 more seconds once; still nothing, score that
  product "not checked" and move on.
- **They ask Claude to make the images:** "I can't draw photos, but Shopee's AI can make posters from these
  selling points, and the brief makes your own photos look professional."
- **Claims:** no "best", "No.1", "cures", "100% safe" or medical promises unless they have proof. Health and beauty
  products especially: keep it to what the product is and does.
- **Allowance high at this point:** do 3 products instead of 5, and skip the briefs ("I've saved them for later").
