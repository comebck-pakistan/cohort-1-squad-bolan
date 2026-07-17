import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AmountText extends StatelessWidget {
  const AmountText(this.amount, {this.style, super.key});
  final double amount;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) => Text('Rs ${amount.toStringAsFixed(0)}', style: style ?? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.ink));
}
