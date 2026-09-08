export class Env {
  static get appEnv(): string {
    return (
      process.env.NEXT_PUBLIC_APP_ENV ??
      process.env.ENVIRONTMENT ??
      "development"
    );
  }

  // Always route via local Next.js proxy in browser to prevent CORS issues
  static get apiUrl(): string {
    if (typeof window !== "undefined") {
      return "/api/proxy";
    }
    return (
      process.env.NEXT_PUBLIC_API_URL ??
      process.env.API_URL ??
      "http://localhost:8000"
    );
  }

  static get backendDirectUrl(): string {
    return (
      process.env.NEXT_PUBLIC_API_URL ??
      process.env.API_URL ??
      "http://localhost:8000"
    );
  }

  static get baseUrl(): string {
    return (
      process.env.NEXT_PUBLIC_BASE_URL ??
      process.env.BASE_URL ??
      "http://localhost:3000"
    );
  }

  static get socketUrl(): string {
    return (
      process.env.NEXT_PUBLIC_SOCKET_URL ??
      process.env.SOCKET_URL ??
      "http://localhost:3001"
    );
  }

  static get appName(): string {
    return (
      process.env.NEXT_PUBLIC_APP_NAME ??
      process.env.APP_NAME ??
      "Payment Checkout"
    );
  }
}
