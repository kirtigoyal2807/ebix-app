/// Resolves plan row `id` → API `productId` for checkout and questionnaires.
///
/// Catalog rows use numeric string ids (`"12"`, …) from [CatalogProduct.toPlanMap];
/// those are returned as-is via [int.tryParse].
///
/// Legacy slug ids (`premium`, …) are not mapped to a real API id — return `0`
/// so checkout/questionnaire do not silently use product `1`. Prefer numeric
/// strings from `GET /products?branchId=…` ([CatalogProduct.id]).
int subscriptionProductApiId(String selectedPlanId) {
  final parsed = int.tryParse(selectedPlanId.trim());
  if (parsed != null && parsed > 0) {
    return parsed;
  }
  return 0;
}
