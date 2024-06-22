import LoginForm from "@/app/ui/login-form";

export default async function Page() {
  return (
    <main>
      <h1 className={`mb-4 text-xl md:text-2xl`}>Dashboard</h1>
      <LoginForm />
    </main>
  );
}
