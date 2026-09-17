import React from "react";
import Image from "next/image";
import { QRCodeSVG } from "qrcode.react";
import { useDetailPaymentLogic } from "./detail_payment_logic";
import { PaymentInstructions } from "./payment_instructions";
import { CheckoutLayout } from "@/shared/component/layouts/CheckoutLayout";
import { StateType } from "@/shared/domain/model/state_model";
import { Format } from "@/shared/utils/format";
import { OrderStatus } from "../../domain/model/enum/order_status";
import { getEffectiveLogo } from "../../domain/model/response/payment_method_response";
import {
  CheckCircle2,
  XCircle,
  Clock,
  Copy,
  Download,
  RefreshCw,
  AlertCircle,
  Building2,
  QrCode,
  ShieldCheck,
  Zap,
} from "lucide-react";

export function DetailPaymentUI() {
  const {
    order,
    status,
    stateStatus,
    qrString,
    vaNumber,
    checkingStatus,
    remainingSeconds,
    isSocketConnected,
    reference,
    parsed,
    handleCheckStatus,
    handleCopy,
    refetch,
  } = useDetailPaymentLogic();

  if (stateStatus === StateType.loading || stateStatus === StateType.initial) {
    return (
      <CheckoutLayout title="Memuat Pembayaran">
        <div className="flex flex-col items-center justify-center py-24 space-y-4">
          <div className="w-10 h-10 border-3 border-sky-500/20 border-t-sky-600 rounded-full animate-spin" />
          <p className="text-xs font-medium text-slate-500">Memuat rincian transaksi...</p>
        </div>
      </CheckoutLayout>
    );
  }

  if (stateStatus === StateType.error) {
    return (
      <CheckoutLayout title="Transaksi Tidak Ditemukan">
        <div className="flex flex-col items-center justify-center py-16 text-center space-y-4">
          <div className="w-14 h-14 rounded-full bg-rose-50 text-rose-500 flex items-center justify-center">
            <AlertCircle className="w-7 h-7" />
          </div>
          <div className="space-y-1">
            <h2 className="text-base font-bold text-slate-900">Gagal Memuat Transaksi</h2>
            <p className="text-xs text-slate-500 max-w-xs">Pastikan nomor referensi dan sesi token valid.</p>
          </div>
          <button
            onClick={refetch}
            className="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-slate-900 text-white text-xs font-bold hover:bg-slate-800 transition shadow-sm cursor-pointer"
          >
            <RefreshCw className="w-3.5 h-3.5" /> Coba Lagi
          </button>
        </div>
      </CheckoutLayout>
    );
  }

  const isSuccess = status === OrderStatus.SUCCESS;
  const isFailed = status === OrderStatus.FAILED;
  const isExpired = status === OrderStatus.EXPIRED;
  const isPending = !isSuccess && !isFailed && !isExpired;

  const paymentMethod = order?.payment_methods;
  const logo = paymentMethod ? getEffectiveLogo(paymentMethod) : "";
  const channelName = paymentMethod?.name || order?.payment_method || "Metode Pembayaran";

  const handleDownloadQR = () => {
    const svg = document.getElementById("qris-qr-code");
    if (!svg) return;
    const svgData = new XMLSerializer().serializeToString(svg);
    const canvas = document.createElement("canvas");
    const ctx = canvas.getContext("2d");
    const img = new window.Image();
    img.onload = () => {
      canvas.width = img.width;
      canvas.height = img.height;
      ctx?.drawImage(img, 0, 0);
      const pngFile = canvas.toDataURL("image/png");
      const downloadLink = document.createElement("a");
      downloadLink.download = `QRIS-${reference}.png`;
      downloadLink.href = pngFile;
      downloadLink.click();
    };
    img.src = "data:image/svg+xml;base64," + btoa(svgData);
  };

  const footerAction = isPending ? (
    <button
      type="button"
      disabled={checkingStatus}
      onClick={() => handleCheckStatus(true)}
      className="w-full py-3.5 px-4 rounded-2xl bg-sky-600 hover:bg-sky-700 active:scale-[0.99] text-white text-xs font-extrabold flex items-center justify-center gap-2 shadow-lg shadow-sky-600/25 transition-all cursor-pointer"
    >
      <RefreshCw className={`w-4 h-4 ${checkingStatus ? "animate-spin" : ""}`} />
      <span>{checkingStatus ? "Sedang Mengecek Pembayaran..." : "Cek Status Pembayaran"}</span>
    </button>
  ) : isSuccess ? (
    <div className="py-2 text-center text-xs font-semibold text-emerald-700 flex items-center justify-center gap-1.5">
      <CheckCircle2 className="w-4 h-4" />
      <span>Transaksi Telah Terverifikasi Sukses</span>
    </div>
  ) : null;

  return (
    <CheckoutLayout
      title="Selesaikan Pembayaran"
      subtitle={order?.project?.name || "Payment Verification"}
      headerRight={
        <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-slate-100 border border-slate-200/80 text-[11px] font-semibold">
          <span
            className={`w-2 h-2 rounded-full ${
              isSocketConnected
                ? "bg-emerald-500 animate-pulse shadow-xs shadow-emerald-500"
                : "bg-amber-500"
            }`}
          />
          <span className="text-slate-700 flex items-center gap-1">
            <Zap className="w-3 h-3 text-sky-500" />
            {isSocketConnected ? "Live Sync" : "Auto Polling"}
          </span>
        </div>
      }
      footer={footerAction}
    >
      {/* Selected Channel Bar */}
      <div className="p-3.5 rounded-2xl border border-slate-200/90 bg-slate-50/80 backdrop-blur-xs flex items-center justify-between shadow-xs">
        <div className="flex items-center gap-3">
          <div className="w-12 h-9 rounded-xl border border-slate-200 bg-white flex items-center justify-center p-1 shrink-0 overflow-hidden shadow-xs">
            {logo ? (
              <Image
                src={logo}
                alt={channelName}
                width={40}
                height={28}
                className="max-h-full max-w-full object-contain"
                unoptimized
              />
            ) : (
              <Building2 className="w-5 h-5 text-slate-400" />
            )}
          </div>
          <div>
            <p className="text-xs font-extrabold text-slate-900 leading-tight">{channelName}</p>
            <p className="text-[10px] font-mono font-medium text-slate-400 mt-0.5">{reference}</p>
          </div>
        </div>

        <div>
          {isSuccess && (
            <span className="inline-flex items-center gap-1 px-3 py-1 rounded-full text-[11px] font-extrabold bg-emerald-100 text-emerald-800 shadow-xs">
              <CheckCircle2 className="w-3.5 h-3.5" />
              Lunas
            </span>
          )}
          {isPending && (
            <div className="text-right flex flex-col items-end gap-0.5">
              <span className="text-xs font-black text-slate-900">{Format.rupiah(parsed.amount)}</span>
              <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-extrabold bg-amber-100 text-amber-900 shadow-xs">
                <Clock className="w-3 h-3" />
                Menunggu
              </span>
            </div>
          )}
          {(isFailed || isExpired) && (
            <span className="inline-flex items-center gap-1 px-3 py-1 rounded-full text-[11px] font-extrabold bg-rose-100 text-rose-800 shadow-xs">
              <XCircle className="w-3.5 h-3.5" />
              {isExpired ? "Kadaluarsa" : "Gagal"}
            </span>
          )}
        </div>
      </div>

      {/* Success View */}
      {isSuccess && (
        <div className="p-6 rounded-3xl bg-gradient-to-b from-emerald-50/80 to-emerald-50/30 border border-emerald-200/80 text-center space-y-4 shadow-xs">
          <div className="w-16 h-16 rounded-2xl bg-emerald-500 text-white flex items-center justify-center mx-auto shadow-lg shadow-emerald-500/30">
            <CheckCircle2 className="w-9 h-9 stroke-[2.5]" />
          </div>
          <div className="space-y-1">
            <h3 className="text-lg font-extrabold text-slate-900 tracking-tight">Pembayaran Sukses!</h3>
            <p className="text-xs text-slate-600">
              Transaksi Anda telah berhasil diverifikasi secara otomatis.
            </p>
          </div>

          <div className="p-4 rounded-2xl bg-white border border-emerald-100/90 text-xs space-y-2.5 text-left shadow-xs">
            <div className="flex justify-between items-center text-slate-500">
              <span>Nomor Referensi</span>
              <span className="font-mono font-bold text-slate-900">{reference}</span>
            </div>
            <div className="flex justify-between items-center text-slate-500 pt-2 border-t border-slate-50">
              <span>Metode Pembayaran</span>
              <span className="font-bold text-slate-900">{channelName}</span>
            </div>
            <div className="flex justify-between items-center text-slate-500 pt-2 border-t border-slate-50">
              <span>Total Terbayar</span>
              <span className="font-extrabold text-base text-emerald-600">{Format.rupiah(parsed.amount)}</span>
            </div>
            <div className="flex justify-between items-center text-slate-500 pt-2 border-t border-slate-50">
              <span>Waktu Selesai</span>
              <span className="font-medium text-slate-700">{Format.dateTime(order?.updated_at || new Date())}</span>
            </div>
          </div>
        </div>
      )}

      {/* Failed / Expired View */}
      {(isFailed || isExpired) && (
        <div className="p-6 rounded-3xl bg-gradient-to-b from-rose-50/80 to-rose-50/30 border border-rose-200/80 text-center space-y-3.5 shadow-xs">
          <div className="w-16 h-16 rounded-2xl bg-rose-500 text-white flex items-center justify-center mx-auto shadow-lg shadow-rose-500/30">
            <XCircle className="w-9 h-9 stroke-[2.5]" />
          </div>
          <div className="space-y-1">
            <h3 className="text-lg font-extrabold text-slate-900 tracking-tight">
              {isExpired ? "Waktu Pembayaran Habis" : "Pembayaran Dibatalkan"}
            </h3>
            <p className="text-xs text-slate-600">
              Batas waktu pembayaran untuk pesanan ini telah berakhir.
            </p>
          </div>
        </div>
      )}

      {/* Pending Active Payment Content */}
      {isPending && (
        <div className="space-y-4">
          {/* Countdown Pill Card */}
          <div className="p-3 rounded-2xl bg-gradient-to-r from-amber-50 to-orange-50 border border-amber-200/70 flex items-center justify-between text-xs text-amber-950 shadow-xs">
            <div className="flex items-center gap-2 font-medium">
              <Clock className="w-4 h-4 text-amber-600 shrink-0" />
              <div>
                <span>Selesaikan dalam</span>
                {parsed.expiredAt && (
                  <p className="text-[10px] text-amber-800/80 font-normal">
                    Jatuh tempo: {Format.dateTime(parsed.expiredAt)}
                  </p>
                )}
              </div>
            </div>
            <span className="font-mono font-extrabold text-sm text-amber-700 tracking-wider shrink-0">
              {Format.countdown(remainingSeconds)}
            </span>
          </div>

          {/* QRIS Display Card */}
          {qrString && (
            <div className="p-6 rounded-3xl border border-slate-200/90 bg-white text-center space-y-4 shadow-sm">
              <div className="flex items-center justify-center gap-1.5 text-xs font-bold text-slate-800">
                <QrCode className="w-4 h-4 text-sky-600" />
                <span>Scan Kode QRIS di Bawah Ini</span>
              </div>

              <div className="p-3.5 bg-white rounded-2xl inline-block border-2 border-slate-100 shadow-md">
                <QRCodeSVG
                  id="qris-qr-code"
                  value={qrString}
                  size={210}
                  level="M"
                  includeMargin
                  className="mx-auto"
                />
              </div>

              <p className="text-[11px] text-slate-400 max-w-[260px] mx-auto leading-relaxed">
                Buka aplikasi e-Wallet atau m-Banking pilihan Anda yang mendukung scan QRIS (GoPay, OVO, DANA, BCA, dll).
              </p>

              <div className="flex justify-center pt-1">
                <button
                  type="button"
                  onClick={handleDownloadQR}
                  className="px-4 py-2 rounded-xl border border-slate-200 text-slate-700 text-xs font-bold hover:bg-slate-50 flex items-center gap-1.5 transition cursor-pointer shadow-2xs"
                >
                  <Download className="w-3.5 h-3.5" />
                  <span>Unduh QR</span>
                </button>
              </div>

              <div className="pt-3 border-t border-slate-100 flex items-center justify-between text-left">
                <div>
                  <p className="text-[11px] font-medium text-slate-400 uppercase tracking-wider">
                    Total Tagihan
                  </p>
                  <p className="text-base font-black text-slate-900 mt-0.5">{Format.rupiah(parsed.amount)}</p>
                </div>
                <button
                  type="button"
                  onClick={() => handleCopy(String(parsed.amount), "Nominal Tagihan")}
                  className="px-3 py-1.5 rounded-xl border border-slate-200 text-slate-700 hover:bg-slate-50 text-xs font-semibold flex items-center gap-1.5 transition cursor-pointer shadow-2xs"
                >
                  <Copy className="w-3 h-3" />
                  <span>Salin Jumlah</span>
                </button>
              </div>
            </div>
          )}

          {/* Virtual Account Number Card */}
          {vaNumber && (
            <div className="p-5 rounded-3xl border border-slate-200/90 bg-white space-y-4 shadow-sm">
              <div>
                <p className="text-[11px] font-bold text-slate-400 uppercase tracking-wider">
                  Nomor Virtual Account
                </p>
                <div className="flex items-center justify-between mt-1.5 p-3 rounded-2xl bg-slate-50 border border-slate-100">
                  <span className="text-xl sm:text-2xl font-mono font-black text-slate-900 tracking-wider select-all">
                    {vaNumber}
                  </span>
                  <button
                    type="button"
                    onClick={() => handleCopy(vaNumber, "Nomor VA")}
                    className="px-3.5 py-1.5 rounded-xl bg-sky-600 hover:bg-sky-700 active:scale-95 text-white text-xs font-bold flex items-center gap-1.5 transition cursor-pointer shadow-xs shadow-sky-600/20"
                  >
                    <Copy className="w-3.5 h-3.5" />
                    <span>Salin</span>
                  </button>
                </div>
              </div>

              <div className="pt-3 border-t border-slate-100 flex items-center justify-between">
                <div>
                  <p className="text-[11px] font-medium text-slate-400 uppercase tracking-wider">
                    Total Tagihan
                  </p>
                  <p className="text-lg font-black text-slate-900 mt-0.5">{Format.rupiah(parsed.amount)}</p>
                </div>
                <button
                  type="button"
                  onClick={() => handleCopy(String(parsed.amount), "Nominal Tagihan")}
                  className="px-3 py-1.5 rounded-xl border border-slate-200 text-slate-700 hover:bg-slate-50 text-xs font-semibold flex items-center gap-1.5 transition cursor-pointer shadow-2xs"
                >
                  <Copy className="w-3 h-3" />
                  <span>Salin Jumlah</span>
                </button>
              </div>
            </div>
          )}

          {/* Payment Instructions (berdasarkan payment category) */}
          <PaymentInstructions
            categoryKey={
              order?.payment_methods?.category?.key ||
              order?.payment_methods?.type ||
              null
            }
            vaNumber={vaNumber}
            amount={parsed.amount}
            reference={reference}
          />

          <div className="pt-2 flex items-center justify-center gap-1.5 text-[11px] text-slate-400 font-medium">
            <ShieldCheck className="w-3.5 h-3.5 text-emerald-500" />
            <span>Sistem memantau verifikasi otomatis secara realtime</span>
          </div>
        </div>
      )}
    </CheckoutLayout>
  );
}
