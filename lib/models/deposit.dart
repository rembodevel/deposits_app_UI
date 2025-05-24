class Deposit {
  final String bankName;
  final String name;
  final double amount;
  final double interestRate;
  bool isFavorite;

  Deposit({
    required this.bankName,
    required this.name,
    required this.amount,
    required this.interestRate,
    this.isFavorite = false,
  });
}