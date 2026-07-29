"use client";

import {
  MapIcon,
  Zap,
  CheckCircle2,
  Clock,
  Activity,
  TrendingUp,
  TrendingDown,
  DollarSign,
  BarChart3,
} from "lucide-react";
import dynamic from "next/dynamic";
import { useEffect, useState } from "react";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { useRouter } from "next/navigation";
import { useDashboard } from "./hooks/useDashboard";

const CustomerMap = dynamic(
  () => import("@/components/dashboard/CustomerMap"),
  {
    ssr: false,
    loading: () => (
      <div className="h-[400px] w-full rounded-4xl bg-white/5 animate-pulse flex items-center justify-center border border-white/5">
        <div className="flex flex-col items-center gap-3">
          <div className="w-10 h-10 border-4 border-primary border-t-transparent rounded-full animate-spin" />
          <p className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/60">
            Sincronizando Geo...
          </p>
        </div>
      </div>
    ),
  },
);

export default function DashboardPage() {
  const router = useRouter();
  const { data, consumptionDelta } = useDashboard();

  const [mousePos, setMousePos] = useState({ x: 0, y: 0 });
  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      setMousePos({ x: e.clientX, y: e.clientY });
    };
    window.addEventListener("mousemove", handleMouseMove);
    return () => window.removeEventListener("mousemove", handleMouseMove);
  }, []);

  const cards = [
    {
      title: "Recaudación Proyectada",
      value: `S/ ${data.stats?.totalRevenue.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) || "0.00"}`,
      icon: DollarSign,
      color: "from-primary/20 to-primary/5",
      accent: "bg-primary",
      description: "Basado en lecturas actuales",
      trend: null,
    },
    {
      title: "Consumo Total",
      value: `${data.stats?.totalConsumptionKwh.toLocaleString() || "0"} kWh`,
      icon: Zap,
      color: "from-cyan-500/20 to-cyan-600/5",
      accent: "bg-cyan-500",
      description: "Periodo actual",
      trend: consumptionDelta,
    },
    {
      title: "Lecturas Completadas",
      value: `${data.stats?.totalReadingsPeriod.toLocaleString() || "0"}`,
      icon: CheckCircle2,
      color: "from-emerald-500/20 to-emerald-600/5",
      accent: "bg-emerald-500",
      description: `${data.stats?.totalCustomers || 0} Clientes totales`,
      trend: null,
    },
    {
      title: "Pendientes de Cobro",
      value: `${data.stats?.pendingReadingsPeriod.toLocaleString() || "0"}`,
      icon: Clock,
      color: "from-orange-500/20 to-orange-600/5",
      accent: "bg-orange-500",
      description: "Sin registro de consumo",
      trend: null,
    },
  ];

  return (
    <div className="p-8 space-y-12 animate-in fade-in duration-1000 relative">
      {/* Dynamic Background Effects */}
      <div
        className="fixed inset-0 pointer-events-none z-50 transition-opacity duration-500"
        style={{
          background: `radial-gradient(800px circle at ${mousePos.x}px ${mousePos.y}px, rgba(255,0,255,0.03), transparent 80%)`,
        }}
      />
      <div
        className="fixed inset-0 pointer-events-none z-50 transition-opacity duration-300"
        style={{
          background: `radial-gradient(400px circle at ${mousePos.x}px ${mousePos.y}px, rgba(0,255,255,0.03), transparent 70%)`,
        }}
      />

      {/* Hero Section */}
      <div className="flex flex-col gap-6 md:flex-row md:items-end md:justify-between border-b border-white/5 pb-10">
        <div className="space-y-2">
          <div className="flex items-center gap-3 mb-3">
            <span className="px-3 py-1 rounded-full bg-primary/10 border border-primary/20 text-[10px] font-black uppercase tracking-[0.2em] text-primary shadow-[0_0_15px_rgba(255,0,255,0.1)]">
              Mando Central
            </span>
            <span className="flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-[10px] font-black uppercase tracking-[0.2em] text-emerald-500">
              <div className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse" />
              Datos en Vivo
            </span>
          </div>
          <h1 className="text-6xl font-black tracking-tighter leading-none">
            Dashboard
          </h1>
          <p className="text-muted-foreground/40 font-bold uppercase text-[10px] tracking-[0.3em]">
            Gestión de Suministro Eléctrico • Chetilla, Cajamarca
          </p>
        </div>
      </div>

      {/* Metric Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {cards.map((card, idx) => (
          <Card
            key={card.title}
            className="relative overflow-hidden border-white/5 bg-card/10 backdrop-blur-3xl group hover:border-primary/30 transition-all duration-700 animate-in fade-in slide-in-from-bottom-4"
            style={{ animationDelay: `${idx * 100}ms` }}
          >
            <div
              className={`absolute top-0 left-0 w-full h-[2px] bg-linear-to-r ${card.accent === "bg-primary" ? "from-primary to-transparent" : "from-cyan-500 to-transparent"} opacity-30 group-hover:opacity-100 transition-opacity`}
            />
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <span className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/60 group-hover:text-white transition-colors">
                {card.title}
              </span>
              <div
                className={`p-2 rounded-xl bg-white/5 border border-white/5 group-hover:scale-110 group-hover:border-primary/20 transition-all duration-500`}
              >
                <card.icon className="w-4 h-4 text-muted-foreground group-hover:text-primary" />
              </div>
            </CardHeader>
            <CardContent>
              {data.loading ? (
                <div className="h-10 w-32 bg-white/5 animate-pulse rounded-lg" />
              ) : (
                <div className="flex flex-col">
                  <div className="flex items-baseline gap-2">
                    <span className="text-3xl font-black tracking-tighter text-white">
                      {card.value}
                    </span>
                    {card.trend !== null && (
                      <div
                        className={`flex items-center gap-0.5 text-[10px] font-black px-1.5 py-0.5 rounded-full ${card.trend >= 0 ? "bg-red-500/10 text-red-500" : "bg-emerald-500/10 text-emerald-500"}`}
                      >
                        {card.trend >= 0 ? (
                          <TrendingUp className="w-3 h-3" />
                        ) : (
                          <TrendingDown className="w-3 h-3" />
                        )}
                        {Math.abs(card.trend).toFixed(1)}%
                      </div>
                    )}
                  </div>
                  <span className="text-[9px] font-bold text-muted-foreground/30 uppercase mt-2 tracking-widest group-hover:text-muted-foreground/60 transition-colors">
                    {card.description}
                  </span>
                </div>
              )}
            </CardContent>
          </Card>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Map Section */}
        <div className="lg:col-span-2 space-y-6">
          <div className="flex items-center justify-between px-2">
            <div className="space-y-1">
              <h3 className="text-xs font-black uppercase tracking-[0.3em] text-muted-foreground flex items-center gap-3">
                <MapIcon className="w-4 h-4 text-primary" />
                Despliegue de Suministros
              </h3>
              <p className="text-[9px] font-bold text-muted-foreground/30 uppercase tracking-widest">
                Geolocalización de medidores en tiempo real
              </p>
            </div>
            <div className="flex items-center gap-2 px-4 py-2 rounded-xl bg-white/5 border border-white/10">
              <div className="w-2 h-2 rounded-full bg-primary shadow-[0_0_8px_#FF00FF]" />
              <span className="text-[10px] font-black uppercase tracking-widest text-white">
                Activos
              </span>
            </div>
          </div>
          <CustomerMap />
        </div>

        {/* Sector Progress Section */}
        <div className="space-y-6">
          <div className="flex items-center gap-3 px-2">
            <Activity className="w-4 h-4 text-secondary" />
            <h3 className="text-xs font-black uppercase tracking-[0.3em] text-muted-foreground">
              Rendimiento por Sector
            </h3>
          </div>
          <Card className="border-white/5 bg-card/5 backdrop-blur-3xl rounded-4xl overflow-hidden flex flex-col border-t-secondary/20 shadow-2xl">
            <CardContent className="p-0 flex-1 overflow-auto max-h-[400px] scrollbar-hide">
              <div className="divide-y divide-white/5">
                {data.loading ? (
                  [1, 2, 3, 4, 5].map((i) => (
                    <div key={i} className="p-6 space-y-4 animate-pulse">
                      <div className="flex justify-between items-center">
                        <div className="h-4 w-32 bg-white/5 rounded" />
                        <div className="h-4 w-12 bg-white/5 rounded" />
                      </div>
                      <div className="h-2 w-full bg-white/5 rounded-full" />
                    </div>
                  ))
                ) : data.stats?.sectorStats.length === 0 ? (
                  <div className="p-16 text-center">
                    <BarChart3 className="w-8 h-8 text-muted-foreground/20 mx-auto mb-4" />
                    <p className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40 italic">
                      Sin métricas sectoriales
                    </p>
                  </div>
                ) : (
                  data.stats?.sectorStats.map((s) => (
                    <div
                      key={s.sectorId}
                      className="p-6 hover:bg-white/3 transition-all duration-500 group"
                    >
                      <div className="flex items-center justify-between mb-3">
                        <div className="space-y-1">
                          <h4 className="text-xs font-black uppercase tracking-tight group-hover:text-primary transition-colors">
                            {s.sectorName}
                          </h4>
                          <div className="flex items-center gap-2">
                            <span className="text-[9px] font-bold text-muted-foreground/40 uppercase tracking-widest">
                              {s.registeredCount} de {s.totalCount} puntos
                            </span>
                          </div>
                        </div>
                        <div className="text-right">
                          <span className="text-lg font-black tracking-tighter text-white group-hover:text-primary transition-colors">
                            {s.progressPercentage}%
                          </span>
                        </div>
                      </div>
                      <div className="h-1.5 w-full bg-white/5 rounded-full overflow-hidden border border-white/5">
                        <div
                          className="h-full bg-linear-to-r from-primary to-secondary transition-all duration-2000 ease-out shadow-[0_0_15px_rgba(255,0,255,0.3)]"
                          style={{ width: `${s.progressPercentage}%` }}
                        />
                      </div>
                      <div className="mt-3 flex justify-between items-center opacity-0 group-hover:opacity-100 transition-all duration-500 translate-y-1 group-hover:translate-y-0">
                        <span className="text-[8px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                          Consumo Acumulado
                        </span>
                        <span className="text-[10px] font-black text-cyan-500 tracking-tighter">
                          {s.totalConsumption.toLocaleString()}{" "}
                          <span className="text-[8px] opacity-60">kWh</span>
                        </span>
                      </div>
                    </div>
                  ))
                )}
              </div>
            </CardContent>
            <div className="p-6 bg-white/2 border-t border-white/5 mt-auto">
              <button
                onClick={() => router.push("/dashboard/readings")}
                className="w-full py-4 rounded-2xl bg-white/5 border border-white/10 text-[10px] font-black uppercase tracking-[0.3em] hover:bg-white/10 hover:border-primary/40 transition-all shadow-xl"
              >
                Auditar Sectores
              </button>
            </div>
          </Card>
        </div>
      </div>
    </div>
  );
}
