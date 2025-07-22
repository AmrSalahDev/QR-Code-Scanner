import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_sacnner_app/core/color/app_color.dart';
import 'package:qr_code_sacnner_app/core/constant/app_constant.dart';
import 'package:qr_code_sacnner_app/core/services/di/di.dart';
import 'package:qr_code_sacnner_app/core/utils/NavBarColorWrapper.dart';
import 'package:qr_code_sacnner_app/core/routes/app_router.dart';
import 'package:qr_code_sacnner_app/features/history/data/models/history_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);

    Hive.registerAdapter(HistoryModelAdapter());

    await Hive.openBox<HistoryModel>(AppConstant.hiveBoxHistory);
  }

  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NavBarColorWrapper(
      navBarColor: AppColor.primaryColor,
      iconBrightness: Brightness.light,
      statusBarColor: AppColor.primaryColor,
      statusBarBrightness: Brightness.light,
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        theme: appThemeData(),
      ),
    );
  }

  ThemeData appThemeData() {
    return ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColor.secondaryColor,
        selectionColor: AppColor.secondaryColor.withValues(alpha: 0.4),
        selectionHandleColor: AppColor.secondaryColor,
      ),
    );
  }
}
