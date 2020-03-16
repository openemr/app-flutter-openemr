import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openemr/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyLocalizations {
  MyLocalizations(this.locale);

  final Locale locale;

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {},
    'ar': {
      'username': 'اسم المستخدم',
      'password': 'كلمه السر',
      'login': 'تسجيل الدخول'
    }
  };

  String translate(key) {
    var lowerKey = key.toString().toLowerCase();
    var translation = _localizedValues[locale.languageCode][lowerKey];
    if (translation == null) return key;
    return translation;
  }

  static String of(BuildContext context, String key) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations)
        .translate(key);
  }
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) {
    return SynchronousFuture<MyLocalizations>(MyLocalizations(locale));
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.ancestorStateOfType(TypeMatcher<_MyAppState>());

    state.setState(() {
      state.locale = newLocale;
    });
  }

  static Locale fetchLocale(BuildContext context) {
    _MyAppState state = context.ancestorStateOfType(TypeMatcher<_MyAppState>());
    return state.locale;
  }
}

class _MyAppState extends State<MyApp> {
  Locale locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();
    this.locale = Locale("en");
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      localizationsDelegates: [
        MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        Locale("fa"),
        Locale("en"),
        Locale("ar"),
        Locale("fa"),
        Locale("he"),
        Locale("ps"),
        Locale("ur"),
      ],
      locale: locale,
      title: 'OpenEMR',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: routes,
    );
  }
}
