import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:my_reading_town/infrastructure/di/service_locator.dart';
import 'package:my_reading_town/infrastructure/ui/config/app_theme.dart';
import 'package:my_reading_town/adapters/providers/book_provider.dart';
import 'package:my_reading_town/adapters/providers/tag_provider.dart';
import 'package:my_reading_town/adapters/providers/village_provider.dart';
import 'package:my_reading_town/infrastructure/ui/localization/language_provider.dart';
import 'package:my_reading_town/infrastructure/ui/screens/splash_screen.dart';
import 'package:my_reading_town/application/services/ad_service.dart';
import 'package:my_reading_town/application/services/audio_service.dart';
import 'package:my_reading_town/application/services/notification_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initServiceLocator();
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
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyReadingTownApp());
}

class MyReadingTownApp extends StatefulWidget {
  const MyReadingTownApp({super.key});

  @override
  State<MyReadingTownApp> createState() => _MyReadingTownAppState();
}

class _MyReadingTownAppState extends State<MyReadingTownApp>
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
      child: MaterialApp(
        title: 'My Reading Town',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const SplashScreen(),
      ),
    );
  }
}
