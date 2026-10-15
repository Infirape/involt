import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: {
    template: "%s | InVolt - Gestión de Suministros",
    default: "InVolt | Sistema de Gestión de Lecturas y Facturación",
  },
  description:
    "Plataforma integral para la administración de lecturas, control de consumo y facturación de servicios eléctricos y agua.",
  keywords: [
    "gestión de suministros",
    "lecturas eléctricas",
    "facturación de agua",
    "involt",
    "administración de servicios",
  ],
};

import { Toaster } from "sonner";
import { TooltipProvider } from "@/components/ui/tooltip";

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es" className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}>
      <body className="min-h-full flex flex-col">
        <TooltipProvider>{children}</TooltipProvider>
        <Toaster theme="dark" position="bottom-right" richColors />
      </body>
    </html>
  );
}
