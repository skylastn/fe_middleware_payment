import { ApiClient } from "@/shared/network/api_client";
import { HttpMethod } from "@/shared/domain/model/enum/http_method";
import { UrlPath } from "@/shared/constant/url_path";
import { ResponseModel } from "@/shared/domain/model/response_model";
import { PaymentCategoryResponse } from "../../../domain/model/response/payment_category_response";
import { PaymentMethodResponse } from "../../../domain/model/response/payment_method_response";

export class PaymentRemoteDataSource {
  private client: ApiClient;

  constructor(client?: ApiClient) {
    this.client = client ?? new ApiClient();
  }

  async getPaymentCategory(token?: string): Promise<ResponseModel<PaymentCategoryResponse[]>> {
    return this.client.request<PaymentCategoryResponse[]>({
      path: UrlPath.CLIENT_PAYMENT_CATEGORY,
      method: HttpMethod.GET,
      token,
    });
  }

  async getPaymentMethod(
    params?: {
      paymentGatewayKey?: string;
      paymentGatewayId?: string;
      categoriesKey?: string;
    },
    token?: string,
  ): Promise<ResponseModel<PaymentMethodResponse[]>> {
    const query: Record<string, string> = {};
    if (params?.paymentGatewayKey) query["payment_gateway_key"] = params.paymentGatewayKey;
    if (params?.paymentGatewayId) query["payment_gateway_id"] = params.paymentGatewayId;
    if (params?.categoriesKey) query["categoriesKey"] = params.categoriesKey;

    return this.client.request<PaymentMethodResponse[]>({
      path: UrlPath.CLIENT_PAYMENT_METHOD,
      method: HttpMethod.GET,
      params: query,
      token,
    });
  }

  async getDetailPaymentMethod(key?: string, token?: string): Promise<ResponseModel<PaymentMethodResponse>> {
    return this.client.request<PaymentMethodResponse>({
      path: UrlPath.CLIENT_PAYMENT_DETAIL,
      method: HttpMethod.GET,
      params: key ? { key } : undefined,
      token,
    });
  }
}
