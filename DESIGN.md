# Design — StayOS

## 1. Product vision

A direct-booking and operations platform for a 20-room independent guest
house, aimed at reducing OTA commission dependency, automating guest
communication and check-in, optimizing pricing, and giving the owner a
real-time view of the business. Architecture is designed for one property
first, with room to expand to multiple properties and hundreds of rooms later.

## 2. Users / roles

Detailed personas (goals, pain points, day-in-the-life) have not been written
yet — only the role list and permission boundaries below exist so far. Fill
in personas before relying on this section for UX decisions.

- Property Owner
- General Manager
- Front Desk Staff
- Housekeeping Staff
- Accountant
- Guest
- System Administrator

## 3. Permission matrix (condensed)

| Role | Reservations | Payments | Pricing | Housekeeping | Reports | Config |
|---|---|---|---|---|---|---|
| Owner | CRUD | View | Approve | View | Full | Full |
| GM | CRUD | View/Refund | Edit | Assign | Full | Partial |
| Front Desk | Create/Read/Update | Create | View | Create | Own shift | — |
| Housekeeping | View own | — | — | Update status | — | — |
| Accountant | View | Full | — | — | Financial | — |
| Guest | Own only | Own | — | — | — | — |
| Sys Admin | — | — | — | — | — | Full (roles, integrations) |

## 4. Feature scope

**MUST HAVE (MVP):** booking engine, availability/no-double-book, Razorpay
payments, basic PMS (rooms/reservations/guests), WhatsApp notifications
(transactional, not full AI), manual check-in, housekeeping task board, basic
dashboard (occupancy/ADR/RevPAR).

**SHOULD HAVE (V2):** WhatsApp AI concierge, smart-lock check-in, dynamic
pricing, review automation, expense tracking.

**NICE TO HAVE (V3):** loyalty/referrals, competitor price intelligence,
programmatic SEO landing pages, multi-property support.

**Deliberately not built initially:** smart-lock integration, AI-driven
pricing, loyalty system — all deferred until direct bookings prove out on the
simpler MVP.

## 5. Roadmap

| Phase | Delivers | Definition of done |
|---|---|---|
| 1. Foundation | Auth, roles, DB schema, room/rate setup | Owner can log in and configure rooms |
| 2. Booking engine | Search → pay → confirm, no double-booking | End-to-end booking works in Razorpay test mode |
| 3. Mini-PMS | Today view, reservations, room status | Front desk runs a full day without spreadsheets |
| 4. WhatsApp transactional | Confirmations, reminders (no AI yet) | Guest receives automated messages |
| 5. Housekeeping | Task board, mobile app | Cleaner updates status without calling front desk |
| 6. WhatsApp AI concierge | Tool-based agent | Handles availability/FAQ without hallucinating |
| 7. Smart check-in + locks | Abstraction layer + one vendor | Guest self-checks-in end to end |
| 8. Dynamic pricing | Formula engine + audit trail | Prices adjust automatically within guardrails |
| 9. Reviews, loyalty, expenses | | Owner sees full P&L and review funnel |
| 10. Hardening | Load test, security review, backup/DR drill | Production sign-off |

**MVP = Phases 1–4.** Estimated realistic for 1–2 full-stack engineers over
roughly 10–12 weeks, given existing familiarity with the chosen stack.

## 6. Engineering principles

1. Production-ready over demo-quality.
2. Modular architecture; API-first design.
3. Mobile-first guest experience.
4. Secure by default.
5. Avoid microservices for the initial MVP — modular monolith.
6. PostgreSQL is the primary source of truth.
7. Financial operations must be auditable.
8. Payment and booking operations must be idempotent.
9. The AI concierge uses real application tools/data, never invented answers.
10. External integrations sit behind abstraction layers.
11. Every important business event should be traceable.
12. Design for one property first; allow multi-property expansion later.
13. Optimize for low operating cost.

## 7. Not yet designed

The full 39-section blueprint originally scoped (detailed UI/UX system,
full API specification, complete DB field list, SEO architecture, loyalty
rules, competitor pricing pipeline, testing pyramid, CI/CD pipeline, repo
structure) was intentionally compressed to the sections above to keep the
first pass token-efficient. Ask for any specific section to be expanded
before building it.
