class FixedCostModel {
  final String docId;
  final String monthlyBudgetId;
  final String description;
  final String expenseType;
  final int expenseAmount;
  final String uid;
  final String createdAt;
  final bool isPaid;

  FixedCostModel(
      {required this.docId,
      required this.monthlyBudgetId,
      required this.description,
      required this.expenseType,
      required this.expenseAmount,
      required this.uid,
      required this.createdAt,
      required this.isPaid});
}
