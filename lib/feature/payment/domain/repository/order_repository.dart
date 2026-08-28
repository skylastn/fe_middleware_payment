import 'package:dartz/dartz.dart';
import '../../../../shared/model/response_model.dart';
import '../model/response/orders.dart';

abstract class OrderRepository {
  Future<Either<ResponseModel, Orders>> getDetailOrder({
    required String reference,
  });

  Future<Either<ResponseModel, ResponseModel>> createOrderPayment({
    required String paymentMethod,
    required String reference,
  });
}
