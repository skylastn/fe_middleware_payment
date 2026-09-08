import { Html, Head, Main, NextScript } from "next/document";

export default function Document() {
  return (
    <Html lang="id" data-scroll-behavior="smooth">
      <Head>
        <meta name="robots" content="noindex, nofollow" />
        <link rel="icon" type="image/png" href="/favicon.ico" />
      </Head>
      <body className="bg-slate-900 text-slate-900 font-sans antialiased">
        <Main />
        <NextScript />
      </body>
    </Html>
  );
}
