import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/amount_text.dart';
import 'receivables_controller.dart';

class RecordPaymentPage extends ConsumerStatefulWidget { const RecordPaymentPage({required this.customerId, super.key}); final String customerId; @override ConsumerState<RecordPaymentPage> createState() => _RecordPaymentPageState(); }
class _RecordPaymentPageState extends ConsumerState<RecordPaymentPage> { final _amount = TextEditingController(); @override void dispose() { _amount.dispose(); super.dispose(); }
 @override Widget build(BuildContext context) { final customer = ref.watch(receivablesProvider).where((c) => c.id == widget.customerId).firstOrNull; if (customer == null) return const Scaffold(body: Center(child: Text('Customer not found'))); return Scaffold(appBar: AppBar(title: const Text('Record payment')), body: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text(customer.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height:6), const Text('Outstanding balance', style: TextStyle(color: AppColors.muted)), AmountText(customer.balance), const SizedBox(height: 30), TextField(controller: _amount, autofocus: true, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Payment received', prefixText: 'Rs  ')), const SizedBox(height: 14), const Text('You can record partial payments at any time.', style: TextStyle(color: AppColors.muted)), const Spacer(), FilledButton(onPressed: () { final amount = double.tryParse(_amount.text); if (amount == null || amount <= 0) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid payment amount'))); return; } ref.read(receivablesProvider.notifier).recordPayment(customer.id, amount); context.go('/customer/${customer.id}'); }, child: const Text('Save payment'))]))); }
}
