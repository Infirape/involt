"use client";

import { Save } from "lucide-react";
import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { useAuth } from "@/lib/hooks/useAuth";
import { useRouter } from "next/navigation";
import { useSettings } from "./hooks/useSettings";
import { ReceiptCopies } from "@/app/gen/involt/v1/models_pb";
import { ReceiptCopiesField } from "./components/ReceiptCopiesField";

export default function SettingsPage() {
  const { isAdmin, loading: authLoading } = useAuth();
  const router = useRouter();
  const {
    settings,
    setSettings,
    loading,
    saving,
    handleSave,
  } = useSettings();

  // The role comes from localStorage, which the server doesn't have: only trust it after mount
  // so the server and first client render match (no hydration mismatch).
  const [isMounted, setIsMounted] = useState(false);
  useEffect(() => setIsMounted(true), []);

  useEffect(() => {
    if (isMounted && !authLoading && !isAdmin) {
      router.push("/dashboard");
    }
  }, [isMounted, authLoading, isAdmin, router]);

  if (!isMounted || authLoading || !isAdmin) return null;

  if (loading) {
    return (
      <div className="p-8 animate-pulse text-muted-foreground font-black uppercase tracking-widest text-xs">
        Cargando configuración...
      </div>
    );
  }

  return (
    <div className="p-8 space-y-8 animate-in fade-in duration-700">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="space-y-1">
          <h1 className="text-4xl font-black tracking-tighter uppercase bg-linear-to-br from-white to-white/40 bg-clip-text text-transparent">
            Configuración
          </h1>
          <p className="text-muted-foreground font-medium">
            Parámetros del sistema y datos institucionales
          </p>
        </div>
      </div>

      <form onSubmit={handleSave} className="grid gap-8 max-w-5xl">
        <div className="grid gap-8 md:grid-cols-2">
          {/* Institutional Info */}
          <Card className="border-white/5 bg-card/20 backdrop-blur-sm">
            <CardHeader>
              <CardTitle className="text-xl font-bold tracking-tight">
                Institución
              </CardTitle>
              <CardDescription>
                Datos que aparecerán en los recibos y reportes
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label className="text-xs uppercase font-bold tracking-wider opacity-60">
                  Municipalidad
                </Label>
                <Input
                  value={settings?.municipalidad || ""}
                  onChange={(e) =>
                    setSettings((prev) =>
                      prev ? { ...prev, municipalidad: e.target.value } : null,
                    )
                  }
                  className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl"
                />
              </div>
              <div className="space-y-2">
                <Label className="text-xs uppercase font-bold tracking-wider opacity-60">
                  Empresa / Concesionaria
                </Label>
                <Input
                  value={settings?.empresa || ""}
                  onChange={(e) =>
                    setSettings((prev) =>
                      prev ? { ...prev, empresa: e.target.value } : null,
                    )
                  }
                  className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl"
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label className="text-xs uppercase font-bold tracking-wider opacity-60">
                    RUC
                  </Label>
                  <Input
                    value={settings?.ruc || ""}
                    onChange={(e) =>
                      setSettings((prev) =>
                        prev ? { ...prev, ruc: e.target.value } : null,
                      )
                    }
                    className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl"
                  />
                </div>
                <div className="space-y-2">
                  <Label className="text-xs uppercase font-bold tracking-wider opacity-60">
                    Teléfono
                  </Label>
                  <Input
                    value={settings?.telefono || ""}
                    onChange={(e) =>
                      setSettings((prev) =>
                        prev ? { ...prev, telefono: e.target.value } : null,
                      )
                    }
                    className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl"
                  />
                </div>
              </div>
              <div className="space-y-2">
                <Label className="text-xs uppercase font-bold tracking-wider opacity-60">
                  Dirección
                </Label>
                <Input
                  value={settings?.direccion || ""}
                  onChange={(e) =>
                    setSettings((prev) =>
                      prev ? { ...prev, direccion: e.target.value } : null,
                    )
                  }
                  className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl"
                />
              </div>
            </CardContent>
          </Card>

          {/* Billing Parameters */}
          <Card className="border-white/5 bg-card/20 backdrop-blur-sm">
            <CardHeader>
              <CardTitle className="text-xl font-bold tracking-tight">
                Facturación
              </CardTitle>
              <CardDescription>Tarifas y parámetros de cálculo</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label className="text-xs uppercase font-bold tracking-wider opacity-60">
                    Tarifa kWh (S/)
                  </Label>
                  <Input
                    type="number"
                    step="0.01"
                    value={settings?.tarifaKwh || 0}
                    onChange={(e) => {
                      const val = parseFloat(e.target.value);
                      setSettings((prev) =>
                        prev ? { ...prev, tarifaKwh: isNaN(val) ? 0 : val } : null,
                      );
                    }}
                    className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl"
                  />
                </div>
                <div className="space-y-2">
                  <Label className="text-xs uppercase font-bold tracking-wider opacity-60">
                    Cargo Fijo (S/)
                  </Label>
                  <Input
                    type="number"
                    step="0.01"
                    value={settings?.cargoFijo || 0}
                    onChange={(e) => {
                      const val = parseFloat(e.target.value);
                      setSettings((prev) =>
                        prev ? { ...prev, cargoFijo: isNaN(val) ? 0 : val } : null,
                      );
                    }}
                    className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl"
                  />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label className="text-xs uppercase font-bold tracking-wider opacity-60">
                    Alumbrado (S/)
                  </Label>
                  <Input
                    type="number"
                    step="0.01"
                    value={settings?.alumbrado || 0}
                    onChange={(e) => {
                      const val = parseFloat(e.target.value);
                      setSettings((prev) =>
                        prev ? { ...prev, alumbrado: isNaN(val) ? 0 : val } : null,
                      );
                    }}
                    className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl"
                  />
                </div>
                <div className="space-y-2">
                  <Label className="text-xs uppercase font-bold tracking-wider opacity-60">
                    Días Vencimiento
                  </Label>
                  <Input
                    type="number"
                    value={settings?.diasVencimiento || 0}
                    onChange={(e) => {
                      const val = parseInt(e.target.value, 10);
                      setSettings((prev) =>
                        prev
                          ? { ...prev, diasVencimiento: isNaN(val) ? 0 : val }
                          : null,
                      );
                    }}
                    className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl"
                  />
                </div>
              </div>
              <div className="flex items-center justify-between p-4 rounded-xl bg-white/5 border border-white/5">
                <div className="space-y-0.5">
                  <Label className="text-sm font-bold uppercase tracking-tight">
                    Aplicar IGV (18%)
                  </Label>
                  <p className="text-xs text-muted-foreground">
                    Activar si los precios no incluyen impuestos
                  </p>
                </div>
                <Switch
                  checked={settings?.igv || false}
                  onCheckedChange={(checked) =>
                    setSettings((prev) =>
                      prev ? { ...prev, igv: checked } : null,
                    )
                  }
                />
              </div>
              <ReceiptCopiesField
                value={settings?.receiptCopies ?? ReceiptCopies.DUPLICATE}
                onChange={(receiptCopies) =>
                  setSettings((prev) => (prev ? { ...prev, receiptCopies } : null))
                }
              />
            </CardContent>
          </Card>
        </div>

        <div className="flex justify-end">
          <Button
            type="submit"
            disabled={saving}
            className="h-12 px-8 font-black uppercase tracking-tighter rounded-xl bg-primary text-primary-foreground hover:scale-[1.02] active:scale-[0.98] transition-all shadow-xl shadow-primary/20"
          >
            {saving ? "Guardando..." : "Guardar Cambios"}
            {!saving && <Save className="ml-2 w-4 h-4" />}
          </Button>
        </div>
      </form>
    </div>
  );
}
