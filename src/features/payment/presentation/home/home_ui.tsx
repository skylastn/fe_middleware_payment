import React from "react";
import { useHomeLogic } from "./home_logic";
import { CheckoutLayout } from "@/shared/component/layouts/CheckoutLayout";
import { StateType } from "@/shared/domain/model/state_model";
import { Format } from "@/shared/utils/format";
import {
  Receipt,
  User,
  ShieldCheck,
  ChevronRight,
  RefreshCcw,
  AlertCircle,
  Building2,
  Calendar,
  Sparkles,
  ShoppingBag,
} from "lucide-react";

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
      <CheckoutLayout title="Rincian Tagihan">
        <div className="flex flex-col items-center justify-center py-24 space-y-4">
          <div className="w-10 h-10 border-3 border-sky-500/20 border-t-sky-600 rounded-full animate-spin" />
          <p className="text-xs font-semibold text-slate-500">Memuat rincian pesanan...</p>
        </div>
      </CheckoutLayout>
    );
  }

  if (stateStatus === StateType.error) {
    return (
      <CheckoutLayout title="Pesanan Tidak Ditemukan">
        <div className="flex flex-col items-center justify-center py-16 text-center space-y-4">
          <div className="w-14 h-14 rounded-2xl bg-rose-50 text-rose-500 flex items-center justify-center shadow-xs">
            <AlertCircle className="w-7 h-7" />
          </div>
          <div className="space-y-1">
            <h2 className="text-base font-bold text-slate-900">Gagal Memuat Pesanan</h2>
            <p className="text-xs text-slate-500 max-w-xs">{errorMessage}</p>
          </div>
          <button
            onClick={refetch}
            className="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-slate-900 text-white text-xs font-bold hover:bg-slate-800 transition cursor-pointer shadow-xs"
          >
            <RefreshCcw className="w-3.5 h-3.5" /> Coba Lagi
          </button>
        </div>
      </CheckoutLayout>
    );
  }

  const footerAction = (
    <div className="flex items-center justify-between gap-4">
      <div className="min-w-0">
        <p className="text-[11px] font-bold text-slate-400 uppercase tracking-wider">Total Tagihan</p>
        <p className="text-xl font-black text-sky-600 tracking-tight leading-tight">
          {Format.rupiah(parsed.amount)}
        </p>
      </div>
      <button
        onClick={handleProceedToPayment}
        className="flex-1 max-w-[190px] flex items-center justify-center gap-2 px-4 py-3.5 rounded-2xl bg-gradient-to-r from-sky-600 to-sky-700 hover:from-sky-700 hover:to-sky-800 active:scale-95 text-white text-xs font-extrabold shadow-lg shadow-sky-600/25 transition-all cursor-pointer"
      >
        <span>Pilih Metode</span>
        <ChevronRight className="w-4 h-4" />
      </button>
    </div>
  );

  return (
    <CheckoutLayout
      title="Rincian Pesanan"
      subtitle={order?.project?.name || "Pembayaran Terverifikasi"}
      headerRight={
        <div className="flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 border border-emerald-200/80 text-emerald-800 text-[11px] font-bold shadow-2xs">
          <ShieldCheck className="w-3.5 h-3.5 text-emerald-600" />
          <span>Aman</span>
        </div>
      }
      footer={footerAction}
    >
      {/* Merchant Info Card */}
      <div className="p-4 rounded-2xl bg-gradient-to-br from-slate-50 to-slate-100/50 border border-slate-200/80 flex items-center justify-between shadow-2xs">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-white border border-slate-200 flex items-center justify-center text-sky-600 shadow-2xs shrink-0">
            <Building2 className="w-5 h-5" />
          </div>
          <div>
            <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Merchant</p>
            <p className="text-xs font-extrabold text-slate-900">{order?.project?.name || "Merchant Partner"}</p>
          </div>
        </div>
        <div className="text-right">
          <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Referensi</p>
          <p className="text-xs font-mono font-bold text-slate-700">{reference}</p>
        </div>
      </div>

      {/* Tabs Selector */}
      <div className="flex p-1 rounded-2xl bg-slate-100 border border-slate-200/80">
        <button
          type="button"
          onClick={() => setActiveTab("order")}
          className={`flex-1 flex items-center justify-center gap-2 py-2.5 rounded-xl text-xs font-extrabold transition-all cursor-pointer ${
            activeTab === "order"
              ? "bg-white text-sky-600 shadow-xs"
              : "text-slate-500 hover:text-slate-900"
          }`}
        >
          <Receipt className="w-3.5 h-3.5" />
          <span>Pesanan</span>
        </button>
        <button
          type="button"
          onClick={() => setActiveTab("customer")}
          className={`flex-1 flex items-center justify-center gap-2 py-2.5 rounded-xl text-xs font-extrabold transition-all cursor-pointer ${
            activeTab === "customer"
              ? "bg-white text-sky-600 shadow-xs"
              : "text-slate-500 hover:text-slate-900"
          }`}
        >
          <User className="w-3.5 h-3.5" />
          <span>Pelanggan</span>
        </button>
      </div>

      {/* Tab Contents */}
      {activeTab === "order" ? (
        <div className="space-y-3">
          <div className="p-4 rounded-2xl border border-slate-200/90 bg-white space-y-3.5 shadow-2xs">
            <div className="flex items-center justify-between">
              <h3 className="text-xs font-extrabold text-slate-900 uppercase tracking-wider flex items-center gap-1.5">
                <ShoppingBag className="w-3.5 h-3.5 text-sky-600" />
                <span>Rincian Tagihan</span>
              </h3>
              <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-sky-50 text-sky-700">
                1 Item
              </span>
            </div>

            <div className="flex items-start justify-between gap-3 pt-3 border-t border-slate-100">
              <div className="space-y-0.5">
                <p className="text-xs font-bold text-slate-800">{parsed.productName}</p>
                <p className="text-[11px] text-slate-400">Order Ref: {reference}</p>
              </div>
              <p className="text-sm font-black text-slate-900">{Format.rupiah(parsed.amount)}</p>
            </div>
          </div>

          <div className="p-4 rounded-2xl border border-slate-200/80 bg-slate-50/60 space-y-2 text-xs">
            <div className="flex justify-between items-center text-slate-500">
              <span>Biaya Transaksi</span>
              <span className="font-bold text-emerald-600 flex items-center gap-1">
                <Sparkles className="w-3 h-3 text-emerald-500" />
                Gratis
              </span>
            </div>
            <div className="flex justify-between items-center text-slate-500 pt-2 border-t border-slate-100">
              <span className="flex items-center gap-1">
                <Calendar className="w-3.5 h-3.5 text-slate-400" />
                Waktu Transaksi
              </span>
              <span className="font-medium text-slate-700">{Format.dateTime(order?.created_at)}</span>
            </div>
          </div>
        </div>
      ) : (
        <div className="p-5 rounded-2xl border border-slate-200/90 bg-white space-y-3.5 text-xs shadow-2xs">
          <h3 className="text-xs font-extrabold text-slate-900 uppercase tracking-wider">
            Informasi Pembeli
          </h3>

          <div className="space-y-1">
            <p className="text-slate-400 text-[10px] font-bold uppercase tracking-wider">Nama Lengkap</p>
            <p className="font-bold text-slate-800 text-sm">{parsed.customerName}</p>
          </div>

          <div className="space-y-1 pt-2.5 border-t border-slate-100">
            <p className="text-slate-400 text-[10px] font-bold uppercase tracking-wider">Email</p>
            <p className="font-semibold text-slate-800">{parsed.email}</p>
          </div>

          <div className="space-y-1 pt-2.5 border-t border-slate-100">
            <p className="text-slate-400 text-[10px] font-bold uppercase tracking-wider">Nomor Ponsel</p>
            <p className="font-mono font-bold text-slate-800">{parsed.phone}</p>
          </div>

          {parsed.address !== "-" && (
            <div className="space-y-1 pt-2.5 border-t border-slate-100">
              <p className="text-slate-400 text-[10px] font-bold uppercase tracking-wider">Alamat</p>
              <p className="font-medium text-slate-700">{parsed.address}</p>
            </div>
          )}
        </div>
      )}
    </CheckoutLayout>
  );
}
