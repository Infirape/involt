import { CheckCircle2, TrendingUp, Users } from "lucide-react";

export default function CaseStudy() {
  return (
    <section id="caso-exito" className="py-16 md:py-24 relative overflow-hidden">
      <div className="absolute top-1/2 left-1/4 w-[400px] h-[400px] rounded-full bg-cyan-500/5 blur-[120px] pointer-events-none" />

      <div className="container mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="lg:grid lg:grid-cols-12 lg:gap-12 items-center">
          <div className="lg:col-span-6 mb-12 lg:mb-0">
            <div className="inline-flex items-center gap-1.5 rounded-full bg-cyan-500/10 px-3 py-1 text-xs font-semibold text-cyan-400 mb-6">
              <TrendingUp className="h-3.5 w-3.5" />
              <span>Caso de Éxito</span>
            </div>

            <h2 className="text-3xl font-bold tracking-tight text-white sm:text-4xl">
              Digitalización total en comunidades de difícil acceso
            </h2>

            <p className="mt-6 text-sm text-muted-foreground leading-relaxed">
              En comunidades rurales andinas con nula conectividad a internet, los métodos
              tradicionales de facturación de electricidad generan retrasos y errores en las
              boletas. Implementamos InVolt para resolver este reto operativo crítico de forma
              definitiva.
            </p>

            <div className="mt-8 space-y-4">
              <div className="flex items-start gap-3">
                <CheckCircle2 className="h-5 w-5 text-primary shrink-0 mt-0.5" />
                <p className="text-sm text-muted-foreground">
                  <strong className="text-foreground">Sincronización robusta:</strong> Lecturistas
                  capturan consumos en campo completamente desconectados. Los datos se suben a la
                  nube automáticamente cuando llegan a una zona con cobertura.
                </p>
              </div>
              <div className="flex items-start gap-3">
                <CheckCircle2 className="h-5 w-5 text-cyan-400 shrink-0 mt-0.5" />
                <p className="text-sm text-muted-foreground">
                  <strong className="text-foreground">Reducción de errores del 98%:</strong> Las
                  lecturas pasan por filtros inteligentes de rango y consistencia, evitando
                  digitaciones incorrectas previas a la facturación.
                </p>
              </div>
              <div className="flex items-start gap-3">
                <CheckCircle2 className="h-5 w-5 text-magenta-400 shrink-0 mt-0.5" />
                <p className="text-sm text-muted-foreground">
                  <strong className="text-foreground">Cuentas transparentes:</strong> Los usuarios
                  reciben recibos PDF claros con gráficos de barras de su consumo de los últimos
                  seis meses, aumentando la confianza y la recaudación.
                </p>
              </div>
            </div>
          </div>

          <div className="lg:col-span-6">
            <div className="relative rounded-2xl border border-border bg-card/60 p-8 md:p-10 backdrop-blur-md">
              <div className="absolute top-0 right-0 -mt-4 -mr-4 bg-primary text-primary-foreground text-xs font-bold px-3 py-1 rounded-full shadow-lg">
                Caso Real
              </div>

              <h3 className="text-xl font-bold text-white mb-6">Métricas de Impacto</h3>

              <div className="grid grid-cols-2 gap-6">
                <div className="border-l-2 border-primary pl-4">
                  <div className="text-3xl font-extrabold text-white">1,125+</div>
                  <div className="text-xs text-muted-foreground mt-1">Usuarios Activos</div>
                </div>

                <div className="border-l-2 border-cyan-400 pl-4">
                  <div className="text-3xl font-extrabold text-white">23</div>
                  <div className="text-xs text-muted-foreground mt-1">Sectores / Comunidades</div>
                </div>

                <div className="border-l-2 border-magenta-400 pl-4">
                  <div className="text-3xl font-extrabold text-white">100%</div>
                  <div className="text-xs text-muted-foreground mt-1">Disponibilidad en Campo</div>
                </div>

                <div className="border-l-2 border-emerald-400 pl-4">
                  <div className="text-3xl font-extrabold text-white">0</div>
                  <div className="text-xs text-muted-foreground mt-1">Pérdida de Lecturas</div>
                </div>
              </div>

              <div className="mt-8 rounded-lg bg-secondary/30 p-4 border border-border/20 flex gap-4 items-center">
                <Users className="h-8 w-8 text-primary shrink-0" />
                <p className="text-xs text-muted-foreground italic leading-relaxed">
                  \"La herramienta nos permitió digitalizar el cobro manual que antes hacíamos en
                  papel y planillas de Excel complejas. Ahora la junta directiva puede ver la
                  morosidad y controlar los cortes de forma inmediata.\"
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
