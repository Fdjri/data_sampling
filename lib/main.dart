import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'features/sampling/presentation/pages/sampling_page.dart';
import 'features/sampling/presentation/pages/edit_page.dart';

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
  initialLocation: '/sampling',
  routes: [
    GoRoute(
      path: '/sampling',
      name: 'sampling',
      builder: (context, state) => const SamplingPage(),
      routes: [
        // Sub-route untuk Edit
        GoRoute(
          path: 'edit', 
          name: 'sampling_edit',
          builder: (context, state) {
            // Kita bisa passing data lewat extra kalau mau simpel
            // final id = state.extra as String?; 
            return const SamplingEditPage();
          },
          routes: [
             // Sub-route untuk Contoh Uji (Gambar 3)
             GoRoute(
               path: 'contoh-uji',
               name: 'contoh_uji',
               builder: (context, state) => const Scaffold(body: Center(child: Text("Halaman Contoh Uji (Gambar 3)"))), // Placeholder
             ),
             // Sub-route untuk Success/Next (Gambar 2)
             GoRoute(
               path: 'success',
               name: 'sampling_success',
               builder: (context, state) => const Scaffold(body: Center(child: Text("Halaman Sukses (Gambar 2)"))), // Placeholder
             ),
          ]
        ),
      ],
    ),
  ],
);