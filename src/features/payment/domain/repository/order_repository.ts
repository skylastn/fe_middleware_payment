import { Either } from "@/shared/utils/utility/either";
import { ResponseModel } from "@/shared/domain/model/response_model";
import { OrdersResponse } from "../model/response/orders_response";
import { CreatePaymentRequest } from "../model/request/create_payment_request";

export interface OrderRepository {
  getDetailOrder(reference: string, token?: string, forceRefresh?: boolean): Promise<Either<ResponseModel, OrdersResponse>>;
  checkOrderStatus(reference: string, token?: string): Promise<Either<ResponseModel, any>>;
  createPayment(request: CreatePaymentRequest, token?: string): Promise<Either<ResponseModel, any>>;
}
