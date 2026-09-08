import type { AppProps } from "next/app";
import "@/shared/styles/globals.css";
import { Toaster } from "react-hot-toast";
import { LoadingProvider } from "@/shared/component/elements/loading_context";
import { GlobalContainerProvider } from "@/shared/dependency_injection/global_container";

export default function App({ Component, pageProps }: AppProps) {
  return (
    <GlobalContainerProvider>
      <LoadingProvider>
        <Toaster
          position="top-center"
          toastOptions={{
            duration: 3500,
            style: {
              fontSize: "12px",
              fontWeight: 600,
              borderRadius: "12px",
              padding: "10px 16px",
            },
          }}
        />
        <Component {...pageProps} />
      </LoadingProvider>
    </GlobalContainerProvider>
  );
}
