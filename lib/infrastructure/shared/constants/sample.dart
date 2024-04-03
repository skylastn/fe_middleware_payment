import '../../../presentation/main/payment/controllers/payment.state.dart';

List<PaymentCategory> listPayment = [
  // PaymentCategory(
  //   title: 'Credit Card',
  //   paymentType: PaymentType.creditCard,
  //   paymentMethod: [
  //     PaymentMethod(
  //       name: 'CREDIT CARD',
  //       description: 'Tanpa Biaya Layanan',
  //       imageUrl: 'assets/images/payment/cc.png',
  //       paymentCode: 'CC',
  //       paymentInstruction: PaymentInstruction(
  //         detail:
  //             'Dapatkan nomor akun virtual BCA Anda setelah menekan tombol pembayaran dibawah.\n'
  //             'Periksa kembali data pembayaran Anda pada menu detail transaksi sebelum melanjutkan transaksi.',
  //         stepPaymentInstruction: [
  //           StepPaymentInstruction(
  //             title: 'm-BCA',
  //             step: [
  //               'Lakukan log in pada aplikasi BCA mobile',
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   ],
  // ),
  PaymentCategory(
    title: 'Bank Transfer',
    paymentType: PaymentType.bankTransfer,
    paymentMethod: [
      // PaymentMethod(
      //   name: 'BCA VA',
      //   description: 'Tanpa Biaya Layanan',
      //   imageUrl: 'assets/images/payment/bca.png',
      //   paymentCode: 'BCA_VA',
      //   paymentInstruction: PaymentInstruction(
      //     detail:
      //         'Dapatkan nomor akun virtual BCA Anda setelah menekan tombol pembayaran dibawah.\n\n'
      //         'Periksa kembali data pembayaran Anda pada menu detail transaksi sebelum melanjutkan transaksi.',
      //     stepPaymentInstruction: [
      //       StepPaymentInstruction(
      //         title: 'm-BCA',
      //         step: [
      //           'Lakukan log in pada aplikasi BCA mobile',
      //           "Pilih 'm-BCA' Masukkan kode akses m-BCA",
      //           "Pilih 'm-Transfer'",
      //           "Pilih 'Virtual Account BCA'",
      //           'Masukkan nomor Virtual Account BCA 16 digit nomor virtual account 70070000xxxxxxxx( pastikan nomor sesuai ) atau pilih dari Daftar Transfer',
      //           'Masukkan jumlah pembayaran sesuai dengan tagihan',
      //           'Masukkan pin m-BCA',
      //           'Pembayaran selesai',
      //         ],
      //       ),
      //       StepPaymentInstruction(
      //         title: 'Klik BCA',
      //         step: [
      //           'Lakukan log in pada aplikasi KlikBCA individual',
      //           'Masukkan user ID dan PIN',
      //           "Pilih 'Transfer Dana'",
      //           "Pilih 'Transfer ke Virtual Account BCA'",
      //           'Masukkan nomor Virtual Account BCA 16 digit nomor virtual account 70070000xxxxxxxx( pastikan nomor sesuai ) atau pilih dari Daftar Transfer',
      //           'Masukkan jumlah pembayaran sesuai dengan tagihan',
      //           'Validasi pembayaran anda',
      //           'Pembayaran selesai',
      //         ],
      //       ),
      //       StepPaymentInstruction(
      //         title: 'ATM BCA',
      //         step: [
      //           'Masukkan kartu ATM BCA dan PIN',
      //           "Pilih 'Transaksi Lainya'",
      //           "Pilih 'Transfer'",
      //           "Pilih 'ke Rekening Virtual Account BCA'",
      //           "Masukkan nomor BCA Virtual Account 16 digit nomor virtual account 70070000xxxxxxxx( pastikan nomor sesuai )",
      //           'Masukkan jumlah pembayaran sesuai dengan tagihan',
      //           'Validasi pembayaran anda',
      //           'Pembayaran selesai',
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
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
                "Pilih Menu BRIVA",
                "Pilih Pembayaran Baru",
                "Masukan Nomor VA yang tertera pada halaman konfirmasi",
                'Masukan PIN BRIMO Anda',
                'Validasi pembayaran anda',
                'Pembayaran Selesai',
              ],
            ),
            StepPaymentInstruction(
              title: 'ATM BRI',
              step: [
                'Masukkan Kartu ATM BRI dan PIN',
                "Pilih menu LAINNYA",
                "Pilih menu PEMBAYARAN/PEMBELIAN",
                "Pilih menu PEMBAYARAN/PEMBELIAN LAIN",
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
                "Pilih menu e-Commerce",
                "Cari penyedia jasa Plink Pay (8903)",
                "Masukan nomor Virtual Account (MVA)",
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
                "Masukkan User ID dan Password",
                "Pilih menu Transfer",
                "Pilih menu Virtual Account Billing kemudian pilih rekening debet",
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
  // PaymentCategory(
  //   title: 'E-Wallet',
  //   paymentType: PaymentType.eWallet,
  //   paymentMethod: [
  //     PaymentMethod(
  //       name: 'OVO',
  //       description: 'Tanpa Biaya Layanan',
  //       imageUrl: 'assets/images/payment/ovo.png',
  //       paymentCode: 'EW_OVO',
  //       paymentInstruction: PaymentInstruction(
  //         detail:
  //             'Dapatkan nomor akun virtual BCA Anda setelah menekan tombol pembayaran dibawah.\n\n'
  //             'Periksa kembali data pembayaran Anda pada menu detail transaksi sebelum melanjutkan transaksi.',
  //         stepPaymentInstruction: [
  //           StepPaymentInstruction(
  //             title: 'm-BCA',
  //             step: [
  //               'Lakukan log in pada aplikasi BCA mobile',
  //               "Pilih 'm-BCA' Masukkan kode akses m-BCA",
  //               "Pilih 'm-Transfer'",
  //               "Pilih 'Virtual Account BCA'",
  //               'Masukkan nomor Virtual Account BCA 16 digit nomor virtual account 70070000xxxxxxxx( pastikan nomor sesuai ) atau pilih dari Daftar Transfer',
  //               'Masukkan jumlah pembayaran sesuai dengan tagihan',
  //               'Masukkan pin m-BCA',
  //               'Pembayaran selesai',
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //     PaymentMethod(
  //       name: 'DANA',
  //       description: 'Tanpa Biaya Layanan',
  //       imageUrl: 'assets/images/payment/dana.png',
  //       paymentCode: 'EW_DANA',
  //       paymentInstruction: PaymentInstruction(
  //         detail: 'Pembayaran DANA harus dilakukan melalui DANA website.\n\n'
  //             'Pastikan bahwa Anda telah terdaftar pada layanan DANA. Klik tombol pembayaran untuk melanjutkan pembayaran ke halaman website DANA.\n\n'
  //             'Periksa kembali data pembayaran Anda sebelum melanjutkan transaksi.',
  //         stepPaymentInstruction: [],
  //       ),
  //     ),
  //   ],
  // ),
  // PaymentCategory(
  //   title: 'QRIS',
  //   paymentType: PaymentType.qris,
  //   paymentMethod: [
  //     PaymentMethod(
  //       name: 'SHOPEEPAY QRIS',
  //       description: 'Tanpa Biaya Layanan',
  //       imageUrl: 'assets/images/payment/shopeepay.png',
  //       paymentCode: 'QRIS_SHOPEE',
  //       paymentInstruction: PaymentInstruction(
  //         detail:
  //             'Dapatkan nomor akun virtual BCA Anda setelah menekan tombol pembayaran dibawah.\n\n'
  //             'Periksa kembali data pembayaran Anda pada menu detail transaksi sebelum melanjutkan transaksi.',
  //         stepPaymentInstruction: [
  //           StepPaymentInstruction(
  //             title: 'ShopeePay',
  //             step: [
  //               'Buka Aplikasi Shopee',
  //               'Pilih menu “Saya” dan pilih ShopeePay',
  //               'Pilih Scan dan lakukan scan pada barcode pembayaran',
  //               'Pilih Bayar Sekarang',
  //               'Tunggu hingga proses pembayaran berhasil',
  //               'Transaksi Anda akan otomatis terkonfirmasi di sistem',
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //     // PaymentMethod(
  //     //   name: 'LINKAJA QRIS',
  //     //   description: 'Tanpa Biaya Layanan',
  //     //   imageUrl: 'https://api-sandbox.duitku.com/pgimages/pg/LQ.svg',
  //     //   paymentCode: 'QRIS_DANA',
  //     //   paymentInstruction: PaymentInstruction(
  //     //     detail:
  //     //         'Dapatkan nomor akun virtual BCA Anda setelah menekan tombol pembayaran dibawah.\n\n'
  //     //         'Periksa kembali data pembayaran Anda pada menu detail transaksi sebelum melanjutkan transaksi.',
  //     //     stepPaymentInstruction: [
  //     //       StepPaymentInstruction(
  //     //         title: 'm-BCA',
  //     //         step: [
  //     //           'Lakukan log in pada aplikasi BCA mobile',
  //     //         ],
  //     //       ),
  //     //     ],
  //     //   ),
  //     // ),
  //   ],
  // ),
  // PaymentCategory(
  //   title: 'Retail',
  //   paymentType: PaymentType.retail,
  //   paymentMethod: [
  //     PaymentMethod(
  //       name: 'RETAIL',
  //       description: 'Tanpa Biaya Layanan',
  //       imageUrl: 'assets/images/payment/retail.png',
  //       paymentCode: 'RT_R',
  //       paymentInstruction: PaymentInstruction(
  //         detail:
  //             'Dapatkan nomor akun virtual BCA Anda setelah menekan tombol pembayaran dibawah.\n\n'
  //             'Periksa kembali data pembayaran Anda pada menu detail transaksi sebelum melanjutkan transaksi.',
  //         stepPaymentInstruction: [
  //           StepPaymentInstruction(
  //             title: 'm-BCA',
  //             step: [
  //               'Lakukan log in pada aplikasi BCA mobile',
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //     PaymentMethod(
  //       name: 'INDOMARET',
  //       description: 'Tanpa Biaya Layanan',
  //       imageUrl: 'assets/images/payment/indomaret.png',
  //       paymentCode: 'RT_IND',
  //       paymentInstruction: PaymentInstruction(
  //         detail:
  //             'Dapatkan nomor akun virtual BCA Anda setelah menekan tombol pembayaran dibawah.\n\n'
  //             'Periksa kembali data pembayaran Anda pada menu detail transaksi sebelum melanjutkan transaksi.',
  //         stepPaymentInstruction: [
  //           StepPaymentInstruction(
  //             title: 'm-BCA',
  //             step: [
  //               'Lakukan log in pada aplikasi BCA mobile',
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   ],
  // ),
  // PaymentCategory(
  //   title: 'E-Banking',
  //   paymentType: PaymentType.retail,
  //   paymentMethod: [
  //     PaymentMethod(
  //       name: 'JENIUS PAY',
  //       description: 'Tanpa Biaya Layanan',
  //       imageUrl: 'assets/images/payment/jenius.png',
  //       paymentCode: 'EB_JENIUS',
  //       paymentInstruction: PaymentInstruction(
  //         detail:
  //             'Dapatkan nomor akun virtual BCA Anda setelah menekan tombol pembayaran dibawah.\n\n'
  //             'Periksa kembali data pembayaran Anda pada menu detail transaksi sebelum melanjutkan transaksi.',
  //         stepPaymentInstruction: [
  //           StepPaymentInstruction(
  //             title: 'm-BCA',
  //             step: [
  //               'Lakukan log in pada aplikasi BCA mobile',
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   ],
  // ),
];
