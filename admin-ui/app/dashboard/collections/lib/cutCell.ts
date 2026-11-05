/** Whether a matrix cell hides its balance: a temporary cut's debt no longer counts as owed. */
export function hidesDebtUnderCut(underCut: boolean, balance: number): boolean {
  return underCut && balance > 0;
}
