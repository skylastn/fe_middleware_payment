# 🛒 Front Office Payment Checkout (Next.js)

[![Next.js 16](https://img.shields.io/badge/Next.js-16-000000?style=flat&logo=nextdotjs&logoColor=white)](https://nextjs.org)
[![React 19](https://img.shields.io/badge/React-19-61DAFB?style=flat&logo=react&logoColor=black)](https://react.dev)
[![TypeScript](https://img.shields.io/badge/TypeScript-6-3178C6?style=flat&logo=typescript&logoColor=white)](https://typescriptlang.org)
[![Tailwind CSS v4](https://img.shields.io/badge/Tailwind_CSS-v4-38BDF8?style=flat&logo=tailwindcss&logoColor=white)](https://tailwindcss.com)
[![Bun](https://img.shields.io/badge/Bun-1-F9F1E0?style=flat&logo=bun&logoColor=black)](https://bun.sh)
[![Socket.io](https://img.shields.io/badge/Socket.io-Realtime-010101?style=flat&logo=socketdotio&logoColor=white)](https://socket.io)
[![Donate Saweria](https://img.shields.io/badge/Donate-Saweria-E8A838?style=flat&logo=coffeescript&logoColor=white)](https://saweria.co/skygamings)

Modern, secure, and responsive **payment checkout portal** that consumes the [Payment Middleware Backend](https://github.com/skylastn/be_middleware_payment). Built with **Next.js (Pages Router)**, **TypeScript**, **Tailwind CSS v4**, **Bun**, and **Clean Architecture** — featuring category-aware payment instructions, live QRIS/VA checkout, and realtime payment status via Socket.io.

---

## 🧭 Documentation Navigation

| Topic | Description | Link |
|:---|:---|:---:|
| ✨ **Key Features** | Category-based channels, realtime status, auto-redirect on success. | [📖 **Explore Features**](#-key-features) |
| 🛣️ **Checkout Flow & Pages** | Transaction lookup → order summary → channel selection → payment execution. | [🧩 **View Page Flow**](#-checkout-flow--pages) |
| 🏗️ **Architecture** | Clean Architecture, Feature-First structure & proxy data flow. | [📂 **See Architecture**](#-architecture) |
| 🚀 **Quick Start** | Local setup, environment variables, and Docker deployment. | [⚡ **Start Here**](#-quick-start) |
| 💖 **Support the Author** | Donate via Saweria or Crypto (BNB / ETH / Solana). | [☕ **Support & Donate**](#-support-the-author--donations) |

---

## ✨ Key Features

- **Multi-Gateway Checkout** — One unified checkout UI for QRIS, Virtual Account, E-Wallet, Retail (Indomaret/Alfamart), and Credit Card channels served by the backend aggregator.
- **Payment Categories from Backend** — Channels are grouped automatically by `payment_category` key (`va`, `qris`, `ewallet`, `retail`, `cc`) and only `is_active` methods are listed.
- **Category-Aware Payment Instructions** — `Petunjuk Pembayaran` renders per category: QRIS scan steps, VA transfer accordions (ATM / Mobile / Internet Banking), e-wallet steps, retail payment-code steps, or 3-D Secure card steps.
- **Live QRIS & Virtual Account** — Order `value` is rendered as a scannable/downloadable QRIS QR SVG or a copyable VA number + amount, determined by the payment method category.
- **Realtime Status Sync** — Socket.io pushes payment notifications instantly; automatic fallback to status polling with reconnect handling.
- **Return URL Redirect** — On successful payment the customer is redirected to the merchant `return_url` (with fallbacks to `returnUrl` / `success_redirect_url` / project callback).
- **CORS-Free API Proxy** — Browser requests go through the Next.js API proxy (`/api/proxy/[...path]`) forwarding to the backend with auth `Token` headers.
- **Mobile-First Modern UI** — Tailwind CSS v4 design system with responsive `CheckoutLayout`, ambient gradients, skeletons, and toast feedback.

---

## 🛣️ Checkout Flow & Pages

| Route | Page | Description |
|:---|:---|:---|
| `/` | Transaction Lookup | Enter invoice `reference` (+ optional session `token`) to start checkout. |
| `/home` | Order Summary | Bill & customer details with merchant info, then proceed to channel selection. |
| `/payment` | Choose Payment | Active payment methods grouped by payment category (QRIS, VA, E-Wallet, etc). |
| `/detailpayment` | Pay & Verify | Live QRIS / VA rendering, countdown, category-aware instructions, realtime status & success redirect. |

> [!TIP]
> The checkout flow is stateless and driven purely by the **order `reference` + expirable session `token`** issued by the backend — no user registration required.

---

## 🏗️ Architecture

Feature-First Clean Architecture with clear separation between **domain**, **application**, **infrastructure**, and **presentation**:

```text
src/
├── pages/                       # Next.js Pages Router
│   ├── index.tsx                # Transaction lookup entrypoint
│   ├── home/index.tsx           # Order summary & customer details
│   ├── payment/index.tsx        # Payment channel selection
│   ├── detailpayment/index.tsx  # Payment execution & instructions
│   └── api/proxy/[...path].ts   # CORS-free backend proxy (Token headers)
├── shared/                      # Cross-cutting utilities
│   ├── component/               # CheckoutLayout, loading states
│   ├── constant/                # Env, URL paths, colors
│   ├── dependency_injection/    # Global DI container (services)
│   ├── domain/model/            # Response & state models
│   ├── network/                 # Axios ApiClient + SocketService
│   ├── styles/                  # Tailwind CSS v4 globals
│   └── utils/                   # Functional Either & formatting helpers
└── features/
    └── payment/
        ├── domain/              # Responses, entities, enums (e.g. PaymentCategoryKey)
        ├── application/         # OrderService & PaymentService (use cases)
        ├── infrastructure/      # Remote data sources & repository impls
        └── presentation/        # _logic hooks & _ui components per page
```

### Backend Data Flow

```text
Browser ── /api/proxy ──> Payment Middleware Backend
   │                         GET  /api/client/order/detail
   │                         GET  /api/client/order/checkOrderStatus
   │                         POST /api/client/order/createPayment
   │                         GET  /api/client/payment/getPaymentCategory
   │                         GET  /api/client/payment/getPaymentMethod
   │
   └── Socket.io (NEXT_PUBLIC_SOCKET_URL) ◄── realtime payment notifications
```

> [!NOTE]
> This repository is the **front office** of the payment platform. Pair it with the [be_middleware_payment](https://github.com/skylastn/be_middleware_payment) backend and its [Postman Workspace](https://www.postman.com/solar-moon-928951/middleware-payment-v2).

---

## ⚡ Quick Start (Local Setup)

```bash
# 1. Install dependencies with Bun
bun install

# 2. Setup Environment
cp .env.example .env

# 3. Run Development Server
bun run dev        # http://localhost:3000

# 4. Production Build & Serve
bun run build && bun run start
```

> [!NOTE]
> Every request is forwarded through the Next.js API proxy, so set `NEXT_PUBLIC_API_URL` to your backend base URL (`http://localhost:8000` for local backend) to avoid CORS during development.

### Environment Variables

| Variable | Example Value | Description |
|:---|:---|:---|
| `NEXT_PUBLIC_API_URL` | `http://localhost:8000` | Payment Middleware backend base URL (server-side/proxy target). |
| `NEXT_PUBLIC_BASE_URL` | `http://localhost:3000` | Public URL of this checkout app (used for redirects). |
| `NEXT_PUBLIC_SOCKET_URL` | `http://localhost:3001` | Socket.io endpoint for realtime payment notifications. |
| `NEXT_PUBLIC_APP_NAME` | `Payment_Checkout` | Application name shown in UI metadata. |
| `NEXT_PUBLIC_APP_ENV` | `development` | Runtime environment label (`development` / `production`). |
| `PORT` | `3000` | Local dev / container port. |

---

## 🐳 Docker Deployment

```bash
# 1. Build & run container (reads .env, injects NEXT_PUBLIC_* build args)
docker compose up -d --build

# Or via Makefile
make docker-build && make docker-up
```

The `Dockerfile` is a multi-stage production build (`oven/bun:1-alpine` builder → `node:24-alpine` runner), with `NEXT_PUBLIC_*` values passed as **build args** from the host `.env` so the static bundle is baked correctly.

---

## 🧪 Testing & Verification

```bash
# Lint TypeScript/React
bun run lint

# Production build (TypeScript check + route compilation)
bun run build

# Validate Dockerfile syntax
docker build --check .
```

---

## 💖 Support the Author / Donations

If this project saves you time or helps power your business, consider supporting the continuous development and maintenance!

### ☕ Indonesian Rupiah (QRIS / E-Wallet)
Support via Saweria:
👉 **[saweria.co/skygamings](https://saweria.co/skygamings)**

### 🪙 Crypto Donations

| Network / Asset | Address |
|:---|:---|
| **BNB (BEP20)** | `0x4927b932b306a214594cd98a98027b7b44fe6e2c` |
| **Ethereum (ERC20)** | `0x4927b932b306a214594cd98a98027b7b44fe6e2c` |
| **Solana (SPL)** | `DEwU3LB2R8987EXCjPEzReUN8P1HJDNBFmtDFdLrr5Z1` |

Thank you for your generous support! 🙏
