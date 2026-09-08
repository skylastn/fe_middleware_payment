import React, { useState } from "react";
import {
  ChevronDown,
  CreditCard,
  Info,
  Landmark,
  MonitorSmartphone,
  QrCode,
  Smartphone,
  Store,
  Wallet,
} from "lucide-react";
import { fromCategoryKey, PaymentCategoryKey } from "../../domain/model/enum/payment_category_key";
import { Format } from "@/shared/utils/format";

interface PaymentInstructionsProps {
  categoryKey?: string | null;
  vaNumber?: string | null;
  amount: number;
  reference: string;
}

function StepList({ steps }: { steps: React.ReactNode[] }) {
  return (
    <div className="p-4 pt-1 space-y-3">
      {steps.map((step, index) => (
        <div key={index} className="flex items-start gap-2.5">
          <span className="mt-px w-5 h-5 shrink-0 rounded-full bg-sky-100 text-sky-700 text-[10px] font-extrabold flex items-center justify-center">
            {index + 1}
          </span>
          <p className="text-[11px] leading-relaxed text-slate-600 pt-0.5">{step}</p>
        </div>
      ))}
    </div>
  );
}

interface AccordionItemProps {
  title: string;
  icon: React.ReactNode;
  open: boolean;
  onToggle: () => void;
  children: React.ReactNode;
}

function AccordionItem({ title, icon, open, onToggle, children }: AccordionItemProps) {
  return (
    <div>
      <button
        type="button"
        onClick={onToggle}
        className="w-full px-4 py-3.5 flex items-center justify-between text-left font-bold text-slate-800 hover:bg-slate-50 transition cursor-pointer"
      >
        <span className="flex items-center gap-2.5">
          {icon}
          <span>{title}</span>
        </span>
        <ChevronDown
          className={`w-4 h-4 text-slate-400 transition-transform duration-200 ${
            open ? "rotate-180 text-sky-600" : ""
          }`}
        />
      </button>
      {open && (
        <div className="px-4 pb-4 pt-1 text-slate-600 space-y-1.5 text-[11px] leading-relaxed bg-slate-50/40">
          {children}
        </div>
      )}
    </div>
  );
}

export function PaymentInstructions({
  categoryKey,
  vaNumber,
  amount,
  reference,
}: PaymentInstructionsProps) {
  const category = fromCategoryKey(categoryKey);
  const [activeChannel, setActiveChannel] = useState<string>("atm");

  const toggleChannel = (key: string) => {
    setActiveChannel((prev) => (prev === key ? "" : key));
  };

  const number = vaNumber || "sesuai instruksi";
  const nominal = Format.rupiah(amount);

  const sectionHeading = (
    <p className="text-xs font-extrabold text-slate-900 uppercase tracking-wide px-1">
      Petunjuk Pembayaran
    </p>
  );

  if (category === PaymentCategoryKey.QRIS) {
    return (
      <div className="space-y-2 pt-1">
        {sectionHeading}
        <div className="border border-slate-200/90 rounded-2xl overflow-hidden bg-white text-xs shadow-2xs">
          <div className="px-4 pt-4 flex items-center gap-2.5">
            <span className="w-7 h-7 rounded-xl bg-sky-50 text-sky-600 flex items-center justify-center shrink-0">
              <QrCode className="w-4 h-4" />
            </span>
            <p className="text-xs font-extrabold text-slate-800">Cara Bayar Menggunakan QRIS</p>
          </div>
          <StepList
            steps={[
              <>Buka aplikasi <strong>m-banking</strong> atau <strong>e-wallet</strong> yang mendukung QRIS (BCA mobile, GoPay, OVO, DANA, ShopeePay, LinkAja, dll).</>,
              <>Pilih menu <strong>Scan / QRIS / Bayar</strong> pada aplikasi.</>,
              <>Arahkan kamera untuk memindai <strong>kode QR</strong> di atas.</>,
              <>Periksa kembali nominal tagihan <strong className="text-slate-900">{nominal}</strong> dan nama merchant sudah sesuai.</>,
              <>Konfirmasi pembayaran dengan <strong>PIN / autentikasi</strong> aplikasi Anda.</>,
              <>Pembayaran selesai. Status transaksi diverifikasi otomatis secara realtime.</>,
            ]}
          />
        </div>
      </div>
    );
  }

  if (category === PaymentCategoryKey.VA) {
    return (
      <div className="space-y-2 pt-1">
        {sectionHeading}
        <div className="border border-slate-200/90 rounded-2xl overflow-hidden divide-y divide-slate-100 bg-white text-xs shadow-2xs">
          <AccordionItem
            title="Transfer melalui ATM"
            icon={<Landmark className="w-4 h-4 text-sky-600" />}
            open={activeChannel === "atm"}
            onToggle={() => toggleChannel("atm")}
          >
            <p>1. Masukkan kartu ATM dan 6 digit PIN Anda.</p>
            <p>
              2. Pilih menu <strong>Transaksi Lainnya</strong> &gt; <strong>Transfer</strong> &gt;{" "}
              <strong>Ke Rekening Virtual Account</strong>.
            </p>
            <p>
              3. Masukkan nomor Virtual Account:{" "}
              <strong className="font-mono text-slate-900 font-bold">{number}</strong>.
            </p>
            <p>
              4. Masukkan jumlah bayar persis:{" "}
              <strong className="text-slate-900">{nominal}</strong>.
            </p>
            <p>5. Konfirmasi rincian transaksi lalu simpan bukti transfer.</p>
          </AccordionItem>

          <AccordionItem
            title="Transfer melalui Mobile Banking"
            icon={<Smartphone className="w-4 h-4 text-sky-600" />}
            open={activeChannel === "m-banking"}
            onToggle={() => toggleChannel("m-banking")}
          >
            <p>1. Buka aplikasi m-banking di smartphone Anda.</p>
            <p>
              2. Pilih menu <strong>Transfer</strong> atau <strong>Bayar / Tagihan</strong>.
            </p>
            <p>3. Pilih saluran <strong>Virtual Account</strong>.</p>
            <p>
              4. Masukkan nomor Virtual Account:{" "}
              <strong className="font-mono text-slate-900 font-bold">{number}</strong>.
            </p>
            <p>
              5. Pastikan nama merchant dan nominal sesuai, lalu selesaikan transaksi dengan PIN.
            </p>
          </AccordionItem>

          <AccordionItem
            title="Transfer melalui Internet Banking"
            icon={<MonitorSmartphone className="w-4 h-4 text-sky-600" />}
            open={activeChannel === "i-banking"}
            onToggle={() => toggleChannel("i-banking")}
          >
            <p>1. Login ke akun Internet Banking Anda.</p>
            <p>2. Pilih menu pembayaran tagihan / Virtual Account.</p>
            <p>
              3. Masukkan nomor Virtual Account lalu klik Lanjutkan:{" "}
              <strong className="font-mono text-slate-900 font-bold">{number}</strong>.
            </p>
            <p>4. Masukkan respon token autentikasi (KeyBCA / Token).</p>
            <p>5. Transaksi selesai dan status transaksi otomatis terupdate.</p>
          </AccordionItem>
        </div>
      </div>
    );
  }

  if (category === PaymentCategoryKey.EWALLET) {
    return (
      <div className="space-y-2 pt-1">
        {sectionHeading}
        <div className="border border-slate-200/90 rounded-2xl overflow-hidden bg-white text-xs shadow-2xs">
          <div className="px-4 pt-4 flex items-center gap-2.5">
            <span className="w-7 h-7 rounded-xl bg-sky-50 text-sky-600 flex items-center justify-center shrink-0">
              <Wallet className="w-4 h-4" />
            </span>
            <p className="text-xs font-extrabold text-slate-800">Cara Bayar Menggunakan E-Wallet</p>
          </div>
          <StepList
            steps={[
              <>Buka aplikasi dompet digital Anda (OVO, DANA, GoPay, ShopeePay, LinkAja, dll).</>,
              <>Pilih menu <strong>Bayar / Scan</strong> sesuai panduan aplikasi.</>,
              <>Masukkan <strong>kode pembayaran</strong> yang ditampilkan atau pindai QR bila tersedia.</>,
              <>Periksa kembali nominal tagihan <strong className="text-slate-900">{nominal}</strong> sudah sesuai.</>,
              <>Konfirmasi pembayaran dengan <strong>PIN aplikasi</strong> Anda.</>,
              <>Simpan bukti pembayaran. Status diverifikasi otomatis secara realtime.</>,
            ]}
          />
        </div>
      </div>
    );
  }

  if (category === PaymentCategoryKey.RETAIL) {
    return (
      <div className="space-y-2 pt-1">
        {sectionHeading}
        <div className="border border-slate-200/90 rounded-2xl overflow-hidden bg-white text-xs shadow-2xs">
          <div className="px-4 pt-4 flex items-center gap-2.5">
            <span className="w-7 h-7 rounded-xl bg-sky-50 text-sky-600 flex items-center justify-center shrink-0">
              <Store className="w-4 h-4" />
            </span>
            <p className="text-xs font-extrabold text-slate-800">Cara Bayar di Gerai Retail</p>
          </div>
          <StepList
            steps={[
              <>Kunjungi gerai <strong>Indomaret / Alfamart</strong> atau convenience store terdekat.</>,
              <>Sampaikan kepada kasir ingin melakukan <strong>pembayaran tagihan</strong>.</>,
              <>
                Sebutkan kode pembayaran:{" "}
                <strong className="font-mono text-slate-900 font-bold">{reference}</strong> atau
                tunjukkan halaman ini kepada kasir.
              </>,
              <>Periksa kembali nominal tagihan <strong className="text-slate-900">{nominal}</strong>.</>,
              <>Bayar tunai kepada kasir dan simpan <strong>struk</strong> sebagai bukti pembayaran.</>,
              <>Status terverifikasi otomatis setelah kasir mengonfirmasi transaksi.</>,
            ]}
          />
        </div>
      </div>
    );
  }

  if (category === PaymentCategoryKey.CC) {
    return (
      <div className="space-y-2 pt-1">
        {sectionHeading}
        <div className="border border-slate-200/90 rounded-2xl overflow-hidden bg-white text-xs shadow-2xs">
          <div className="px-4 pt-4 flex items-center gap-2.5">
            <span className="w-7 h-7 rounded-xl bg-sky-50 text-sky-600 flex items-center justify-center shrink-0">
              <CreditCard className="w-4 h-4" />
            </span>
            <p className="text-xs font-extrabold text-slate-800">Cara Bayar Menggunakan Kartu</p>
          </div>
          <StepList
            steps={[
              <>Siapkan <strong>kartu kredit / debit</strong> Anda.</>,
              <>Lanjutkan ke <strong>halaman pembayaran aman</strong> (3-D Secure) yang ditampilkan sistem.</>,
              <>Masukkan <strong>nomor kartu</strong>, <strong>masa berlaku</strong>, dan <strong>CVV</strong>.</>,
              <>Selesaikan autentikasi <strong>OTP / 3DS</strong> dari bank penerbit bila diminta.</>,
              <>Tunggu konfirmasi transaksi. Status diverifikasi otomatis secara realtime.</>,
            ]}
          />
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-2 pt-1">
      {sectionHeading}
      <div className="border border-slate-200/90 rounded-2xl overflow-hidden bg-white text-xs shadow-2xs">
        <div className="px-4 pt-4 flex items-center gap-2.5">
          <span className="w-7 h-7 rounded-xl bg-sky-50 text-sky-600 flex items-center justify-center shrink-0">
            <Info className="w-4 h-4" />
          </span>
          <p className="text-xs font-extrabold text-slate-800">Cara Menyelesaikan Pembayaran</p>
        </div>
        <StepList
          steps={[
            <>Ikuti petunjuk yang ditampilkan pada halaman saluran pembayaran Anda.</>,
            <>Pastikan nominal tagihan <strong className="text-slate-900">{nominal}</strong> sudah sesuai.</>,
            <>Hubungi merchant apabila mengalami kendala selama proses pembayaran.</>,
          ]}
        />
      </div>
    </div>
  );
}
