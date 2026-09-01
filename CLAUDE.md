# CLAUDE.md

Instructions for Claude (chat or Claude Code) when working inside this repository.
This project was planned in conversation before any code existed — see
`ARCHITECTURE.md` for the technical design and `DESIGN.md` for product scope,
roles, and roadmap. Read both before making non-trivial changes.

## Project

StayOS (working name) — a direct-booking and operations platform for a 20-room
guest house. Purpose: reduce OTA commission dependency, automate guest
communication and check-in, optimize room pricing, and give the owner
real-time visibility into the business. Architecture is designed to expand to
multiple properties later, but built for one property first.

## Stack

- Backend: Java, Spring Boot — **modular monolith** (package-per-module, not
  microservices) with modules: `booking`, `payments`, `guests`, `pms`,
  `housekeeping`, `pricing`, `whatsapp`, `notifications`, `expenses`,
  `reviews`, `loyalty`, `audit`.
- Frontend (guest-facing + admin/PMS): Next.js, React, TypeScript, Tailwind CSS.
- Staff mobile (housekeeping): React Native.
- Database: PostgreSQL — the single source of truth.
- Cache/queue: Redis (idempotency keys, rate limiting, job scheduling).
- Auth: Auth0 (OTP + RBAC + MFA for admin/owner roles).
- Realtime: Socket.IO or Spring WebSocket for live PMS/housekeeping views.
- Object storage: S3-compatible (guest ID docs, room photos).
- Payments: Razorpay primary (UPI/cards/netbanking/wallets); Stripe later
  for international cards.
- Messaging: WhatsApp Cloud API (official Meta API, not a third-party wrapper).
- Infra target: AWS (RDS Postgres, ECS/Fargate, S3, CloudFront), ap-south-1.

## Hard rules — do not violate these when writing code

1. **No microservices for MVP.** Keep everything inside the Spring Boot
   monolith unless one module's load has genuinely and measurably diverged.
2. **Booking/payment writes must be idempotent** and wrapped in a DB
   transaction. Use an idempotency key of `reservation_id + attempt_no`.
3. **Never trust the frontend for payment confirmation.** A reservation only
   becomes `CONFIRMED` after a signature-verified Razorpay webhook is
   processed. The client-side "success" callback is not authoritative.
4. **No app-level double-booking checks.** Prevention is enforced by a
   Postgres exclusion constraint on `(room_id, daterange(check_in, check_out))`
   — don't reimplement this in application logic, and don't remove it.
5. **External integrations go behind an interface.** Smart locks, payment
   providers, and messaging providers are never called directly from business
   logic — see `LockProvider` for the pattern to follow for any new
   integration.
6. **The WhatsApp AI agent never invents data.** It answers availability,
   price, or booking status only via tool calls
   (`get_availability`, `get_price`, `get_reservation_status`, etc.) that hit
   the real `booking`/`pms` modules. If a tool doesn't exist for a claim the
   agent wants to make, add the tool — don't let the model guess.
7. **Every pricing change and financial mutation writes an audit log row**
   (old value, new value, inputs, actor).

## Current status

Nothing has been implemented yet beyond the smart-lock abstraction interface
(`LockProvider` — see the code file from this migration). This repo starts at
the planning/architecture stage. MVP scope is Phases 1–4 in `DESIGN.md`
(foundation, booking engine, mini-PMS, transactional WhatsApp) — start there.
