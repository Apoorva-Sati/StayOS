import { handleAuth } from '@auth0/nextjs-auth0';

// Provides /api/auth/login, /api/auth/logout, /api/auth/callback,
// /api/auth/me for free.
export const GET = handleAuth();
