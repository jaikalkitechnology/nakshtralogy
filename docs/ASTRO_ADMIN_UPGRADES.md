# Astro App + Admin Panel — Upgrade Plan & Status

Branch: `claude/multi-language-support-agents-g6p93h`
Scope: flutter_astro, flutter_user, react_admin, FastAPI backend.
Rule: never change astrology calculation/scoring/dasha/transit/remedy logic.

Status key: ⬜ pending · 🟡 in progress · ✅ done · ⏸ blocked/needs input

---

## 1. Approval → notify astrologer (push + email)
Admin **Astrologers** + **KYC** tabs: when an astrologer / KYC is **approved**
(or rejected), send them a **push notification AND an email**.

- ⬜ Backend: on astrologer approve/reject → push (FCM) + email (SMTP) + in-app record
- ⬜ Backend: on KYC approve/reject → push + email + in-app record
- ⬜ Email templates (approved / rejected) using the existing SMTP settings
- ⬜ Admin: confirm the approve/reject buttons trigger the above; show send result

## 2. Astro dashboard bell with unread badge
Home screen bell icon shows a **red number badge** for pending items (new chat /
audio / video requests + unread notifications). Tapping opens the list; badge clears.

- ⬜ Backend: unread/pending count endpoint (requests + notifications)
- ⬜ Astro: bell widget with red count badge on the dashboard app bar
- ⬜ Astro: tap → notifications/requests screen; mark-read clears the badge
- ⬜ Poll/refresh on resume (and via FCM when a request arrives)

## 3. Customer Support / FAQ (admin-managed, per app)
Astro **Profile → Customer Support** with an **FAQ** (e.g. "notification not
receiving", "call not connecting", "withdrawal succeeded"). FAQs are **served by
API** and **editable in the admin panel**, kept **separate for user vs astro**.

- ⬜ Backend: FAQ model (audience: user|astro, question, answer, category, order, active)
- ⬜ Backend: public `GET /faq?audience=…` + admin CRUD
- ⬜ Admin: FAQ manager tab (add/edit/reorder/toggle, per audience)
- ⬜ Astro: Profile → Customer Support screen (search + expandable FAQ)
- ⬜ User: same Support screen (audience=user)

## 4. Legal links (privacy / terms / refund)
Both apps link to **privacy policy, terms, refund** on nakshatralogy.com.

- ⬜ Astro: Profile → "About & Legal" with the 3 links (in-app webview / external)
- ⬜ User: same section
- ⬜ Show app version alongside (nice-to-have)

## 5. Support-ticket / complaint management (end-to-end)
Both apps: **raise a ticket** — description + **up to 2 images** — then see its
**status** (pending / in progress / completed) with history. Admin **Support
Tickets** tab manages all tickets and can **email / notify** the raiser.

- ⬜ Backend: Ticket model (user_id, role, subject, description, images[], status,
  category, priority, created/updated) + reply/thread
- ⬜ Backend: user/astro create + list + detail; image upload (≤2, bytes/web-safe)
- ⬜ Backend: admin list/filter by status, update status, reply, email + push on update
- ⬜ Admin: Support Tickets tab — table (status filters), detail drawer, reply,
  status change, send email/notification
- ⬜ Astro: Raise Ticket screen (desc + ≤2 images) + My Tickets list w/ status
- ⬜ User: same Raise Ticket + My Tickets
- ⬜ Auto-acknowledge (push + email) to raiser on submit

## 6. Google-login profile image fix (both apps)
Profile image breaks because uploaded images come from the **backend as a
relative/static path** while Google images are **absolute URLs**. Normalize so
both render.

- ⬜ Backend: return an **absolute** avatar URL (resolve static/relative → full URL)
- ⬜ Astro: avatar widget handles absolute URL + relative fallback + initials
- ⬜ User: same avatar handling
- ⬜ On Google login, store the Google photo URL if no uploaded image

---

## Recommended extras (proposed — see chat for rationale)
- ⬜ Notification **inbox** (list, read/unread, deep-link) — not just a badge
- ⬜ Ticket **thread/chat** (2-way replies) rather than status-only
- ⬜ Ticket **category + priority + auto-acknowledgement**
- ⬜ Admin complaint **SLA/assignment/internal notes + CSV export**
- ⬜ Reusable **absolute-URL avatar helper** shared across screens
- ⬜ Ensure all of the above work on **web** (bell, support, legal, tickets)
- ⬜ Localize every new string (existing l10n keys / English fallback)
