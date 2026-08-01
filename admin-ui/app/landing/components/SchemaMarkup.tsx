export default function SchemaMarkup() {
  const schema = {
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    name: "InVolt",
    operatingSystem: "All",
    applicationCategory: "BusinessApplication",
    description:
      "Sistema de gestión de lecturas, control de consumo y facturación de servicios eléctricos y agua. Diseñado para optimizar la administración de suministros en ámbitos urbanos y rurales con tecnología offline-first.",
    offers: {
      "@type": "Offer",
      price: "0.00",
      priceCurrency: "USD",
      description: "Consultar planes corporativos y de escala gubernamental.",
    },
    featureList: [
      "Lectura sincronizada offline-first para zonas con baja conectividad",
      "Facturación automatizada de servicios y control de consumo histórico",
      "Exportación directa de reportes consolidados a PDF y Excel",
      "Matriz de cobros y estados de pago en tiempo real",
    ],
    author: {
      "@type": "Organization",
      name: "Infira",
      url: "https://infira.pe",
    },
  };

  return (
    <script
      type="application/ld+json"
      // biome-ignore lint/security/noDangerouslySetInnerHtml: JSON-LD script injection
      dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }}
    />
  );
}
