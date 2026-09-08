import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/router";
import toast from "react-hot-toast";
import { useOrderService, usePaymentService } from "@/shared/dependency_injection/global_container";
import { PaymentCategoryResponse } from "../../domain/model/response/payment_category_response";
import { PaymentMethodResponse } from "../../domain/model/response/payment_method_response";
import { StateType } from "@/shared/domain/model/state_model";

export function usePaymentMethodLogic() {
  const router = useRouter();
  const orderService = useOrderService();
  const paymentService = usePaymentService();

  const [stateStatus, setStateStatus] = useState<StateType>(StateType.initial);
  const [categories, setCategories] = useState<PaymentCategoryResponse[]>([]);
  const [submitting, setSubmitting] = useState(false);
  const [selectedMethodKey, setSelectedMethodKey] = useState<string | null>(null);

  const reference = (router.query.reference as string) || "";
  const token = (router.query.token as string) || "";
  const paymentGatewayKey =
    (router.query.paymentGatewayKey as string) ||
    (router.query.payment_gateway_key as string) ||
    "";

  const fetchMethodsAndCategories = useCallback(async () => {
    if (!router.isReady) return;

    if (!reference) {
      setStateStatus(StateType.error);
      return;
    }

    setStateStatus(StateType.loading);

    let effectiveGatewayKey = paymentGatewayKey;
    if (!effectiveGatewayKey) {
      const orderRes = await orderService.getDetailOrder(reference, token);
      orderRes.fold(
        () => {},
        (order) => {
          if (order.project?.slug) {
            effectiveGatewayKey = order.project.slug.toLowerCase();
          }
        }
      );
    }

    const [catRes, methodRes] = await Promise.all([
      paymentService.getPaymentCategory(token),
      paymentService.getPaymentMethod({ paymentGatewayKey: effectiveGatewayKey }, token),
    ]);

    catRes.fold(
      (err) => {
        setStateStatus(StateType.error);
        toast.error(err.message || "Gagal memuat kategori pembayaran.");
      },
      (fetchedCategories) => {
        methodRes.fold(
          (err) => {
            setStateStatus(StateType.error);
            toast.error(err.message || "Gagal memuat metode pembayaran.");
          },
          (fetchedMethods) => {
            const activeMethods = fetchedMethods.filter((m) => m.is_active !== false);

            const resultCategories: PaymentCategoryResponse[] = [];

            for (const cat of fetchedCategories) {
              const catMethods = activeMethods.filter((m) => {
                if (m.category?.key && m.category.key === cat.key) return true;
                if (m.type && m.type === cat.key) return true;
                return false;
              });

              if (catMethods.length > 0) {
                resultCategories.push({
                  ...cat,
                  paymentMethods: catMethods,
                });
              }
            }

            const uncategorized = activeMethods.filter((m) => {
              const catKey = m.category?.key || m.type;
              return !fetchedCategories.some((c) => c.key === catKey);
            });

            if (uncategorized.length > 0) {
              resultCategories.push({
                id: 0,
                key: "other",
                title: "Metode Lainnya",
                detail: "Pilihan saluran pembayaran lainnya",
                paymentMethods: uncategorized,
              });
            }

            setCategories(resultCategories);
            setStateStatus(StateType.success);
          }
        );
      }
    );
  }, [router.isReady, reference, token, paymentGatewayKey, orderService, paymentService]);

  useEffect(() => {
    fetchMethodsAndCategories();
  }, [fetchMethodsAndCategories]);

  const handleSelectMethod = async (method: PaymentMethodResponse) => {
    if (!method.key || submitting) return;

    setSelectedMethodKey(method.key);
    setSubmitting(true);
    toast.loading("Memproses saluran pembayaran...", { id: "payment" });

    const result = await orderService.createPayment(
      {
        reference,
        paymentMethod: method.key,
      },
      token
    );

    result.fold(
      (err) => {
        setSubmitting(false);
        setSelectedMethodKey(null);
        toast.error(err.message || "Gagal memilih metode pembayaran.", { id: "payment" });
      },
      () => {
        toast.success("Saluran pembayaran siap!", { id: "payment" });
        const query: Record<string, string> = { reference };
        if (token) query.token = token;

        router.push({
          pathname: "/detailpayment",
          query,
        });
      }
    );
  };

  return {
    reference,
    token,
    categories,
    stateStatus,
    submitting,
    selectedMethodKey,
    handleSelectMethod,
    refetch: fetchMethodsAndCategories,
  };
}
