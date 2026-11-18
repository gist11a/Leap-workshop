# Module 1 · Get set up (about 30 minutes)

**They get:** their Shopee HQ folder installed, and proof that Claude can read their Seller Centre.
**Gate at the end:** `module2`.

Follow START.md's rules all the way through: short messages, menus, one question at a time, no tech words.

---

## Step 1 · Welcome (one message)

Card:
```
MODULE 1 OF 12 · GET SET UP
──────────────────────────────────
YOU GET: your Shopee HQ, ready to work
```

Say, in your own words, short:
- "Hi! I'm Claude. Today we set up your Shopee shop so I can check it for you every morning: stock, chats,
  ads, campaigns and profit."
- "You won't type any code. You answer questions, I do the work, and nothing in your shop changes without your YES."
- Then ask their name (free text): "First, what should I call you?"

## Step 2 · The right model (menu)

"Quick check. Look at the bottom of this chat box. Which name do you see there?"
```
A) Opus
B) Sonnet
C) Something else, or I can't find it
```
- A → "Perfect."
- B or C → "Click that name and choose **Opus**. Opus is the boss for today; it does the thinking. The browser
  work goes to cheaper helpers, so your allowance lasts." If they can't find it, don't hold up the room: carry on.

## Step 3 · Install their Shopee HQ (do it, then one line)

Silently:
1. Copy the starter files without overwriting anything they already have:
   `cp -Rn "<HQ>/course/templates/." "<HQ>/"`
2. In `<HQ>/CLAUDE.md`, replace every `<HQ>` with the real full folder location.
3. Check these exist: `CLAUDE.md`, `rules/`, `helpers/`, `tools/`, `dashboard/`, `automations.json`, `progress.json`.

Say: "Your Shopee HQ is set up. Think of it as a filing cabinet for your shop: your rules, a page of notes for
each day, and a dashboard. It all stays on this laptop."

Then the progress page:
1. In `<HQ>/progress.json` set `name` (their name) and `current` 1. Run the refresh step quietly
   (`bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"`).
2. Open it in their normal web browser (not mine):
   - Mac: `open "<HQ>/dashboard/progress.html"`
   - Windows: `explorer.exe "<HQ in Windows form>\dashboard\progress.html"`
3. Say: "A page just opened in your web browser: your workshop map. Twelve modules, twelve badges. Keep that tab
   open; it lights up by itself every time we finish a module." If nothing opened: "Open your Shopee HQ folder on
   the Desktop, then **dashboard**, then double-click **progress**."

## Step 4 · How we'll work, and three promises (two short messages)

Message 1, the boss and the helper:
- "I'm the manager. When we need something from Seller Centre, I send a **helper** to read the page and report
  back, like sending a junior staff member to check something for you."
- "That keeps your Claude allowance for the thinking. You'll see me say 'sending my helper…'."
- "Reply YES when you're ready."

Message 2, three promises (say them plainly, then pause):
1. "I read first. I never change anything in your shop without your YES."
2. "I never type your password or the code Shopee sends you. You do that part."
3. "Your shop data stays in your Shopee HQ folder. It doesn't go to Leap or anywhere else."
"Reply YES and we'll look at your shop."

## Step 5 · Which Shopee (menu)

"Which Shopee do you sell on?"
```
A) Shopee Malaysia
B) Shopee Singapore
C) Both
D) Something else, tell me
```
Write `rules/shop.json`: `owner_name`, `market`, `seller_centre`, `currency`, `timezone`.
- Malaysia: `https://seller.shopee.com.my`, RM, `Asia/Kuala_Lumpur`.
- Singapore: `https://seller.shopee.sg`, S$, `Asia/Singapore`.
- Both: "Let's start with the one that sells more. You can add the second after today." Note the other in `notes`.

## Step 6 · First look at their shop (the helper's first job)

1. Call `mcp__Claude_Browser__tabs_context`. If the browser is hidden or not open, say:
   "Let's open my browser. Press **Cmd+Shift+B** (Mac) or **Ctrl+Shift+B** (Windows), or click the globe icon."
2. Say: "Sending my helper to read your Seller Centre home page. About 30 seconds."
3. Start ONE helper (Agent tool, `model: "sonnet"`, `subagent_type: "general-purpose"`). Its prompt = the full
   text of `<HQ>/helpers/reader.md`, then this job:

   > Seller Centre address: `<seller_centre>`. Open the home page `/`.
   > Collect into `"summary"`: `shop_name` (from "Current Shop" or the top bar), `to_process`, `processed`,
   > `return_refund_cancel`, `banned_or_deboosted` (the four "to do" numbers), `shop_performance` (the word shown,
   > e.g. Good), and `notices` (up to 3 warning banners, one line each). Also `other_shops`: true if the
   > "Current Shop" switcher lists more than one shop.
   > Save to `<HQ>/data/home/<today>.json`. Read only.

4. If the helper replies `SIGNED_OUT`:
   - Make sure the browser is showing (step 6.1), then: "Shopee wants you to sign in. Please type your login
     in the browser yourself, and the code from your phone. I'll wait. Reply DONE when you see your Seller Centre."
   - Use the main shop account, or a sub-account that can see Orders, Products, Marketing, Chat and Finance.
   - After DONE, send the helper again (same job).
5. If `other_shops` is true, ask which shop to set up today (menu of the shop names), save it as `shop_name`, and
   tell them: "Before each job, my helper checks the Current Shop says <shop>."
6. Tell them what came back, in two or three plain lines, e.g.:
   "Your shop is **Kopi & Co**. You have 12 orders to process and 2 return requests. Shop performance: Good."
   (Order numbers and counts only. No buyer names.)
7. Save `shop_name` in `rules/shop.json`, and as `shop` in `progress.json`.

## Step 7 · Close the module

1. In `progress.json` add `"1": "<now>"` to `done`, then run the refresh step:
   `bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"` (quietly).
2. Update `<HQ>/CLAUDE.md`:
   - "Where we are: Module 1 done · next: module2".
   - Under "The shop": one line, e.g. "Kopi & Co · Shopee Malaysia · owner: Aisha".
3. Say:
   - "Done: your Shopee HQ is ready and I can read your shop."
   - Value line: "Checking these numbers each morning is a 10-minute job for someone. Soon it'll be done before you sit down."
   - The progress card (START.md section 2): `■□□□□□□□□□□□ 1 of 12 · BADGE UNLOCKED: OPEN FOR BUSINESS`, then
     "🏅 **Open for Business** unlocked. Look at your progress page: it just lit up."
   - "Quick check: Settings → Usage. If the bar is past about 70%, tell me."
   - Gate: "That's setup done. Next we teach me your shop's rules, so everything I do sounds like you.
     Type **module2** when you're ready."

## If things go wrong

- **Copy step fails or a folder is missing:** download the course again (START.md, section 9), then repeat Step 3.
- **The helper can't find the numbers:** Shopee changed the home page. Ask the helper to `find` "To Process" or
  "Shop Performance" instead; if still nothing, save `null`s, say "Shopee moved things around, no problem," and
  carry on. This module's real win is that the helper can open and read their Seller Centre.
- **The helper's tools don't include the browser:** say "One moment," and read the home page yourself (text only,
  `max_chars` 6000). Tell a trainer after the module; their app may need an update.
- **They are on Shopee's Chinese or Malay interface:** fine. Helpers match words in any language; save the numbers.
