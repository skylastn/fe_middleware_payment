import { useState, useEffect, useCallback, useRef } from "react";
import { useRouter } from "next/router";
import toast from "react-hot-toast";
import { useOrderService } from "@/shared/dependency_injection/global_container";
import { OrdersResponse, parseOrderDetails } from "../../domain/model/response/orders_response";
import { OrderStatus } from "../../domain/model/enum/order_status";
import { StateType } from "@/shared/domain/model/state_model";

export function useDetailPaymentLogic() {
  const router = useRouter();
  const orderService = useOrderService();

  const [stateStatus, setStateStatus] = useState<StateType>(StateType.initial);
  const [order, setOrder] = useState<OrdersResponse | null>(null);
  const [qrString, setQrString] = useState<string | null>(null);
  const [vaNumber, setVaNumber] = useState<string | null>(null);
  const [checkoutUrl, setCheckoutUrl] = useState<string | null>(null);
  const [checkingStatus, setCheckingStatus] = useState(false);
  const [remainingSeconds, setRemainingSeconds] = useState(3600);

  const reference = (router.query.reference as string) || "";
  const token = (router.query.token as string) || "";
  const pollTimerRef = useRef<NodeJS.Timeout | null>(null);

  const extractPaymentPayload = useCallback((orderData: OrdersResponse) => {
    const isQris = (orderData.payment_method || "").toLowerCase().includes("qris");
    const val = (orderData.value || "").trim();

    let qr: string | null = null;
    let va: string | null = null;
    let url: string | null = null;

    if (val) {
      if (isQris || val.startsWith("000201") || val.length > 60) {
        qr = val;
      } else {
        va = val;
      }
    }

    // Try parsing from response object/json
    let resObj: Record<string, any> = {};
    if (typeof orderData.response === "string") {
      try {
        resObj = JSON.parse(orderData.response);
      } catch {
        resObj = {};
      }
    } else if (orderData.response && typeof orderData.response === "object") {
      resObj = orderData.response;
    }

    if (!qr) {
      qr = resObj.qrContent || resObj.qrString || resObj.qr_string || resObj.qr_url || null;
    }

    if (!va) {
      va =
        resObj.virtualAccountData?.virtualAccountNo ||
        resObj.virtualAccount?.vaNumber ||
        resObj.vaNumber ||
        resObj.va_numbers?.[0]?.va_number ||
        resObj.bca_va_number ||
        resObj.permata_va_number ||
        resObj.bri_va_number ||
        resObj.bni_va_number ||
        null;
    }

    const rawUrl =
      orderData.url ||
      resObj.checkout_url ||
      resObj.paymentUrl ||
      resObj.invoice_url ||
      resObj.link;

    if (rawUrl && typeof rawUrl === "string" && rawUrl.startsWith("http")) {
      url = rawUrl;
    }

    setQrString(qr);
    setVaNumber(va);
    setCheckoutUrl(url);
  }, []);

  const fetchOrder = useCallback(async () => {
    if (!router.isReady || !reference) return;

    setStateStatus(StateType.loading);
    const result = await orderService.getDetailOrder(reference, token);

    result.fold(
      (err) => {
        setStateStatus(StateType.error);
        toast.error(err.message || "Gagal memuat rincian pembayaran.");
      },
      (data) => {
        setOrder(data);
        extractPaymentPayload(data);
        setStateStatus(StateType.success);
      }
    );
  }, [router.isReady, reference, token, orderService, extractPaymentPayload]);

  const handleCheckStatus = async (showToast = true) => {
    if (!reference || checkingStatus) return;

    setCheckingStatus(true);
    if (showToast) {
      toast.loading("Mengecek status pembayaran...", { id: "check-status" });
    }

    const checkRes = await orderService.checkOrderStatus(reference, token);

    checkRes.fold(
      (err) => {
        setCheckingStatus(false);
        if (showToast) {
          toast.error(err.message || "Gagal mengecek status pembayaran.", { id: "check-status" });
        }
      },
      (resData) => {
        setCheckingStatus(false);
        const newStatus = resData?.status || resData?.order_status;
        if (newStatus && order) {
          setOrder({ ...order, status: newStatus });
        }

        if (showToast) {
          if (newStatus === OrderStatus.SUCCESS) {
            toast.success("Pembayaran berhasil diterima!", { id: "check-status" });
          } else {
            toast.success(`Status transaksi: ${newStatus || "PENDING"}`, { id: "check-status" });
          }
        }
      }
    );
  };

  useEffect(() => {
    fetchOrder();
  }, [fetchOrder]);

  // Polling checkOrderStatus every 7 seconds if pending
  useEffect(() => {
    const isPending = !order?.status || order.status.toUpperCase() === OrderStatus.PENDING;

    if (isPending && reference) {
      pollTimerRef.current = setInterval(() => {
        void handleCheckStatus(false);
      }, 7000);
    }

    return () => {
      if (pollTimerRef.current) {
        clearInterval(pollTimerRef.current);
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [order?.status, reference]);

  // Expiration Countdown
  useEffect(() => {
    const timer = setInterval(() => {
      setRemainingSeconds((prev) => (prev > 0 ? prev - 1 : 0));
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const handleCopy = (text: string, label: string) => {
    if (!navigator.clipboard) {
      toast.error("Clipboard tidak didukung di browser ini.");
      return;
    }
    navigator.clipboard.writeText(text);
    toast.success(`${label} berhasil disalin!`);
  };

  const parsed = parseOrderDetails(order);
  const status = (order?.status || OrderStatus.PENDING).toUpperCase();

  return {
    order,
    status,
    stateStatus,
    qrString,
    vaNumber,
    checkoutUrl,
    checkingStatus,
    remainingSeconds,
    reference,
    parsed,
    handleCheckStatus,
    handleCopy,
    refetch: fetchOrder,
  };
}
