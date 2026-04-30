/// Resolves plan row id → API `productId` (`GET /products` uses numeric ids).
int subscriptionProductApiId(String selectedPlanId) {
  final parsed = int.tryParse(selectedPlanId.trim());
  if (parsed != null && parsed > 0) {
    return parsed;
  }
  switch (selectedPlanId) {
    case 'premium':
      return 1;
    case 'basic':
      return 1;
    case 'unlimited':
      return 1;
    default:
      return 0;
  }
}
