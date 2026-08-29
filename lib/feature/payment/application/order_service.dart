import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../shared/model/response_model.dart';
import '../domain/model/response/orders.dart';
import '../domain/repository/order_repository.dart';

class OrderService {
  final OrderRepository repository = Get.find<OrderRepository>();

  Future<Either<ResponseModel, Orders>> getDetailOrder({
    required String reference,
  }) {
    return repository.getDetailOrder(reference: reference);
  }

  Future<Either<ResponseModel, ResponseModel>> createOrderPayment({
    required String paymentMethod,
    required String reference,
  }) {
    return repository.createOrderPayment(
      paymentMethod: paymentMethod,
      reference: reference,
    );
  }
}
