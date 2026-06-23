import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_reading_village/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:my_reading_village/infrastructure/di/service_locator.dart';
import 'package:my_reading_village/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_village/adapters/providers/book_provider.dart';
import 'package:my_reading_village/adapters/providers/tag_provider.dart';
import 'package:my_reading_village/adapters/providers/village_provider.dart';
import 'package:my_reading_village/infrastructure/ui/localization/language_provider.dart';
import 'package:my_reading_village/infrastructure/ui/screens/splash_screen.dart';
import 'package:my_reading_village/application/services/ad_service.dart';
import 'package:my_reading_village/application/services/audio_service.dart';
import 'package:my_reading_village/application/services/notification_service.dart';
import 'package:my_reading_village/application/services/analytics_service.dart';
import 'package:my_reading_village/application/services/time_verification_service.dart';
import 'package:my_reading_village/application/services/store_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConstants.loadVersion();
  try {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } catch (_) {}
  initServiceLocator();
  unawaited(sl<TimeVerificationService>().ensureInitialized());
  await sl<LanguageProvider>().load(LanguageProvider.defaultLocale);
  try {
    await sl<NotificationService>().initialize();
    await sl<NotificationService>().requestPermission();
  } catch (_) {}
  try {
    await sl<AdService>().initialize();
  } catch (_) {}
  try {
    await sl<AudioService>().initialize();
  } catch (_) {}
  try {
    await sl<AnalyticsService>().initialize();
  } catch (_) {}
  try {
    await sl<StoreService>().initialize();
  } catch (_) {}
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyReadingVillageApp());
}

class MyReadingVillageApp extends StatefulWidget {
  const MyReadingVillageApp({super.key});

  @override
  State<MyReadingVillageApp> createState() => _MyReadingVillageAppState();
}

class _MyReadingVillageAppState extends State<MyReadingVillageApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      sl<AudioService>().pauseForBackground();
      sl<TimeVerificationService>().onPause();
    } else if (state == AppLifecycleState.resumed) {
      sl<AudioService>().resumeFromBackground();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sl<BookProvider>()),
        ChangeNotifierProvider.value(value: sl<TagProvider>()),
        ChangeNotifierProvider.value(value: sl<VillageProvider>()),
        ChangeNotifierProvider.value(value: sl<LanguageProvider>()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (_, langProvider, __) {
          final parts = langProvider.currentLocale.split('_');
          final locale =
              parts.length == 2 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
          return MaterialApp(
            title: 'My Reading Village',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            locale: locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
              Locale('pt'),
              Locale('fr'),
              Locale('it'),
            ],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
