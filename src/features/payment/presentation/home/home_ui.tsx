import React from "react";
import { useHomeLogic } from "./home_logic";
import { CheckoutLayout } from "@/shared/component/layouts/CheckoutLayout";
import { StateType } from "@/shared/domain/model/state_model";
import { Format } from "@/shared/utils/format";
import { Receipt, User, ShieldCheck, ChevronRight, RefreshCcw, AlertCircle } from "lucide-react";

export function HomeUI() {
  const {
    order,
    stateStatus,
    activeTab,
    setActiveTab,
    errorMessage,
    reference,
    parsed,
    handleProceedToPayment,
    refetch,
  } = useHomeLogic();

  if (stateStatus === StateType.loading || stateStatus === StateType.initial) {
    return (
      <CheckoutLayout title="Rincian Pesanan">
        <div className="flex flex-col items-center justify-center py-24 space-y-4">
          <div className="w-10 h-10 border-3 border-sky-500/20 border-t-sky-600 rounded-full animate-spin" />
          <p className="text-xs font-medium text-slate-500">Memuat rincian pesanan...</p>
        </div>
      </CheckoutLayout>
    );
  }

  if (stateStatus === StateType.error) {
    return (
      <CheckoutLayout title="Pesanan Tidak Ditemukan">
        <div className="flex flex-col items-center justify-center py-16 text-center space-y-4">
          <div className="w-14 h-14 rounded-full bg-rose-50 text-rose-500 flex items-center justify-center">
            <AlertCircle className="w-7 h-7" />
          </div>
          <div className="space-y-1">
            <h2 className="text-base font-bold text-slate-900">Gagal Memuat Pesanan</h2>
            <p className="text-xs text-slate-500 max-w-xs">{errorMessage}</p>
          </div>
          <button
            onClick={refetch}
            className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-slate-900 text-white text-xs font-semibold hover:bg-slate-800 transition"
          >
            <RefreshCcw className="w-3.5 h-3.5" /> Coba Lagi
          </button>
        </div>
      </CheckoutLayout>
    );
  }

  const footerAction = (
    <div className="flex items-center justify-between gap-4">
      <div>
        <p className="text-[11px] font-medium text-slate-400 uppercase tracking-wider">Total Pembayaran</p>
        <p className="text-lg font-extrabold text-sky-600 leading-tight">
          {Format.rupiah(parsed.amount)}
        </p>
      </div>
      <button
        onClick={handleProceedToPayment}
        className="flex-1 max-w-[180px] flex items-center justify-center gap-2 px-4 py-3 rounded-xl bg-sky-600 hover:bg-sky-700 active:scale-[0.98] text-white text-sm font-bold shadow-md shadow-sky-600/20 transition-all cursor-pointer"
      >
        <span>Bayar Sekarang</span>
        <ChevronRight className="w-4 h-4" />
      </button>
    </div>
  );

  return (
    <CheckoutLayout
      title="Rincian Pesanan"
      subtitle={order?.project?.name || "Pembayaran Terverifikasi"}
      headerRight={
        <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-emerald-50 border border-emerald-200/60 text-emerald-700 text-[11px] font-semibold">
          <ShieldCheck className="w-3.5 h-3.5" />
          <span>Aman</span>
        </div>
      }
      footer={footerAction}
    >
      {/* Merchant Info Card */}
      <div className="p-4 rounded-xl bg-slate-50 border border-slate-100 flex items-center justify-between">
        <div className="space-y-0.5">
          <p className="text-[11px] font-medium text-slate-400 uppercase">Merchant</p>
          <p className="text-sm font-bold text-slate-800">{order?.project?.name || "Merchant Partner"}</p>
        </div>
        <div className="text-right space-y-0.5">
          <p className="text-[11px] font-medium text-slate-400 uppercase">Referensi</p>
          <p className="text-xs font-mono font-bold text-slate-700">{reference}</p>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex p-1 rounded-xl bg-slate-100/80 border border-slate-200/60">
        <button
          type="button"
          onClick={() => setActiveTab("order")}
          className={`flex-1 flex items-center justify-center gap-2 py-2 rounded-lg text-xs font-bold transition-all ${
            activeTab === "order"
              ? "bg-white text-sky-600 shadow-sm"
              : "text-slate-500 hover:text-slate-800"
          }`}
        >
          <Receipt className="w-3.5 h-3.5" />
          <span>Pesanan</span>
        </button>
        <button
          type="button"
          onClick={() => setActiveTab("customer")}
          className={`flex-1 flex items-center justify-center gap-2 py-2 rounded-lg text-xs font-bold transition-all ${
            activeTab === "customer"
              ? "bg-white text-sky-600 shadow-sm"
              : "text-slate-500 hover:text-slate-800"
          }`}
        >
          <User className="w-3.5 h-3.5" />
          <span>Pelanggan</span>
        </button>
      </div>

      {/* Tab Contents */}
      {activeTab === "order" ? (
        <div className="space-y-3">
          <div className="p-4 rounded-xl border border-slate-100 space-y-3 bg-white">
            <h3 className="text-xs font-bold text-slate-900 uppercase tracking-wide">Item Pembelian</h3>
            <div className="flex items-start justify-between gap-3 pt-2 border-t border-slate-50">
              <div className="space-y-0.5">
                <p className="text-sm font-semibold text-slate-800">{parsed.productName}</p>
                <p className="text-xs text-slate-400">1x transaksi tagihan</p>
              </div>
              <p className="text-sm font-bold text-slate-900">{Format.rupiah(parsed.amount)}</p>
            </div>
          </div>

          <div className="p-4 rounded-xl border border-slate-100 space-y-2 bg-slate-50/50">
            <div className="flex justify-between text-xs text-slate-500">
              <span>Biaya Layanan</span>
              <span className="font-semibold text-emerald-600">Gratis</span>
            </div>
            <div className="flex justify-between text-xs text-slate-500 pt-2 border-t border-slate-100">
              <span>Waktu Pemesanan</span>
              <span className="font-medium text-slate-700">{Format.dateTime(order?.created_at)}</span>
            </div>
          </div>
        </div>
      ) : (
        <div className="p-4 rounded-xl border border-slate-100 space-y-3.5 bg-white text-xs">
          <h3 className="text-xs font-bold text-slate-900 uppercase tracking-wide">Data Pelanggan</h3>

          <div className="space-y-1">
            <p className="text-slate-400 text-[11px]">Nama Lengkap</p>
            <p className="font-semibold text-slate-800 text-sm">{parsed.customerName}</p>
          </div>

          <div className="space-y-1 pt-2 border-t border-slate-50">
            <p className="text-slate-400 text-[11px]">Email</p>
            <p className="font-semibold text-slate-800">{parsed.email}</p>
          </div>

          <div className="space-y-1 pt-2 border-t border-slate-50">
            <p className="text-slate-400 text-[11px]">Nomor Telepon</p>
            <p className="font-semibold text-slate-800 font-mono">{parsed.phone}</p>
          </div>

          {parsed.address !== "-" && (
            <div className="space-y-1 pt-2 border-t border-slate-50">
              <p className="text-slate-400 text-[11px]">Alamat</p>
              <p className="font-medium text-slate-700">{parsed.address}</p>
            </div>
          )}
        </div>
      )}
    </CheckoutLayout>
  );
}
