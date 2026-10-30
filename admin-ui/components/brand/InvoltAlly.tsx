import Image from "next/image";

interface InvoltAllyProps {
  /** Logo only (collapsed sidebar). */
  compact?: boolean;
  className?: string;
}

/** Footer credit: InVolt appears only as the technology ally; the client company is the main brand. */
export function InvoltAlly({ compact = false, className = "" }: InvoltAllyProps) {
  return (
    <div
      className={`flex items-center gap-2 text-[9px] uppercase tracking-[0.2em] font-black text-muted-foreground/40 ${className}`}
      title="Aliado tecnológico: InVolt"
    >
      <Image
        src="/assets/logo.png"
        alt="InVolt"
        width={18}
        height={18}
        className="shrink-0 opacity-70"
      />
      {!compact && (
        <span>
          Aliado tecnológico <span className="text-white/60">InVolt</span>
        </span>
      )}
    </div>
  );
}
