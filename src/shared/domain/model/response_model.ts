import { AxiosResponse } from "axios";

export class ResponseModel<T = unknown> {
  status = false;
  success = false;
  code?: number;
  message?: string;
  total?: number;
  perPage?: number;
  currentPage?: number;
  data?: T;

  static from<T>(
    res: AxiosResponse<{
      status?: boolean;
      success?: boolean;
      code?: number;
      message?: string;
      total?: number;
      perPage?: number;
      currentPage?: number;
      data?: T;
    }>,
  ): ResponseModel<T> {
    const raw = res.data ?? {};

    const isSuccess =
      typeof raw.status === "boolean"
        ? raw.status
        : typeof raw.success === "boolean"
        ? raw.success
        : res.status >= 200 && res.status < 300;

    return {
      status: isSuccess,
      success: isSuccess,
      code: raw.code ?? res.status,
      message: raw.message ?? res.statusText ?? "Success",
      total: raw.total,
      perPage: raw.perPage,
      currentPage: raw.currentPage,
      data: raw.data,
    };
  }

  static fromError(error: unknown): ResponseModel<never> {
    const res = new ResponseModel<never>();
    res.status = false;
    res.success = false;
    res.message = error instanceof Error ? error.message : "Unknown error";
    return res;
  }
}
