-- Week 1 foundation schema: room_types, rooms, guests, reservations, payments.
-- Everything else from ARCHITECTURE.md (users/roles, rate_plans, invoices,
-- etc.) comes in later phases.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS btree_gist;  -- required for the EXCLUDE constraint below

CREATE TABLE room_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    base_rate NUMERIC(10,2) NOT NULL,
    max_occupancy INTEGER NOT NULL DEFAULT 2,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE rooms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_type_id UUID NOT NULL REFERENCES room_types(id),
    room_number VARCHAR(20) NOT NULL UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE'
        CHECK (status IN ('AVAILABLE','OCCUPIED','DIRTY','CLEANING','MAINTENANCE','OUT_OF_ORDER')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE guests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(30) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE reservations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_id UUID NOT NULL REFERENCES rooms(id),
    guest_id UUID NOT NULL REFERENCES guests(id),
    check_in DATE NOT NULL,
    check_out DATE NOT NULL CHECK (check_out > check_in),
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING','PAYMENT_PROCESSING','CONFIRMED','CHECKED_IN','CHECKED_OUT','CANCELLED','NO_SHOW')),
    total_amount NUMERIC(10,2) NOT NULL,
    idempotency_key VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- This is the load-bearing line from Week 1: the database itself refuses
    -- two overlapping, non-cancelled reservations on the same room. No
    -- application-level overlap check should ever be added on top of this -
    -- see CLAUDE.md rule 4.
    EXCLUDE USING gist (
        room_id WITH =,
        daterange(check_in, check_out) WITH &&
    ) WHERE (status NOT IN ('CANCELLED','NO_SHOW'))
);

CREATE INDEX idx_reservations_room_id ON reservations(room_id);
CREATE INDEX idx_reservations_guest_id ON reservations(guest_id);
CREATE INDEX idx_reservations_status ON reservations(status);

CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reservation_id UUID NOT NULL REFERENCES reservations(id),
    amount NUMERIC(10,2) NOT NULL,
    provider VARCHAR(30) NOT NULL DEFAULT 'RAZORPAY',
    -- Razorpay order/payment id. Webhook handling must be idempotent on this.
    provider_ref VARCHAR(150) NOT NULL UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'CREATED'
        CHECK (status IN ('CREATED','SUCCEEDED','FAILED','REFUNDED','PARTIALLY_REFUNDED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_payments_reservation_id ON payments(reservation_id);
