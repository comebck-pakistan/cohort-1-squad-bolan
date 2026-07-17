import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/invoices/presentation/invoice_review_page.dart';
import '../../features/invoices/presentation/upload_invoice_page.dart';
import '../../features/receivables/presentation/customer_detail_page.dart';
import '../../features/receivables/presentation/record_payment_page.dart';
import '../../features/receivables/presentation/receivables_page.dart';
import '../../shared/widgets/app_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) => GoRouter(
      initialLocation: '/home',
      routes: [
        ShellRoute(
          builder: (context, state, child) => AppScaffold(child: child),
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const DashboardPage()),
            GoRoute(path: '/receivables', builder: (_, __) => const ReceivablesPage()),
          ],
        ),
        GoRoute(path: '/upload', builder: (_, __) => const UploadInvoicePage()),
        GoRoute(path: '/review', builder: (_, __) => const InvoiceReviewPage()),
        GoRoute(
          path: '/customer/:id',
          builder: (_, state) => CustomerDetailPage(customerId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/payment/:id',
          builder: (_, state) => RecordPaymentPage(customerId: state.pathParameters['id']!),
        ),
      ],
      errorBuilder: (_, state) => Scaffold(body: Center(child: Text('Page unavailable: ${state.error}'))),
    ));
