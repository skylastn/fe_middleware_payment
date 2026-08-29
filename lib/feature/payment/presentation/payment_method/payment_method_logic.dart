import 'package:get/get.dart';

import '../../../../shared/model/state_status.dart';
import '../../../../shared/navigation/routes.dart';
import '../../../../shared/utility/snackbar.dart';
import '../../application/order_service.dart';
import '../../application/payment_service.dart';
import '../../domain/model/response/payment_category.dart';
import '../../domain/model/response/payment_method.dart';
import 'payment_method_state.dart';

class PaymentMethodLogic extends GetxController {
  final state = PaymentMethodState();
  final PaymentService _paymentService = PaymentService();
  final OrderService _orderService = OrderService();

  @override
  void onReady() {
    super.onReady();
    state.orderId = Get.parameters['reference'] ?? '';
    if (state.orderId.isEmpty) {
      Snackbar.showInfo(message: 'Sorry Order ID is Empty');
    }
    fetchPaymentMethods();
  }

  Future<void> fetchPaymentMethods() async {
    state.status = StateStatus.loading;
    update();

    String? fromFilter = Get.parameters['from'];
    if ((fromFilter == null || fromFilter.isEmpty) && state.orderId.isNotEmpty) {
      final orderResult = await _orderService.getDetailOrder(reference: state.orderId);
      orderResult.fold((_) {}, (order) {
        if (order.project?.slug != null && order.project!.slug.isNotEmpty) {
          fromFilter = order.project!.slug.toLowerCase();
        }
      });
    }

    final categoriesResult = await _paymentService.getPaymentCategory();
    final methodsResult = await _paymentService.getPaymentMethod(from: fromFilter);

    categoriesResult.fold(
      (errCat) {
        state.status = StateStatus.error;
        state.errorMsg = errCat.msg;
        update();
      },
      (categories) {
        methodsResult.fold(
          (errMethod) {
            state.status = StateStatus.error;
            state.errorMsg = errMethod.msg;
            update();
          },
          (methods) {
            final List<PaymentCategory> resultCategories = [];

            for (var cat in categories) {
              final catMethods = methods.where((m) {
                if (m.category?.key != null && m.category!.key == cat.key) {
                  return true;
                }
                if (m.type != null && m.type == cat.key) {
                  return true;
                }
                return false;
              }).toList();

              if (catMethods.isNotEmpty) {
                resultCategories.add(
                  PaymentCategory(
                    id: cat.id,
                    key: cat.key,
                    title: cat.title,
                    detail: cat.detail,
                    createdAt: cat.createdAt,
                    updatedAt: cat.updatedAt,
                    paymentMethods: catMethods,
                  ),
                );
              }
            }

            final uncategorizedMethods = methods.where((m) {
              final catKey = m.category?.key ?? m.type;
              return !categories.any((c) => c.key == catKey);
            }).toList();

            if (uncategorizedMethods.isNotEmpty) {
              resultCategories.add(
                PaymentCategory(
                  id: 0,
                  key: 'other',
                  title: 'Metode Lainnya',
                  detail: 'Pilihan saluran pembayaran lainnya',
                  paymentMethods: uncategorizedMethods,
                ),
              );
            }

            state.categories = resultCategories;
            state.status = StateStatus.success;
            update();
          },
        );
      },
    );
  }

  Future<void> routeToDetail(PaymentResponse content, PaymentCategory category) async {
    final token = Get.parameters['token'] ?? '';
    final paymentCode = content.key ?? '';
    if (paymentCode.isEmpty) return;

    state.status = StateStatus.loading;
    update();

    final result = await _orderService.createOrderPayment(
      paymentMethod: paymentCode,
      reference: state.orderId,
    );

    result.fold(
      (err) {
        state.status = StateStatus.error;
        state.errorMsg = err.msg;
        Snackbar.showInfo(message: err.msg);
        update();
      },
      (_) {
        state.status = StateStatus.success;
        update();

        final params = <String, String>{
          'reference': state.orderId,
        };
        if (token.isNotEmpty) {
          params['token'] = token;
        }

        Get.toNamed(
          Routes.DETAILPAYMENT,
          parameters: params,
        );
      },
    );
  }
}
