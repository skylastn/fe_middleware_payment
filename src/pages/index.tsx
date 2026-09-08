import React, { useEffect, useState } from "react";
import { useRouter } from "next/router";
import { CheckoutLayout } from "@/shared/component/layouts/CheckoutLayout";
import { Search, ShieldCheck, ArrowRight, CreditCard, Lock, Sparkles } from "lucide-react";

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
      title="Portal Pembayaran"
      subtitle="Selesaikan tagihan Anda dengan mudah & aman"
      headerRight={
        <div className="w-8 h-8 rounded-xl bg-sky-50 text-sky-600 flex items-center justify-center border border-sky-100">
          <CreditCard className="w-4 h-4" />
        </div>
      }
    >
      <div className="space-y-4 py-2">
        {/* Hero Card */}
        <div className="p-4 rounded-2xl bg-gradient-to-br from-sky-500 to-indigo-600 text-white space-y-1 shadow-md shadow-sky-500/20">
          <div className="flex items-center gap-1.5 text-sky-100 text-[10px] font-bold uppercase tracking-wider">
            <Sparkles className="w-3.5 h-3.5" />
            <span>Multi-Gateway Checkout</span>
          </div>
          <h2 className="text-base font-extrabold tracking-tight">Cari Transaksi Anda</h2>
          <p className="text-xs text-sky-100/90 leading-relaxed">
            Masukkan nomor referensi invoice untuk melanjutkan pembayaran via QRIS, Virtual Account, atau e-Wallet.
          </p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-1.5">
            <label className="text-xs font-bold text-slate-800">Nomor Referensi Transaksi</label>
            <div className="relative">
              <input
                type="text"
                required
                placeholder="Contoh: PROJ-INV-20260908-001"
                value={reference}
                onChange={(e) => setReference(e.target.value)}
                className="w-full px-3.5 py-3 pl-10 rounded-xl border border-slate-200 text-xs font-mono font-medium focus:border-sky-500 focus:ring-3 focus:ring-sky-500/20 outline-hidden transition bg-slate-50/40 focus:bg-white"
              />
              <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3.5" />
            </div>
          </div>

          <div className="space-y-1.5">
            <div className="flex justify-between items-center">
              <label className="text-xs font-bold text-slate-800">Token Sesi</label>
              <span className="text-[10px] text-slate-400 font-medium">Opsional</span>
            </div>
            <div className="relative">
              <input
                type="text"
                placeholder="Masukkan token sesi dari tautan jika ada"
                value={token}
                onChange={(e) => setToken(e.target.value)}
                className="w-full px-3.5 py-3 pl-10 rounded-xl border border-slate-200 text-xs font-mono font-medium focus:border-sky-500 focus:ring-3 focus:ring-sky-500/20 outline-hidden transition bg-slate-50/40 focus:bg-white"
              />
              <Lock className="w-4 h-4 text-slate-400 absolute left-3.5 top-3.5" />
            </div>
          </div>

          <button
            type="submit"
            className="w-full py-3.5 px-4 rounded-2xl bg-slate-900 hover:bg-slate-800 active:scale-95 text-white text-xs font-extrabold flex items-center justify-center gap-2 shadow-md shadow-slate-950/20 transition-all cursor-pointer"
          >
            <span>Lanjutkan ke Pembayaran</span>
            <ArrowRight className="w-4 h-4" />
          </button>

          <div className="pt-3 flex items-center justify-center gap-1.5 text-[11px] text-slate-400 font-medium">
            <ShieldCheck className="w-3.5 h-3.5 text-emerald-500" />
            <span>Dilindungi enkripsi end-to-end 256-bit</span>
          </div>
        </form>
      </div>
    </CheckoutLayout>
  );
}
