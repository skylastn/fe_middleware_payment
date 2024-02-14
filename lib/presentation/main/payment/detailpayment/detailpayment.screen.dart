import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../infrastructure/shared/widget/mobile_size_widget.dart';
import '../../widget/main_widget.dart';
import '../controllers/payment.state.dart';
import 'controllers/detailpayment.controller.dart';

class DetailPaymentScreen extends GetView<DetailpaymentController> {
  DetailPaymentScreen({Key? key}) : super(key: key);
  var logic = Get.find<DetailpaymentController>();
  var state = Get.find<DetailpaymentController>().state;

  @override
  Widget build(BuildContext context) {
    return MobileSizeWidget(
      body: SizedBox(
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
                    Expanded(
                      flex: 6,
                      child: Text(
                        state.paymentMethod?.name ?? '',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FlutterLogo(),
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
            // Row
          ],
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
            itemWidget(
              title: 'Deskripsi',
              subTitle: state.paymentMethod?.paymentInstruction.detail ?? '',
            ),
            const SizedBox(height: 8),
            if ((state.paymentMethod?.paymentInstruction
                        .stepPaymentInstruction ??
                    [])
                .isNotEmpty)
              paymentInstructionWidget(),
          ],
        ),
      ),
    );
  }

  Widget paymentInstructionWidget() {
    return ListView(
      shrinkWrap: true,
      children: [
        const Row(
          children: [
            Icon(
              Icons.integration_instructions,
            ),
            SizedBox(width: 8),
            Text(
              'Cara Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          itemCount: state
              .paymentMethod?.paymentInstruction.stepPaymentInstruction.length,
          itemBuilder: (context, index) {
            StepPaymentInstruction? content = state.paymentMethod
                ?.paymentInstruction.stepPaymentInstruction[index];
            return Card(
              child: ExpansionTile(
                title: Text(
                  content?.title ?? '',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: List<Widget>.generate(
                  (content?.step ?? []).length,
                  (index) => ListTile(
                    title: Text(
                      content?.step[index] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
