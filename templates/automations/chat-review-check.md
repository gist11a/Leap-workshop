# Automation recipe: Chat and review check

- **id:** `chat-review-check` · **topics:** `chats`, `reviews` · **changes the shop:** never by itself.
  It writes reply drafts into `approvals.json`; replies are sent only after the owner's YES (`helpers/doer.md`).
- **Saves:** `data/chats/<today>.json`, `data/reviews/<today>.json`, approvals, alerts, the run log.
- Replace `<HQ>` with the full Shopee HQ folder location (it's written in `<HQ>/CLAUDE.md`).

## 1. Get ready
Read `<HQ>/CLAUDE.md`, `rules/shop.json`, `rules/store.json`, `rules/chat.json`. "Today" = the date in the shop's
timezone, `YYYY-MM-DD`. Look at `approvals.json`: chats or reviews that already have a `waiting` draft are skipped
unless the buyer wrote again.

## 2. Read the waiting chats and reviews
**Who reads:** in a live chat with the owner (Opus), send ONE helper (Agent tool, `model: "sonnet"`,
`subagent_type: "general-purpose"`, prompt = the text of `<HQ>/helpers/reader.md` + the job below).
In a scheduled run you are already on Sonnet: read the pages yourself, following every rule in `helpers/reader.md`.

The job:
> **A. Chats.** Open `<seller_centre>/webchat/conversations`. Wait 4 seconds. Never touch **Serving Mode**, never
> type in the message box, never close or end a chat. Click the **All** filter at the top of the list and choose
> **To Manually Reply**, and in the shop filter (it says **All Shops**) pick `<shop_name>`. Only chats labelled
> with the shop `<shop_name>` count (the list mixes every shop on this login).
> For up to 10 chats, newest first: open the chat (wait 3 seconds) and read it with `get_page_text` (`max_chars`
> 12000: the chat list comes first, the open chat at the end; messages have no sender names, so the buyer's lines
> are the ones the shop hasn't answered yet). If a puzzle or slider check pops up, stop and reply `VERIFY`. Collect `buyer` (the full username, used only to find the chat again),
> `buyer_short` (first 3 letters + `***`), `waiting_since` (time of the oldest unanswered buyer message),
> `last_buyer_message` (exact words, but replace any phone number, email or address with `[removed]`),
> `about` (one short line: what they want), `order_id` and `product` if they're mentioned.
> **B. Reviews.** Open `<seller_centre>/portal/settings/shop/rating`. Wait 4 seconds. From the top collect
> `shop_rating`, `unreplied_bad` ("Unreplied Bad Ratings"). Open the **To Reply** tab. The stars of each review
> aren't in the page text, so use the **star filter**: 1 star, then 2, 3, 4 and 5, and take `stars` from the filter
> you're on. For up to 20 reviews, newest first, collect `order_id`, `product` (first 50 characters), `stars`, `review` (the buyer's words,
> up to 300 characters, phone numbers/emails/addresses replaced with `[removed]`), `buyer_short`, `date`.
> Never click Reply, Review Prize or anything else that changes the shop.
> Save chats to `<HQ>/data/chats/<today>.json` as `{"read_at", "source_pages", "summary": {"waiting"},
> "found": [...]}` and reviews to `<HQ>/data/reviews/<today>.json` as `{"read_at", "source_pages",
> "summary": {"to_reply", "shop_rating", "unreplied_bad"}, "found": [...]}`. Reply with the two counts.

`VERIFY` (Shopee's puzzle check, which opening chats can trigger): follow "When Shopee needs the owner" in
`<HQ>/CLAUDE.md` (live chat: the owner does the puzzle, then read again; scheduled run: alert + their chosen notice,
log, stop). Never touch the puzzle.
`SIGNED_OUT`: live chat → ask the owner to sign in; scheduled run → urgent alert "Seller Centre is signed out.
Please sign in in Claude's browser.", log the run as "skipped: signed out", refresh, stop.

## 3. Write the replies (you do this, not the helper)
Use only `rules/chat.json` and `rules/store.json`. **Every reply follows `shopee_rules`**, uses their `tone`,
`greeting` and `sign_off`, answers in the buyer's language, and promises nothing that isn't in `store.json`.
If `rules/shop-profile.md` exists, its "Product facts" and "Answers the shop already gives" may be used as facts.
Returns, refunds and cancellations always follow `store.json` → `shopee_policy`; mention one of `my_extra_policies`
(warranty, exchange…) only when the buyer asks about it.
Use the `faq` answers when the question matches. Don't invent facts: if you need one you don't have, it's a
hand-over.

**Chats:** for each chat in `found`:
- If it matches `always_hand_to_me`, or you'd have to guess a fact → **hand-over**: write a short holding reply
  ("So sorry about this! Let me check with the team and come back to you today.") and a one-line reason.
- Otherwise → **draft**: a reply of 1–4 short lines.
- Add to `approvals.json`: `{"id": "C<n>", "created": "<today HH:MM>", "topic": "chats",
  "what": "Reply to <buyer_short>: \"<first 60 characters of the reply>…\"",
  "where": {"page": "/webchat/conversations", "buyer": "<buyer>"}, "before": "<last_buyer_message>",
  "do": "<the full reply>", "kind": "draft" or "hand-over", "reason": "<hand-over reason, or null>",
  "status": "waiting"}`. Ids keep counting up from the highest `C` number already in the file.

**Reviews:** for each review in `found`:
- 4–5 stars → a warm thank-you, 1–2 lines, mention the product by its short name. `kind` "thank-you".
- 1–3 stars → a calm, kind public reply: say sorry, don't argue, don't blame the courier or the buyer, invite them
  to chat with the shop so you can help. Never offer anything in exchange for changing the review. `kind` "bad".
- Add to `approvals.json`: `{"id": "R<n>", "created", "topic": "reviews", "what": "<stars>★ <product short>:
  \"<first 60 characters of the reply>…\"", "where": {"page": "/portal/settings/shop/rating",
  "order_id": "<order_id>", "product": "<product>"}, "before": "<review>", "do": "<the full reply>",
  "kind": "thank-you" or "bad", "status": "waiting"}`. Ids keep counting up from the highest `R` number already in
  the file.

Then write the day files again with:
- chats `summary`: `waiting`, `replies_drafted`, `handed_to_me`, `oldest_wait_hours`; `items`: one per chat,
  `{"buyer": buyer_short, "asked": about, "status": "Draft ready" / "Hand to you"}`. Remove the full `buyer`
  usernames from the day file (they're only in `approvals.json`).
- reviews `summary`: `to_reply`, `bad_to_reply` (1–3 stars), `shop_rating`, `unreplied_bad`; `items`: one per
  review, `{"product", "stars", "review" (first 80 characters), "status": "Draft ready"}`.
- a one-line `note` on each.

## 4. Alerts
First remove alerts with `topic` "chats" or "reviews" dated today. Then add:
- `urgent` if any chat has waited more than 12 hours: "<N> chats waiting over 12 hours. Say 'what needs my YES?'".
  (Shopee's response rate counts only replies by a person within 12 hours: `knowledge/shopee-basics.md` §4.)
- `watch` if any chat has waited 9–12 hours (Shopee marks it "Due Soon"): "<N> chats are close to 12 hours."
- Chats whose last buyer message is **over 7 days old** can't be answered on Shopee any more: draft nothing, and
  mention them once in the `note`.
- `urgent` for every hand-over: "<buyer_short> needs you: <reason>."
- `watch` if there are bad reviews to answer: "<N> bad reviews to reply to."
- `info` for drafts ready: "<N> chat replies and <M> review replies ready for your YES."

## 5. Finish
First: if this automation's entry in `automations.json` has `"extras"`, run the ones whose days match today
(`automations/extras.md` → "How it works"). Then:
1. Add to `data/runs/<today>.json`: `{"time", "automation": "Chat and review check", "result": "<short>",
   "alerts": <n>, "approvals": <drafts added>}`.
2. Update this automation's `last_run` and `last_result` in `automations.json`.
3. `bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"`.
4. Live chat: show the drafts as in Module 6. Scheduled run: end with three lines, e.g.
   "4 chats waiting (1 needs you) · 6 reviews to reply · 9 replies ready. Say 'what needs my YES?' in Claude."
