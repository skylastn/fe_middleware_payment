import { Either } from "@/shared/utils/utility/either";
import { ResponseModel } from "@/shared/domain/model/response_model";
import { PaymentRepository } from "../domain/repository/payment_repository";
import { PaymentRepositoryImpl } from "../infrastructure/persistence/payment_repository_impl";
import { PaymentCategoryResponse } from "../domain/model/response/payment_category_response";
import { PaymentMethodResponse } from "../domain/model/response/payment_method_response";

export class PaymentService {
  constructor(private repository: PaymentRepository = new PaymentRepositoryImpl()) {}

  async getPaymentCategory(token?: string): Promise<Either<ResponseModel, PaymentCategoryResponse[]>> {
    return this.repository.getPaymentCategory(token);
  }

  async getPaymentMethod(
    params?: {
      paymentGatewayKey?: string;
      paymentGatewayId?: string;
      categoriesKey?: string;
    },
    token?: string,
  ): Promise<Either<ResponseModel, PaymentMethodResponse[]>> {
    return this.repository.getPaymentMethod(params, token);
  }

  async getDetailPaymentMethod(key?: string, token?: string): Promise<Either<ResponseModel, PaymentMethodResponse>> {
    return this.repository.getDetailPaymentMethod(key, token);
  }
}
