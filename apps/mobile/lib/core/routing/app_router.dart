import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';

final routerProvider = Provider<GoRouter>((ref) => GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(path: '/dashboard', builder: (context, state) => const DashboardPage()),
      ],
      errorBuilder: (context, state) => Scaffold(body: Center(child: Text(state.error.toString()))),
    ));
