import { ArrowRight, Cloud, Shield, Zap } from "lucide-react";
import Link from "next/link";

export default function Hero() {
  return (
    <section className="relative overflow-hidden pt-20 pb-16 md:pt-32 md:pb-24">
      {/* Background glow effects */}
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] rounded-full bg-primary/10 blur-[120px] pointer-events-none" />
      <div className="absolute top-1/3 left-1/3 w-[300px] h-[300px] rounded-full bg-cyan-500/10 blur-[100px] pointer-events-none" />
      <div className="absolute top-1/2 right-1/4 w-[350px] h-[350px] rounded-full bg-magenta-500/10 blur-[110px] pointer-events-none" />

      <div className="container mx-auto px-4 sm:px-6 lg:px-8 relative z-10 text-center">
        <div className="mx-auto max-w-3xl">
          <div className="inline-flex items-center gap-2 rounded-full border border-primary/20 bg-primary/5 px-3 py-1 text-xs font-semibold text-primary mb-6 animate-pulse">
            <Zap className="h-3 w-3" />
            <span>Infira Premium Suite — Telemetría Inteligente</span>
          </div>

          <h1 className="text-4xl font-extrabold tracking-tight text-white sm:text-5xl md:text-6xl">
            Gestión inteligente de{" "}
            <span className="bg-gradient-to-r from-primary via-cyan-400 to-magenta-400 bg-clip-text text-transparent">
              suministros eléctricos y agua
            </span>
          </h1>

          <p className="mt-6 text-lg text-muted-foreground max-w-2xl mx-auto leading-relaxed">
            InVolt es la plataforma líder en digitalización de lecturas y facturación para empresas
            de servicios públicos. Diseñada para operar sin límites con tecnología offline-first,
            garantizando la continuidad operativa en cualquier escenario geográfico.
          </p>

          <div className="mt-10 flex flex-wrap justify-center gap-4">
            <Link
              href="/login"
              className="inline-flex h-11 items-center justify-center gap-2 rounded-md bg-primary px-6 text-base font-semibold text-primary-foreground shadow transition-transform hover:scale-[1.03] active:scale-[0.97]"
              id="btn-hero-cta-primary"
            >
              Acceder al Sistema
              <ArrowRight className="h-4 w-4" />
            </Link>
            <a
              href="#caracteristicas"
              className="inline-flex h-11 items-center justify-center rounded-md border border-border bg-secondary/50 px-6 text-base font-semibold text-foreground backdrop-blur-sm transition-colors hover:bg-secondary"
              id="btn-hero-cta-secondary"
            >
              Ver Características
            </a>
          </div>
        </div>

        {/* Feature Highlights Grid */}
        <div className="mt-16 grid grid-cols-1 gap-6 sm:grid-cols-3 max-w-4xl mx-auto text-left">
          <div className="flex gap-4 rounded-lg border border-border/40 bg-card/40 p-5 backdrop-blur-md">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-primary/10 text-primary">
              <Cloud className="h-5 w-5" />
            </div>
            <div>
              <h3 className="text-sm font-bold text-foreground">Sincronización Offline-First</h3>
              <p className="mt-1 text-xs text-muted-foreground">
                Toma lecturas en campo sin conectividad. El sistema sincroniza automáticamente al
                detectar internet.
              </p>
            </div>
          </div>

          <div className="flex gap-4 rounded-lg border border-border/40 bg-card/40 p-5 backdrop-blur-md">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-cyan-500/10 text-cyan-400">
              <Zap className="h-5 w-5" />
            </div>
            <div>
              <h3 className="text-sm font-bold text-foreground">Procesamiento Automatizado</h3>
              <p className="mt-1 text-xs text-muted-foreground">
                Generación instantánea de recibos PDF, gráficos de consumo y matrices de pago en
                segundos.
              </p>
            </div>
          </div>

          <div className="flex gap-4 rounded-lg border border-border/40 bg-card/40 p-5 backdrop-blur-md">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-emerald-500/10 text-emerald-400">
              <Shield className="h-5 w-5" />
            </div>
            <div>
              <h3 className="text-sm font-bold text-foreground">Seguridad de Nivel Empresarial</h3>
              <p className="mt-1 text-xs text-muted-foreground">
                Control estricto de roles, auditoría de lecturas y encriptación de datos sensibles
                de usuarios.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
