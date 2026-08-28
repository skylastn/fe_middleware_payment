import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../shared/constants/colors.dart';
import '../../../../shared/logic/network_logic.dart';
import '../../../../shared/logic/socket_logic.dart';
import '../../../../shared/utility/format.dart';
import '../../../../shared/utility/snackbar.dart';
import '../../../../shared/widgets/mobile_size_widget.dart';
import '../../../../shared/widgets/picture_handler_widget.dart';
import '../../../../shared/widgets/state_widget.dart';
import '../../domain/model/response/project.dart';
import '../widget/main_widget.dart';
import 'detail_payment_logic.dart';
import 'detail_payment_state.dart';
import 'widget/duitku_widget.dart';

class DetailPaymentPage extends GetView<DetailPaymentLogic> {
  const DetailPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final networkLogic = Get.find<NetworkLogic>();
    final socketLogic = Get.find<SocketLogic>();

    return MobileSizeWidget(
      body: GetBuilder<DetailPaymentLogic>(
        builder: (logic) {
          final state = logic.state;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top App Bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    if (Navigator.canPop(context))
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
                    if (Navigator.canPop(context)) const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pembayaran',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.textPrimary,
                            ),
                          ),
                          Text(
                            'Selesaikan transaksi Anda',
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorConstants.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Obx(() => connectionBadge(
                              isOnline: networkLogic.isConnected.value,
                              label: 'Internet',
                              icon: Icons.wifi,
                            )),
                        const SizedBox(width: 6),
                        Obx(() => connectionBadge(
                              isOnline: socketLogic.isConnected.value,
                              label: 'Live Sync',
                              icon: Icons.sync_rounded,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(color: ColorConstants.border),
              const SizedBox(height: 12),

              // Selected Payment Method Header Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorConstants.surfaceMuted,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ColorConstants.border, width: 0.8),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 50,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ColorConstants.border,
                          width: 0.8,
                        ),
                      ),
                      child: Center(
                        child: PictureHandlerWidget().pictureHandler(
                          state.paymentMethod?.imageUrl ?? '',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.paymentMethod?.name ?? 'Metode Pembayaran',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.textPrimary,
                            ),
                          ),
                          Text(
                            state.paymentCategory?.title ?? '',
                            style: const TextStyle(
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
              const SizedBox(height: 12),

              // Content Area
              Expanded(
                child: StateWidget().initial(
                  stateStatus: state.status,
                  body: descriptionWidget(logic),
                ),
              ),

              const SizedBox(height: 10),
              const Divider(color: ColorConstants.border),
              const SizedBox(height: 10),

              // Bottom Action Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total Tagihan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      totalWidget(state),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      try {
                        if (!state.isPayment) {
                          state.isPayment = true;
                          logic.createOrderPayment();
                          return;
                        }
                        await logic.getDetailOrder(isLoading: false);
                        if (state.order?.status == 'PAID' ||
                            state.order?.status == 'SUCCESS') {
                          Snackbar.showInfo(
                            title: 'Sukses',
                            message: 'Pembayaran Anda berhasil!',
                          );
                        } else {
                          Snackbar.showInfo(
                            title: 'Status',
                            message:
                                'Status saat ini: ${state.order?.status ?? 'PENDING'}',
                          );
                        }
                      } catch (e) {
                        Snackbar.showInfo(
                          title: 'Error',
                          message: e.toString(),
                        );
                      }
                    },
                    icon: Icon(
                      !state.isPayment
                          ? Icons.lock_outline_rounded
                          : Icons.refresh_rounded,
                      size: 18,
                    ),
                    label: Text(
                      !state.isPayment ? 'Bayar Sekarang' : 'Cek Status',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget totalWidget(DetailPaymentState state) {
    double amount = 0.0;
    if (state.order?.project?.projectType == ProjectType.duitku) {
      amount = (state.duitkuOrder.request?.paymentAmount ?? 0).toDouble();
    } else if (state.order?.project?.projectType == ProjectType.spnpay) {
      amount = (state.spnPayOrder.request?.amount ?? 0).toDouble();
    }
    return Text(
      Format.rupiahConvert(amount),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: ColorConstants.primary,
      ),
    );
  }

  Widget descriptionWidget(DetailPaymentLogic logic) {
    final state = logic.state;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (!state.isPayment) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ColorConstants.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorConstants.border, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: ColorConstants.textSecondary,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Informasi Pembayaran',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  state.paymentMethod?.paymentInstruction.detail ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: ColorConstants.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (state.isPayment) ...[
          statusWidget(state),
          const SizedBox(height: 12),
        ],
        if ((state.paymentMethod?.paymentInstruction.stepPaymentInstruction ??
                [])
            .isNotEmpty)
          paymentInstructionWidget(state),
      ],
    );
  }

  Widget statusWidget(DetailPaymentState state) {
    final status = (state.order?.status ?? '').isEmpty
        ? 'PENDING'
        : state.order!.status;
    final isSuccess = status == 'PAID' || status == 'SUCCESS';
    return Column(
      children: [
        if (state.order?.project?.projectType == ProjectType.spnpay)
          itemWidget(
            title: 'Nomor Virtual Account',
            subTitle: state.spnPayOrder.response?.virtualAccount.vaNumber ?? '',
            endWidget: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  await Clipboard.setData(
                    ClipboardData(
                      text: state.spnPayOrder.response?.virtualAccount
                              .vaNumber ??
                          '',
                    ),
                  );
                  Snackbar.showInfo(
                      message: 'Nomor VA disalin ke clipboard');
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ColorConstants.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorConstants.border,
                      width: 0.8,
                    ),
                  ),
                  child: const Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: ColorConstants.primary,
                  ),
                ),
              ),
            ),
          ),
        if (state.order?.project?.projectType == ProjectType.duitku)
          DuitkuWidget(),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSuccess
                ? ColorConstants.successLight
                : ColorConstants.warningLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSuccess
                  ? ColorConstants.success.withAlpha(0x40)
                  : ColorConstants.warning.withAlpha(0x40),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSuccess
                    ? Icons.check_circle_rounded
                    : Icons.access_time_filled_rounded,
                color: isSuccess ? ColorConstants.success : ColorConstants.warning,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status Transaksi',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: ColorConstants.textSecondary,
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSuccess
                            ? ColorConstants.success
                            : ColorConstants.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget connectionBadge({
    required bool isOnline,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline
            ? ColorConstants.successLight
            : ColorConstants.errorLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOnline
              ? ColorConstants.success.withAlpha(0x30)
              : ColorConstants.error.withAlpha(0x30),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: isOnline ? ColorConstants.success : ColorConstants.error,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isOnline ? ColorConstants.success : ColorConstants.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentInstructionWidget(DetailPaymentState state) {
    final instructions =
        state.paymentMethod?.paymentInstruction.stepPaymentInstruction ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 18,
                color: ColorConstants.primary,
              ),
              SizedBox(width: 8),
              Text(
                'Petunjuk Pembayaran',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.textPrimary,
                ),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: instructions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final content = instructions[index];
            return Container(
              decoration: BoxDecoration(
                color: ColorConstants.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorConstants.border, width: 0.8),
              ),
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 14),
                childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                shape: const Border(),
                collapsedShape: const Border(),
                title: Text(
                  content.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.textPrimary,
                  ),
                ),
                children: List<Widget>.generate(
                  content.step.length,
                  (stepIndex) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          margin: const EdgeInsets.only(top: 2, right: 8),
                          decoration: BoxDecoration(
                            color: ColorConstants.surfaceMuted,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorConstants.border,
                              width: 0.8,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${stepIndex + 1}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            content.step[stepIndex],
                            style: const TextStyle(
                              fontSize: 12,
                              color: ColorConstants.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
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
