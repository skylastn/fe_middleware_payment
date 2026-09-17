import { ApiClient } from "@/shared/network/api_client";
import { HttpMethod } from "@/shared/domain/model/enum/http_method";
import { UrlPath } from "@/shared/constant/url_path";
import { ResponseModel } from "@/shared/domain/model/response_model";
import { OrdersResponse } from "../../../domain/model/response/orders_response";
import { CreatePaymentRequest } from "../../../domain/model/request/create_payment_request";

const orderCache = new Map<string, { data: ResponseModel<OrdersResponse>; expiresAt: number }>();
const pendingOrderRequests = new Map<string, Promise<ResponseModel<OrdersResponse>>>();

export class OrderRemoteDataSource {
  private client: ApiClient;

  constructor(client?: ApiClient) {
    this.client = client ?? new ApiClient();
  }

  static invalidateCache(reference?: string): void {
    if (reference) {
      for (const key of orderCache.keys()) {
        if (key.startsWith(`${reference}:`)) {
          orderCache.delete(key);
        }
      }
    } else {
      orderCache.clear();
    }
  }

  async getDetailOrder(
    reference: string,
    token?: string,
    forceRefresh = false,
  ): Promise<ResponseModel<OrdersResponse>> {
    const cacheKey = `${reference}:${token || ""}`;
    const now = Date.now();

    if (!forceRefresh) {
      const cached = orderCache.get(cacheKey);
      if (cached && cached.expiresAt > now) {
        return cached.data;
      }

      const pending = pendingOrderRequests.get(cacheKey);
      if (pending) {
        return pending;
      }
    }

    const requestPromise = (async () => {
      try {
        const res = await this.client.request<OrdersResponse>({
          path: UrlPath.CLIENT_ORDER_DETAIL,
          method: HttpMethod.GET,
          params: { reference },
          token,
        });

        if (res.status && res.data) {
          orderCache.set(cacheKey, { data: res, expiresAt: Date.now() + 30000 });
        }

        return res;
      } finally {
        pendingOrderRequests.delete(cacheKey);
      }
    })();

    pendingOrderRequests.set(cacheKey, requestPromise);
    return requestPromise;
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
    OrderRemoteDataSource.invalidateCache(request.reference);

    return this.client.request<any>({
      path: UrlPath.CLIENT_ORDER_CREATE_PAYMENT,
      method: HttpMethod.POST,
      data: request,
      token,
    });
  }
}
