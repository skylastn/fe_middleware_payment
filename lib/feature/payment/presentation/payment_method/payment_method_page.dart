import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/constants/colors.dart';
import '../../../../shared/constants/sample.dart';
import '../../../../shared/widgets/mobile_size_widget.dart';
import '../widget/main_widget.dart';
import 'payment_method_logic.dart';

class PaymentMethodPage extends GetView<PaymentMethodLogic> {
  const PaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileSizeWidget(
      body: GetBuilder<PaymentMethodLogic>(
        builder: (logic) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorConstants.surfaceMuted,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: ColorConstants.border,
                            width: 0.8,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: ColorConstants.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Metode Pembayaran',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.textPrimary,
                          ),
                        ),
                        Text(
                          'Pilih saluran pembayaran yang Anda inginkan',
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: ColorConstants.border),
            const SizedBox(height: 8),

            // Payment Categories & Methods
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listPayment.length,
                    itemBuilder: (context, index) => paymentMethodWidget(
                      paymentCategory: listPayment[index],
                      callback: (content) => logic.routeToDetail(
                        content,
                        listPayment[index],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
