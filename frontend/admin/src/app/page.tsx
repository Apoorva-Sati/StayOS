import { auth0 } from '@/lib/route';
import { redirect } from 'next/navigation';

export default async function Dashboard() {
  const session = await auth0.getSession();

  if (!session?.user) {
    redirect('/auth/login');
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

      <a href="/auth/logout" className="mt-6 inline-block text-sm underline">
        Log out
      </a>
    </main>
  );
}