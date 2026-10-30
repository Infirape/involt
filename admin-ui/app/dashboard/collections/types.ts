// Shared types for the collections billing module.
import type { ServiceStatus } from "@/app/gen/involt/v1/models_pb";
import type { ReceiptStatus } from "@/app/gen/involt/v1/payments_pb";

export interface SectorTab {
  id: string;
  name: string;
  communityId: string;
  communityName: string;
}

/** One customer × period cell. readingId is "" when the period has no receipt yet. */
export interface MatrixCell {
  readingId: string;
  customerId: string;
  customerName: string;
  period: string;
  total: number;
  paid: number;
  balance: number;
  status: ReceiptStatus;
}

export interface CustomerRow {
  customerId: string;
  customerCode: string;
  customerName: string;
  serviceStatus: ServiceStatus;
  /** Outstanding balance across all periods, not only the visible ones. */
  totalDebt: number;
  cells: Record<string, MatrixCell>;
}

export interface MatrixTotals {
  billed: number;
  collected: number;
}

export type Half = "H1" | "H2";
