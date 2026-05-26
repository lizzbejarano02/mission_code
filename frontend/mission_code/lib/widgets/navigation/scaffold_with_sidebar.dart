import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import 'app_sidebar.dart';

class ScaffoldWithSidebar extends ConsumerWidget {
  final Widget child;

  const ScaffoldWithSidebar({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isWide = MediaQuery.of(context).size.width > 760;

    if (authState is! AuthAuthenticated) return child;

    if (isWide) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Row(
          children: [
            const AppSidebar(),
            Expanded(child: child),
          ],
        ),
      );
    }

    // En móvil devuelve el hijo directamente
    // (cada screen maneja su propio AppBar)
    return child;
  }
}