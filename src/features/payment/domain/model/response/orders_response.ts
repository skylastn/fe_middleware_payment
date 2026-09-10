import { PaymentMethodResponse } from "./payment_method_response";
import { ProjectResponse } from "./project_response";

export interface OrdersResponse {
  id?: number | string;
  type?: string;
  reference?: string;
  name?: string;
  status?: string;
  mode?: string;
  email?: string;
  address?: string;
  phone?: string;
  notes?: string;
  payment_method?: string;
  payment_methods?: PaymentMethodResponse;
  amount?: number;
  project?: ProjectResponse;
  request?: string | Record<string, any>;
  response?: string | Record<string, any>;
  callback?: string | Record<string, any>;
  value?: string;
  url?: string;
  return_url?: string;
  created_at?: string;
  updated_at?: string;

  // Computed helper fields
  totalAmount?: number;
  productDetails?: string;
  customerName?: string;
}

export function parseOrderDetails(order?: OrdersResponse | null): {
  amount: number;
  productName: string;
  customerName: string;
  email: string;
  phone: string;
  address: string;
  returnUrl: string;
  parsedRequest: Record<string, any>;
  parsedResponse: Record<string, any>;
} {
  if (!order) {
    return {
      amount: 0,
      productName: "-",
      customerName: "-",
      email: "-",
      phone: "-",
      address: "-",
      returnUrl: "",
      parsedRequest: {},
      parsedResponse: {},
    };
  }

  let reqObj: Record<string, any> = {};
  if (typeof order.request === "string") {
    try {
      reqObj = JSON.parse(order.request);
    } catch {
      reqObj = {};
    }
  } else if (order.request && typeof order.request === "object") {
    reqObj = order.request;
  }

  let resObj: Record<string, any> = {};
  if (typeof order.response === "string") {
    try {
      resObj = JSON.parse(order.response);
    } catch {
      resObj = {};
    }
  } else if (order.response && typeof order.response === "object") {
    resObj = order.response;
  }

  const amount =
    (order.amount !== undefined && order.amount !== null && Number(order.amount) > 0
      ? Number(order.amount)
      : null) ??
    (Number(reqObj.paymentAmount) ||
      Number(order.totalAmount) ||
      0);

  const productName =
    reqObj.productDetails ||
    reqObj.productDetail ||
    reqObj.product_details ||
    order.productDetails ||
    "Pembayaran Layanan";

  const customerName =
    order.name ||
    [reqObj.firstName, reqObj.lastName].filter(Boolean).join(" ") ||
    reqObj.customerVaName ||
    reqObj.name ||
    order.customerName ||
    order.email ||
    "-";

  const email = order.email || reqObj.email || "-";
  const phone = order.phone || reqObj.phone || reqObj.phoneNumber || "-";
  const address = order.address || reqObj.address || "-";
  const returnUrl =
    order.return_url ||
    reqObj.returnUrl ||
    reqObj.return_url ||
    reqObj.success_redirect_url ||
    reqObj.redirect_url ||
    order.project?.callback ||
    "";

  return {
    amount,
    productName,
    customerName,
    email,
    phone,
    address,
    returnUrl,
    parsedRequest: reqObj,
    parsedResponse: resObj,
  };
}
