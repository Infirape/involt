import Image from "next/image";
import Link from "next/link";

export default function Header() {
  return (
    <header className="sticky top-0 z-50 w-full border-b border-border/40 bg-background/80 backdrop-blur-md">
      <div className="container mx-auto flex h-16 items-center justify-between px-4 sm:px-6 lg:px-8">
        <div className="flex items-center gap-2">
          <Link href="/" className="flex items-center gap-2">
            <Image
              src="/assets/logo.png"
              alt="InVolt Logo"
              width={32}
              height={32}
              className="object-contain"
            />
            <span className="text-xl font-bold tracking-tight text-foreground">
              In<span className="text-primary">Volt</span>
            </span>
          </Link>
        </div>

        <nav className="hidden md:flex items-center gap-8">
          <a
            href="#caracteristicas"
            className="text-sm font-medium text-muted-foreground transition-colors hover:text-foreground"
          >
            Características
          </a>
          <a
            href="#caso-exito"
            className="text-sm font-medium text-muted-foreground transition-colors hover:text-foreground"
          >
            Caso de Éxito
          </a>
          <a
            href="#preguntas-frecuentes"
            className="text-sm font-medium text-muted-foreground transition-colors hover:text-foreground"
          >
            Preguntas Frecuentes
          </a>
        </nav>

        <div className="flex items-center gap-4">
          <Link
            href="/login"
            className="inline-flex h-9 items-center justify-center rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground shadow-sm transition-transform hover:scale-[1.02] active:scale-[0.98]"
            id="btn-header-login"
          >
            Iniciar Sesión
          </Link>
        </div>
      </div>
    </header>
  );
}
