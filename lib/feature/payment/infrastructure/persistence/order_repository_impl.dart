import 'dart:convert';
import 'package:dartz/dartz.dart';

import '../../../../shared/model/response_model.dart';
import '../../domain/model/response/orders.dart';
import '../../domain/repository/order_repository.dart';
import '../data_source/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({OrderRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? OrderRemoteDataSource();

  @override
  Future<Either<ResponseModel, Orders>> getDetailOrder({
    required String reference,
  }) async {
    final response =
        await remoteDataSource.getDetailOrder(reference: reference);
    if (!response.isError) {
      return Right(
        Orders.fromJson(
          jsonDecode(response.result?.body ?? '')['data'],
        ),
      );
    }
    return Left(response);
  }

  @override
  Future<Either<ResponseModel, ResponseModel>> createOrderPayment({
    required String paymentMethod,
    required String reference,
  }) async {
    final response = await remoteDataSource.createOrderPayment(
      paymentMethod: paymentMethod,
      reference: reference,
    );
    if (!response.isError) {
      return Right(response);
    }
    return Left(response);
  }
}
