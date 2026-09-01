# StayOS - week 1

Foundation only: DB schema with the no-double-booking constraint, Spring Boot
backend skeleton, Auth0 login on the admin app, a placeholder guest site.
No booking, payment, or housekeeping logic yet - that's weeks 2-4. See
`DESIGN.md` for the full roadmap and `ARCHITECTURE.md` for the system design
this scaffold implements. `CLAUDE.md` has the rules to follow when adding
code (don't remove the DB-level booking constraint, don't trust client-side
payment confirmation, etc).

## Layout

```
StayOS/
├── backend/            Spring Boot API
├── frontend/
│   ├── admin/          Next.js + Auth0 - staff/owner PMS
│   └── guest-site/     Next.js - public booking site
├── docker-compose.yml
├── CLAUDE.md
├── ARCHITECTURE.md
├── DESIGN.md
└── README.md
```

## Run it

**1. Database**

```
docker compose up -d
```

Starts Postgres on `localhost:5432` (db `stayos`, user `stayos`, password
`stayos_local_dev` - see `docker-compose.yml`). Flyway applies
`backend/src/main/resources/db/migration/V1__init_schema.sql` automatically
on backend startup.

**2. Backend**

```
cd backend
mvn spring-boot:run
```

Runs on `http://localhost:8080`. Requires Java 21 and Maven; nothing here
has been build-tested in this environment (no Maven Central access from
where this was generated) - if the build fails on a dependency version,
that's the first thing to check.

**3. Admin app (Auth0 login)**

```
cd frontend/admin
copy .env.local.example .env.local   (Windows)  or  cp .env.local.example .env.local
npm install
npm run dev -- -p 3001
```

Runs on `http://localhost:3001`. You need an Auth0 tenant with a Regular Web
Application configured with callback URL
`http://localhost:3001/api/auth/callback` and logout URL
`http://localhost:3001`.

**4. Guest site (placeholder)**

```
cd frontend/guest-site
npm install
npm run dev
```

Runs on `http://localhost:3000`.

## What's actually done vs. stubbed

| Piece | Status |
|---|---|
| DB schema (5 tables) + exclusion constraint | Real, ready to run |
| JPA entities + repositories | Real |
| Admin Auth0 login + protected `/dashboard` | Real |
| Guest site | Placeholder page only |
| Booking, payment, housekeeping logic | Not started - week 2+ |

## Next

Week 2: room search endpoint, booking flow, Razorpay order + webhook,
reservation state machine.
