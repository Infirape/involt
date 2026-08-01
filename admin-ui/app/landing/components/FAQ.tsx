import { HelpCircle } from "lucide-react";

export default function FAQ() {
  const faqs = [
    {
      q: "¿Qué es InVolt y cómo ayuda a la facturación de servicios?",
      a: "InVolt es un sistema de telemetría y facturación integral para juntas de agua y electricidad. Permite registrar consumos a través de una aplicación móvil offline, procesar los datos de manera centralizada en la nube, y generar recibos de pago con historial de consumo de forma automática.",
    },
    {
      q: "¿Cómo funciona la aplicación en zonas rurales sin internet (Offline-First)?",
      a: "El lecturista descarga la base de datos de usuarios antes de salir. En el campo, la app guarda todas las lecturas de forma segura en la memoria interna del celular (SQLite/Isar) sin requerir señal de red. Una vez que el dispositivo detecta internet, todos los registros se sincronizan automáticamente con el servidor central.",
    },
    {
      q: "¿Qué tipo de reportes y entregables genera el sistema?",
      a: "InVolt genera recibos individuales en formato PDF optimizados para impresión o envío digital, que incluyen el gráfico de barras del consumo mensual de los últimos 6 meses. También permite exportar consolidados, padrones de usuarios y estados de deuda directamente a archivos Excel estructurados.",
    },
    {
      q: "¿Cómo se gestionan los pagos y cobros de los usuarios?",
      a: "El panel administrativo incluye una Matriz de Cobranza estilo planilla interactiva. Los administradores pueden registrar pagos parciales o totales de forma masiva con un par de clics, cambiar los estados de pago de manera manual y llevar una auditoría exacta de los ingresos de la organización.",
    },
    {
      q: "¿Es seguro y escalable para múltiples comunidades?",
      a: "Sí. InVolt cuenta con una arquitectura hexagonal basada en Go y ConnectRPC, diseñada para soportar miles de peticiones simultáneas con latencia mínima. Admite multi-usuarios con diferentes niveles de acceso (Administradores, Lecturistas, Supervisores) para garantizar la seguridad de la información.",
    },
  ];

  return (
    <section
      id="preguntas-frecuentes"
      className="py-16 md:py-24 border-t border-border/20 bg-card/10"
    >
      <div className="container mx-auto px-4 sm:px-6 lg:px-8 max-w-4xl">
        <div className="text-center mb-16">
          <div className="inline-flex items-center gap-1.5 rounded-full bg-primary/10 px-3 py-1 text-xs font-semibold text-primary mb-6">
            <HelpCircle className="h-3.5 w-3.5" />
            <span>Centro de Respuestas</span>
          </div>
          <h2 className="text-3xl font-bold tracking-tight text-white sm:text-4xl">
            Preguntas Frecuentes
          </h2>
          <p className="mt-4 text-sm text-muted-foreground">
            Encontrá respuestas rápidas sobre cómo funciona la tecnología InVolt en ámbitos urbanos
            y rurales.
          </p>
        </div>

        <div className="space-y-4">
          {faqs.map((faq) => (
            <details
              key={faq.q}
              className="group rounded-xl border border-border/40 bg-card/45 p-6 [&_summary::-webkit-details-marker]:hidden cursor-pointer transition-all hover:border-primary/20"
            >
              <summary className="flex items-center justify-between text-base font-bold text-foreground">
                <span className="pr-4">{faq.q}</span>
                <span className="transition duration-300 group-open:-rotate-180">
                  <svg
                    fill="none"
                    height="24"
                    shapeRendering="geometricPrecision"
                    stroke="currentColor"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth="1.5"
                    viewBox="0 0 24 24"
                    width="24"
                    role="img"
                    aria-label="Flecha de despliegue"
                  >
                    <title>Flecha de despliegue</title>
                    <path d="M6 9l6 6 6-6" />
                  </svg>
                </span>
              </summary>
              <p className="mt-4 text-sm text-muted-foreground leading-relaxed cursor-default">
                {faq.a}
              </p>
            </details>
          ))}
        </div>
      </div>
    </section>
  );
}
