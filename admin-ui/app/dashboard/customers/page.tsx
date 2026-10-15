"use client";

import { Users } from "lucide-react";
import { useAuth } from "@/lib/hooks/useAuth";
import { CustomerTable } from "@/components/dashboard/CustomerTable";
import { Card } from "@/components/ui/card";
import { adminClient } from "@/lib/rpc";
import { useState, useEffect } from "react";

export default function CustomersPage() {
  const { isAdmin } = useAuth();
  const [totalCount, setTotalCount] = useState(0);
  // The role is read from localStorage, which the server doesn't have: only trust it after
  // mount so the server and first client render match (no hydration mismatch).
  const [isMounted, setIsMounted] = useState(false);

  useEffect(() => {
    setIsMounted(true);
    adminClient.getCustomers({ pageSize: 1, pageNumber: 1 }).then(resp => {
      setTotalCount(resp.totalCount);
    });
  }, []);

  if (!isMounted || !isAdmin) return null;

  return (
    <div className="p-8 space-y-8 animate-in fade-in duration-700">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="space-y-1">
          <h1 className="text-4xl font-black tracking-tighter uppercase bg-linear-to-br from-white to-white/40 bg-clip-text text-transparent">
            Gestión de Suministros
          </h1>
          <p className="text-muted-foreground font-medium">
            Padrón general de clientes y medidores de Qarwaqiru
          </p>
        </div>
      </div>

      <div className="grid gap-6 md:grid-cols-4">
        <div className="md:col-span-3">
          <Card className="border-white/5 bg-card/20 backdrop-blur-sm shadow-2xl overflow-hidden p-6">
            <CustomerTable />
          </Card>
        </div>

        <div className="space-y-6">
          <Card className="p-6 border-white/5 bg-primary/5 backdrop-blur-sm relative overflow-hidden group">
            <div className="absolute top-0 right-0 p-4 opacity-5 pointer-events-none group-hover:scale-110 transition-transform duration-700">
              <Users className="w-24 h-24 rotate-12" />
            </div>
            <div className="relative space-y-4">
              <div className="space-y-1">
                <p className="text-[10px] font-black uppercase tracking-widest text-primary/60">
                  Total Registrados
                </p>
                <p className="text-4xl font-black tracking-tighter text-primary">
                  {totalCount}
                </p>
              </div>
              <p className="text-[10px] font-medium text-muted-foreground/60 leading-relaxed uppercase tracking-widest">
                Todos los suministros están georeferenciados para facilitar la
                lectura mensual.
              </p>
            </div>
          </Card>
        </div>
      </div>
    </div>
  );
}
