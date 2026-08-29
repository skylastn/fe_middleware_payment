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
      try {
        final body = jsonDecode(response.result?.body ?? '');
        final data = body['data'];
        return Right(paymentCategoryFromJson(data));
      } catch (e) {
        return Left(ResponseModel(isError: true, result: response.result, msg: e.toString()));
      }
    }
    return Left(response);
  }

  @override
  Future<Either<ResponseModel, List<PaymentResponse>>> getPaymentMethod({
    String? from,
    String? categoriesKey,
  }) async {
    final response = await remoteDataSource.getPaymentMethod(
      from: from,
      categoriesKey: categoriesKey,
    );
    if (!response.isError) {
      try {
        final body = jsonDecode(response.result?.body ?? '');
        final data = body['data'];
        if (data is List) {
          return Right(
            List<PaymentResponse>.from(
              data.map((e) => PaymentResponse.fromMap(e)),
            ),
          );
        }
        return const Right([]);
      } catch (e) {
        return Left(ResponseModel(isError: true, result: response.result, msg: e.toString()));
      }
    }
    return Left(response);
  }

  @override
  Future<Either<ResponseModel, PaymentResponse>>
      getDetailPaymentMethod() async {
    final response = await remoteDataSource.getDetailPaymentMethod();
    if (!response.isError) {
      try {
        final body = jsonDecode(response.result?.body ?? '');
        final data = body['data'];
        if (data != null) {
          return Right(PaymentResponse.fromMap(data));
        }
      } catch (e) {
        return Left(ResponseModel(isError: true, result: response.result, msg: e.toString()));
      }
    }
    return Left(response);
  }
}
