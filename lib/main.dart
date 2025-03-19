import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kturag/features/screen2/screen2.dart';
import 'package:kturag/localization/app_localizations.dart';
import 'package:kturag/app/theme.dart';
import 'package:kturag/app/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LanguageProvider(
      changeLanguage: setLocale,
      child: MaterialApp(
        title: 'KTU',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        locale: _locale,
        supportedLocales: const [Locale('en'), Locale('ml')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (locale != null &&
                locale.languageCode == supportedLocale.languageCode) {
              return supportedLocale;
            }
          }
          return const Locale('en');
        },
        routes: {
          '/screen2': (context) => Screen2(onLocaleChange: setLocale),
        },
        home: const Scaffold(
          body: Center(child: Text("Welcome to KTU RAG!")),
        ),
      ),
    );
  }
}

class LanguageProvider extends InheritedWidget {
  final Function(Locale) changeLanguage;

  const LanguageProvider(
      {required Widget child, required this.changeLanguage, Key? key})
      : super(key: key, child: child);

  static LanguageProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LanguageProvider>();
  }

  @override
  bool updateShouldNotify(LanguageProvider oldWidget) => true;
}
