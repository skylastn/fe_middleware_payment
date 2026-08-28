import '../../feature/payment/presentation/payment_method/payment_method_state.dart';

List<PaymentCategory> listPayment = [
  PaymentCategory(
    title: 'Bank Transfer',
    paymentType: PaymentType.bankTransfer,
    paymentMethod: [
      PaymentMethod(
        name: 'BRI VA',
        description: 'Tanpa Biaya Layanan',
        imageUrl: 'assets/images/payment/bri.png',
        paymentCode: 'BRI_VA',
        paymentInstruction: PaymentInstruction(
          detail:
              'Dapatkan nomor akun virtual BRI Anda setelah menekan tombol pembayaran dibawah.\n\n'
              'Periksa kembali data pembayaran Anda pada menu detail transaksi sebelum melanjutkan transaksi.',
          stepPaymentInstruction: [
            StepPaymentInstruction(
              title: 'BRIMO',
              step: [
                'Lakukan log in pada aplikasi BRI Mobile (Android/Iphone)',
                'Pilih Menu BRIVA',
                'Pilih Pembayaran Baru',
                'Masukan Nomor VA yang tertera pada halaman konfirmasi',
                'Masukan PIN BRIMO Anda',
                'Validasi pembayaran anda',
                'Pembayaran Selesai',
              ],
            ),
            StepPaymentInstruction(
              title: 'ATM BRI',
              step: [
                'Masukkan Kartu ATM BRI dan PIN',
                'Pilih menu LAINNYA',
                'Pilih menu PEMBAYARAN/PEMBELIAN',
                'Pilih menu PEMBAYARAN/PEMBELIAN LAIN',
                'Pilih menu BRIVA',
                'Masukkan nomor VA yang tertera pada halaman konfirmasi dan tekan BENAR',
                'Konfirmasi pembayaran dengan menekan Ya',
                'Pembayaran Selesai'
              ],
            ),
          ],
        ),
      ),
      PaymentMethod(
        name: 'MANDIRI VA',
        description: 'Tanpa Biaya Layanan',
        imageUrl: 'assets/images/payment/mandiri.png',
        paymentCode: 'MANDIRI_VA',
        paymentInstruction: PaymentInstruction(
          detail:
              'Dapatkan nomor akun virtual Mandiri Anda setelah menekan tombol pembayaran dibawah.\n\n'
              'Periksa kembali data pembayaran Anda pada menu detail transaksi sebelum melanjutkan transaksi.',
          stepPaymentInstruction: [
            StepPaymentInstruction(
              title: 'Livin By Mandiri',
              step: [
                'Pilih Menu Bayar',
                'Pilih menu e-Commerce',
                'Cari penyedia jasa Plink Pay (8903)',
                'Masukan nomor Virtual Account (MVA)',
                'Masukan nominal pembayaran',
                'Klik Lanjutkan',
                'Pilih Konfirmasi untuk membayarkan tagihan',
                'Cek status transaksi',
              ],
            ),
          ],
        ),
      ),
      PaymentMethod(
        name: 'BNI VA',
        description: 'Tanpa Biaya Layanan',
        imageUrl: 'assets/images/payment/bni.png',
        paymentCode: 'BNI_VA',
        paymentInstruction: PaymentInstruction(
          detail:
              'Dapatkan nomor akun virtual BNI Anda setelah menekan tombol pembayaran dibawah.\n\n'
              'Periksa kembali data pembayaran Anda pada menu detail transaksi sebelum melanjutkan transaksi.',
          stepPaymentInstruction: [
            StepPaymentInstruction(
              title: 'Mobile Banking BNI',
              step: [
                'Akses BNI Mobile Banking',
                'Masukkan User ID dan Password',
                'Pilih menu Transfer',
                'Pilih menu Virtual Account Billing kemudian pilih rekening debet',
                "Masukkan 16 digit nomor Virtual Account yang tertera pada halaman konfirmasi (Contoh: 988002XXXXXXXXXX) pada menu 'inputbaru'",
                'Tagihan yang harus dibayarkan akan muncul pada layar konfirmasi',
                'Konfirmasi transaksi dan masukkan Password Transaksi',
                'Pembayaran Anda Telah Berhasil',
                'Simpan bukti transaksi'
              ],
            ),
          ],
        ),
      ),
    ],
  ),
  PaymentCategory(
    title: 'QRIS',
    paymentType: PaymentType.qris,
    paymentMethod: [
      PaymentMethod(
        name: 'SHOPEEPAY QRIS',
        description: 'Tanpa Biaya Layanan',
        imageUrl: 'assets/images/payment/shopeepay.png',
        paymentCode: 'SP',
        paymentInstruction: PaymentInstruction(
          detail:
              'Dapatkan nomor akun virtual BCA Anda setelah menekan tombol pembayaran dibawah.\n\n'
              'Periksa kembali data pembayaran Anda pada menu detail transaksi sebelum melanjutkan transaksi.',
          stepPaymentInstruction: [
            StepPaymentInstruction(
              title: 'ShopeePay',
              step: [
                'Buka Aplikasi Shopee',
                'Pilih menu “Saya” dan pilih ShopeePay',
                'Pilih Scan dan lakukan scan pada barcode pembayaran',
                'Pilih Bayar Sekarang',
                'Tunggu hingga proses pembayaran berhasil',
                'Transaksi Anda akan otomatis terkonfirmasi di sistem',
              ],
            ),
          ],
        ),
      ),
      PaymentMethod(
        name: 'NUSA QRIS',
        description: 'Tanpa Biaya Layanan',
        imageUrl:
            'https://play-lh.googleusercontent.com/KMVnnWmi8RNAJG3FZDvBt6bmeaBrpOUh508mSsAhmzFWy_kmTHQhUxfSErrJd1i-GDs',
        paymentCode: 'SQ',
        paymentInstruction: PaymentInstruction(
          detail:
              'Dapatkan nomor akun virtual BCA Anda setelah menekan tombol pembayaran dibawah.\n\n'
              'Periksa kembali data pembayaran Anda pada menu detail transaksi sebelum melanjutkan transaksi.',
          stepPaymentInstruction: [
            StepPaymentInstruction(
              title: 'ShopeePay',
              step: [
                'Buka Aplikasi Shopee',
                'Pilih menu “Saya” dan pilih ShopeePay',
                'Pilih Scan dan lakukan scan pada barcode pembayaran',
                'Pilih Bayar Sekarang',
                'Tunggu hingga proses pembayaran berhasil',
                'Transaksi Anda akan otomatis terkonfirmasi di sistem',
              ],
            ),
          ],
        ),
      ),
    ],
  ),
];
