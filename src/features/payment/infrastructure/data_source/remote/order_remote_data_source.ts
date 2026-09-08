import { ApiClient } from "@/shared/network/api_client";
import { HttpMethod } from "@/shared/domain/model/enum/http_method";
import { UrlPath } from "@/shared/constant/url_path";
import { ResponseModel } from "@/shared/domain/model/response_model";
import { OrdersResponse } from "../../../domain/model/response/orders_response";
import { CreatePaymentRequest } from "../../../domain/model/request/create_payment_request";

export class OrderRemoteDataSource {
  private client: ApiClient;

  constructor(client?: ApiClient) {
    this.client = client ?? new ApiClient();
  }

  async getDetailOrder(reference: string, token?: string): Promise<ResponseModel<OrdersResponse>> {
    return this.client.request<OrdersResponse>({
      path: UrlPath.CLIENT_ORDER_DETAIL,
      method: HttpMethod.GET,
      params: { reference },
      token,
    });
  }

  async checkOrderStatus(reference: string, token?: string): Promise<ResponseModel<any>> {
    return this.client.request<any>({
      path: UrlPath.CLIENT_ORDER_CHECK_STATUS,
      method: HttpMethod.GET,
      params: { reference },
      token,
    });
  }

  async createPayment(request: CreatePaymentRequest, token?: string): Promise<ResponseModel<any>> {
    return this.client.request<any>({
      path: UrlPath.CLIENT_ORDER_CREATE_PAYMENT,
      method: HttpMethod.POST,
      data: request,
      token,
    });
  }
}
