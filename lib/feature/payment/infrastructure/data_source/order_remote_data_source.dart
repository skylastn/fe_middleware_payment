import 'package:get/get.dart';
import '../../../../shared/model/response_model.dart';
import '../../../../shared/provider/api_provider.dart';

class OrderRemoteDataSource {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<ResponseModel> getDetailOrder({required String reference}) {
    return _apiProvider.get('order/detail', query: {'reference': reference});
  }

  Future<ResponseModel> createOrderPayment({
    required String paymentMethod,
    required String reference,
  }) {
    return _apiProvider.post('order/createPayment', body: {
      'reference': reference,
      'paymentMethod': paymentMethod,
    });
  }
}
