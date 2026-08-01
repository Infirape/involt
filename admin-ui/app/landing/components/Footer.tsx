import Image from "next/image";
import Link from "next/link";

export default function Footer() {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="border-t border-border/40 bg-background py-8 md:py-12 mt-auto">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col md:flex-row items-center justify-between gap-6">
          <div className="flex items-center gap-2">
            <Image
              src="/assets/logo.png"
              alt="InVolt Logo"
              width={24}
              height={24}
              className="object-contain"
            />
            <span className="text-sm font-bold tracking-tight text-foreground">
              In<span className="text-primary">Volt</span>
            </span>
          </div>

          <p className="text-xs text-muted-foreground order-last md:order-none">
            &copy; {currentYear} InVolt. Todos los derechos reservados. Un producto de{" "}
            <a
              href="https://infira.pe"
              target="_blank"
              rel="noopener noreferrer"
              className="text-primary hover:underline"
            >
              Infira
            </a>
          </p>

          <div className="flex gap-6 text-xs text-muted-foreground">
            <a href="#caracteristicas" className="hover:text-foreground transition-colors">
              Características
            </a>
            <a href="#caso-exito" className="hover:text-foreground transition-colors">
              Caso de Éxito
            </a>
            <a href="#preguntas-frecuentes" className="hover:text-foreground transition-colors">
              FAQ
            </a>
            <Link href="/login" className="hover:text-foreground transition-colors">
              Iniciar Sesión
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}
