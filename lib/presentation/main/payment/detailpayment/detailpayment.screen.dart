import '../../../../app/global/network_logic.dart';
import '../../../../app/global/socket_logic.dart';
import 'widget/duitku_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../domain/model/response/project.dart';
import '../../../../shared/utils/format.dart';
import '../../../../shared/utils/snackbar.dart';
import '../../../../shared/widget/mobile_size_widget.dart';
import '../../../../shared/widget/state_widget.dart';
import '../../widget/main_widget.dart';
import '../controllers/payment.state.dart';
import 'controllers/detailpayment.controller.dart';

class DetailPaymentScreen extends GetView<DetailPaymentController> {
  DetailPaymentScreen({super.key});
  final logic = Get.find<DetailPaymentController>();
  final state = Get.find<DetailPaymentController>().state;
  final networkLogic = Get.find<NetworkLogic>();
  final socketLogic = Get.find<SocketLogic>();

  @override
  Widget build(BuildContext context) {
    return MobileSizeWidget(
      body: GetBuilder<DetailPaymentController>(
        builder: (_) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (Navigator.canPop(context))
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                      ),
                    ),
                  if (Navigator.canPop(context)) const SizedBox(width: 12),
                  const Center(
                    child: Text(
                      'Detail Payment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(children: [
                    Obx(() => networkWidget(networkLogic.isConnected.value)),
                    const SizedBox(width: 8),
                    Obx(() => socketWidget(socketLogic.isConnected.value)),
                  ]),
                ],
              ),
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
              child: StateWidget().initial(
                stateStatus: state.status,
                body: descriptionWidget(),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    totalWidget(),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.only(
                        top: 16,
                        bottom: 16,
                        left: 12,
                        right: 12,
                      ),
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.white,
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.blue,
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      if (!state.isPayment) {
                        state.isPayment = true;
                        logic.createOrderPayment();
                        return;
                      }
                      await logic.getDetailOrder(isLoading: false);
                      if (state.order?.status == 'PAID') {
                        Snackbar.showInfo(
                          title: 'Sukses',
                          message: 'Pembayaran anda berhasil',
                        );
                      }
                    } catch (e) {
                      Snackbar.showInfo(
                        title: 'Error',
                        message: e.toString(),
                      );
                    }
                  },
                  child: Text(
                    !state.isPayment
                        ? 'pembayaran'.toUpperCase()
                        : 'Cek Transaksi',
                    style: const TextStyle(fontSize: 14),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget totalWidget() {
    if (state.order?.project?.projectType == ProjectType.duitku) {
      return Text(
        Format.rupiahConvert(
          (state.duitkuOrder.request?.paymentAmount ?? 0).toDouble(),
        ),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    return Text(
      Format.rupiahConvert(
        state.order?.project?.projectType == ProjectType.spnpay
            ? (state.spnPayOrder.request?.amount ?? 0).toDouble()
            : 0.0,
      ),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
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
            if (!state.isPayment)
              itemWidget(
                title: 'Deskripsi',
                subTitle: state.paymentMethod?.paymentInstruction.detail ?? '',
              ),
            if (state.isPayment) statusWidget(),
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

  Widget statusWidget() {
    return ListView(
      shrinkWrap: true,
      children: [
        if (state.order?.project?.projectType == ProjectType.spnpay)
          itemWidget(
            title: 'Nomor Akun Virtual',
            subTitle: state.spnPayOrder.response?.virtualAccount.vaNumber ?? '',
            endWidget: InkWell(
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: state.spnPayOrder.response?.virtualAccount.vaNumber ??
                        '',
                  ),
                );
                Snackbar.showInfo(message: 'Copied to your clipboard !');
              },
              child: const Icon(Icons.copy),
            ),
          ),
        if (state.order?.project?.projectType == ProjectType.duitku)
          DuitkuWidget(),
        itemWidget(
          title: 'Status Transaksi',
          subTitle:
              'Transaction ${(state.order?.status ?? '').isEmpty ? 'PENDING' : state.order?.status}.',
        ),
      ],
    );
  }

  Widget socketWidget(bool isConnected) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isConnected ? Colors.green : Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget networkWidget(bool isConnected) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Icon(
        Icons.wifi,
        size: 30,
        color: isConnected ? Colors.green : Colors.red,
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
