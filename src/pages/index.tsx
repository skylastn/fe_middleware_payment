import React, { useEffect, useState } from "react";
import { useRouter } from "next/router";
import { CheckoutLayout } from "@/shared/component/layouts/CheckoutLayout";
import { Search, ShieldCheck, ArrowRight } from "lucide-react";

export default function RootPage() {
  const router = useRouter();
  const [reference, setReference] = useState("");
  const [token, setToken] = useState("");

  useEffect(() => {
    if (router.isReady && router.query.reference) {
      router.replace({
        pathname: "/home",
        query: router.query,
      });
    }
  }, [router.isReady, router.query, router]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!reference.trim()) return;

    const query: Record<string, string> = { reference: reference.trim() };
    if (token.trim()) query.token = token.trim();

    router.push({
      pathname: "/home",
      query,
    });
  };

  return (
    <CheckoutLayout
      title="Cari Pembayaran"
      subtitle="Masukkan nomor referensi transaksi Anda"
    >
      <form onSubmit={handleSubmit} className="space-y-4 py-4">
        <div className="space-y-1.5">
          <label className="text-xs font-bold text-slate-700">Nomor Referensi Transaksi</label>
          <div className="relative">
            <input
              type="text"
              required
              placeholder="Contoh: PROJ-INV-20260908-001"
              value={reference}
              onChange={(e) => setReference(e.target.value)}
              className="w-full px-3.5 py-2.5 pl-9 rounded-xl border border-slate-200 text-xs font-mono focus:border-sky-500 focus:ring-2 focus:ring-sky-500/20 outline-hidden transition"
            />
            <Search className="w-4 h-4 text-slate-400 absolute left-3 top-3" />
          </div>
        </div>

        <div className="space-y-1.5">
          <label className="text-xs font-bold text-slate-700">
            Token Sesi <span className="text-slate-400 font-normal">(Opsional)</span>
          </label>
          <input
            type="text"
            placeholder="Masukkan token sesi jika ada"
            value={token}
            onChange={(e) => setToken(e.target.value)}
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-xs font-mono focus:border-sky-500 focus:ring-2 focus:ring-sky-500/20 outline-hidden transition"
          />
        </div>

        <button
          type="submit"
          className="w-full py-3 px-4 rounded-xl bg-sky-600 hover:bg-sky-700 text-white text-xs font-bold flex items-center justify-center gap-2 shadow-md shadow-sky-600/20 transition cursor-pointer"
        >
          <span>Lanjutkan ke Pembayaran</span>
          <ArrowRight className="w-4 h-4" />
        </button>

        <div className="pt-4 flex items-center justify-center gap-1.5 text-[11px] text-slate-400">
          <ShieldCheck className="w-3.5 h-3.5 text-emerald-500" />
          <span>Portal checkout resmi Payment Middleware</span>
        </div>
      </form>
    </CheckoutLayout>
  );
}
