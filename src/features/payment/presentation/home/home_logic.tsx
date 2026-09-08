import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/router";
import toast from "react-hot-toast";
import { useOrderService } from "@/shared/dependency_injection/global_container";
import { OrdersResponse, parseOrderDetails } from "../../domain/model/response/orders_response";
import { StateType } from "@/shared/domain/model/state_model";

export function useHomeLogic() {
  const router = useRouter();
  const orderService = useOrderService();

  const [stateStatus, setStateStatus] = useState<StateType>(StateType.initial);
  const [order, setOrder] = useState<OrdersResponse | null>(null);
  const [activeTab, setActiveTab] = useState<"order" | "customer">("order");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const reference = (router.query.reference as string) || "";
  const token = (router.query.token as string) || "";

  const fetchOrder = useCallback(async () => {
    if (!router.isReady) return;

    if (!reference) {
      setStateStatus(StateType.error);
      setErrorMessage("Nomor referensi pesanan tidak ditemukan.");
      return;
    }

    setStateStatus(StateType.loading);
    const result = await orderService.getDetailOrder(reference, token);

    result.fold(
      (err) => {
        setStateStatus(StateType.error);
        const msg = err.message || "Gagal mengambil data pesanan.";
        setErrorMessage(msg);
        toast.error(msg);
      },
      (data) => {
        setOrder(data);
        setStateStatus(StateType.success);
      }
    );
  }, [router.isReady, reference, token, orderService]);

  useEffect(() => {
    fetchOrder();
  }, [fetchOrder]);

  const handleProceedToPayment = () => {
    if (!reference) return;

    const query: Record<string, string> = { reference };
    if (token) query.token = token;

    if (order?.project?.slug) {
      query.paymentGatewayKey = order.project.slug.toLowerCase();
    }

    router.push({
      pathname: "/payment",
      query,
    });
  };

  const parsed = parseOrderDetails(order);

  return {
    order,
    stateStatus,
    activeTab,
    setActiveTab,
    errorMessage,
    reference,
    token,
    parsed,
    handleProceedToPayment,
    refetch: fetchOrder,
  };
}
