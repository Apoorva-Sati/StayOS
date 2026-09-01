package com.stayos.lock;

import java.time.Instant;

/**
 * Abstraction over any smart-lock vendor's API.
 *
 * This is the exact logic discussed in architecture planning: no vendor SDK
 * (Yale, August, Tuya, TTLock, etc.) should ever be called directly from
 * business logic. Each vendor gets a concrete adapter implementing this
 * interface, so the PMS/booking modules can swap lock providers without any
 * change to check-in, checkout, or override logic.
 *
 * If a concrete adapter's call fails, the caller is expected to fall back to
 * the manual override path (front-desk-issued physical/temporary key) rather
 * than blocking guest check-in.
 */
public interface LockProvider {

    /**
     * Generate a temporary access code for a room, valid only for the given
     * window. Implementations must enforce the window at the lock level
     * where the vendor API supports it, not just in application code.
     */
    AccessCode generateAccessCode(String roomId, Instant validFrom, Instant validTo);

    /**
     * Revoke a previously issued access code immediately (e.g. lost phone,
     * early cancellation, emergency override).
     */
    void revokeAccessCode(String codeId);

    /**
     * Current reachable state of the lock, used by the PMS to detect a
     * failed/offline lock before it becomes a guest-facing problem.
     */
    LockStatus getLockStatus(String roomId);

    record AccessCode(String codeId, String roomId, String code, Instant validFrom, Instant validTo) {}

    enum LockStatus {
        ONLINE,
        OFFLINE,
        LOW_BATTERY,
        UNKNOWN
    }
}
