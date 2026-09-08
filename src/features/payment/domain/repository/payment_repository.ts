import { Either } from "@/shared/utils/utility/either";
import { ResponseModel } from "@/shared/domain/model/response_model";
import { PaymentCategoryResponse } from "../model/response/payment_category_response";
import { PaymentMethodResponse } from "../model/response/payment_method_response";

export interface PaymentRepository {
  getPaymentCategory(token?: string): Promise<Either<ResponseModel, PaymentCategoryResponse[]>>;
  getPaymentMethod(
    params?: {
      paymentGatewayKey?: string;
      paymentGatewayId?: string;
      categoriesKey?: string;
    },
    token?: string,
  ): Promise<Either<ResponseModel, PaymentMethodResponse[]>>;
  getDetailPaymentMethod(key?: string, token?: string): Promise<Either<ResponseModel, PaymentMethodResponse>>;
}
