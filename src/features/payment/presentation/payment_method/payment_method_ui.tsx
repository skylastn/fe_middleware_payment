import React from "react";
import { useRouter } from "next/router";
import Image from "next/image";
import { usePaymentMethodLogic } from "./payment_method_logic";
import { CheckoutLayout } from "@/shared/component/layouts/CheckoutLayout";
import { StateType } from "@/shared/domain/model/state_model";
import { getEffectiveLogo } from "../../domain/model/response/payment_method_response";
import { ArrowLeft, ChevronRight, CreditCard, ShieldCheck, AlertCircle, RefreshCcw } from "lucide-react";

export function PaymentMethodUI() {
  const router = useRouter();
  const {
    categories,
    stateStatus,
    submitting,
    selectedMethodKey,
    handleSelectMethod,
    refetch,
  } = usePaymentMethodLogic();

  if (stateStatus === StateType.loading || stateStatus === StateType.initial) {
    return (
      <CheckoutLayout title="Pilih Pembayaran">
        <div className="space-y-4 py-2">
          {[1, 2, 3].map((i) => (
            <div key={i} className="space-y-2 animate-pulse">
              <div className="h-3 w-28 bg-slate-200 rounded-md" />
              <div className="h-16 w-full bg-slate-100 rounded-2xl" />
              <div className="h-16 w-full bg-slate-100 rounded-2xl" />
            </div>
          ))}
        </div>
      </CheckoutLayout>
    );
  }

  if (stateStatus === StateType.error) {
    return (
      <CheckoutLayout title="Gagal Memuat Saluran">
        <div className="flex flex-col items-center justify-center py-16 text-center space-y-4">
          <div className="w-14 h-14 rounded-2xl bg-rose-50 text-rose-500 flex items-center justify-center shadow-xs">
            <AlertCircle className="w-7 h-7" />
          </div>
          <div className="space-y-1">
            <h2 className="text-base font-bold text-slate-900">Saluran Tidak Tersedia</h2>
            <p className="text-xs text-slate-500 max-w-xs">Gagal memuat metode pembayaran yang tersedia.</p>
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

  return (
    <CheckoutLayout
      title="Pilih Pembayaran"
      subtitle="Pilih saluran pembayaran yang Anda inginkan"
      headerRight={
        <button
          type="button"
          onClick={() => router.back()}
          className="p-2 rounded-xl border border-slate-200/80 bg-slate-50 text-slate-600 hover:bg-slate-100 transition cursor-pointer"
          title="Kembali ke Ringkasan"
        >
          <ArrowLeft className="w-4 h-4" />
        </button>
      }
    >
      <div className="space-y-5">
        {categories.length === 0 ? (
          <div className="p-8 text-center border-2 border-dashed border-slate-200 rounded-2xl space-y-2.5 bg-slate-50/50">
            <CreditCard className="w-8 h-8 mx-auto text-slate-300" />
            <p className="text-xs font-bold text-slate-700">Tidak ada saluran pembayaran aktif</p>
            <p className="text-[11px] text-slate-400">Silakan hubungi pemilik merchant untuk mengaktifkan saluran pembayaran.</p>
          </div>
        ) : (
          categories.map((category) => (
            <div key={category.id || category.key} className="space-y-2.5">
              <div className="px-1 flex items-center gap-2">
                <span className="w-1.5 h-3.5 rounded-full bg-sky-600" />
                <h3 className="text-xs font-extrabold text-slate-900 uppercase tracking-wider">
                  {category.title || category.key}
                </h3>
              </div>

              <div className="space-y-2">
                {category.paymentMethods?.map((method) => {
                  const logo = getEffectiveLogo(method);
                  const isSelected = selectedMethodKey === method.key;

                  return (
                    <button
                      key={method.id || method.key}
                      type="button"
                      disabled={submitting}
                      onClick={() => handleSelectMethod(method)}
                      className={`w-full p-3.5 rounded-2xl border flex items-center justify-between text-left transition-all cursor-pointer ${
                        isSelected
                          ? "border-sky-500 bg-sky-50/60 ring-2 ring-sky-500/20 shadow-xs"
                          : "border-slate-200/90 bg-white hover:border-slate-300 hover:bg-slate-50/40 hover:shadow-2xs active:scale-[0.99]"
                      }`}
                    >
                      <div className="flex items-center gap-3.5">
                        <div className="w-12 h-9 rounded-xl border border-slate-200 bg-white flex items-center justify-center p-1.5 shrink-0 overflow-hidden shadow-2xs">
                          {logo ? (
                            <Image
                              src={logo}
                              alt={method.name || "Payment"}
                              width={40}
                              height={28}
                              className="max-h-full max-w-full object-contain"
                              unoptimized
                            />
                          ) : (
                            <CreditCard className="w-4 h-4 text-slate-400" />
                          )}
                        </div>

                        <div className="space-y-0.5">
                          <p className="text-xs font-extrabold text-slate-900 leading-snug">
                            {method.name || method.key}
                          </p>
                          {method.bankCode && (
                            <span className="text-[10px] font-mono font-bold uppercase px-1.5 py-0.5 rounded-md bg-slate-100 text-slate-600 inline-block">
                              {method.bankCode}
                            </span>
                          )}
                        </div>
                      </div>

                      <div className="text-slate-300 pl-2">
                        {isSelected && submitting ? (
                          <div className="w-4 h-4 border-2 border-sky-500/20 border-t-sky-600 rounded-full animate-spin" />
                        ) : (
                          <ChevronRight className="w-4 h-4 text-slate-400" />
                        )}
                      </div>
                    </button>
                  );
                })}
              </div>
            </div>
          ))
        )}

        <div className="pt-3 border-t border-slate-100 flex items-center justify-center gap-1.5 text-[11px] text-slate-400 font-medium">
          <ShieldCheck className="w-3.5 h-3.5 text-emerald-500" />
          <span>Transaksi Anda dienkripsi dengan standar SNAP & PCI-DSS</span>
        </div>
      </div>
    </CheckoutLayout>
  );
}
