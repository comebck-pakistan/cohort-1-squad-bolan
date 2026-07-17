class Customer {
  const Customer({required this.id, required this.name, required this.phone, required this.balance, required this.dueDate, required this.invoiceCount});
  final String id;
  final String name;
  final String phone;
  final double balance;
  final DateTime dueDate;
  final int invoiceCount;

  bool get isOverdue => dueDate.isBefore(DateTime.now());
  Customer copyWith({double? balance}) => Customer(id: id, name: name, phone: phone, balance: balance ?? this.balance, dueDate: dueDate, invoiceCount: invoiceCount);
}
