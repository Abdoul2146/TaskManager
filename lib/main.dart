import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './screens/task_list_screen.dart';
import './providers/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// The root widget of the app, responsible for theme and navigation.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the current theme mode from the provider (persistent)
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'My Tasks App',
      debugShowCheckedModeBanner: false,
      // Light theme configuration
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4C8DFF),
          primary: const Color(0xFF4C8DFF),
          secondary: const Color(0xFF4C8DFF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF4C8DFF),
          foregroundColor: Colors.white,
          elevation: 6,
          shape: CircleBorder(),
        ),
        cardColor: Colors.white,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          labelSmall: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
      ),
      // Dark theme configuration
      darkTheme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF181A20),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4C8DFF),
          primary: const Color(0xFF4C8DFF),
          secondary: const Color(0xFF4C8DFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF4C8DFF), // Always blue for FAB
          foregroundColor: Colors.white,
          elevation: 6,
          shape: CircleBorder(),
        ),
        cardColor: const Color(0xFF23263A),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          labelSmall: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
        ),
      ),
      themeMode: themeMode, // Controlled by Riverpod provider and persisted
      home: const TaskListScreen(),
    );
  }
}
