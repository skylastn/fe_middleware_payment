import axios, { AxiosError, AxiosInstance } from "axios";
import { Env } from "../constant/env";
import { HttpMethod } from "../domain/model/enum/http_method";
import { ResponseHttpType } from "../domain/model/enum/response_http_type";
import { ResponseModel } from "../domain/model/response_model";

export class ApiClient {
  private axiosInstance: AxiosInstance;

  constructor(baseURL: string = Env.apiUrl) {
    this.axiosInstance = axios.create({
      baseURL,
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
      },
      timeout: 30000,
    });

    this.axiosInstance.interceptors.request.use((config) => {
      // Auto-extract token from URL or localStorage if running in browser
      if (typeof window !== "undefined") {
        const urlParams = new URLSearchParams(window.location.search);
        const queryToken = urlParams.get("token");
        const storedToken = sessionStorage.getItem("client_payment_token");
        const token = queryToken || storedToken;

        if (token) {
          config.headers = config.headers ?? {};
          config.headers["Token"] = token;
          if (queryToken && queryToken !== storedToken) {
            sessionStorage.setItem("client_payment_token", queryToken);
          }
        }
      }
      return config;
    });
  }

  async request<TResponse = unknown, TParams = unknown, TBody = unknown>(args: {
    path: string;
    method: HttpMethod;
    params?: TParams;
    data?: TBody;
    url?: string;
    token?: string;
    responseType?: ResponseHttpType;
    signal?: AbortSignal;
  }): Promise<ResponseModel<TResponse>> {
    const {
      path,
      method,
      params,
      data,
      url,
      token,
      responseType = ResponseHttpType.JSON,
      signal,
    } = args;

    const cleanPath = path.replace(/^\/+/, "");
    const endpoint = url
      ? `${url.replace(/\/+$/, "")}/${cleanPath}`
      : `/${cleanPath}`;

    const headers: Record<string, string> = {};
    if (token) {
      headers["Token"] = token;
    }

    const requestConfig = {
      url: endpoint,
      method,
      params,
      data,
      headers,
      responseType,
      signal,
    };

    try {
      const res = await this.axiosInstance.request(requestConfig);

      if (Array.isArray(res.data)) {
        const result = new ResponseModel<TResponse>();
        result.status = true;
        result.success = true;
        result.message = "Success";
        result.data = res.data as TResponse;
        return result;
      }
      return ResponseModel.from<TResponse>(res);
    } catch (error: unknown) {
      if (axios.isCancel(error)) {
        const result = new ResponseModel<TResponse>();
        result.status = false;
        result.success = false;
        result.message = "Request cancelled";
        return result;
      }

      const err = error as AxiosError<{
        message?: string;
        data?: TResponse;
      }>;
      const message =
        err.response?.data?.message ?? err.message ?? "Network error";

      const result = new ResponseModel<TResponse>();
      result.status = false;
      result.success = false;
      result.message = message;
      result.data = err.response?.data?.data;

      return result;
    }
  }
}
