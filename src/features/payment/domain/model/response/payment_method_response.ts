import { PaymentCategoryResponse } from "./payment_category_response";

export interface GatewayInfo {
  id?: string;
  key?: string;
  name?: string;
}

export interface PaymentMethodResponse {
  id?: number | string;
  key?: string;
  name?: string;
  category_id?: number | string | null;
  type?: string;
  payment_gateway_id?: string | null;
  payment_gateway_key?: string | null;
  payment_gateway?: GatewayInfo | null;
  bankCode?: string;
  image?: string | null;
  image_url?: string | null;
  is_active?: boolean;
  category?: PaymentCategoryResponse | null;
}

export function getEffectiveLogo(method: PaymentMethodResponse): string {
  if (method.image_url && method.image_url.trim().length > 0) {
    return method.image_url;
  }
  if (method.image && method.image.trim().length > 0) {
    if (method.image.startsWith("http") || method.image.startsWith("/")) {
      return method.image;
    }
    return `/images/payment/${method.image}`;
  }
  // Fallback to bankCode or key based preset image in public/images/payment/
  const key = (method.bankCode || method.key || "").toLowerCase();
  if (key.includes("bca")) return "/images/payment/bca.png";
  if (key.includes("bni")) return "/images/payment/bni.png";
  if (key.includes("bri")) return "/images/payment/bri.png";
  if (key.includes("mandiri")) return "/images/payment/mandiri.png";
  if (key.includes("dana")) return "/images/payment/dana.png";
  if (key.includes("ovo")) return "/images/payment/ovo.png";
  if (key.includes("shopee")) return "/images/payment/shopeepay.png";
  if (key.includes("indomaret")) return "/images/payment/indomaret.png";
  if (key.includes("card") || key.includes("cc") || key.includes("vc")) return "/images/payment/cc.png";
  return "";
}
