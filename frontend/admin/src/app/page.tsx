import { getSession } from '@auth0/nextjs-auth0';
import { redirect } from 'next/navigation';

export default async function Home() {
  const session = await getSession();

  if (session?.user) {
    redirect('/dashboard');
  }

  return (
    <main className="p-10">
      <h1 className="text-2xl font-semibold">StayOS admin</h1>
      <p className="mt-2 text-gray-600">Front desk / owner login.</p>
      <a
        href="/api/auth/login"
        className="mt-4 inline-block rounded bg-black px-4 py-2 text-white"
      >
        Log in
      </a>
    </main>
  );
}
