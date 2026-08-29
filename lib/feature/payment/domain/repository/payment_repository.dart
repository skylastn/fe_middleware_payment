import 'package:dartz/dartz.dart';
import '../../../../shared/model/response_model.dart';
import '../model/response/payment_category.dart';
import '../model/response/payment_method.dart';

abstract class PaymentRepository {
  Future<Either<ResponseModel, List<PaymentCategory>>> getPaymentCategory();
  Future<Either<ResponseModel, List<PaymentResponse>>> getPaymentMethod({
    String? from,
    String? categoriesKey,
  });
  Future<Either<ResponseModel, PaymentResponse>> getDetailPaymentMethod();
}
