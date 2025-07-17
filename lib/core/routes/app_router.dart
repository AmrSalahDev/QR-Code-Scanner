import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/features/presentation/screens/event/cubit/event_cubit.dart';
import 'package:qr_code_sacnner_app/features/presentation/screens/event/event_screen.dart';
import 'package:qr_code_sacnner_app/features/presentation/screens/generate/cubit/generate_cubit.dart';
import 'package:qr_code_sacnner_app/features/presentation/screens/generate/generate_screen.dart';
import 'package:qr_code_sacnner_app/features/presentation/screens/history/cubit/history_cubit.dart';
import 'package:qr_code_sacnner_app/features/presentation/screens/history/history_screen.dart';
import 'package:qr_code_sacnner_app/features/presentation/router/home_shell.dart';
import 'package:qr_code_sacnner_app/features/presentation/screens/scan/cubit/scan_cubit.dart';
import 'package:qr_code_sacnner_app/features/presentation/screens/scan/scan_screen.dart';
import 'package:qr_code_sacnner_app/features/presentation/screens/splash/splash_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String generate = '/generate';
  static const String scan = '/scan';
  static const String history = '/history';
  static const String event = '/event';
  static const String settings = '/settings';
}

final GlobalKey<ScanScreenState> scanScreenKey = GlobalKey<ScanScreenState>();

final GoRouter appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return HomeShell(child: child);
      },
      routes: [
        GoRoute(
          path: AppRouter.generate,
          builder: (context, state) => BlocProvider(
            create: (context) => GenerateCubit(),
            child: GenerateScreen(),
          ),
        ),
        GoRoute(
          path: AppRouter.scan,
          builder: (context, state) => BlocProvider(
            create: (_) => ScanCubit(),
            child: ScanScreen(key: scanScreenKey),
          ),
        ),
        GoRoute(
          path: AppRouter.history,
          builder: (context, state) => BlocProvider(
            create: (_) => HistoryCubit()..loadHistories(),
            child: HistoryScreen(),
          ),
        ),
      ],
    ),
    // This one won't have the ConvexAppBar!
    GoRoute(
      path: AppRouter.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRouter.event,
      builder: (context, state) =>
          BlocProvider(create: (context) => EventCubit(), child: EventScreen()),
    ),
  ],
);
