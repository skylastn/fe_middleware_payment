import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../domain/model/response/project.dart';
import '../../../../infrastructure/navigation/routes.dart';
import '../../../../infrastructure/shared/utils/format.dart';
import '../../../../infrastructure/shared/utils/snackbar.dart';
import '../../../../infrastructure/shared/widget/mobile_size_widget.dart';
import '../../../../infrastructure/widget/state_widget.dart';
import '../../widget/main_widget.dart';
import '../controllers/payment.state.dart';
import 'controllers/detailpayment.controller.dart';

class DetailPaymentScreen extends GetView<DetailPaymentController> {
  DetailPaymentScreen({Key? key}) : super(key: key);
  var logic = Get.find<DetailPaymentController>();
  var state = Get.find<DetailPaymentController>().state;

  @override
  Widget build(BuildContext context) {
    return MobileSizeWidget(
      body: SizedBox(
        height: context.isPhone ? Get.height : Get.height * 0.88,
        child: GetBuilder<DetailPaymentController>(
          builder: (_) => Column(
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
                      Text(
                        Format.rupiahConvert(
                          state.order?.project?.projectType ==
                                  ProjectType.spnpay
                              ? (state.spnPayOrder.request?.amount ?? 0)
                                  .toDouble()
                              : 0.0,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 12,
                          right: 12,
                        ),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          ? "pembayaran".toUpperCase()
                          : 'Cek Transaksi',
                      style: const TextStyle(fontSize: 14),
                    ),
                  )
                ],
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
        itemWidget(
          title: 'Status Transaksi',
          subTitle: 'Transaction ${state.order?.status}.',
        ),
      ],
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
