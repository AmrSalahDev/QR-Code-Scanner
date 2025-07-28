import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_sacnner_app/core/routes/args/show_qr_code_args.dart';
import 'package:qr_code_sacnner_app/core/routes/args/show_qr_data_args.dart';
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
import 'package:qr_code_sacnner_app/features/history/domain/usecases/delete_history_usecase.dart';
import 'package:qr_code_sacnner_app/features/history/domain/usecases/get_histories_usecase.dart';
import 'package:qr_code_sacnner_app/features/history/presentation/cubit/history_cubit.dart';
import 'package:qr_code_sacnner_app/features/history/presentation/screen/history_screen.dart';
import 'package:qr_code_sacnner_app/global/cubits/connection_cubit.dart';
import 'package:qr_code_sacnner_app/features/location/presentation/screens/location_screen.dart';
import 'package:qr_code_sacnner_app/features/router/home_shell.dart';
import 'package:qr_code_sacnner_app/features/scan/presentation/cubit/scan_cubit.dart';
import 'package:qr_code_sacnner_app/features/scan/presentation/screen/scan_screen.dart';
import 'package:qr_code_sacnner_app/features/show_qr_code/presentation/screens/show_qr_code_screen.dart';
import 'package:qr_code_sacnner_app/features/show_qr_data/presentation/cubit/view_qr_data_cubit.dart';
import 'package:qr_code_sacnner_app/features/show_qr_data/presentation/screens/show_qr_data_screen.dart';

class AppRouter {
  static const String generate = '/generate';
  static const String scan = '/scan';
  static const String history = '/history';
  static const String event = '/event';
  static const String settings = '/settings';
  static const String contact = '/contact';
  static const String business = '/business';
  static const String showQrData = '/showQrData';
  static const String showQrCode = '/showQrCode';
  static const String location = '/location';
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
            create: (_) => HistoryCubit(
              getIt<GetHistoriesUseCase>(),
              getIt<DeleteHistoryUseCase>(),
            ),
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
      path: AppRouter.location,
      builder: (context, state) => BlocProvider(
        create: (context) => ConnectionCubit(),
        child: LocationScreen(),
      ),
    ),

    GoRoute(
      path: AppRouter.showQrCode,
      builder: (context, state) {
        final args = state.extra as ShowQrCodeArgs;
        return ShowQrCodeScreen(
          qrData: args.qrData,
          qrType: args.qrType,
          qrCodeBeforeFormatting: args.qrDataBeforeFormatting,
        );
      },
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
      path: AppRouter.showQrData,
      builder: (context, state) {
        final args = state.extra as ShowQrDataArgs;
        return BlocProvider(
          create: (context) => ViewQrDataCubit(),
          child: ShowQrDataScreen(data: args.qrData, type: args.qrType),
        );
      },
    ),
  ],
);
