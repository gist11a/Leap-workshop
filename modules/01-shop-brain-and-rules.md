# Module 1 · Your shop's brain and rules (about 40 minutes)

**They get:** Claude that knows their shop, keeps their promises to buyers, and sounds like them.
**Files filled:** `rules/shop.json`, `rules/store.json`, `rules/chat.json`, `rules/my-shop-info.md`, `<HQ>/CLAUDE.md`.
**Gate at the end:** `module2`.

Follow START.md's rules all the way through: short messages, lettered menus, one question at a time, no tech words.
Every later module reads these rules, so this is the module that makes everything else "theirs".
Write each answer to its file **as soon as they give it** (small edits), so nothing is lost if the chat breaks.

---

## Step 1 · Open the module (one message)

Card:
```
MODULE 1 OF 11 · YOUR SHOP'S BRAIN AND RULES
──────────────────────────────────
YOU GET: a Claude that knows your shop and sounds like you
```

Say, short:
- "Think of a new staff member's first day. You tell them the rules once: what you sell, what you promise buyers,
  how you talk to them."
- "That's this module. I'll write it all down in your Shopee HQ, and every automation today follows it."
- "Four short rounds of questions. Most answers are one letter."
- "Reply YES when you're ready."

## Step 2 · Send the helper while you talk (start it, don't wait)

Say: "While we talk, I'm sending my helper to read two pages: your chat numbers and your couriers."

Start ONE helper (Agent tool, `model: "sonnet"`, `subagent_type: "general-purpose"`). Its prompt = the full text of
`<HQ>/helpers/reader.md`, then this job:

> Seller Centre address: `<seller_centre>` (from `rules/shop.json`). Check "Current Shop" says `<shop_name>`.
> 1. Open `/portal/chat-management`. Collect `chat_enquiries_30d`, `chat_response_rate` (a number, e.g. 96.08),
>    `response_time` (as shown, e.g. "01:47:21"), and whether **Agent Greetings**, **Shortcut** and **FAQ** look
>    switched on (true/false/null). Don't open Edit.
> 2. Open `/portal/all-settings/shipping/shipping-channel`. Collect `couriers_on`: the names of the shipping
>    channels that are switched on. **Never touch a switch.**
> Save both under `"summary"` in `<HQ>/data/shop/<today>.json`. Read only.

Carry on with Step 3 straight away. When the helper finishes, use its numbers in Round B and in Step 5.
If it reports `SIGNED_OUT`, finish the round you're in, then handle it as in Module 0 Step 6.

## Step 3 · What did you bring? (menu)

"Did you bring any shop info today? Costs, return policy, the questions buyers always ask, lowest prices?"
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
   (`## Costs`, `## Lowest prices`, `## Return policy`, `## Buyer questions`, `## Ad goals`, `## Restock times`,
   `## Other`). Skip headings with nothing. No buyer details.
2. Fill any rule it answers (ship time, returns, warranty, FAQ answers…) so you **don't ask that question again**.
3. Tell them in one or two lines what you took from it: "Got it: your return policy, 6 buyer questions and costs
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
2. Couriers: if the helper is back, "Your shop ships with **<couriers_on>**. Right?" (YES or fix).
   If it isn't back yet, ask this later. Save `couriers`.
3. "What's your return policy?"
   ```
   A) Shopee's normal return and refund rules ★
   B) Returns only if the item is damaged or wrong
   C) Returns within a set number of days — tell me how many
   D) Something else — tell me
   ```
   Save `return_days` (null for A or B) and `return_conditions` in plain words.
4. "Warranty?"
   ```
   A) No warranty ★
   B) Yes — tell me how long and who handles it
   ```
5. "Are all your products original, from the brand or an official supplier?"
   ```
   A) Yes, 100% original ★
   B) Some are — tell me which
   C) Not a brand product (handmade, own brand, generic)
   ```
   Save `authentic_products`. Only A lets a reply say "100% original".
6. "When can buyers expect a chat reply from a real person?"
   ```
   A) Every day, 9am to 6pm ★
   B) Weekdays only, office hours
   C) Most of the day, including evenings
   D) Something else — tell me
   ```
   Save `chat_hours`.
7. "Anything you **never** promise? For example an exact delivery date, or free gifts."
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
   invented facts). If you need a fact you don't have (sizes, expiry), leave a blank: "[size chart]".
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
   Save `morning_check_at` (e.g. "09:00") in `shop.json`. We use it in Module 4.
3. "Where should urgent alerts go?"
   ```
   A) Here in Claude, and the dashboard ★
   B) Also a morning summary in my Gmail drafts (we set it up in Module 11)
   ```
   B → ask for the email address, save `alert_email`. "In Module 11 I'll put a short morning summary in your Gmail
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
   Returns: Shopee's normal rules · 100% original
   Replies: warm and friendly · English and Malay
   Chat now: 96% answered · about 1h 47m to reply (last 30 days)
   ```
   (Last line from the helper. If it isn't back yet, leave that line out.)
   "Reply YES if that's right, or tell me what to fix."
2. **Live test** (this is the fun bit, keep it moving):
   - "Let's test me. Type a question a buyer sent you this week, exactly how they wrote it."
   - Write the reply you'd send, using `chat.json` and `store.json` only. Show it in a box. Under it, one line:
     "✓ only promises what's in your rules · ✓ follows Shopee's chat rules". **Nothing is sent.**
   - Then: "Now try a hard one, like a broken item or an angry buyer."
   - For anything in `always_hand_to_me`: don't draft a fix. Say "This one I'd **pass to you**:" + one line on why,
     and a short holding reply they could use ("So sorry about this! Let me check with the team and come back to you
     today."). "That's how I'll handle it every time."
   - If they don't like a reply's wording, fix the rule (tone, greeting, an FAQ answer), not just that reply, and
     say so: "Fixed in your rules, so every reply changes, not just this one."
   - One easy question and one hard one is enough. Watch the clock (this module is the tightest of the day).

## Step 6 · Close the module

1. Run the refresh step: `bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"` (quietly).
2. Update `<HQ>/CLAUDE.md`:
   - "Where we are: Module 1 done · next: module2".
   - Under "The shop": 2–3 lines (shop, market, what they sell, goal, ship time, tone).
   - Under "How the owner likes things": Round D answers, plus anything they said about themselves along the way
     (e.g. "hates long messages", "packs orders herself in the evening").
3. Say:
   - "Done: your shop's rules are written down. Every reply and every check today follows them."
   - "Want to change a rule later? Just tell me, like 'we now ship within 1 day'. I'll update it."
   - Value line: "That's the training you'd give a new admin, in 30 minutes, and I won't forget it."
   - "Quick check: Settings → Usage. If the bar is past about 70%, tell me."
   - Gate: "That's 1 of 11 done. Next, your dashboard: one page with your whole shop on it.
     Type **module2** when you're ready."

## If things go wrong

- **They want to skip a round:** use the ★ defaults and tell them which you used. Rules can change any time.
- **Their file won't open** (a locked PDF, a big spreadsheet): "Let's just paste the important part," or move on with
  the questions. Don't spend more than 3 minutes on it.
- **They give a policy that breaks Shopee's rules** (e.g. "tell them to WhatsApp me"): "Shopee can warn shops for
  that, so I won't put it in a reply. I'll pass those chats to you instead." Add it to `always_hand_to_me`.
- **The helper finds no couriers or chat numbers:** ask them for couriers; leave the chat line out of the card. Save `null`s.
- **They ask whether replies will be sent automatically:** "Not today. Every reply waits for your YES. After a week,
  if you trust my replies for simple questions, you can tell me to send those by myself." (`auto_send` stays false.)
