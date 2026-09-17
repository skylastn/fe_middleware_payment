import { useState, useEffect, useCallback, useRef } from "react";
import { useRouter } from "next/router";
import toast from "react-hot-toast";
import { useOrderService } from "@/shared/dependency_injection/global_container";
import { OrdersResponse, parseOrderDetails } from "../../domain/model/response/orders_response";
import { OrderStatus } from "../../domain/model/enum/order_status";
import { StateType } from "@/shared/domain/model/state_model";
import { SocketService, SocketNotificationPayload } from "@/shared/network/socket_service";

function computeRemainingSeconds(order?: OrdersResponse | null): number {
  if (!order) return 3600;

  let expiredAtStr = order.expired_at;
  if (!expiredAtStr && order.request) {
    try {
      const reqObj = typeof order.request === "string" ? JSON.parse(order.request) : order.request;
      expiredAtStr = reqObj.expired_at || reqObj.expiredAt;
    } catch {
      // ignore JSON parse error
    }
  }

  if (expiredAtStr) {
    const target = new Date(expiredAtStr).getTime();
    if (!isNaN(target)) {
      return Math.max(0, Math.floor((target - Date.now()) / 1000));
    }
  }

  if (order.created_at) {
    const created = new Date(order.created_at).getTime();
    if (!isNaN(created)) {
      const target = created + 3600 * 1000;
      return Math.max(0, Math.floor((target - Date.now()) / 1000));
    }
  }

  return 3600;
}

export function useDetailPaymentLogic() {
  const router = useRouter();
  const orderService = useOrderService();

  const [stateStatus, setStateStatus] = useState<StateType>(StateType.initial);
  const [order, setOrder] = useState<OrdersResponse | null>(null);
  const [qrString, setQrString] = useState<string | null>(null);
  const [vaNumber, setVaNumber] = useState<string | null>(null);
  const [checkingStatus, setCheckingStatus] = useState(false);
  const [remainingSeconds, setRemainingSeconds] = useState(3600);
  const [isSocketConnected, setIsSocketConnected] = useState(false);

  const reference = (router.query.reference as string) || "";
  const token = (router.query.token as string) || "";
  const socketServiceRef = useRef<SocketService | null>(null);
  const hasRedirectedRef = useRef(false);

  const orderRef = useRef<OrdersResponse | null>(null);
  useEffect(() => {
    orderRef.current = order;
  });

  const handleSuccessRedirect = useCallback(
    (orderData?: OrdersResponse | null) => {
      if (hasRedirectedRef.current) return;

      const currentOrder = orderData ?? orderRef.current;
      if (!currentOrder) return;

      let reqObj: Record<string, any> = {};
      if (typeof currentOrder.request === "string") {
        try {
          reqObj = JSON.parse(currentOrder.request);
        } catch {
          reqObj = {};
        }
      } else if (currentOrder.request && typeof currentOrder.request === "object") {
        reqObj = currentOrder.request;
      }

      const targetUrl =
        currentOrder.return_url ||
        reqObj.returnUrl ||
        reqObj.return_url ||
        reqObj.success_redirect_url ||
        reqObj.redirect_url ||
        currentOrder.project?.callback ||
        "";

      if (targetUrl && targetUrl.startsWith("http")) {
        hasRedirectedRef.current = true;
        toast.success("Pembayaran Berhasil! Mengalihkan ke merchant...", {
          id: "redirect-success",
          duration: 2500,
        });
        setTimeout(() => {
          window.location.href = targetUrl;
        }, 1200);
      }
    },
    []
  );

  const extractPaymentPayload = useCallback((orderData: OrdersResponse) => {
    const val = (orderData.value || "").trim();
    if (!val) {
      setQrString(null);
      setVaNumber(null);
      return;
    }

    const categoryKey = (
      orderData.payment_methods?.category?.key ||
      orderData.payment_methods?.type ||
      ""
    ).toLowerCase();

    // Directly determine QRIS from category.key
    const isQris =
      categoryKey === "qris" ||
      (!categoryKey && (val.startsWith("000201") || val.length > 60));

    if (isQris) {
      setQrString(val);
      setVaNumber(null);
    } else {
      setVaNumber(val);
      setQrString(null);
    }
  }, []);

  const handleCheckStatus = useCallback(
    async (showToast = true) => {
      if (!reference || checkingStatus) return;

      setCheckingStatus(true);
      if (showToast) {
        toast.loading("Mengecek status pembayaran...", { id: "check-status" });
      }

      const checkRes = await orderService.getDetailOrder(reference, token, true);

      checkRes.fold(
        (err) => {
          setCheckingStatus(false);
          if (showToast) {
            toast.error(err.message || "Gagal mengecek status pembayaran.", {
              id: "check-status",
            });
          }
        },
        (orderData) => {
          setCheckingStatus(false);
          setOrder(orderData);
          extractPaymentPayload(orderData);
          setRemainingSeconds(computeRemainingSeconds(orderData));

          const newStatus = (
            orderData?.status ||
            ""
          ).toUpperCase();

          if (newStatus === OrderStatus.SUCCESS || newStatus === "PAID") {
            handleSuccessRedirect(orderData);
          }

          if (showToast) {
            if (newStatus === OrderStatus.SUCCESS || newStatus === "PAID") {
              toast.success("Pembayaran berhasil diterima!", {
                id: "check-status",
              });
            } else if (newStatus === OrderStatus.FAILED) {
              toast.error("Pembayaran gagal atau dibatalkan.", {
                id: "check-status",
              });
            } else {
              toast.success(`Status transaksi: ${newStatus || "PENDING"}`, {
                id: "check-status",
              });
            }
          }
        }
      );
    },
    [reference, token, checkingStatus, orderService, extractPaymentPayload, handleSuccessRedirect]
  );

  // Keep a stable ref for callbacks inside socket events
  const handleCheckStatusRef = useRef(handleCheckStatus);
  useEffect(() => {
    handleCheckStatusRef.current = handleCheckStatus;
  });

  const handleSuccessRedirectRef = useRef(handleSuccessRedirect);
  useEffect(() => {
    handleSuccessRedirectRef.current = handleSuccessRedirect;
  });

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
        setRemainingSeconds(computeRemainingSeconds(data));
        setStateStatus(StateType.success);

        const st = (data.status || "").toUpperCase();
        if (st === OrderStatus.SUCCESS || st === "PAID") {
          handleSuccessRedirect(data);
        }
      }
    );
  }, [router.isReady, reference, token, orderService, extractPaymentPayload, handleSuccessRedirect]);

  useEffect(() => {
    fetchOrder();
  }, [fetchOrder]);

  // Priority Socket Listening (mounted ONCE per reference)
  useEffect(() => {
    if (!reference) return;

    const socketService = new SocketService();
    socketServiceRef.current = socketService;

    socketService.connect({
      onConnectionChange: (connected) => {
        setIsSocketConnected(connected);
      },
      onReconnect: () => {
        // When socket reconnects, refresh data/check status once
        void handleCheckStatusRef.current(false);
      },
      onNotification: (payload: SocketNotificationPayload) => {
        const notifData = payload.data || payload;
        const notifRef =
          notifData.reference || notifData.order_id || notifData.trxId;

        if (notifRef && notifRef === reference) {
          const rawStatus = (
            notifData.status ||
            notifData.order_status ||
            "SUCCESS"
          ).toUpperCase();
          setOrder((prev) => (prev ? { ...prev, status: rawStatus } : null));

          if (rawStatus === OrderStatus.SUCCESS || rawStatus === "PAID") {
            toast.success("Pembayaran berhasil diverifikasi secara realtime!", {
              id: "realtime-success",
              icon: "🎉",
            });
            handleSuccessRedirectRef.current();
          }
        }
      },
    });

    return () => {
      socketService.disconnect();
      socketServiceRef.current = null;
    };
  }, [reference]);

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
  const rawStatus = (order?.status || OrderStatus.PENDING).toUpperCase();
  const isTimeExpired = remainingSeconds <= 0 && rawStatus !== OrderStatus.SUCCESS && rawStatus !== "PAID";
  const status = isTimeExpired && rawStatus === OrderStatus.PENDING ? OrderStatus.EXPIRED : rawStatus;

  return {
    order,
    status,
    stateStatus,
    qrString,
    vaNumber,
    checkingStatus,
    remainingSeconds,
    isSocketConnected,
    reference,
    parsed,
    handleCheckStatus,
    handleCopy,
    refetch: fetchOrder,
  };
}
