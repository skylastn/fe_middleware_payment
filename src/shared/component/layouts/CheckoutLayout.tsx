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
      </Head>
      <div className="min-h-screen w-full bg-slate-900 flex flex-col items-center justify-center p-0 sm:p-4 md:p-6 antialiased">
        {/* Card Container */}
        <div className="w-full max-w-md bg-white sm:rounded-2xl shadow-2xl flex flex-col min-h-screen sm:min-h-[640px] sm:max-h-[90vh] overflow-hidden border-0 sm:border border-slate-200/80">
          {/* Header */}
          {(title || subtitle || headerRight) && (
            <header className="px-5 py-4 border-b border-slate-100 flex items-center justify-between bg-white sticky top-0 z-20">
              <div>
                <h1 className="text-base font-bold text-slate-900 leading-snug">{title}</h1>
                {subtitle && <p className="text-xs text-slate-500 mt-0.5">{subtitle}</p>}
              </div>
              {headerRight && <div>{headerRight}</div>}
            </header>
          )}

          {/* Content Area */}
          <main className="flex-1 overflow-y-auto p-5 space-y-4">
            {children}
          </main>

          {/* Sticky Footer */}
          {footer && (
            <footer className="p-4 bg-slate-50 border-t border-slate-100 sticky bottom-0 z-20">
              {footer}
            </footer>
          )}
        </div>
      </div>
    </>
  );
}
