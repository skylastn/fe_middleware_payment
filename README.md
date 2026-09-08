# 🛒 Front Office Payment Checkout (Next.js + Clean Architecture)

Modern, secure, and responsive payment checkout portal for Payment Middleware built with **Next.js (Pages Router)**, **TypeScript**, **Tailwind CSS v4**, and **Clean Architecture**.

---

## 🏗️ Architecture & Folder Structure

Following Feature-First Clean Architecture:

```text
src/
├── pages/                          # Next.js Pages Router
│   ├── _app.tsx                    # App providers (DI, Loading, Toast)
│   ├── _document.tsx               # HTML layout
│   ├── index.tsx                   # Transaction lookup entrypoint
│   ├── home/index.tsx              # Order summary & customer details
│   ├── payment/index.tsx           # Payment channel selection
│   └── detailpayment/index.tsx     # Payment execution & instructions
├── shared/                         # Shared Cross-Cutting Utilities
│   ├── component/                  # Reusable UI & CheckoutLayout
│   ├── constant/                   # Env, URLs, Colors
│   ├── dependency_injection/       # Global DI Container (Services)
│   ├── domain/model/               # Generic Response & State models
│   ├── network/                    # Axios ApiClient with token interceptor
│   ├── styles/                     # Tailwind CSS v4 globals
│   └── utils/                      # Functional Either & formatting helpers
└── features/
    └── payment/                    # Payment Domain Feature
        ├── domain/                 # Domain entities, requests, responses
        ├── application/            # OrderService & PaymentService
        ├── infrastructure/         # Remote Data Sources & Repositories
        └── presentation/           # UI Components & Logic Hooks
```

---

## ⚡ Quick Start

```bash
# 1. Install dependencies with Bun
bun install

# 2. Configure Environment
cp .env.example .env

# 3. Run Development Server
bun run dev

# 4. Build Production Bundle
bun run build
```

---

## 🐳 Docker Deployment

```bash
docker compose up -d --build
```
