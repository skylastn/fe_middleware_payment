import 'dart:convert';
import 'package:dartz/dartz.dart';

import '../../../../shared/model/response_model.dart';
import '../../domain/model/response/payment_category.dart';
import '../../domain/model/response/payment_method.dart';
import '../../domain/repository/payment_repository.dart';
import '../data_source/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({PaymentRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? PaymentRemoteDataSource();

  @override
  Future<Either<ResponseModel, List<PaymentCategory>>>
      getPaymentCategory() async {
    final response = await remoteDataSource.getPaymentCategory();
    if (!response.isError) {
      return Right(
        paymentCategoryFromJson(
          jsonDecode(response.result?.body ?? '')['data'],
        ),
      );
    }
    return Left(response);
  }

  @override
  Future<Either<ResponseModel, List<PaymentResponse>>>
      getPaymentMethod() async {
    final response = await remoteDataSource.getPaymentMethod();
    if (!response.isError) {
      return Right(
        List.from(
          jsonDecode(response.result?.body ?? '')['data']
              .map((e) => PaymentResponse.fromMap(e)),
        ),
      );
    }
    return Left(response);
  }

  @override
  Future<Either<ResponseModel, PaymentResponse>>
      getDetailPaymentMethod() async {
    final response = await remoteDataSource.getDetailPaymentMethod();
    if (!response.isError &&
        jsonDecode(response.result?.body ?? '')['data'] != null) {
      return Right(
        PaymentResponse.fromMap(
          jsonDecode(response.result?.body ?? '')['data'],
        ),
      );
    }
    return Left(response);
  }
}
