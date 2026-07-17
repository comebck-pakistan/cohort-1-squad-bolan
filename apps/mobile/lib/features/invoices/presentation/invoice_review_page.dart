import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../receivables/presentation/receivables_controller.dart';

class InvoiceReviewPage extends ConsumerWidget { const InvoiceReviewPage({super.key});
 @override Widget build(BuildContext context, WidgetRef ref) => Scaffold(appBar: AppBar(title: const Text('Review invoice')), body: SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
  Container(height: 132, decoration: BoxDecoration(color: const Color(0xFFE9E9E4), borderRadius: BorderRadius.circular(18)), child: const Center(child: Icon(Icons.receipt_long_rounded, size: 54, color: AppColors.muted))), const SizedBox(height: 18),
  Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(12)), child: const Row(children: [Icon(Icons.auto_awesome_rounded, color: AppColors.brand), SizedBox(width: 10), Expanded(child: Text('AI extracted these details. Please confirm before saving.'))])), const SizedBox(height: 22),
  Text('Customer', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 8), const TextField(decoration: InputDecoration(labelText: 'Shop name', hintText: 'Raza Super Store'), controller: null), const SizedBox(height: 16),
  Row(children: [Expanded(child: Text('Invoice items', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))), TextButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Add item'))]),
  const Card(child: ListTile(title: Text('Olper Milk 1L'), subtitle: Text('25 × Rs 510'), trailing: Text('Rs 12,750', style: TextStyle(fontWeight: FontWeight.w700)))), const SizedBox(height: 16),
  const TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Total amount', prefixText: 'Rs  ', hintText: '12,750')), const SizedBox(height: 28),
  FilledButton(onPressed: () { ref.read(receivablesProvider.notifier).addDemoInvoice(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice saved to receivables'))); context.go('/receivables'); }, child: const Text('Confirm & save invoice')),
 ])));
}
