import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecorderLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  RecorderLocalizations(this.locale);

  static RecorderLocalizations of(BuildContext context) {
    return Localizations.of<RecorderLocalizations>(context, RecorderLocalizations)!;
  }

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('lib/language/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static const LocalizationsDelegate<RecorderLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<RecorderLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<RecorderLocalizations> load(Locale locale) async {
    RecorderLocalizations localizations = new RecorderLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}