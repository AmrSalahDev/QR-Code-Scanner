import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/services/di/di.dart';
import 'package:qr_code_sacnner_app/features/business/domain/usecases/generate_business_qr_usecase.dart';
import 'package:qr_code_sacnner_app/features/business/domain/usecases/validate_business_inputs_usecase.dart';
import 'package:qr_code_sacnner_app/features/business/presentation/screen/cubit/business_cubit.dart';
import 'package:qr_code_sacnner_app/features/contact/domain/usecases/generate_contact_qr_usecase.dart';
import 'package:qr_code_sacnner_app/features/contact/domain/usecases/validate_contact_inputs.dart';
import 'package:qr_code_sacnner_app/features/generate/presentation/cubit/wifi_create_dialog_cubit.dart';
import 'package:qr_code_sacnner_app/features/business/presentation/screen/business_screen.dart';
import 'package:qr_code_sacnner_app/features/contact/presentation/cubit/contact_cubit.dart';
import 'package:qr_code_sacnner_app/features/contact/presentation/screen/contact_screen.dart';
import 'package:qr_code_sacnner_app/features/event/presentation/cubit/event_cubit.dart';
import 'package:qr_code_sacnner_app/features/event/presentation/screen/event_screen.dart';
import 'package:qr_code_sacnner_app/features/generate/presentation/cubit/generate_cubit.dart';
import 'package:qr_code_sacnner_app/features/generate/presentation/screen/generate_screen.dart';
import 'package:qr_code_sacnner_app/features/history/presentation/cubit/history_cubit.dart';
import 'package:qr_code_sacnner_app/features/history/presentation/screen/history_screen.dart';
import 'package:qr_code_sacnner_app/features/router/home_shell.dart';
import 'package:qr_code_sacnner_app/features/scan/presentation/cubit/scan_cubit.dart';
import 'package:qr_code_sacnner_app/features/scan/presentation/screen/scan_screen.dart';
import 'package:qr_code_sacnner_app/features/view_qr_data/presentation/cubit/view_qr_data_cubit.dart';
import 'package:qr_code_sacnner_app/features/view_qr_data/presentation/screens/view_qr_data_screen.dart';

class AppRouter {
  static const String generate = '/generate';
  static const String scan = '/scan';
  static const String history = '/history';
  static const String event = '/event';
  static const String settings = '/settings';
  static const String contact = '/contact';
  static const String business = '/business';
  static const String viewQrData = '/viewQrData';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRouter.scan,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return HomeShell(child: child);
      },
      routes: [
        GoRoute(
          path: AppRouter.generate,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<GenerateCubit>()),
              BlocProvider(
                create: (context) => (getIt<WifiCreateDialogCubit>()),
              ),
            ],
            child: GenerateScreen(),
          ),
        ),
        GoRoute(
          path: AppRouter.scan,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<ScanCubit>(),
            child: ScanScreen(),
          ),
        ),
        GoRoute(
          path: AppRouter.history,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<HistoryCubit>()..loadHistories(),
            child: HistoryScreen(),
          ),
        ),
      ],
    ),
    // This one won't have the ConvexAppBar!
    GoRoute(
      path: AppRouter.event,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<EventCubit>(),
        child: EventScreen(),
      ),
    ),
    GoRoute(
      path: AppRouter.contact,
      builder: (context, state) => BlocProvider(
        create: (context) => ContactCubit(
          getIt<GenerateContactQrUseCase>(),
          getIt<ValidateContactInputs>(),
        ),
        child: ContactScreen(),
      ),
    ),
    GoRoute(
      path: AppRouter.business,
      builder: (context, state) => BlocProvider(
        create: (context) => BusinessCubit(
          getIt<GenerateBusinessQrUseCase>(),
          getIt<ValidateBusinessInputsUsecase>(),
        ),
        child: BusinessScreen(),
      ),
    ),
    GoRoute(
      path: AppRouter.viewQrData,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final data = args['data'] as String;
        final type = args['type'] as String;
        return BlocProvider(
          create: (context) => ViewQrDataCubit(),
          child: ViewQrDataScreen(data: data, type: type),
        );
      },
    ),
  ],
);
