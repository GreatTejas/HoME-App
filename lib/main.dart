import 'package:flutter/material.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const HomeApp());
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HoME App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF173D32)),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
