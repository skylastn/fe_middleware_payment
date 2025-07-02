import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../domain/model/response_model.dart';
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

  Future<Either<ResponseModel, List<PaymentResponse>>>
      getPaymentMethod() async {
    var response = await RemoteSource().getApi('payment/getPaymentMethod');
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

  Future<Either<ResponseModel, PaymentResponse>>
      getDetailPaymentMethod() async {
    var response =
        await RemoteSource().getApi('payment/getDetailPaymentMethod');
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
