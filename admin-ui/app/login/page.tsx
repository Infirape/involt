"use client";

import { Zap } from "lucide-react";
import Image from "next/image";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { adminClient } from "@/lib/rpc";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const router = useRouter();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      const resp = await adminClient.login({ email, password });

      // Store token in cookie (simple client-side for now, would be better in server action)
      document.cookie = `admin_token=${resp.token}; path=/; max-age=86400; SameSite=Strict`;

      // Store user info for UI role-based access
      if (resp.user) {
        localStorage.setItem(
          "admin_user",
          JSON.stringify({
            id: resp.user.id,
            email: resp.user.email,
            role: resp.user.role,
          }),
        );
      }

      router.push("/dashboard");
    } catch (err: unknown) {
      console.error("Login failed:", err);
      const errorMessage =
        err instanceof Error ? err.message : "Credenciales inválidas";
      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen p-4 bg-[radial-gradient(circle_at_top_right,oklch(0.88_0.21_95/0.1),transparent_40%)]">
      <Card className="w-full max-w-md border-primary/10 bg-card/40 backdrop-blur-2xl shadow-2xl shadow-primary/5 animate-in fade-in zoom-in duration-700">
        <CardHeader className="space-y-1 text-center">
          <div className="flex justify-center mb-6">
            <div className="relative group">
              <div className="absolute -inset-1 bg-linear-to-r from-primary/50 to-primary/20 rounded-2xl blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200" />
              <div className="relative p-1 rounded-2xl bg-black/40 border border-white/5 shadow-inner">
                <Image
                  src="/assets/logo_chetilla.png"
                  alt="Hidroeléctrica QARWAQIRU MICHAY"
                  width={80}
                  height={80}
                  className="rounded-xl transition-transform duration-500 group-hover:scale-110"
                />
              </div>
            </div>
          </div>
          <CardTitle className="text-3xl font-black tracking-tighter bg-linear-to-br from-white to-white/60 bg-clip-text text-transparent uppercase leading-tight">
            Hidroeléctrica <br />
            <span className="text-primary tracking-normal">QARWAQIRU MICHAY</span>
          </CardTitle>
          <CardDescription className="text-muted-foreground/60 font-medium">
            Portal de Gestión
          </CardDescription>
        </CardHeader>
        <form onSubmit={handleLogin}>
          <CardContent className="space-y-5">
            {error && (
              <div className="p-3 text-sm font-semibold border rounded-lg bg-destructive/10 border-destructive/20 text-destructive animate-in slide-in-from-top-1 duration-300">
                {error}
              </div>
            )}
            <div className="space-y-2">
              <Label
                htmlFor="email"
                className="text-xs font-bold uppercase tracking-widest text-muted-foreground/80 ml-1"
              >
                Correo Electrónico
              </Label>
              <Input
                id="email"
                type="email"
                placeholder="nombre@hidroelectrica.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="h-12 bg-white/5 border-white/5 focus:border-primary/30 focus:ring-primary/20 transition-all duration-300 rounded-xl"
              />
            </div>
            <div className="space-y-2">
              <div className="flex items-center justify-between ml-1">
                <Label
                  htmlFor="password"
                  title="password"
                  className="text-xs font-bold uppercase tracking-widest text-muted-foreground/80"
                >
                  Contraseña
                </Label>
              </div>
              <Input
                id="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                className="h-12 bg-white/5 border-white/5 focus:border-primary/30 focus:ring-primary/20 transition-all duration-300 rounded-xl"
              />
            </div>
          </CardContent>
          <CardFooter className="pt-2">
            <Button
              type="submit"
              className="w-full h-12 text-base font-black transition-all duration-500 hover:shadow-xl hover:shadow-primary/20 group relative overflow-hidden rounded-xl border-none"
              disabled={loading}
            >
              <span className="relative z-10 flex items-center justify-center gap-2 uppercase tracking-tighter">
                {loading ? "Iniciando..." : "Acceder al Panel"}
                {!loading && (
                  <Zap className="w-4 h-4 fill-current transition-transform group-hover:rotate-12 group-hover:scale-125" />
                )}
              </span>
              <div className="absolute inset-0 bg-linear-to-r from-primary via-primary/90 to-primary opacity-90 group-hover:opacity-100 transition-opacity duration-500" />
            </Button>
          </CardFooter>
        </form>
      </Card>

      <div className="fixed bottom-8 text-center text-[10px] uppercase tracking-[0.2em] text-muted-foreground/30 font-black">
        Powered by <span className="text-white/60">InVolt</span> / Energía Rural
        Inteligente &copy; 2026
      </div>
    </div>
  );
}
