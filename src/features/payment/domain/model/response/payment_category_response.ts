import { PaymentMethodResponse } from "./payment_method_response";

export interface PaymentCategoryResponse {
  id?: number | string;
  key?: string;
  title?: string;
  detail?: string;
  paymentMethods?: PaymentMethodResponse[];
  created_at?: string;
  updated_at?: string;
}
