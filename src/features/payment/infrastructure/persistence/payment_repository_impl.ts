import { Either, left, right } from "@/shared/utils/utility/either";
import { ResponseModel } from "@/shared/domain/model/response_model";
import { PaymentRepository } from "../../domain/repository/payment_repository";
import { PaymentRemoteDataSource } from "../data_source/remote/payment_remote_data_source";
import { PaymentCategoryResponse } from "../../domain/model/response/payment_category_response";
import { PaymentMethodResponse } from "../../domain/model/response/payment_method_response";

export class PaymentRepositoryImpl implements PaymentRepository {
  private dataSource: PaymentRemoteDataSource;

  constructor(dataSource?: PaymentRemoteDataSource) {
    this.dataSource = dataSource ?? new PaymentRemoteDataSource();
  }

  async getPaymentCategory(token?: string): Promise<Either<ResponseModel, PaymentCategoryResponse[]>> {
    const res = await this.dataSource.getPaymentCategory(token);
    if (res.status && Array.isArray(res.data)) {
      return right(res.data);
    }
    return left(res);
  }

  async getPaymentMethod(
    params?: {
      paymentGatewayKey?: string;
      paymentGatewayId?: string;
      categoriesKey?: string;
    },
    token?: string,
  ): Promise<Either<ResponseModel, PaymentMethodResponse[]>> {
    const res = await this.dataSource.getPaymentMethod(params, token);
    if (res.status && Array.isArray(res.data)) {
      return right(res.data);
    }
    return left(res);
  }

  async getDetailPaymentMethod(key?: string, token?: string): Promise<Either<ResponseModel, PaymentMethodResponse>> {
    const res = await this.dataSource.getDetailPaymentMethod(key, token);
    if (res.status && res.data) {
      return right(res.data);
    }
    return left(res);
  }
}
