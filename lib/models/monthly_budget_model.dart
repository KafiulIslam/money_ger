class MonthlyBudgetModel {
  final String monthId;
  final int monthlyBudget;
  final DateTime createdAt;
  final String monthName;
  final String userId;

  MonthlyBudgetModel(
      {required this.monthId,
      required this.monthlyBudget,
      required this.createdAt,
      required this.monthName,
      required this.userId});
}
