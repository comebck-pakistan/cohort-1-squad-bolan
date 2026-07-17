import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class UploadInvoicePage extends StatelessWidget { const UploadInvoicePage({super.key});
 @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Add invoice')), body: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
  Text('Turn an invoice into a receivable', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('Take a clear photo or choose a WhatsApp screenshot. You’ll review every detail before it is saved.', style: TextStyle(color: AppColors.muted)), const SizedBox(height: 30),
  Expanded(child: Container(decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.brand.withOpacity(.25), width: 2)), child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircleAvatar(radius: 36, backgroundColor: Colors.white, child: Icon(Icons.document_scanner_rounded, size: 38, color: AppColors.brand)), SizedBox(height: 16), Text('Upload invoice', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)), SizedBox(height: 6), Text('Camera, gallery or WhatsApp', style: TextStyle(color: AppColors.muted))]))),
  const SizedBox(height: 20), FilledButton.icon(onPressed: () => context.push('/review'), icon: const Icon(Icons.camera_alt_rounded), label: const Text('Take a photo')), const SizedBox(height: 10), OutlinedButton.icon(onPressed: () => context.push('/review'), icon: const Icon(Icons.photo_library_outlined), label: const Text('Choose from gallery')),
 ])));
}
