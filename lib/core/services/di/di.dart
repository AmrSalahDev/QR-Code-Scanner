import 'package:get_it/get_it.dart';
import 'package:qr_code_sacnner_app/core/services/dialog_service.dart';
import 'package:qr_code_sacnner_app/features/business/domain/usecases/generate_business_qr_usecase.dart';
import 'package:qr_code_sacnner_app/features/business/domain/usecases/validate_business_inputs_usecase.dart';
import 'package:qr_code_sacnner_app/features/contact/domain/usecases/generate_contact_qr_usecase.dart';
import 'package:qr_code_sacnner_app/features/contact/domain/usecases/validate_contact_inputs.dart';
import 'package:qr_code_sacnner_app/features/domain/usecases/validate_wifi_input_usecase.dart';
import 'package:qr_code_sacnner_app/features/generate/presentation/cubit/wifi_create_dialog_cubit.dart';
import 'package:qr_code_sacnner_app/features/event/presentation/cubit/event_cubit.dart';
import 'package:qr_code_sacnner_app/features/generate/presentation/cubit/generate_cubit.dart';
import 'package:qr_code_sacnner_app/features/history/data/repositories/history_repository_impl.dart';
import 'package:qr_code_sacnner_app/features/history/domain/repositories/history_repository.dart';
import 'package:qr_code_sacnner_app/features/history/domain/usecases/add_history_usecase.dart';
import 'package:qr_code_sacnner_app/features/history/domain/usecases/delete_history_usecase.dart';
import 'package:qr_code_sacnner_app/features/history/domain/usecases/get_histories_usecase.dart';
import 'package:qr_code_sacnner_app/features/history/presentation/cubit/history_cubit.dart';
import 'package:qr_code_sacnner_app/features/scan/presentation/cubit/scan_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerLazySingleton<DialogService>(() => DialogService());

  // Repository
  getIt.registerLazySingleton<HistoryRepository>(() => HistoryRepositoryImpl());

  // Use Cases
  getIt.registerLazySingleton(
    () => GetHistoriesUseCase(getIt<HistoryRepository>()),
  );

  getIt.registerLazySingleton(
    () => AddHistoryUseCase(getIt<HistoryRepository>()),
  );

  getIt.registerLazySingleton(
    () => DeleteHistoryUseCase(getIt<HistoryRepository>()),
  );

  getIt.registerLazySingleton<ValidateWifiInputUseCase>(
    () => ValidateWifiInputUseCase(),
  );
  getIt.registerLazySingleton<GenerateContactQrUseCase>(
    () => GenerateContactQrUseCase(),
  );

  getIt.registerLazySingleton<ValidateContactInputs>(
    () => ValidateContactInputs(),
  );

  getIt.registerLazySingleton<GenerateBusinessQrUseCase>(
    () => GenerateBusinessQrUseCase(),
  );

  getIt.registerLazySingleton<ValidateBusinessInputsUsecase>(
    () => ValidateBusinessInputsUsecase(),
  );

  // Cubits
  getIt.registerFactory(() => WifiCreateDialogCubit(getIt(), getIt()));
  getIt.registerFactory(() => EventCubit());
  getIt.registerFactory(() => HistoryCubit(getIt(), getIt()));
  getIt.registerFactory(() => GenerateCubit());
  getIt.registerFactory(() => ScanCubit());
}
