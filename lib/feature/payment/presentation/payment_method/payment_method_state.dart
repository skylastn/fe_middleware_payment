import '../../../../shared/model/state_status.dart';
import '../../domain/model/response/payment_category.dart';

class PaymentMethodState {
  String orderId = '';
  StateStatus status = StateStatus.inital;
  String errorMsg = '';
  List<PaymentCategory> categories = [];
}
