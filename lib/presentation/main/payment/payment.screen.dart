import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/constants/sample.dart';
import '../../../shared/widget/mobile_size_widget.dart';
import '../widget/main_widget.dart';
import 'controllers/payment.controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  PaymentScreen({super.key});
  final logic = Get.find<PaymentController>();
  final state = Get.find<PaymentController>().state;

  @override
  Widget build(BuildContext context) {
    return MobileSizeWidget(
      body: GetBuilder<PaymentController>(
        builder: (_) => SizedBox(
          height: context.isPhone ? Get.height : Get.height * 0.88,
          child: Column(
            children: [
              Stack(
                children: [
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1),
              const SizedBox(height: 8),
              Card(
                elevation: 3,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        flex: 6,
                        child: Text(
                          'Pilih Metode Pembayaran',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          // child: FlutterLogo(),
                          child: Container(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: descriptionWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget descriptionWidget() {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 16),
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
    );
  }
}
