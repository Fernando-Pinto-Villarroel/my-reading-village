import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_reading_village/infrastructure/ui/localization/language_provider.dart';

extension ContextTranslation on BuildContext {
  String t(String key, {String? fallback}) =>
      watch<LanguageProvider>().translate(key, fallback: fallback);

  String tw(String key, Map<String, String> params, {String? fallback}) =>
      watch<LanguageProvider>().translateWith(key, params, fallback: fallback);
}
