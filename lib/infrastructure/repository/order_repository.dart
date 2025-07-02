import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../domain/model/response_model.dart';
import '../../domain/model/response/orders.dart';
import '../network/remote_source.dart';

class OrderRepository {
  Future<Either<ResponseModel, Orders>> getDetailOrder({
    required String reference,
  }) async {
    var response = await RemoteSource().getApi('order/detail', query: {
      'reference': reference,
    });
    if (!response.isError) {
      return Right(
        Orders.fromJson(
          jsonDecode(response.result?.body ?? '')['data'],
        ),
      );
    }
    return Left(response);
  }

  Future<Either<ResponseModel, ResponseModel>> createOrderPayment({
    required String paymentMethod,
    required String reference,
  }) async {
    var response = await RemoteSource().postApi('order/createPayment', body: {
      'reference': reference,
      'paymentMethod': paymentMethod,
    });
    if (!response.isError) {
      return Right(response);
    }
    return Left(response);
  }
}
