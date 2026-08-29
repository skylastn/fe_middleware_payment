import 'package:get/get.dart';
import '../../../../shared/model/response_model.dart';
import '../../../../shared/provider/api_provider.dart';

class PaymentRemoteDataSource {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<ResponseModel> getPaymentCategory() {
    return _apiProvider.get('client/payment/getPaymentCategory');
  }

  Future<ResponseModel> getPaymentMethod({String? from, String? categoriesKey}) {
    final query = <String, dynamic>{};
    if (from != null && from.isNotEmpty) query['from'] = from;
    if (categoriesKey != null && categoriesKey.isNotEmpty) {
      query['categoriesKey'] = categoriesKey;
    }
    return _apiProvider.get('client/payment/getPaymentMethod', query: query.isNotEmpty ? query : null);
  }

  Future<ResponseModel> getDetailPaymentMethod() {
    return _apiProvider.get('client/payment/getDetailPaymentMethod');
  }
}
