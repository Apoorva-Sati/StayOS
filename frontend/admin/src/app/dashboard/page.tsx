import { getSession } from '@auth0/nextjs-auth0';
import { redirect } from 'next/navigation';

export default async function Dashboard() {
  const session = await getSession();

  if (!session?.user) {
    redirect('/api/auth/login');
  }

  return (
    <main className="p-10">
      <h1 className="text-2xl font-semibold">Dashboard</h1>
      <p className="mt-2 text-gray-600">
        Logged in as {session!.user.email}
      </p>

      {/*
        Week 3 goes here: arrivals, departures, occupied/available rooms,
        rooms needing cleaning, pending payments. Not built yet - this route
        just proves the Auth0 login + protected-route wiring works.
      */}

      <a href="/api/auth/logout" className="mt-6 inline-block text-sm underline">
        Log out
      </a>
    </main>
  );
}
