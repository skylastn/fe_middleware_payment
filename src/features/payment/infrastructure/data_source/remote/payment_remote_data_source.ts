import { ApiClient } from "@/shared/network/api_client";
import { HttpMethod } from "@/shared/domain/model/enum/http_method";
import { UrlPath } from "@/shared/constant/url_path";
import { ResponseModel } from "@/shared/domain/model/response_model";
import { PaymentCategoryResponse } from "../../../domain/model/response/payment_category_response";
import { PaymentMethodResponse } from "../../../domain/model/response/payment_method_response";

const categoryCache = new Map<string, { data: ResponseModel<PaymentCategoryResponse[]>; expiresAt: number }>();
const methodCache = new Map<string, { data: ResponseModel<PaymentMethodResponse[]>; expiresAt: number }>();
const pendingCategoryRequests = new Map<string, Promise<ResponseModel<PaymentCategoryResponse[]>>>();
const pendingMethodRequests = new Map<string, Promise<ResponseModel<PaymentMethodResponse[]>>>();

export class PaymentRemoteDataSource {
  private client: ApiClient;

  constructor(client?: ApiClient) {
    this.client = client ?? new ApiClient();
  }

  static invalidateCache(): void {
    categoryCache.clear();
    methodCache.clear();
  }

  async getPaymentCategory(token?: string, forceRefresh = false): Promise<ResponseModel<PaymentCategoryResponse[]>> {
    const cacheKey = token || "default";
    const now = Date.now();

    if (!forceRefresh) {
      const cached = categoryCache.get(cacheKey);
      if (cached && cached.expiresAt > now) {
        return cached.data;
      }

      const pending = pendingCategoryRequests.get(cacheKey);
      if (pending) {
        return pending;
      }
    }

    const requestPromise = (async () => {
      try {
        const res = await this.client.request<PaymentCategoryResponse[]>({
          path: UrlPath.CLIENT_PAYMENT_CATEGORY,
          method: HttpMethod.GET,
          token,
        });

        if (res.status && res.data) {
          categoryCache.set(cacheKey, { data: res, expiresAt: Date.now() + 60000 });
        }

        return res;
      } finally {
        pendingCategoryRequests.delete(cacheKey);
      }
    })();

    pendingCategoryRequests.set(cacheKey, requestPromise);
    return requestPromise;
  }

  async getPaymentMethod(
    params?: {
      paymentGatewayKey?: string;
      paymentGatewayId?: string;
      categoriesKey?: string;
    },
    token?: string,
    forceRefresh = false,
  ): Promise<ResponseModel<PaymentMethodResponse[]>> {
    const query: Record<string, string> = {};
    if (params?.paymentGatewayKey) query["payment_gateway_key"] = params.paymentGatewayKey;
    if (params?.paymentGatewayId) query["payment_gateway_id"] = params.paymentGatewayId;
    if (params?.categoriesKey) query["categoriesKey"] = params.categoriesKey;

    const cacheKey = `${JSON.stringify(query)}:${token || "default"}`;
    const now = Date.now();

    if (!forceRefresh) {
      const cached = methodCache.get(cacheKey);
      if (cached && cached.expiresAt > now) {
        return cached.data;
      }

      const pending = pendingMethodRequests.get(cacheKey);
      if (pending) {
        return pending;
      }
    }

    const requestPromise = (async () => {
      try {
        const res = await this.client.request<PaymentMethodResponse[]>({
          path: UrlPath.CLIENT_PAYMENT_METHOD,
          method: HttpMethod.GET,
          params: query,
          token,
        });

        if (res.status && res.data) {
          methodCache.set(cacheKey, { data: res, expiresAt: Date.now() + 60000 });
        }

        return res;
      } finally {
        pendingMethodRequests.delete(cacheKey);
      }
    })();

    pendingMethodRequests.set(cacheKey, requestPromise);
    return requestPromise;
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
