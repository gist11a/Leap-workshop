# Module 2 · Your shop's brain and rules (about 40 minutes)

**They get:** Claude that knows their shop, keeps their promises to buyers, and sounds like them.
**Files filled:** `rules/shop.json`, `rules/store.json`, `rules/chat.json`, `rules/my-shop-info.md`, `<HQ>/CLAUDE.md`,
and with the Shop Scan `rules/shop-profile.md` + `data/scan/<today>.json`.
**Gate at the end:** `module3`.

Follow START.md's rules all the way through: short messages, lettered menus, one question at a time, no tech words.
Every later module reads these rules, so this is the module that makes everything else "theirs".
Write each answer to its file **as soon as they give it** (small edits), so nothing is lost if the chat breaks.

---

## Step 1 · Open the module (one message)

Card:
```
MODULE 2 OF 12 · YOUR SHOP'S BRAIN AND RULES
──────────────────────────────────
YOU GET: a Claude that knows your shop and sounds like you
```

Say, short:
- "Think of a new staff member's first day. You tell them the rules once: what you sell, what you promise buyers,
  how you talk to them."
- "That's this module. I'll write it all down in your Shopee HQ, and every automation today follows it."
- "Four short rounds of questions. Most answers are one letter."
- "Reply YES when you're ready."

## Step 2 · Offer a full Shop Scan (ask first, then run it in the background)

The recipe is `<HQ>/automations/shop-scan.md`. Read it now.

Say, short:
- "Before the questions, an offer. While we talk, my helper can **study your whole shop** in the background: your
  orders, ads, products in detail, stock, reviews, and your past chats with buyers."
- "Then I know your shop from the real numbers, not only from what you tell me. It only **reads**: nothing in your
  shop changes, and I only open chats you've already read, so nothing new gets marked as read."
- "It takes about 10 to 20 minutes while we keep talking, and it uses a fair share of your Claude allowance, about
  two modules' worth." (If they said their Usage bar is past half, make B the ★ choice.)
```
A) Yes, do the full shop scan ★
B) Just the basics for now (your chat numbers, 1 minute)
C) Not now
```
- **A** → "Starting it. You'll see me mention it when each part finishes." Start **Shop Scan part 1** in the
  background exactly as the recipe says, and go straight on to Step 3. Start part 2 when part 1 finishes, part 3
  when part 2 finishes. The questions still all happen: "The scan shows me what your shop does. Your answers tell me
  what you want."
- **B** → start ONE helper in the background with the text of `<HQ>/helpers/reader.md` + **Shop Scan part 2, step
  3 only** (the chat numbers, saved under `"summary"` in `data/shop/<today>.json`). Go on to Step 3.
- **C** → go on to Step 3. Note in `<HQ>/CLAUDE.md` under "The shop": "Shop scan not done yet (say 'scan my shop')."
- Any part replies `SIGNED_OUT`: finish the question you're on, then handle it as in Module 1 Step 6 and restart
  that part. `VERIFY` (a Shopee puzzle check): as the recipe says, the owner does the puzzle; don't restart.

**Using what the scan finds (as each part comes back, mid-interview):**
- Mention it in one line, then use it: "My helper finished reading your sales: 214 orders in 30 days, best seller
  Kopi O Drip Bag. I'll use that."
- **Confirm instead of asking** when the scan already knows: couriers (part 1), whether they ship fast (part 1's
  orders), their usual tone and greeting (part 3). E.g. "In your chats you write warm replies in Malay and English,
  with a little emoji, starting 'Hi dear!'. Keep that?" (A) Yes ★ B) Change it).
- **Real buyer questions beat guesses:** in Round C, if part 3 is back, show the buyers' top questions from
  `rules/shop-profile.md` instead of the A–H list, and write the FAQ answers from "Answers the shop already gives"
  (cleaned up, checked against their rules).
- Never let the scan override what the owner says. If they differ ("you said 2 days, but most orders ship in 3"),
  ask once, plainly, and save what the owner decides.

## Step 3 · What did you bring? (menu)

"Did you bring any shop info today? Costs, your own shop policies, the questions buyers always ask, lowest prices?"
```
A) Yes, in a Google Sheet or Google Doc
B) Yes, a file on this laptop
C) I'll paste or type it here
D) No, just ask me
E) Something else — tell me
```
- **A** → "What's the file called? Even part of the name helps." Search their Google Drive with the Drive connector
  and read only that file. If Drive isn't connected: "No problem, let's do B instead."
- **B** → "Drag the file into this chat box." (Spreadsheet, Word, PDF or a photo of a printed page are all fine.)
- **C** → "Go ahead. Rough is fine, a list is fine."
- **D** → go to Step 4.

For A, B or C:
1. Save what they gave, in their own words, under clear headings to `rules/my-shop-info.md`
   (`## Costs`, `## Lowest prices`, `## My extra policies`, `## Buyer questions`, `## Ad goals`, `## Restock times`,
   `## Other`). Skip headings with nothing. No buyer details.
2. Fill any rule it answers (ship time, extra policies such as warranty, FAQ answers…) so you **don't ask that question again**.
3. Tell them in one or two lines what you took from it: "Got it: your warranty policy, 6 buyer questions and costs
   for 14 products. Costs we use after lunch."

## Step 4 · Four rounds of questions

Each question is one message with a lettered menu. End each **round's first question** with
"(Or just say YES and I'll use sensible defaults.)" — YES fills the round with the defaults marked ★ and moves on.
Skip any question Step 3 already answered.

### Round A · About your shop → `rules/shop.json`

1. "In one line, what do you sell?" (free text, e.g. "baby clothes and toys"). Save `what_we_sell`.
2. "What kind of Shopee shop is it?"
   ```
   A) Shopee Mall
   B) Preferred Seller
   C) Normal shop ★
   D) Not sure
   ```
   Save `shop_type`, and `is_mall` true/false. Not sure → normal, "we'll check it when we do profit."
3. "What matters most to you this month?"
   ```
   A) More sales
   B) Better profit on each sale
   C) Less time on admin ★
   D) Fewer bad reviews and chats left waiting
   E) Something else — tell me
   ```
   Save `main_goal`. Use it all day: lead every summary with the number that goes with it.

### Round B · Your promises to buyers → `rules/store.json`

Say first: "Now your promises. When I write a reply for you, I'll only promise what's written here."

1. "How fast do you ship?"
   ```
   A) Same day or next day
   B) Within 2 days ★
   C) Within 3 days
   D) Longer — tell me
   ```
   Save `ship_within_days` (1, 2, 3 or their number).
2. Couriers: if the scan's part 1 is back, "Your orders go out with **<couriers seen in the orders>**. Right?"
   (YES or fix). Otherwise ask: "Which couriers do you use?" (free text). Save `couriers`.
3. **Policies.** Say first (don't ask): "Shopee's own policies always apply to your shop: its return and refund
   rules, the Shopee Guarantee, and its chat and review rules. I'll always follow those. They're already in your
   rules and can't be switched off." (They're in `store.json` → `shopee_policy`.)
   Then: "Do you have any **extra** policies of your own, on top of Shopee's?" Pick all that apply, e.g. **B C**.
   ```
   A) No, just Shopee's ★
   B) Warranty (tell me how long and who handles it)
   C) Exchange for a wrong size or colour (tell me how many days)
   D) Free gift or freebie rules (e.g. "free sample with every order above RM50")
   E) Something else — tell me (or paste your policy)
   ```
   - A → `my_extra_policies` stays empty. Nothing else to ask.
   - Each other letter → one short follow-up for the detail, then save it to `my_extra_policies` as
     `{"policy": "1-year warranty", "details": "Brand handles it; buyer chats us with the order number"}`.
   - If Step 3 gave you their policy, show what you saved instead of asking: "From your file: <policy>. Right?"
   - **An extra policy can add to Shopee's, never take away.** "No returns", "no refunds" or "returns only by bank
     transfer" can't override Shopee's rules: "Shopee's return rules still apply to every buyer, so I can't promise
     that. I'll pass those chats to you instead." Add it to `always_hand_to_me` and save nothing in `my_extra_policies`.
4. "Are all your products original, from the brand or an official supplier?"
   ```
   A) Yes, 100% original ★
   B) Some are — tell me which
   C) Not a brand product (handmade, own brand, generic)
   ```
   Save `authentic_products`. Only A lets a reply say "100% original".
5. "When can buyers expect a chat reply from a real person?"
   ```
   A) Every day, 9am to 6pm ★
   B) Weekdays only, office hours
   C) Most of the day, including evenings
   D) Something else — tell me
   ```
   Save `chat_hours`.
6. "Anything you **never** promise? For example an exact delivery date, or free gifts."
   (free text, or "no"). Add to `promises_we_never_make`. Always add "an exact delivery date" unless they disagree:
   "Shopee's couriers set that, so we never promise a day."

### Round C · How your shop talks → `rules/chat.json`

1. "How should your replies sound?"
   ```
   A) Warm and friendly, a little emoji ★
   B) Polite and professional, no emoji
   C) Short and to the point
   D) Something else — tell me
   ```
   Save `tone`.
2. Write **three** greetings and sign-offs in that tone (one line each, using their shop name), e.g. for A:
   ```
   A) "Hi dear! Thanks for chatting with Kopi & Co 😊" … "Have a lovely day!"
   B) "Hello! Welcome to Kopi & Co." … "Thank you, Kopi & Co team"
   C) "Hi there 👋" … "Happy shopping!"
   D) My own — I'll type it
   ```
   Save `greeting` and `sign_off`.
3. "Which languages do your buyers write in?"
   ```
   A) English and Malay ★
   B) English, Malay and Chinese
   C) English only
   D) Something else — tell me
   ```
   Save `languages`. `reply_in_buyers_language` stays true.
4. **Buyer questions.** If Step 3 gave you their FAQ, show the questions in one list and skip to 5.
   Otherwise: "What do buyers ask you most? Pick all that apply, e.g. **A C E**."
   ```
   A) Is it original?
   B) When will my order ship / arrive?
   C) Which size or colour should I pick?
   D) Is it in stock?
   E) Can I get a discount for buying more?
   F) How do I use it / what's the expiry date?
   G) Can I return or exchange it?
   H) Something else — tell me
   ```
5. For each question, **write the answer yourself from Round B and Round C** (their tone, their promises, no
   invented facts). Returns and exchanges: Shopee's policy first ("you can ask for a return in the Shopee app"),
   then their extra policy if they have one. If you need a fact you don't have (sizes, expiry), leave a blank: "[size chart]".
   Show them all answers in one message, numbered, one or two lines each:
   "Here are your answers. Reply YES, or tell me the number to change." Save to `faq` as `{"q": "...", "a": "..."}`.
6. Shopee's rules (say this, don't ask): "Shopee also has chat rules. I'll always follow them: no asking buyers to
   pay or chat outside Shopee, no phone numbers or addresses in chat, never asking them to cancel, and no gifts
   for good reviews. Breaking these can get a shop warned." (They're already in `shopee_rules`.)
7. "Anything **you** never want said? A competitor's name, a word you hate, a topic to avoid?" (free text or "no").
   Save to `never_say`.
8. "Some chats I'll always pass to you instead of answering. Right now that's: refunds and returns, damaged or wrong
   items, angry buyers, health or safety questions, and money questions that aren't in your rules. Add anything?"
   (free text or YES). Add to `always_hand_to_me`.

### Round D · How you like to hear from me → `rules/shop.json` + `CLAUDE.md`

1. "When I report to you, how should it look?"
   ```
   A) Three lines: the numbers and what to do ★
   B) A short list with a bit of detail
   C) Full detail, I like to read
   ```
2. "What time should your morning check be ready?"
   ```
   A) 8:00am
   B) 9:00am ★
   C) 10:00am
   D) Another time — tell me
   ```
   Save `morning_check_at` (e.g. "09:00") in `shop.json`. We use it in Module 5.
3. "Where should urgent alerts go?"
   ```
   A) Here in Claude, and the dashboard ★
   B) Also a morning summary in my Gmail drafts (we set it up in Module 12)
   ```
   B → ask for the email address, save `alert_email`. "In Module 12 I'll put a short morning summary in your Gmail
   drafts. I never send it; you just read it." 

Save Round D's answer 1 as `how_to_talk_to_me` in `shop.json`.

## Step 5 · Show it back, then a live test

1. One plain card, then ask for YES or fixes:
   ```
   YOUR SHOP, AS I KNOW IT
   ──────────────────────────────────
   Kopi & Co · Shopee Malaysia · normal shop
   Sells: coffee beans and drip bags
   Goal this month: less time on admin
   Ships within 2 days · SPX, J&T
   Policies: Shopee's (always) + 1-year warranty · 100% original
   Replies: warm and friendly · English and Malay
   Chat now: 92% answered · about 2h 10m to reply (last 30 days)
   ```
   (Last line from the scan's part 2 or the basics helper. If it isn't back yet, leave that line out.)
   "Reply YES if that's right, or tell me what to fix."
   If the scan has finished (or as soon as it does, even in a later module), a second card from
   `rules/shop-profile.md`, five lines at most, EXAMPLE:
   ```
   WHAT I LEARNED FROM YOUR SHOP
   ──────────────────────────────────
   Last 30 days: RM8,940 sales · 214 orders · 2.1% of visitors buy
   Best sellers: Kopi O Drip Bag · Hazelnut 250g · Robusta 1kg
   Ads last week: RM280 spent · RM4.10 back for every RM1
   Buyers ask most: halal? (9) · when will it arrive? (7) · which grind? (5)
   Watch: Hazelnut 250g runs out in about 6 days · 3 bad reviews have no reply
   ```
   "I'll keep this in mind for every check and every reply. Anything there that surprises you?"
2. **Live test** (this is the fun bit, keep it moving):
   - "Let's test me. Type a question a buyer sent you this week, exactly how they wrote it."
   - Write the reply you'd send, using `chat.json`, `store.json` and (if the scan ran) the "Product facts" in
     `rules/shop-profile.md`. Show it in a box. Under it, one line:
     "✓ only promises what's in your rules · ✓ follows Shopee's chat rules". **Nothing is sent.**
   - Then: "Now try a hard one, like a broken item or an angry buyer."
   - For anything in `always_hand_to_me`: don't draft a fix. Say "This one I'd **pass to you**:" + one line on why,
     and a short holding reply they could use ("So sorry about this! Let me check with the team and come back to you
     today."). "That's how I'll handle it every time."
   - If they don't like a reply's wording, fix the rule (tone, greeting, an FAQ answer), not just that reply, and
     say so: "Fixed in your rules, so every reply changes, not just this one."
   - One easy question and one hard one is enough. Watch the clock (this module is the tightest of the day).

## Step 6 · Close the module

**If the scan is still running:** don't wait for it. "My helper is still studying your past chats. That's fine:
the next module doesn't need the browser. I'll tell you when it's done." When it finishes later, show the "What I
learned" card then. (Module 4 needs the browser: wait for the scan before its helper starts.)

1. In `progress.json` add `"2": "<now>"` to `done` (and `"shop-scan"` to `bonus` once the scan has finished), then run
   the refresh step: `bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"` (quietly).
2. Update `<HQ>/CLAUDE.md`:
   - "Where we are: Module 2 done · next: module3".
   - Under "The shop": 2–3 lines (shop, market, what they sell, goal, ship time, tone), and "Shop scan: <date>,
     see rules/shop-profile.md" (or "not done yet").
   - Under "How the owner likes things": Round D answers, plus anything they said about themselves along the way
     (e.g. "hates long messages", "packs orders herself in the evening").
3. Say:
   - "Done: your shop's rules are written down. Every reply and every check today follows them."
   - "Want to change a rule later? Just tell me, like 'we now ship within 1 day'. I'll update it."
   - Value line: "That's the training you'd give a new admin, in 30 minutes, and I won't forget it."
   - "Quick check: Settings → Usage. If the bar is past about 70%, tell me."
   - Gate: "That's 2 of 12 done. Next, your dashboard: one page with your whole shop on it.
     Type **module3** when you're ready."

## If things go wrong

- **They want to skip a round:** use the ★ defaults and tell them which you used. Rules can change any time.
- **Their file won't open** (a locked PDF, a big spreadsheet): "Let's just paste the important part," or move on with
  the questions. Don't spend more than 3 minutes on it.
- **They give a policy that breaks Shopee's rules** (e.g. "tell them to WhatsApp me"): "Shopee can warn shops for
  that, so I won't put it in a reply. I'll pass those chats to you instead." Add it to `always_hand_to_me`.
- **The scan is slow or a part gets stuck:** keep going with the questions; the scan is a bonus, not a must. Skip
  the stuck part (the recipe says how). If the allowance bar is past 70%, stop after the part that's running.
- **The helper finds no couriers or chat numbers:** ask them for couriers; leave the chat line out of the card. Save `null`s.
- **They ask whether replies will be sent automatically:** "Not today. Every reply waits for your YES. After a week,
  if you trust my replies for simple questions, you can tell me to send those by myself." (`auto_send` stays false.)
