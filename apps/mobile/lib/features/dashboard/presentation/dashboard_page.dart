import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/amount_text.dart';
import '../../receivables/presentation/receivables_controller.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(receivablesProvider);
    final total = customers.fold<double>(0, (sum, item) => sum + item.balance);
    final overdue = customers.where((item) => item.isOverdue).toList();
    return SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 100), children: [
      Row(children: [
        const CircleAvatar(backgroundColor: AppColors.mint, child: Icon(Icons.storefront_rounded, color: AppColors.brand)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Assalam-o-alaikum, Ahmed', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)), const Text('Here is today’s collection picture', style: TextStyle(color: AppColors.muted))])),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
      ]),
      const SizedBox(height: 26),
      Text('Outstanding balance', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.muted)),
      const SizedBox(height: 6),
      AmountText(total, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.ink)),
      const SizedBox(height: 18),
      Row(children: [
        _Metric(label: 'Overdue', value: '${overdue.length}', color: AppColors.danger),
        const SizedBox(width: 12),
        _Metric(label: 'Due this week', value: '${customers.length - overdue.length}', color: AppColors.warning),
      ]),
      const SizedBox(height: 28),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Needs attention', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)), TextButton(onPressed: () => context.go('/receivables'), child: const Text('See all'))]),
      if (overdue.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Text('No overdue payments. Great work!')),
      ...overdue.map((customer) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Card(child: ListTile(onTap: () => context.push('/customer/${customer.id}'), contentPadding: const EdgeInsets.all(16), leading: const CircleAvatar(backgroundColor: Color(0xFFFFE7E4), child: Icon(Icons.priority_high_rounded, color: AppColors.danger)), title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: const Text('Payment overdue'), trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [AmountText(customer.balance, style: const TextStyle(fontWeight: FontWeight.w800)), const Text('4 days late', style: TextStyle(fontSize: 12, color: AppColors.danger))]))))),
    ]));
  }
}
class _Metric extends StatelessWidget { const _Metric({required this.label, required this.value, required this.color}); final String label; final String value; final Color color; @override Widget build(BuildContext context) => Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: color)), Text(label, style: const TextStyle(color: AppColors.muted))]))); }
