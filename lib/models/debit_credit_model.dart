class DebitCreditModel {
  final String id;
  final String userId;
  final String createdAt;
  final String debtsName;
  final String debtsType;
  final int debtsAmount;

  DebitCreditModel(
      {required this.id,
      required this.userId,
      required this.createdAt,
      required this.debtsName,
      required this.debtsType,
      required this.debtsAmount});
}
