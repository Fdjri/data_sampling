import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'features/sampling/presentation/pages/sampling_page.dart';
import 'features/sampling/presentation/pages/edit_page.dart';
import 'features/sampling/presentation/pages/contoh_uji_page.dart';
import 'features/auth/presentation/pages/auth_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.router(
      title: 'Aplikasi Sampling',
      debugShowCheckedModeBanner: false,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadZincColorScheme.light(),
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    // Rute Login
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    
    // Rute Sampling (Dashboard)
    GoRoute(
      path: '/sampling',
      name: 'sampling',
      builder: (context, state) => const SamplingPage(),
      routes: [
        GoRoute(
          path: 'edit',
          name: 'sampling_edit',
          builder: (context, state) {
            return const SamplingEditPage();
          },
          routes: [
            GoRoute(
              path: 'contoh-uji',
              name: 'contoh_uji',
              builder: (context, state) => const ContohUjiPage(),
            ),
            GoRoute(
              path: 'success',
              name: 'sampling_success',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text("Halaman Sukses (Gambar 2)")),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
