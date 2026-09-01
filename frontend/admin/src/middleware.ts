import { withMiddlewareAuthRequired } from '@auth0/nextjs-auth0/edge';

// Defense-in-depth alongside the getSession() check in dashboard/page.tsx:
// this stops unauthenticated requests at the edge before they even render.
export default withMiddlewareAuthRequired();

export const config = {
  matcher: ['/dashboard/:path*'],
};
