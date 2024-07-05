import { Suspense } from "react";
import { fetchLatestInvoices } from "@/app/lib/data";
import { RevenueChartSkeleton } from "@packages/ui/skeletons";
import LatestInvoices from "@/app/ui/latest-invoices";
import RevenueChart from "@/app/ui/revenue-chart";
import Card from "@/app/ui/cards";

export default async function Page() {
  const latestInvoices = await fetchLatestInvoices();
  return (
    <main>
      <h1 className={`mb-4 text-xl md:text-2xl`}>The Dashboard</h1>
      <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
        <Card />
        <Card />
        <Card />
      </div>
      <div className="mt-6 grid grid-cols-1 gap-6 md:grid-cols-4 lg:grid-cols-8">
        <Suspense fallback={<RevenueChartSkeleton />}>
          <RevenueChart />
        </Suspense>
        <LatestInvoices latestInvoices={latestInvoices} />
      </div>
    </main>
  );
}
