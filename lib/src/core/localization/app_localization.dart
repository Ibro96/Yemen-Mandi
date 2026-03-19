import 'package:flutter/widgets.dart';

class AppLocalization {
  AppLocalization(this.locale);
  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  static const _strings = {
    'en': {
      'appName': 'Yemen Mandi',
      'home': 'Home',
      'orders': 'Orders',
      'cart': 'Cart',
      'favorites': 'Favorites',
      'profile': 'Profile',
      'search': 'Search meals',
      'addToCart': 'Add',
      'checkout': 'Checkout',
      'unavailable': 'Unavailable',
      'welcome': 'Welcome Back',
      'login': 'Login',
    },
    'ar': {
      'appName': 'يمن مندي',
      'home': 'الرئيسية',
      'orders': 'طلباتي',
      'cart': 'السلة',
      'favorites': 'المفضلة',
      'profile': 'الحساب',
      'search': 'ابحث عن وجبة',
      'addToCart': 'إضافة',
      'checkout': 'إكمال الطلب',
      'unavailable': 'غير متوفر',
      'welcome': 'مرحباً بعودتك',
      'login': 'تسجيل الدخول',
    }
  };

  String t(String key) => _strings[locale.languageCode]![key] ?? key;
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async => AppLocalization(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) => false;
}
