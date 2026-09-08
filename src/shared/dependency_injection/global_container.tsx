import React, { createContext, useContext, useMemo } from "react";
import { OrderService } from "@/features/payment/application/order_service";
import { PaymentService } from "@/features/payment/application/payment_service";

export type GlobalContainer = {
  orderService: OrderService;
  paymentService: PaymentService;
};

export function createContainer(): GlobalContainer {
  return {
    orderService: new OrderService(),
    paymentService: new PaymentService(),
  };
}

const GlobalContainerContext = createContext<GlobalContainer | null>(null);

export function GlobalContainerProvider({ children }: { children: React.ReactNode }) {
  const container = useMemo(() => createContainer(), []);
  return (
    <GlobalContainerContext.Provider value={container}>
      {children}
    </GlobalContainerContext.Provider>
  );
}

export function useContainer(): GlobalContainer {
  const ctx = useContext(GlobalContainerContext);
  if (!ctx) {
    throw new Error("useContainer must be used within GlobalContainerProvider");
  }
  return ctx;
}

export const useOrderService = () => useContainer().orderService;
export const usePaymentService = () => useContainer().paymentService;
