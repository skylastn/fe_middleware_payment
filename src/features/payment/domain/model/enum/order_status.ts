export enum OrderStatus {
  PENDING = "PENDING",
  SUCCESS = "SUCCESS",
  FAILED = "FAILED",
  EXPIRED = "EXPIRED",
}

export const isTerminalStatus = (status?: string | null): boolean => {
  if (!status) return false;
  const s = status.toUpperCase();
  return s === OrderStatus.SUCCESS || s === OrderStatus.FAILED || s === OrderStatus.EXPIRED;
};
