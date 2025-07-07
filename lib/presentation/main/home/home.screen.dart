import '../../../shared/utils/snackbar.dart';
import '../../../shared/widget/mobile_size_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../domain/model/response/project.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../shared/utils/format.dart';
import '../../../shared/widget/state_widget.dart';
import '../widget/main_widget.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});
  final logic = Get.find<HomeController>();
  final state = Get.find<HomeController>().state;

  @override
  Widget build(BuildContext context) {
    return MobileSizeWidget(
      body: GetBuilder<HomeController>(
        builder: (_) => SizedBox(
          height: context.isPhone
              ? Get.height
              : state.tabIndex == 0
                  ? Get.height * 0.65
                  : Get.height * 0.88,
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
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
                          'Rincian Belanja',
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
                child: StateWidget().initial(
                  stateStatus: state.status,
                  body: descriptionWidget(),
                ),
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
        child: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TabBar(
                controller: state.tabController,
                onTap: (index) {
                  state.tabIndex = index;
                  logic.update();
                },
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: const EdgeInsets.only(bottom: 10, top: 10),
                tabs: const [
                  Text(
                    'PESANAN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'PELANGGAN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  controller: state.tabController,
                  children: [
                    orderDetailWidget(),
                    customerDetailWidget(),
                  ],
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
                      if (state.order?.project?.projectType ==
                          ProjectType.spnpay)
                        Text(
                          Format.rupiahConvert(
                            (state.spnPayOrder.request?.amount ?? 0).toDouble(),
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
                    onPressed: () => Get.toNamed(
                      Routes.PAYMENT,
                      parameters: {
                        'reference': state.orderId,
                      },
                    ),
                    child: Text(
                      'pembayaran'.toUpperCase(),
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

  Widget orderDetailWidget() {
    return ListView(
      children: [
        const SizedBox(height: 16),
        itemWidget(
          title: 'Id Pemesanan',
          subTitle: state.orderId,
          endWidget: InkWell(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: state.orderId));
              Snackbar.showInfo(message: 'Copied to your clipboard !');
            },
            child: const Icon(Icons.copy),
          ),
        ),
        itemWidget(
          title: 'Catatan',
          subTitle: state.order?.notes ?? '',
        ),
        itemWidget(
          title: 'Daftar Barang',
          subTitle: '${state.order?.notes ?? ''} x 1',
          endWidget: Text(
            Format.rupiahConvert(
                state.order?.project?.projectType == ProjectType.spnpay
                    ? (state.spnPayOrder.request?.amount ?? 0).toDouble()
                    : 0),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              Format.rupiahConvert(
                  state.order?.project?.projectType == ProjectType.spnpay
                      ? (state.spnPayOrder.request?.amount ?? 0).toDouble()
                      : 0),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget customerDetailWidget() {
    return ListView(
      children: [
        const SizedBox(height: 16),
        itemWidget(
          title: 'Nama Lengkap',
          subTitle: state.order?.project?.projectType == ProjectType.spnpay
              ? state.spnPayOrder.request?.viewName ?? ''
              : '',
        ),
        itemWidget(
          title: 'Nomor Telepon',
          subTitle: (state.order?.phone ?? '').isNotEmpty
              ? state.order!.phone!.substring(1, state.order?.phone?.length)
              : '',
        ),
        itemWidget(
          title: 'Email',
          subTitle: state.order?.email ?? '',
        ),

        const Text(
          'Alamat',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Divider(thickness: 1),
        itemWidget(
          title: state.order?.project?.projectType == ProjectType.spnpay
              ? state.spnPayOrder.request?.viewName ?? ''
              : '',
          subTitle: state.order?.address ?? '',
        ),
        // const Text(
        //   'Alamat Pengiriman',
        //   style: TextStyle(
        //     fontSize: 15,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        // const Divider(thickness: 1),
        // itemWidget(
        //   title: 'Sahid Rahutomo',
        //   subTitle: 'Jl. Jakarta Bandung',
        // ),
        // const Text(
        //   'Alamat Penagihan',
        //   style: TextStyle(
        //     fontSize: 15,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        // const Divider(thickness: 1),
        // itemWidget(
        //   title: 'Sahid Rahutomo',
        //   subTitle: 'Jl. Jakarta Bandung',
        // ),
      ],
    );
  }
}
