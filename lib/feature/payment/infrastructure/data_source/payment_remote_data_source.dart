import 'package:get/get.dart';
import '../../../../shared/model/response_model.dart';
import '../../../../shared/provider/api_provider.dart';

class PaymentRemoteDataSource {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<ResponseModel> getPaymentCategory() {
    return _apiProvider.get('payment/getPaymentCategory');
  }

  Future<ResponseModel> getPaymentMethod() {
    return _apiProvider.get('payment/getPaymentMethod');
  }

  Future<ResponseModel> getDetailPaymentMethod() {
    return _apiProvider.get('payment/getDetailPaymentMethod');
  }
}
