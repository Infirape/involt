"use client";

import {
  Calendar,
  ChevronLeft,
  ChevronRight,
  DollarSign,
  LayoutDashboard,
  LogOut,
  MapPin,
  Menu,
  Settings,
  Users,
  X,
  Zap,
} from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { PeriodStatus } from "@/app/gen/involt/v1/models_pb";
import { BrandLogo } from "@/components/brand/BrandLogo";
import { InvoltAlly } from "@/components/brand/InvoltAlly";
import { PeriodSelector } from "@/components/dashboard/layout/PeriodSelector";
import { useAuth } from "@/lib/hooks/useAuth";
import { useBrand } from "@/lib/hooks/useBrand";
import { adminClient } from "@/lib/rpc";
import { useConfigStore } from "@/lib/store/useConfigStore";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const router = useRouter();
  const { isAdmin } = useAuth();
  const brand = useBrand();
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [isMobileOpen, setIsMobileOpen] = useState(false);
  const [isMounted, setIsMounted] = useState(false);

  const { setSelectedPeriod, setPeriods } = useConfigStore();

  // Load periods, initialize collapsed state and set mounted flag
  useEffect(() => {
    const timer = setTimeout(() => {
      setIsMounted(true);
      const saved = localStorage.getItem("sidebar_collapsed");
      if (saved === "true") {
        setIsCollapsed(true);
      }
    }, 0);

    const initConfig = async () => {
      try {
        const resp = await adminClient.listPeriods({});
        const dbPeriods = resp.periods.map((p) => ({
          id: p.id,
          status: p.status === PeriodStatus.OPEN ? "OPEN" : "CLOSED",
        }));
        setPeriods(dbPeriods);

        // If no period selected yet, pick the open one or the first one
        if (!useConfigStore.getState().selectedPeriod && dbPeriods.length > 0) {
          const open = dbPeriods.find((p) => p.status === "OPEN");
          setSelectedPeriod(open?.id || dbPeriods[0].id);
        }
      } catch (err) {
        console.error("Failed to load periods:", err);
      }
    };

    initConfig();

    return () => clearTimeout(timer);
  }, [setPeriods, setSelectedPeriod]);

  // Persistence for collapsed state is now handled during initialization

  const toggleCollapse = () => {
    const newState = !isCollapsed;
    setIsCollapsed(newState);
    localStorage.setItem("sidebar_collapsed", String(newState));
  };

  const menuItems = [
    { href: "/dashboard", label: "Dashboard", icon: LayoutDashboard },
    { href: "/dashboard/customers", label: "Clientes", icon: Users },
    { href: "/dashboard/readings", label: "Lecturas", icon: Zap },
    { href: "/dashboard/collections", label: "Cobranzas", icon: DollarSign },
    ...(isMounted && isAdmin
      ? [
          { href: "/dashboard/users", label: "Usuarios", icon: Users },
          { href: "/dashboard/communities", label: "Comunidades", icon: MapPin },
          { href: "/dashboard/periods", label: "Periodos", icon: Calendar },
          {
            href: "/dashboard/settings",
            label: "Configuración",
            icon: Settings,
          },
        ]
      : []),
  ];

  const handleLogout = () => {
    document.cookie =
      "admin_token=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT;";
    localStorage.removeItem("admin_user");
    router.push("/login");
  };

  return (
    <div className="flex min-h-screen bg-background">
      {/* Mobile Header */}
      <div className="lg:hidden fixed top-0 left-0 right-0 h-16 bg-card/50 backdrop-blur-xl border-b border-white/5 z-50 px-4 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <BrandLogo
            brand={brand}
            width={32}
            height={35}
            className="h-9 w-auto object-contain"
          />
          <span className="font-black tracking-tighter text-sm uppercase line-clamp-1">
            {brand.name}
          </span>
        </div>
        <div className="flex items-center gap-2">
          <PeriodSelector variant="minimal" />
          <button
            onClick={() => setIsMobileOpen(true)}
            className="p-2 rounded-xl bg-white/5 text-primary"
          >
            <Menu className="w-6 h-6" />
          </button>
        </div>
      </div>

      {/* Mobile Overlay */}
      {isMobileOpen && (
        <div
          className="lg:hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-[60] animate-in fade-in duration-300"
          onClick={() => setIsMobileOpen(false)}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`
          fixed lg:sticky top-0 h-screen z-[70] transition-all duration-500 ease-in-out border-r border-white/5 bg-card/20 backdrop-blur-xl flex flex-col
          ${isCollapsed ? "w-20" : "w-72"}
          ${isMobileOpen ? "translate-x-0" : "-translate-x-full lg:translate-x-0"}
        `}
      >
        {/* Toggle Button (Desktop Only) */}
        <button
          onClick={toggleCollapse}
          className="hidden lg:flex absolute -right-3 top-20 w-6 h-6 bg-primary text-black rounded-full items-center justify-center shadow-lg hover:scale-110 transition-all z-50"
        >
          {isCollapsed ? (
            <ChevronRight className="w-3.5 h-3.5" />
          ) : (
            <ChevronLeft className="w-3.5 h-3.5" />
          )}
        </button>

        {/* Mobile Close Button */}
        <button
          onClick={() => setIsMobileOpen(false)}
          className="lg:hidden absolute right-4 top-4 p-2 rounded-xl bg-white/5 text-white"
        >
          <X className="w-5 h-5" />
        </button>

        <div
          className={`p-8 flex items-center gap-3 transition-all duration-500 ${isCollapsed ? "px-6" : "px-8"}`}
        >
          <BrandLogo
            brand={brand}
            width={44}
            height={48}
            className="h-12 w-auto object-contain shrink-0"
          />
          {!isCollapsed && (
            <div className="flex flex-col animate-in fade-in slide-in-from-left-2 duration-500">
              <span className="font-black tracking-tighter text-sm uppercase line-clamp-2">
                {brand.name}
              </span>
              <span className="text-[10px] text-muted-foreground uppercase tracking-widest font-bold">
                Admin Panel
              </span>
            </div>
          )}
        </div>

        <nav className="flex-1 px-3 space-y-1.5 py-4 overflow-y-auto overflow-x-hidden custom-scrollbar">
          {/* Period Selector in Nav (Desktop) */}
          <div
            className={`mb-6 transition-all duration-500 ${isCollapsed ? "px-2 mb-4" : "px-4 py-4 rounded-2xl bg-white/5 border border-white/5"}`}
          >
            <PeriodSelector isCollapsed={isCollapsed} />
          </div>

          {menuItems.map((item) => {
            const isActive = pathname === item.href;
            return (
              <Link
                key={item.href}
                href={item.href}
                onClick={() => setIsMobileOpen(false)}
                className={`flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-300 group relative ${
                  isActive
                    ? "bg-primary/10 text-primary shadow-lg shadow-primary/5"
                    : "text-muted-foreground hover:bg-white/5 hover:text-foreground"
                }`}
              >
                <item.icon
                  className={`w-5 h-5 shrink-0 transition-transform duration-500 ${
                    isActive ? "scale-110" : "group-hover:scale-110"
                  }`}
                />
                {!isCollapsed && (
                  <span className="font-bold tracking-tight text-sm uppercase whitespace-nowrap animate-in fade-in slide-in-from-left-2 duration-500">
                    {item.label}
                  </span>
                )}

                {isActive && !isCollapsed && (
                  <div className="ml-auto w-1.5 h-1.5 rounded-full bg-primary shadow-[0_0_8px_rgba(255,230,0,0.8)]" />
                )}

                {/* Tooltip (only when collapsed) */}
                {isCollapsed && (
                  <div className="absolute left-full ml-4 px-3 py-2 bg-zinc-900 border border-white/10 rounded-lg text-[10px] font-black uppercase tracking-widest text-white opacity-0 group-hover:opacity-100 pointer-events-none transition-all translate-x-[-10px] group-hover:translate-x-0 z-[100] whitespace-nowrap shadow-2xl">
                    {item.label}
                  </div>
                )}
              </Link>
            );
          })}
        </nav>

        <div className="p-3 border-t border-white/5 space-y-3">
          <InvoltAlly compact={isCollapsed} className={isCollapsed ? "justify-center" : "px-4"} />
          <button
            type="button"
            onClick={handleLogout}
            className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl text-destructive/60 hover:text-destructive hover:bg-destructive/10 transition-all duration-300 font-bold text-sm uppercase group relative ${isCollapsed ? "justify-center" : ""}`}
          >
            <LogOut className="w-5 h-5 shrink-0 transition-transform group-hover:-translate-x-1" />
            {!isCollapsed && <span>Cerrar Sesión</span>}

            {isCollapsed && (
              <div className="absolute left-full ml-4 px-3 py-2 bg-destructive border border-destructive/20 rounded-lg text-[10px] font-black uppercase tracking-widest text-white opacity-0 group-hover:opacity-100 pointer-events-none transition-all translate-x-[-10px] group-hover:translate-x-0 z-[100] whitespace-nowrap shadow-2xl">
                Cerrar Sesión
              </div>
            )}
          </button>
        </div>
      </aside>

      {/* Main Content */}
      <main
        className={`flex-1 transition-all duration-500 ${isMobileOpen ? "overflow-hidden" : "overflow-auto"} pt-16 lg:pt-0`}
      >
        <div className="relative min-h-screen">
          {/* Subtle background glow */}
          <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-primary/5 rounded-full blur-[120px] pointer-events-none" />
          <div className="relative z-10 p-0">{children}</div>
        </div>
      </main>
    </div>
  );
}
