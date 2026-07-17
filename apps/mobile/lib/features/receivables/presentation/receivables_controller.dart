import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/receivable.dart';

final receivablesProvider = NotifierProvider<ReceivablesController, List<Customer>>(ReceivablesController.new);

class ReceivablesController extends Notifier<List<Customer>> {
  @override
  List<Customer> build() => [
        Customer(id: '1', name: 'Al-Madina General Store', phone: '0301 2345678', balance: 48500, dueDate: DateTime.now().subtract(const Duration(days: 4)), invoiceCount: 3),
        Customer(id: '2', name: 'Bismillah Kiryana', phone: '0332 1678921', balance: 32600, dueDate: DateTime.now().add(const Duration(days: 2)), invoiceCount: 2),
        Customer(id: '3', name: 'New City Mart', phone: '0315 8842210', balance: 18250, dueDate: DateTime.now().add(const Duration(days: 6)), invoiceCount: 1),
      ];
  void recordPayment(String id, double amount) => state = [for (final customer in state) if (customer.id == id) customer.copyWith(balance: (customer.balance - amount).clamp(0, double.infinity).toDouble()) else customer];
  void addDemoInvoice() => state = [...state, Customer(id: DateTime.now().millisecondsSinceEpoch.toString(), name: 'Raza Super Store', phone: '0300 0000000', balance: 12750, dueDate: DateTime.now().add(const Duration(days: 7)), invoiceCount: 1)];
}
