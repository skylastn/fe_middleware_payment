import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../shared/model/response_model.dart';
import '../domain/model/response/payment_category.dart';
import '../domain/model/response/payment_method.dart';
import '../domain/repository/payment_repository.dart';

class PaymentService {
  final PaymentRepository repository = Get.find<PaymentRepository>();

  Future<Either<ResponseModel, List<PaymentCategory>>> getPaymentCategory() {
    return repository.getPaymentCategory();
  }

  Future<Either<ResponseModel, List<PaymentResponse>>> getPaymentMethod() {
    return repository.getPaymentMethod();
  }

  Future<Either<ResponseModel, PaymentResponse>> getDetailPaymentMethod() {
    return repository.getDetailPaymentMethod();
  }
}
