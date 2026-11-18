# How Shopee works: structure, numbers and rules (SG + MY)

For Claude. **Read only the section you need** (each module and recipe names its section). Checked 19 Nov 2026 against
Shopee's Seller Education Hubs, Shopee Ads help pages and Leap's takeaway calculator (fees matched to real
income statements). Shopee changes rules often: when Seller Centre shows
something different, trust Seller Centre and say so. Explain any of this to the owner in plain words, never as a lecture.

## 1. How Shopee is built
```
Login (merchant account) ── can manage several shops, often SG + MY together
 └─ Shop  (Current Shop switcher; every page shows ONE shop, except Seller Chat, which mixes them all)
     └─ Product / item   (Product ID, Parent SKU, name, category, cover + up to 8 images, video)
         └─ Variation    (Variation ID, SKU, price, stock). A product with no variations still has one.
```
- **Ads:** shop → channel (mostly **GMV Max** now) → ad (budget, target ROAS, on/paused) → for group ads, the
  products inside. A product can be in only **one** GMV Max ad. A shop has at most one **Shop GMV Max**, which
  Shopee fills with products that have no other ad.
- **Campaigns:** campaign (e.g. 11.11) → session (time slot, its own price range and **5pm** nomination deadline)
  → eligible variation → your nomination (price, stock) → status.
- **Orders:** one order → one or more lines (a variation × quantity). Orders exports have no Product ID: match by SKU.
- **Chat** belongs to the login, not the shop: Seller Chat lists every shop's chats. Always filter to this shop.
- **Always check "Current Shop"** before reading anything: one login, several shops.

## 2. Reading the numbers right
- **"-", "--" or blank means "no value", not 0.** Save `null`.
- **Missing rows:** Business Insights' product list leaves out products with no sales: missing = sold 0.
- **Unique counts never add up:** visitors and buyers are unique per period. Never add days together; use
  Shopee's own week or month figure.
- **Three order bases:** placed (order made) → paid → confirmed (after the cancel window). Never compare one basis
  with another. Business Insights shows paid by default.
- **When a day is final:** yesterday's shop and product numbers are **usually ready by 5–6am**. Shopee's own note
  says processing can run until 10am, so on a slow day Business Insights still says "Data is under processing" or
  "No Data" after 6am. If it does, use the last good numbers and try again later; by 10am they're always final. Ads keep adding sales to past days for a few days. Affiliate days are final on day +2.
  Orders keep changing for weeks (shipping, returns).
- **My Inventory's sales averages are rounded up to whole numbers.** Anything that sold at all shows as at least
  1 a day, and "Days of Supply" is worked out from that. Real speed = units sold in Business Insights ÷ days.
- **Ads and affiliates are separate channels.** Never add affiliate sales to ad sales.
- **Ad sales ≠ shop sales:** an ad gets credit for any order from the shop within 7 days of a click, so ad sales
  can't be compared with shop sales one-for-one.
- Treat long IDs as text (Product IDs, order numbers).

## 3. Stock and shipping (Module 4, 5)
- **Ship time:** orders paid **before 2pm ship the same day; later orders by the next working day.** Only
  **pre-order** listings may take 3–30 days. (MY: shops under 120 days old are exempt.)
- **Non-Fulfilment Rate (NFR):** orders the shop cancels (including **out-of-stock cancellations**) or that come back
  by the seller's fault. 7-day window, counted Mondays, aim under 5%. 10%+ = a penalty point (SG: 20%+ = 3 points).
  So **selling something you don't have costs points**, not just a sale.
- **Late Shipment Rate (LSR):** SG 5%+ (MY 10%+) = a penalty point.
- **Promotion stock is reserved:** stock put in a promotion can't be sold before it starts; leftovers come back after.
- Out of stock = stock 0 or less. Lost sales ≈ days out of stock × normal daily units × price.
- **Never ask a buyer to cancel**; if something is out of stock, the owner cancels it themselves.

## 4. Chats and reviews (Module 6)
- **Never:** phone numbers, WhatsApp, bank details, outside links, steering a sale off Shopee, asking a buyer to
  cancel, rude replies. SG: rude replies or cancel requests = 2 points a week; off-platform steering up to 15 points
  or a frozen account.
- **Chat Response Rate (CRR):** last 30 days, counts only **replies by a person** (text, stickers, shortcuts) sent
  **within 12 hours**, nights and weekends included. Auto-replies, FAQ and AI-assistant answers **don't count**.
  Preferred and Mall shops need **85%+**. SG: under 40% = no Flash Deals.
- Shopee flags a chat **Due Soon at 9 hours** unanswered and **Overdue at 12 hours**.
- A shop **can't reply once the buyer's last message is over 7 days old**.
- Promotional or mass messages only through Auto-Reply, FAQ, Broadcast: anything else counts as spam.
- **Puzzle checks:** opening many chats can make Shopee show a slide puzzle. Only the owner may do it.

## 5. Ads (Module 7)
- **Formats:** GMV Max (one product, an ad group of 2–30, or Shop GMV Max) replaced manual product ads in July 2025.
  It's charged per impression and aims at orders: judge it on **sales per RM1/S$1 (ROAS)**, not clicks. Shop+ is the
  keyword/shop ad. Brand formats are Mall-only.
- **Words:** Expense = spend. Sales (called GMV before Jan 2026) = attributed sales. **ROAS = sales ÷ expense.**
  ACOS = expense ÷ sales. "Direct" figures count only the advertised product itself.
- **Learning:** an ad needs **at least 7 days** to learn, and learning restarts after a target edit. Judge on 7–14
  days, never one day (yesterday's ad sales also keep growing for a few days).
- **Change rules (Shopee's own):** change a budget or target at most 1–2 times a day, **steps within 10%** (never over
  20%), then watch 3–7 days. Max **10 actions per product ad per day**. Switching on and off a lot can restrict traffic.
- **Target ROAS:** a lower target gets more traffic, a higher one less. Real ROAS usually lands at 80–120% of target.
- **ROAS Protection** (a weekly rebate when an ad misses its target) ends if the ad is paused or edited.
- **Credit is prepaid:** ads stop at zero, and a low balance can quietly slow them down.
- **Peak days** (9.9, 11.11, 12.12): start 2+ weeks early; ad conversion often rises 2–3×.
- Restricted from ads: adult, alcohol, tobacco/vape, weapons, loans, infant formula (stage 1–2), second-hand goods
  and more. Restricted categories may get little GMV Max delivery.

## 6. Fees and profit (Module 8). Rates: `tools/shopee-fees.json`
```
price after voucher = price × qty − the shop's OWN vouchers/discounts   (Shopee-funded vouchers cost the shop nothing)
commission     = price after voucher × category rate (Mall pays more; lower on Promo Xtra SG / Cashback MY; SG caps
                 commission on electronics and furniture)
programme fee  = price after voucher × Promo Xtra (SG, two bands) / Cashback (MY) on EVERY order while enrolled;
                 higher on campaign days; capped per item (MY RM108, SG S$60 / S$70)
transaction fee= what the buyer paid, incl. their shipping × 3.27% SG / 3.78% MY (instalment: MY 4.86%; SG 6.54% only
                 on 6- and 12-month orders in the Special SPayLater Programme)
MY only        = RM0.54 platform support per order (shown INSIDE the "Service Fee" line); opt-in Ads Escrow Top-Up
                 2.16%; pre-order items 2.16%
shipping       = SG: seller pays by parcel weight (S$2.30 up to 1 kg … S$11.20 up to 30 kg; buyer pays a fixed S$1.99;
                 weight = the bigger of real weight and L×W×H÷6000). MY: usually nothing (Shopee rebates it)
payout         = price after voucher − Shopee's fees − seller shipping
takeaway       = payout − packing or warehouse fees (+ 8% SST MY / 9% GST SG on the warehouse bill)
profit         = takeaway − product cost (incl. getting it to you) − running costs per order − ads
```
- **Campaign days raise the programme fee on every order in the window, nominated or not.** Commission stays the same.
- **A shop's own RM5 voucher costs it about RM4**, because the fees shrink with the price.
- **Running costs** (staff, rent, tools, warehouse minimums) ÷ orders a month is often the biggest cost per order
  for a small shop, and it shrinks as orders grow.
- **Break-even:** ROAS = price ÷ what's left before ads; the most ads may cost per order = what's left before ads.
- SG: GST is already inside the rates. Most shops aren't GST-registered (only a must above S$1m a year); a
  registered shop claims back the GST in fees and warehouse bills but pays 9/109 of what buyers paid (about 6.5% of
  every sale, net). MY: 8% SST is added on fees and warehouse bills, and nothing can be claimed back.
- New sellers: SG pays 0% commission for 120 days. MY commission starts after 120 days or 200 completed orders.
- Payout: SG when the buyer confirms receipt or the 15-day return window ends; MY 2–3 working days after.

## 7. Campaigns, promotions and vouchers (Module 9)
- **Calendar:** double dates (1.1 … 12.12), mid-month (15th; SG "15MMS"), payday (25th; SG "25SSS"). MY big sales run
  from 12am three days before a double date (one day before for 15th/25th). SG doesn't publish its windows.
- **Nominations close at 5pm** on set dates, often 2–3 weeks before the sale. Check the Campaign to-do list.
- Campaign prices are checked against the shop's **30-day lowest and 30-day average price**. SG Price Teaser: at least
  4% below last month's lowest. The price must fit **that session's** range.
- **Never raise the original price just before a promotion** ("misleading discount"): listings get banned.
- **After approval the price can only go down and stock only up.** Shopee-nominated products need Approve/Reject.
- SG Flash Deals: the shop pays the whole discount, items lock once approved, keep 0 penalty points. MY: 6+
  points shuts a shop out of all campaigns.
- Promotions: Discount (up to 180 days), Bundle Deal (must beat buying singly), Add-on Deal. Flash Deal price beats
  everything. One seller voucher per order. SG vouchers: a fixed discount must be at least 3% of the minimum spend.

## 8. Affiliates (Module 10)
- Commission is a rate the shop sets per product, on what the buyer paid, charged **only on completed orders**
  (MY adds 8% SST on top). Days are final on day +2. MY: orders through another shop's affiliate link pay **50%**
  of your rate.

## 9. Listings and images (Module 11)
- Images 1:1, at least 1024×1024; a cover plus up to 8 more; a video helps.
- **Wrong category is a violation** (SG: listing in the wrong category for vouchers is spam: deboost, then bans and
  points). If Seller Centre shows a "category doesn't match" warning, tell the owner; they fix it themselves.
- Also violations: duplicate or keyword-stuffed listings, prohibited or fake items, slow shipping without
  Pre-Order, saying "no returns".

## 10. Account health
- Penalty points are counted on Mondays and reset each quarter. Higher tiers bring deboosts, listing limits and
  campaign bans. **15 points in a quarter freezes the account.** Keep points at 0 for campaigns.
- Preferred Seller (SG) needs among others: CRR 85%+, rating 4.6+, NFR and LSR under 5%, at most 2 points.

## 11. Returns (both markets)
- Returns and refunds go through Shopee's Return/Refund. **SG: shops may not set their own return terms or charge
  extra for returns** (points or a freeze). Disputes within 72 hours (SG).
- MY: a return that's the seller's fault costs the shop both ways' shipping unless disputed with evidence.
- Shopee Mall shops offer 15-day returns.

## 12. SG vs MY at a glance
| | SG | MY |
|---|---|---|
| Money | S$, GST 9% inside the rates | RM, SST 8% added on fees |
| Transaction fee | 3.27% | 3.78% |
| Per-order fee | none | RM0.54 |
| Programme fee | Promo Xtra 5.45% (campaign days 6.54%); 3.27% / 4.36% on phones, gaming, pets, baby | Cashback 5.94% (campaign days 8.10%) |
| Seller shipping | by weight: S$2.30 up to 1 kg, S$3.21 up to 5 kg | usually none |
| Late shipping point | LSR 5%+ | LSR 10%+ |
| Campaign ban | curated, by penalty tier | 6+ points |
| Pre-order fee | none | 2.16% |
| Fee shown on income details | separate lines | "Service Fee" = Cashback fee + RM0.54 |
