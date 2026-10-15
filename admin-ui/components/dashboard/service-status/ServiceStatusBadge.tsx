import { ZapOff } from "lucide-react";
import { ServiceStatus } from "@/app/gen/involt/v1/models_pb";
import { serviceStatusOption } from "@/lib/serviceStatus";
import { cn } from "@/lib/utils";

interface ServiceStatusBadgeProps {
  status: ServiceStatus;
  /** Hide the badge for supplies with service (the common case) to reduce noise. */
  hideWhenActive?: boolean;
  className?: string;
}

export function ServiceStatusBadge({ status, hideWhenActive, className }: ServiceStatusBadgeProps) {
  const option = serviceStatusOption(status);
  const active = option.value === ServiceStatus.ACTIVE;
  if (hideWhenActive && active) return null;
  return (
    <span
      className={cn(
        "inline-flex items-center gap-1 px-1.5 py-0.5 rounded-md border text-[10px] font-bold uppercase whitespace-nowrap",
        option.className,
        className,
      )}
    >
      {!active && <ZapOff className="w-3 h-3" />}
      {option.label}
    </span>
  );
}
