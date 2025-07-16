import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/presentation/screens/event/cubit/event_cubit.dart';
import 'package:qr_code_sacnner_app/presentation/screens/event/event_screen.dart';
import 'package:qr_code_sacnner_app/presentation/screens/generate/cubit/generate_cubit.dart';
import 'package:qr_code_sacnner_app/presentation/screens/generate/generate_screen.dart';
import 'package:qr_code_sacnner_app/presentation/screens/history/cubit/history_cubit.dart';
import 'package:qr_code_sacnner_app/presentation/screens/history/history_screen.dart';
import 'package:qr_code_sacnner_app/presentation/screens/home/home_screen.dart';
import 'package:qr_code_sacnner_app/presentation/screens/scan/cubit/scan_cubit.dart';
import 'package:qr_code_sacnner_app/presentation/screens/scan/scan_screen.dart';
import 'package:qr_code_sacnner_app/presentation/screens/splash/splash_screen.dart';

final GlobalKey<ScanScreenState> scanScreenKey = GlobalKey<ScanScreenState>();

final GoRouter appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/generate',
          builder: (context, state) => BlocProvider(
            create: (context) => GenerateCubit(),
            child: GenerateScreen(),
          ),
        ),
        GoRoute(
          path: '/scan',
          builder: (context, state) => BlocProvider(
            create: (_) => ScanCubit(),
            child: ScanScreen(key: scanScreenKey),
          ),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => BlocProvider(
            create: (_) => HistoryCubit()..loadHistories(),
            child: HistoryScreen(),
          ),
        ),
      ],
    ),
    // This one won't have the ConvexAppBar!
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/event',
      builder: (context, state) =>
          BlocProvider(create: (context) => EventCubit(), child: EventScreen()),
    ),
  ],
);
