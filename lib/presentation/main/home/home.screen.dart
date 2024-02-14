import 'package:fe_middleware_payment/infrastructure/shared/utils/snackbar.dart';
import 'package:fe_middleware_payment/infrastructure/shared/widget/mobile_size_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../widget/main_widget.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key);
  var logic = Get.find<HomeController>();
  var state = Get.find<HomeController>().state;

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
                  const Column(
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        'Rp. 61.940',
                        style: TextStyle(
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
                    onPressed: () => Get.toNamed(
                      Routes.PAYMENT,
                      parameters: {
                        'orderId': state.orderId,
                      },
                    ),
                    child: Text(
                      "pembayaran".toUpperCase(),
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
              await Clipboard.setData(const ClipboardData(text: 'OTDN-ORD-29'));
              Snackbar.showInfo(message: 'Copied to your clipboard !');
            },
            child: const Icon(Icons.copy),
          ),
        ),
        itemWidget(
          title: 'Catatan',
          subTitle: 'Pembayaran ....',
        ),
        itemWidget(
          title: 'Daftar Barang',
          subTitle: 'Pembayaran .... x 1',
          endWidget: const Text(
            'Rp. 61.940',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Rp. 61.940',
              style: TextStyle(
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
          subTitle: 'AndalanSoftware',
        ),
        itemWidget(
          title: 'Nomor Telepon',
          subTitle: '(+62) 88124213134',
        ),
        itemWidget(
          title: 'Email',
          subTitle: 'andalansoftware@gmail.com',
        ),
        const Text(
          'Alamat Pengiriman',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Divider(thickness: 1),
        itemWidget(
          title: 'Sahid Rahutomo',
          subTitle: 'Jl. Jakarta Bandung',
        ),
        const Text(
          'Alamat Penagihan',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Divider(thickness: 1),
        itemWidget(
          title: 'Sahid Rahutomo',
          subTitle: 'Jl. Jakarta Bandung',
        ),
      ],
    );
  }
}
