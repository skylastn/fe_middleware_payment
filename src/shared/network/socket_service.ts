import { io, Socket } from "socket.io-client";
import { Env } from "../constant/env";

export type SocketNotificationPayload = {
  type: string;
  data?: any;
};

export class SocketService {
  private socket: Socket | null = null;
  private onNotificationCallback: ((payload: SocketNotificationPayload) => void) | null = null;
  private onConnectionChangeCallback: ((connected: boolean) => void) | null = null;
  private onReconnectCallback: (() => void) | null = null;
  private hasConnectedOnce = false;

  connect(options?: {
    onNotification?: (payload: SocketNotificationPayload) => void;
    onConnectionChange?: (connected: boolean) => void;
    onReconnect?: () => void;
  }): Socket {
    if (this.socket) {
      return this.socket;
    }

    this.onNotificationCallback = options?.onNotification ?? null;
    this.onConnectionChangeCallback = options?.onConnectionChange ?? null;
    this.onReconnectCallback = options?.onReconnect ?? null;

    const socketUrl = Env.socketUrl;

    this.socket = io(socketUrl, {
      transports: ["websocket", "polling"],
      autoConnect: true,
      reconnection: true,
      reconnectionAttempts: 10,
      reconnectionDelay: 3000,
      reconnectionDelayMax: 15000,
      randomizationFactor: 0.5,
      timeout: 10000,
      query: {
        project: "payment",
        path: "notification",
      },
    });

    this.socket.on("connect", () => {
      this.onConnectionChangeCallback?.(true);
      if (this.hasConnectedOnce) {
        this.onReconnectCallback?.();
      }
      this.hasConnectedOnce = true;
    });

    this.socket.on("disconnect", () => {
      this.onConnectionChangeCallback?.(false);
    });

    this.socket.on("connect_error", () => {
      this.onConnectionChangeCallback?.(false);
    });

    this.socket.io.on("reconnect", () => {
      this.onConnectionChangeCallback?.(true);
      this.onReconnectCallback?.();
    });

    this.socket.on("notification", (data: any) => {
      if (data && typeof data === "object") {
        this.onNotificationCallback?.(data);
      }
    });

    return this.socket;
  }

  disconnect(): void {
    if (this.socket) {
      this.socket.removeAllListeners();
      this.socket.disconnect();
      this.socket = null;
      this.hasConnectedOnce = false;
    }
  }

  get isConnected(): boolean {
    return Boolean(this.socket?.connected);
  }
}
