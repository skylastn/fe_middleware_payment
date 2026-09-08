import { Either, left, right } from "@/shared/utils/utility/either";
import { ResponseModel } from "@/shared/domain/model/response_model";
import { OrderRepository } from "../../domain/repository/order_repository";
import { OrderRemoteDataSource } from "../data_source/remote/order_remote_data_source";
import { OrdersResponse } from "../../domain/model/response/orders_response";
import { CreatePaymentRequest } from "../../domain/model/request/create_payment_request";

export class OrderRepositoryImpl implements OrderRepository {
  private dataSource: OrderRemoteDataSource;

  constructor(dataSource?: OrderRemoteDataSource) {
    this.dataSource = dataSource ?? new OrderRemoteDataSource();
  }

  async getDetailOrder(reference: string, token?: string): Promise<Either<ResponseModel, OrdersResponse>> {
    const res = await this.dataSource.getDetailOrder(reference, token);
    if (res.status && res.data) {
      return right(res.data);
    }
    return left(res);
  }

  async checkOrderStatus(reference: string, token?: string): Promise<Either<ResponseModel, any>> {
    const res = await this.dataSource.checkOrderStatus(reference, token);
    if (res.status) {
      return right(res.data);
    }
    return left(res);
  }

  async createPayment(request: CreatePaymentRequest, token?: string): Promise<Either<ResponseModel, any>> {
    const res = await this.dataSource.createPayment(request, token);
    if (res.status) {
      return right(res.data);
    }
    return left(res);
  }
}
