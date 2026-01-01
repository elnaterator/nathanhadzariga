import type { Metadata } from "next";
import { Inter } from "next/font/google";
import { Analytics } from "@vercel/analytics/react";
import Header from "../components/Header";
import Footer from "../components/Footer";
import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
});

export const metadata: Metadata = {
  title: {
    default: "Nathan Hadzariga | Staff Software Engineer",
    template: "%s | Nathan Hadzariga",
  },
  description:
    "Staff Software Engineer at Experian. Portfolio showcasing scalable systems, technical leadership, and impactful projects.",
  keywords: [
    "Software Engineer",
    "Staff Engineer",
    "Full Stack",
    "TypeScript",
    "React",
    "Next.js",
    "Technical Leadership",
  ],
  authors: [{ name: "Nathan Hadzariga" }],
  creator: "Nathan Hadzariga",
  openGraph: {
    type: "website",
    locale: "en_US",
    url: "https://nathanhadzariga.com",
    title: "Nathan Hadzariga | Staff Software Engineer",
    description:
      "Staff Software Engineer portfolio showcasing scalable systems, technical leadership, and impactful projects.",
    siteName: "Nathan Hadzariga",
  },
  twitter: {
    card: "summary_large_image",
    title: "Nathan Hadzariga | Staff Software Engineer",
    description:
      "Staff Software Engineer portfolio showcasing scalable systems and technical leadership.",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="dark">
      <body
        className={`${inter.variable} font-sans antialiased bg-black text-white min-h-screen flex flex-col`}
      >
        <Header />
        <main className="flex-1">{children}</main>
        <Footer />
        <Analytics />
      </body>
    </html>
  );
}
