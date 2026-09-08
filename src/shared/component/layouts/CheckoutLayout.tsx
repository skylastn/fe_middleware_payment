import React from "react";
import Head from "next/head";

interface CheckoutLayoutProps {
  title?: string;
  subtitle?: string;
  children: React.ReactNode;
  headerRight?: React.ReactNode;
  footer?: React.ReactNode;
}

export function CheckoutLayout({
  title = "Payment Checkout",
  subtitle,
  children,
  headerRight,
  footer,
}: CheckoutLayoutProps) {
  return (
    <>
      <Head>
        <title>{title}</title>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
        <link rel="icon" type="image/png" href="/images/im_background_dashboard.jpg" />
      </Head>
      <div className="min-h-screen w-full bg-radial from-slate-900 via-slate-950 to-black flex flex-col items-center justify-center p-0 sm:p-4 md:p-6 antialiased relative overflow-hidden selection:bg-sky-500 selection:text-white">
        {/* Subtle decorative ambient gradients */}
        <div className="absolute -top-32 -left-32 w-96 h-96 bg-sky-500/10 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute -bottom-32 -right-32 w-96 h-96 bg-indigo-500/10 rounded-full blur-3xl pointer-events-none" />

        {/* Card Container */}
        <div className="w-full max-w-[440px] bg-white sm:rounded-3xl shadow-[0_20px_60px_-15px_rgba(0,0,0,0.6)] flex flex-col min-h-screen sm:min-h-[660px] sm:max-h-[92vh] overflow-hidden border-0 sm:border border-slate-200/90 relative z-10 transition-all">
          {/* Header */}
          {(title || subtitle || headerRight) && (
            <header className="px-5 py-4 border-b border-slate-100 flex items-center justify-between bg-white/95 backdrop-blur-md sticky top-0 z-20 transition-all">
              <div className="min-w-0 pr-2">
                <h1 className="text-base font-extrabold text-slate-900 tracking-tight leading-snug truncate">
                  {title}
                </h1>
                {subtitle && (
                  <p className="text-[11px] font-medium text-slate-400 truncate mt-0.5">
                    {subtitle}
                  </p>
                )}
              </div>
              {headerRight && <div className="shrink-0">{headerRight}</div>}
            </header>
          )}

          {/* Content Area */}
          <main className="flex-1 overflow-y-auto px-5 py-4 space-y-4">
            {children}
          </main>

          {/* Sticky Footer */}
          {footer && (
            <footer className="p-4 bg-slate-50/95 backdrop-blur-md border-t border-slate-100 sticky bottom-0 z-20">
              {footer}
            </footer>
          )}
        </div>
      </div>
    </>
  );
}
