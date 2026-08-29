import '../../feature/payment/domain/model/response/payment_category.dart';
import '../../feature/payment/domain/model/response/payment_method.dart';

List<PaymentCategory> samplePaymentCategories = [
  PaymentCategory(
    id: 1,
    title: 'Bank Transfer',
    key: 'bank_transfer',
    detail: 'Transfer melalui Virtual Account bank terkemuka',
    paymentMethods: [
      PaymentResponse(
        name: 'BRI VA',
        imageUrl: 'assets/images/payment/bri.png',
        key: 'BRI_VA',
        from: 'duitku',
        type: 'bank_transfer',
      ),
      PaymentResponse(
        name: 'MANDIRI VA',
        imageUrl: 'assets/images/payment/mandiri.png',
        key: 'MANDIRI_VA',
        from: 'duitku',
        type: 'bank_transfer',
      ),
      PaymentResponse(
        name: 'BNI VA',
        imageUrl: 'assets/images/payment/bni.png',
        key: 'BNI_VA',
        from: 'duitku',
        type: 'bank_transfer',
      ),
    ],
  ),
  PaymentCategory(
    id: 2,
    title: 'QRIS',
    key: 'qris',
    detail: 'Scan menggunakan aplikasi pembayaran QRIS apapun',
    paymentMethods: [
      PaymentResponse(
        name: 'SHOPEEPAY QRIS',
        imageUrl: 'assets/images/payment/shopeepay.png',
        key: 'SP',
        from: 'duitku',
        type: 'qris',
      ),
    ],
  ),
];
