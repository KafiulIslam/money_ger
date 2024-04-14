class OneDayExpenseTile {
  final String date;
  final List<ExpenseModel> dayExpenseList;

  OneDayExpenseTile({required this.date, required this.dayExpenseList});
}

class ExpenseModel {
  final String monthlyBudgetId;
  final String description;
  final String expenseType;
  final int expenseAmount;
  final String uid;
  final String createdAt;

  ExpenseModel(
      {required this.monthlyBudgetId,
      required this.description,
      required this.expenseType,
      required this.expenseAmount,
      required this.uid,
      required this.createdAt});
}
