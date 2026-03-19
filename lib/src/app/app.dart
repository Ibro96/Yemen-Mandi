import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/localization/app_localization.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('ar'));
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class YemenMandiApp extends ConsumerStatefulWidget {
  const YemenMandiApp({super.key});

  @override
  ConsumerState<YemenMandiApp> createState() => _YemenMandiAppState();
}

class _YemenMandiAppState extends ConsumerState<YemenMandiApp> {
  @override
  void initState() {
    super.initState();
    _restorePrefs();
  }

  Future<void> _restorePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('lang');
    final dark = prefs.getBool('dark_mode');
    if (lang != null) ref.read(localeProvider.notifier).state = Locale(lang);
    if (dark != null) ref.read(themeModeProvider.notifier).state = dark ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final theme = ref.watch(themeModeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Yemen Mandi',
      locale: locale,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: theme,
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalization.supportedLocales,
      routerConfig: appRouter,
      builder: (context, child) {
        final rtl = locale.languageCode == 'ar';
        return Directionality(textDirection: rtl ? TextDirection.rtl : TextDirection.ltr, child: child!);
      },
    );
  }
}
