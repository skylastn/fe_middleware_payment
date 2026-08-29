import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../shared/constants/colors.dart';
import '../../../../shared/navigation/routes.dart';
import '../../../../shared/utility/format.dart';
import '../../../../shared/utility/snackbar.dart';
import '../../../../shared/widgets/mobile_size_widget.dart';
import '../../../../shared/widgets/state_widget.dart';
import '../../domain/model/response/project.dart';
import '../widget/main_widget.dart';
import 'home_logic.dart';

class HomePage extends GetView<HomeLogic> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileSizeWidget(
      body: GetBuilder<HomeLogic>(
        builder: (logic) {
          final state = logic.state;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Row(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      color: ColorConstants.primary,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Rincian Pesanan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorConstants.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: ColorConstants.border),
              const SizedBox(height: 12),

              // Content Area
              Expanded(
                child: StateWidget().initial(
                  stateStatus: state.status,
                  body: descriptionWidget(logic),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget descriptionWidget(HomeLogic logic) {
    final state = logic.state;
    return Column(
      children: [
        // Tab Selector Card
        Container(
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: ColorConstants.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: state.tabController,
            onTap: (index) {
              state.tabIndex = index;
              logic.update();
            },
            indicator: BoxDecoration(
              color: ColorConstants.surface,
              borderRadius: BorderRadius.circular(9),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A0F172A),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: EdgeInsets.zero,
            labelColor: ColorConstants.primary,
            unselectedLabelColor: ColorConstants.textSecondary,
            tabs: const [
              Tab(
                child: Text(
                  'Pesanan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Pelanggan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: state.tabController,
            children: [
              orderDetailWidget(logic),
              customerDetailWidget(logic),
            ],
          ),
        ),

        const SizedBox(height: 12),
        const Divider(color: ColorConstants.border),
        const SizedBox(height: 12),

        // Bottom Summary & Checkout Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    Format.rupiahConvert(
                      state.order?.totalAmount ??
                          (state.order?.project?.projectType == ProjectType.spnpay
                              ? (state.spnPayOrder.request?.amount ?? 0).toDouble()
                              : 0.0),
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: ColorConstants.primary,
                    ),
                  ),
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
                onPressed: () => Get.toNamed(
                  Routes.PAYMENT,
                  parameters: {
                    'reference': state.orderId,
                  },
                ),
                icon: const Icon(Icons.payment_rounded, size: 18),
                label: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget orderDetailWidget(HomeLogic logic) {
    final state = logic.state;
    final amount = state.order?.totalAmount ??
        (state.order?.project?.projectType == ProjectType.spnpay
            ? (state.spnPayOrder.request?.amount ?? 0).toDouble()
            : 0.0);
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        itemWidget(
          title: 'ID Pemesanan',
          subTitle: state.orderId,
          endWidget: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: state.orderId));
                Snackbar.showInfo(message: 'ID Pemesanan disalin ke clipboard');
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ColorConstants.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorConstants.border, width: 0.8),
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
        itemWidget(
          title: 'Catatan',
          subTitle: (state.order?.notes ?? '').isEmpty
              ? 'Tidak ada catatan'
              : state.order!.notes!,
        ),
        itemWidget(
          title: 'Daftar Barang',
          subTitle: '${state.order?.notes ?? 'Item'} x 1',
          endWidget: Text(
            Format.rupiahConvert(amount),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ColorConstants.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget customerDetailWidget(HomeLogic logic) {
    final state = logic.state;
    final customerName = (state.order?.customerDisplayName ?? '-').isNotEmpty &&
            state.order?.customerDisplayName != '-'
        ? state.order!.customerDisplayName
        : (state.order?.project?.projectType == ProjectType.spnpay
            ? state.spnPayOrder.request?.viewName ?? '-'
            : '-');
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        itemWidget(
          title: 'Nama Lengkap',
          subTitle: customerName,
        ),
        itemWidget(
          title: 'Nomor Telepon',
          subTitle: (state.order?.phone ?? '').isNotEmpty
              ? (state.order!.phone!.startsWith('0') ||
                      state.order!.phone!.startsWith('+')
                  ? state.order!.phone!
                  : '0${state.order!.phone!}')
              : '-',
        ),
        itemWidget(
          title: 'Email',
          subTitle: (state.order?.email ?? '').isEmpty
              ? '-'
              : state.order!.email!,
        ),
        itemWidget(
          title: 'Alamat Pengiriman',
          subTitle: (state.order?.address ?? '').isEmpty
              ? '-'
              : state.order!.address!,
        ),
      ],
    );
  }
}
