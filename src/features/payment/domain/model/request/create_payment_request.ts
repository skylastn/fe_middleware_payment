export interface CreatePaymentRequest {
  reference: string;
  paymentMethod: string;
  paymentRepositoryId?: string;
  paymentGatewayKey?: string;
  amount?: number;
}
