import 'dart:io';

import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/configs/routes/route_generator.dart';
import 'package:final_flashcard/configs/theme/global_theme.dart';
import 'package:final_flashcard/di/di_config.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:final_flashcard/firebase_options.dart';
import 'package:final_flashcard/generated/locales.g.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await configureDependencies();
  await Hive.openBox('final_flashcard');
  if (!Platform.isWindows) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: GlobalConstants.appName,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en"),
        Locale("vi"),
      ],
      translationsKeys: AppTranslation.translations,
      navigatorKey: Get.key,
      fallbackLocale: const Locale("en"),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: RouteGenerator.splash,
      onGenerateRoute: RouteGenerator.generateRoutes,
    );
  }
}
