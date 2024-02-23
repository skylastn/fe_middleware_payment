import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fe_middleware_payment/domain/model/ResponseModel.dart';
import '../../domain/model/response/payment_category.dart';
import '../../domain/model/response/payment_method.dart';
import '../network/remote_source.dart';

class PaymentRepository {
  Future<Either<ResponseModel, List<PaymentCategory>>>
      getPaymentCategory() async {
    var response = await RemoteSource().getApi('payment/getPaymentCategory');
    if (!response.isError) {
      return Right(
        paymentCategoryFromJson(
          jsonDecode(response.result?.body ?? '')['data'],
        ),
      );
    }
    return Left(response);
  }

  Future<Either<ResponseModel, List<PaymentMethod>>> getPaymentMethod() async {
    var response = await RemoteSource().getApi('payment/getPaymentMethod');
    if (!response.isError) {
      return Right(
        paymentMethodFromJson(
          jsonDecode(response.result?.body ?? '')['data'],
        ),
      );
    }
    return Left(response);
  }

  Future<Either<ResponseModel, PaymentMethod>> getDetailPaymentMethod() async {
    var response =
        await RemoteSource().getApi('payment/getDetailPaymentMethod');
    if (!response.isError &&
        jsonDecode(response.result?.body ?? '')['data'] != null) {
      return Right(
        PaymentMethod.fromJson(
          jsonDecode(response.result?.body ?? '')['data'],
        ),
      );
    }
    return Left(response);
  }
}
