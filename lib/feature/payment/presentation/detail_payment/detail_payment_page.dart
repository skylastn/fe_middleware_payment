import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/constants/colors.dart';
import '../../../../shared/logic/network_logic.dart';
import '../../../../shared/logic/socket_logic.dart';
import '../../../../shared/utility/format.dart';
import '../../../../shared/utility/snackbar.dart';
import '../../../../shared/widgets/mobile_size_widget.dart';
import '../../../../shared/widgets/picture_handler_widget.dart';
import '../../../../shared/widgets/state_widget.dart';
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
          final paymentName = state.paymentName.isNotEmpty
              ? state.paymentName
              : (state.order?.paymentMethods?.name ??
                  state.paymentCode.replaceAll('_', ' '));
          final categoryTitle = state.categoryTitle.isNotEmpty
              ? state.categoryTitle
              : (state.order?.paymentMethods?.category?.title ?? 'Saluran Pembayaran');
          final imageUrl = state.imageUrl.isNotEmpty
              ? state.imageUrl
              : (state.order?.paymentMethods?.imageUrl ??
                  state.order?.paymentMethods?.image ??
                  '');

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
                      height: 44,
                      width: 54,
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
                        child: imageUrl.isNotEmpty
                            ? PictureHandlerWidget().pictureHandler(imageUrl)
                            : const Icon(
                                Icons.payment_rounded,
                                size: 24,
                                color: ColorConstants.primary,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            paymentName.isEmpty ? 'Metode Pembayaran' : paymentName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            categoryTitle,
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
                        if (!state.isPayment &&
                            (state.order?.response ?? '').isEmpty &&
                            (state.order?.value ?? '').isEmpty) {
                          state.isPayment = true;
                          await logic.createOrderPayment();
                          return;
                        }
                        await logic.getDetailOrder(isLoading: false);
                        final status = state.order?.status ?? '';
                        if (status == 'PAID' || status == 'SUCCESS') {
                          Snackbar.showInfo(
                            title: 'Sukses',
                            message: 'Pembayaran Anda berhasil!',
                          );
                        } else if (status == 'EXPIRED') {
                          Snackbar.showInfo(
                            title: 'Kadaluarsa',
                            message: 'Waktu pembayaran telah habis.',
                          );
                        } else if (status == 'FAILED') {
                          Snackbar.showInfo(
                            title: 'Gagal',
                            message: 'Pembayaran gagal diproses.',
                          );
                        } else {
                          Snackbar.showInfo(
                            title: 'Status',
                            message: 'Status saat ini: ${status.isEmpty ? 'PENDING' : status}',
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
                      !state.isPayment &&
                              (state.order?.response ?? '').isEmpty &&
                              (state.order?.value ?? '').isEmpty
                          ? Icons.lock_outline_rounded
                          : Icons.refresh_rounded,
                      size: 18,
                    ),
                    label: Text(
                      !state.isPayment &&
                              (state.order?.response ?? '').isEmpty &&
                              (state.order?.value ?? '').isEmpty
                          ? 'Bayar Sekarang'
                          : 'Cek Status',
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
    final amount = state.order?.totalAmount ?? 0.0;
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
        statusWidget(state),
        const SizedBox(height: 12),
        DuitkuWidget(),
        const SizedBox(height: 12),
        paymentInstructionWidget(state),
      ],
    );
  }

  Widget statusWidget(DetailPaymentState state) {
    final status = (state.order?.status ?? '').isEmpty
        ? 'PENDING'
        : state.order!.status;
    final isSuccess = status == 'PAID' || status == 'SUCCESS';
    final isFailed = status == 'FAILED' || status == 'EXPIRED';

    Color bgColor = ColorConstants.warningLight;
    Color borderColor = ColorConstants.warning.withAlpha(0x40);
    Color iconColor = ColorConstants.warning;
    IconData icon = Icons.access_time_filled_rounded;

    if (isSuccess) {
      bgColor = ColorConstants.successLight;
      borderColor = ColorConstants.success.withAlpha(0x40);
      iconColor = ColorConstants.success;
      icon = Icons.check_circle_rounded;
    } else if (isFailed) {
      bgColor = ColorConstants.errorLight;
      borderColor = ColorConstants.error.withAlpha(0x40);
      iconColor = ColorConstants.error;
      icon = Icons.cancel_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
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
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConstants.border, width: 0.8),
      ),
      clipBehavior: Clip.antiAlias,
      child: const ExpansionTile(
        initiallyExpanded: true,
        tilePadding: EdgeInsets.symmetric(horizontal: 14),
        childrenPadding: EdgeInsets.fromLTRB(14, 0, 14, 12),
        shape: Border(),
        collapsedShape: Border(),
        title: Text(
          'Petunjuk Pembayaran',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ColorConstants.textPrimary,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.textSecondary,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Periksa kembali nomor virtual account, kode bayar, atau scan QRIS yang tertera di atas.',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2. ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.textSecondary,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Selesaikan pembayaran sesuai nominal yang ditentukan sebelum batas waktu transaksi berakhir.',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '3. ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.textSecondary,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Setelah pembayaran berhasil, sistem akan mendeteksi status secara otomatis dan mengarahkan kembali ke merchant.',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
