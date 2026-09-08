import React, { useState } from "react";
import Image from "next/image";
import { QRCodeSVG } from "qrcode.react";
import { useDetailPaymentLogic } from "./detail_payment_logic";
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
  ExternalLink,
  ChevronDown,
  RefreshCw,
  AlertCircle,
  Building2,
  QrCode,
  ShieldCheck,
} from "lucide-react";

export function DetailPaymentUI() {
  const {
    order,
    status,
    stateStatus,
    qrString,
    vaNumber,
    checkoutUrl,
    checkingStatus,
    remainingSeconds,
    reference,
    parsed,
    handleCheckStatus,
    handleCopy,
    refetch,
  } = useDetailPaymentLogic();

  const [activeAccordion, setActiveAccordion] = useState<string | null>("atm");

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
            className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-slate-900 text-white text-xs font-semibold hover:bg-slate-800 transition"
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
    <div className="flex gap-2.5">
      <button
        type="button"
        disabled={checkingStatus}
        onClick={() => handleCheckStatus(true)}
        className="flex-1 py-3 px-4 rounded-xl border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 text-xs font-bold flex items-center justify-center gap-2 transition cursor-pointer"
      >
        <RefreshCw className={`w-3.5 h-3.5 ${checkingStatus ? "animate-spin" : ""}`} />
        <span>{checkingStatus ? "Mengecek..." : "Cek Status"}</span>
      </button>

      {order?.project?.callback && (
        <a
          href={order.project.callback}
          className="flex-1 py-3 px-4 rounded-xl bg-slate-900 hover:bg-slate-800 text-white text-xs font-bold flex items-center justify-center gap-1.5 transition text-center"
        >
          <span>Kembali</span>
        </a>
      )}
    </div>
  ) : (
    <a
      href={order?.project?.callback || "/"}
      className={`w-full py-3.5 px-4 rounded-xl text-white text-xs font-bold flex items-center justify-center gap-2 transition text-center ${
        isSuccess ? "bg-emerald-600 hover:bg-emerald-700" : "bg-slate-900 hover:bg-slate-800"
      }`}
    >
      <span>Selesai & Kembali ke Merchant</span>
    </a>
  );

  return (
    <CheckoutLayout
      title="Status Pembayaran"
      subtitle={order?.project?.name || "Payment Verification"}
      footer={footerAction}
    >
      {/* Selected Channel Bar */}
      <div className="p-3.5 rounded-xl border border-slate-200 bg-slate-50 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-10 h-8 rounded-lg border border-slate-200 bg-white flex items-center justify-center p-1 shrink-0 overflow-hidden">
            {logo ? (
              <Image
                src={logo}
                alt={channelName}
                width={36}
                height={24}
                className="max-h-full max-w-full object-contain"
                unoptimized
              />
            ) : (
              <Building2 className="w-4 h-4 text-slate-400" />
            )}
          </div>
          <div>
            <p className="text-xs font-bold text-slate-800 leading-tight">{channelName}</p>
            <p className="text-[11px] font-mono text-slate-400">{reference}</p>
          </div>
        </div>

        <div>
          {isSuccess && (
            <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-bold bg-emerald-100 text-emerald-800">
              <CheckCircle2 className="w-3.5 h-3.5" />
              Lunas
            </span>
          )}
          {isPending && (
            <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-bold bg-amber-100 text-amber-800">
              <Clock className="w-3.5 h-3.5" />
              Menunggu
            </span>
          )}
          {(isFailed || isExpired) && (
            <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-bold bg-rose-100 text-rose-800">
              <XCircle className="w-3.5 h-3.5" />
              {isExpired ? "Kadaluarsa" : "Gagal"}
            </span>
          )}
        </div>
      </div>

      {/* Success View */}
      {isSuccess && (
        <div className="p-6 rounded-2xl bg-emerald-50/60 border border-emerald-100 text-center space-y-4">
          <div className="w-14 h-14 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto shadow-sm">
            <CheckCircle2 className="w-8 h-8" />
          </div>
          <div className="space-y-1">
            <h3 className="text-base font-extrabold text-emerald-950">Pembayaran Berhasil!</h3>
            <p className="text-xs text-emerald-700">
              Transaksi telah diverifikasi secara otomatis oleh sistem.
            </p>
          </div>
          <div className="p-3.5 rounded-xl bg-white border border-emerald-100 text-xs space-y-2 text-left">
            <div className="flex justify-between text-slate-500">
              <span>Nomor Referensi</span>
              <span className="font-mono font-bold text-slate-800">{reference}</span>
            </div>
            <div className="flex justify-between text-slate-500">
              <span>Total Terbayar</span>
              <span className="font-extrabold text-slate-900">{Format.rupiah(parsed.amount)}</span>
            </div>
            <div className="flex justify-between text-slate-500">
              <span>Waktu Selesai</span>
              <span className="font-medium text-slate-800">{Format.dateTime(order?.updated_at || new Date())}</span>
            </div>
          </div>
        </div>
      )}

      {/* Failed / Expired View */}
      {(isFailed || isExpired) && (
        <div className="p-6 rounded-2xl bg-rose-50/60 border border-rose-100 text-center space-y-3">
          <div className="w-14 h-14 rounded-full bg-rose-100 text-rose-600 flex items-center justify-center mx-auto">
            <XCircle className="w-8 h-8" />
          </div>
          <div className="space-y-1">
            <h3 className="text-base font-extrabold text-rose-950">
              {isExpired ? "Pembayaran Kadaluarsa" : "Pembayaran Gagal"}
            </h3>
            <p className="text-xs text-rose-700">
              Waktu batas pembayaran telah habis atau transaksi dibatalkan.
            </p>
          </div>
        </div>
      )}

      {/* Pending Active Payment Content */}
      {isPending && (
        <div className="space-y-4">
          {/* Countdown Card */}
          <div className="p-3 rounded-xl bg-amber-50/70 border border-amber-200/60 flex items-center justify-between text-xs text-amber-900">
            <div className="flex items-center gap-2">
              <Clock className="w-4 h-4 text-amber-600" />
              <span>Selesaikan dalam</span>
            </div>
            <span className="font-mono font-bold text-sm text-amber-700">
              {Format.countdown(remainingSeconds)}
            </span>
          </div>

          {/* QRIS Display */}
          {qrString && (
            <div className="p-5 rounded-2xl border border-slate-200 bg-white text-center space-y-3.5 shadow-xs">
              <div className="flex items-center justify-center gap-1.5 text-xs font-bold text-slate-700">
                <QrCode className="w-4 h-4 text-sky-600" />
                <span>Scan QRIS untuk Membayar</span>
              </div>

              <div className="p-3 bg-white rounded-xl inline-block border border-slate-100 shadow-sm">
                <QRCodeSVG
                  id="qris-qr-code"
                  value={qrString}
                  size={200}
                  level="M"
                  includeMargin
                  className="mx-auto"
                />
              </div>

              <div className="flex gap-2 justify-center pt-1">
                <button
                  type="button"
                  onClick={handleDownloadQR}
                  className="px-3 py-1.5 rounded-lg border border-slate-200 text-slate-700 text-xs font-semibold hover:bg-slate-50 flex items-center gap-1.5 transition cursor-pointer"
                >
                  <Download className="w-3.5 h-3.5" />
                  <span>Unduh QR</span>
                </button>
                <button
                  type="button"
                  onClick={() => handleCopy(qrString, "Kode QR")}
                  className="px-3 py-1.5 rounded-lg border border-slate-200 text-slate-700 text-xs font-semibold hover:bg-slate-50 flex items-center gap-1.5 transition cursor-pointer"
                >
                  <Copy className="w-3.5 h-3.5" />
                  <span>Salin Teks</span>
                </button>
              </div>
            </div>
          )}

          {/* Virtual Account Number Display */}
          {vaNumber && (
            <div className="p-4 rounded-xl border border-slate-200 bg-white space-y-3 shadow-xs">
              <div>
                <p className="text-[11px] font-medium text-slate-400 uppercase tracking-wide">
                  Nomor Virtual Account
                </p>
                <div className="flex items-center justify-between mt-1">
                  <span className="text-xl font-mono font-extrabold text-slate-900 tracking-wider">
                    {vaNumber}
                  </span>
                  <button
                    type="button"
                    onClick={() => handleCopy(vaNumber, "Nomor VA")}
                    className="px-3 py-1.5 rounded-lg bg-sky-50 text-sky-700 hover:bg-sky-100 text-xs font-bold flex items-center gap-1.5 transition cursor-pointer"
                  >
                    <Copy className="w-3.5 h-3.5" />
                    <span>Salin</span>
                  </button>
                </div>
              </div>

              <div className="pt-3 border-t border-slate-100 flex items-center justify-between">
                <div>
                  <p className="text-[11px] font-medium text-slate-400 uppercase tracking-wide">
                    Total Tagihan
                  </p>
                  <p className="text-base font-bold text-slate-900">{Format.rupiah(parsed.amount)}</p>
                </div>
                <button
                  type="button"
                  onClick={() => handleCopy(String(parsed.amount), "Nominal")}
                  className="px-2.5 py-1 rounded-lg border border-slate-200 text-slate-600 hover:bg-slate-50 text-[11px] font-medium flex items-center gap-1 transition cursor-pointer"
                >
                  <Copy className="w-3 h-3" />
                  <span>Salin</span>
                </button>
              </div>
            </div>
          )}

          {/* Checkout URL / Hosted Link */}
          {checkoutUrl && (
            <div className="p-4 rounded-xl border border-sky-100 bg-sky-50/50 space-y-3">
              <div className="space-y-1">
                <p className="text-xs font-bold text-sky-950">Lanjutkan Pembayaran Eksternal</p>
                <p className="text-[11px] text-sky-700">
                  Saluran ini memerlukan interaksi pada halaman resmi penyedia pembayaran.
                </p>
              </div>
              <a
                href={checkoutUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="w-full py-2.5 px-4 rounded-xl bg-sky-600 hover:bg-sky-700 text-white text-xs font-bold flex items-center justify-center gap-2 transition"
              >
                <span>Buka Halaman Pembayaran</span>
                <ExternalLink className="w-3.5 h-3.5" />
              </a>
            </div>
          )}

          {/* Payment Instructions Accordion */}
          <div className="space-y-2 pt-1">
            <p className="text-xs font-bold text-slate-900 uppercase tracking-wide px-1">
              Petunjuk Pembayaran
            </p>

            <div className="border border-slate-200 rounded-xl overflow-hidden divide-y divide-slate-100 bg-white text-xs">
              {/* ATM */}
              <div>
                <button
                  type="button"
                  onClick={() => setActiveAccordion(activeAccordion === "atm" ? null : "atm")}
                  className="w-full px-4 py-3 flex items-center justify-between text-left font-semibold text-slate-800 hover:bg-slate-50 transition cursor-pointer"
                >
                  <span>Transfer melalui ATM</span>
                  <ChevronDown
                    className={`w-4 h-4 text-slate-400 transition-transform ${
                      activeAccordion === "atm" ? "rotate-180" : ""
                    }`}
                  />
                </button>
                {activeAccordion === "atm" && (
                  <div className="px-4 pb-3 pt-1 text-slate-600 space-y-1 text-[11px] leading-relaxed">
                    <p>1. Masukkan kartu ATM dan 6 digit PIN Anda.</p>
                    <p>2. Pilih menu <strong>Transaksi Lainnya</strong> &gt; <strong>Transfer</strong> &gt; <strong>Ke Rekening Virtual Account</strong>.</p>
                    <p>3. Masukkan nomor Virtual Account: <strong className="font-mono">{vaNumber || "sesuai tagihan"}</strong>.</p>
                    <p>4. Masukkan jumlah bayar persis: <strong>{Format.rupiah(parsed.amount)}</strong>.</p>
                    <p>5. Konfirmasi rincian transaksi lalu simpan struk pembayaran.</p>
                  </div>
                )}
              </div>

              {/* Mobile Banking */}
              <div>
                <button
                  type="button"
                  onClick={() => setActiveAccordion(activeAccordion === "m-banking" ? null : "m-banking")}
                  className="w-full px-4 py-3 flex items-center justify-between text-left font-semibold text-slate-800 hover:bg-slate-50 transition cursor-pointer"
                >
                  <span>Transfer melalui Mobile Banking</span>
                  <ChevronDown
                    className={`w-4 h-4 text-slate-400 transition-transform ${
                      activeAccordion === "m-banking" ? "rotate-180" : ""
                    }`}
                  />
                </button>
                {activeAccordion === "m-banking" && (
                  <div className="px-4 pb-3 pt-1 text-slate-600 space-y-1 text-[11px] leading-relaxed">
                    <p>1. Buka aplikasi m-Banking di smartphone Anda.</p>
                    <p>2. Pilih menu <strong>Transfer</strong> atau <strong>Bayar / Tagihan</strong>.</p>
                    <p>3. Pilih saluran <strong>Virtual Account</strong>.</p>
                    <p>4. Masukkan nomor Virtual Account: <strong className="font-mono">{vaNumber || "sesuai tagihan"}</strong>.</p>
                    <p>5. Pastikan nama dan nominal sesuai, lalu masukkan PIN m-Banking Anda.</p>
                  </div>
                )}
              </div>

              {/* Internet Banking */}
              <div>
                <button
                  type="button"
                  onClick={() => setActiveAccordion(activeAccordion === "i-banking" ? null : "i-banking")}
                  className="w-full px-4 py-3 flex items-center justify-between text-left font-semibold text-slate-800 hover:bg-slate-50 transition cursor-pointer"
                >
                  <span>Transfer melalui Internet Banking</span>
                  <ChevronDown
                    className={`w-4 h-4 text-slate-400 transition-transform ${
                      activeAccordion === "i-banking" ? "rotate-180" : ""
                    }`}
                  />
                </button>
                {activeAccordion === "i-banking" && (
                  <div className="px-4 pb-3 pt-1 text-slate-600 space-y-1 text-[11px] leading-relaxed">
                    <p>1. Login ke akun Internet Banking Anda.</p>
                    <p>2. Pilih menu pembayaran tagihan / Virtual Account.</p>
                    <p>3. Masukkan kode Virtual Account lalu klik Lanjutkan.</p>
                    <p>4. Masukkan respon token autentikasi (KeyBCA/Token).</p>
                    <p>5. Transaksi selesai dan status otomatis terverifikasi.</p>
                  </div>
                )}
              </div>
            </div>
          </div>

          <div className="pt-2 flex items-center justify-center gap-1.5 text-[11px] text-slate-400 font-medium">
            <ShieldCheck className="w-3.5 h-3.5 text-emerald-500" />
            <span>Verifikasi pembayaran otomatis berjalan secara realtime</span>
          </div>
        </div>
      )}
    </CheckoutLayout>
  );
}
