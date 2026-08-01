import { Database, Eye, FileSpreadsheet, LineChart, Network, Smartphone } from "lucide-react";

export default function Features() {
  const list = [
    {
      icon: <Smartphone className="h-6 w-6 text-primary" />,
      title: "Aplicación Móvil para Lecturistas",
      desc: "Captura de lecturas en campo con validaciones en tiempo real para evitar errores de digitación. Compatible con celulares Android estándar.",
    },
    {
      icon: <Database className="h-6 w-6 text-cyan-400" />,
      title: "Base de Datos Offline-First",
      desc: "Las lecturas tomadas se guardan en Isar/SQLite localmente y se sincronizan de forma transparente e inteligente al recuperar conectividad.",
    },
    {
      icon: <FileSpreadsheet className="h-6 w-6 text-magenta-400" />,
      title: "Matriz de Pagos Estilo Excel",
      desc: "Panel web administrativo ágil e interactivo que permite registrar pagos manuales de forma masiva, ideal para juntas de administración de servicios.",
    },
    {
      icon: <LineChart className="h-6 w-6 text-emerald-400" />,
      title: "Generación de Recibos Premium",
      desc: "Generación automatizada de recibos en formato PDF interactivo con historial de consumo de los últimos 6 meses y caritas indicadoras de estado.",
    },
    {
      icon: <Eye className="h-6 w-6 text-indigo-400" />,
      title: "Auditoría e Historial de Consumos",
      desc: "Supervisión detallada de cada lectura, permitiendo filtrar consumos atípicos, fugas o manipulación de medidores desde el panel de control.",
    },
    {
      icon: <Network className="h-6 w-6 text-amber-400" />,
      title: "Arquitectura Hexagonal Robusta",
      desc: "Backend desarrollado en Go con ConnectRPC que asegura transacciones ultra rápidas y latencia mínima en la sincronización de miles de usuarios.",
    },
  ];

  return (
    <section
      id="caracteristicas"
      className="py-16 md:py-24 border-y border-border/20 bg-card/20 relative"
    >
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-2xl mx-auto mb-16">
          <h2 className="text-3xl font-bold tracking-tight text-white sm:text-4xl">
            Herramientas diseñadas para el control total
          </h2>
          <p className="mt-4 text-sm text-muted-foreground">
            InVolt integra tecnología móvil de última generación con una robusta administración en
            la nube para garantizar una facturación exacta y sin fricciones.
          </p>
        </div>

        <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3">
          {list.map((item) => (
            <div
              key={item.title}
              className="group relative rounded-xl border border-border/40 bg-card p-6 shadow-sm transition-all hover:-translate-y-1 hover:border-primary/30 hover:shadow-md"
            >
              <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-secondary group-hover:bg-secondary/80">
                {item.icon}
              </div>
              <h3 className="text-lg font-bold text-foreground group-hover:text-primary transition-colors">
                {item.title}
              </h3>
              <p className="mt-2 text-sm text-muted-foreground leading-relaxed">{item.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
