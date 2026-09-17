import { Either } from "@/shared/utils/utility/either";
import { ResponseModel } from "@/shared/domain/model/response_model";
import { OrderRepository } from "../domain/repository/order_repository";
import { OrderRepositoryImpl } from "../infrastructure/persistence/order_repository_impl";
import { OrdersResponse } from "../domain/model/response/orders_response";
import { CreatePaymentRequest } from "../domain/model/request/create_payment_request";

export class OrderService {
  constructor(private repository: OrderRepository = new OrderRepositoryImpl()) {}

  async getDetailOrder(
    reference: string,
    token?: string,
    forceRefresh = false,
  ): Promise<Either<ResponseModel, OrdersResponse>> {
    return this.repository.getDetailOrder(reference, token, forceRefresh);
  }

  async checkOrderStatus(reference: string, token?: string): Promise<Either<ResponseModel, any>> {
    return this.repository.checkOrderStatus(reference, token);
  }

  async createPayment(request: CreatePaymentRequest, token?: string): Promise<Either<ResponseModel, any>> {
    return this.repository.createPayment(request, token);
  }
}
