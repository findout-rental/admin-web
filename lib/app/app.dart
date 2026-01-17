import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../core/constants/storage_keys.dart';
import '../core/theme/app_theme.dart';
import '../core/localization/app_translations.dart';
import 'routes/app_pages.dart';
import 'bindings/initial_binding.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FindOut Admin',
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      checkerboardOffscreenLayers: false,
      checkerboardRasterCacheImages: false,
      
      // Enable logging for debugging
      logWriterCallback: (text, {bool? isError}) {
        // Logging is handled by AppLogger in production
        // This callback is only for GetX internal logging
      },

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: AppTheme.themeMode,

      // Localization
      locale: _getInitialLocale(),
      fallbackLocale: const Locale('en', 'US'),
      translations: AppTranslations(),
      localeResolutionCallback: (locale, supportedLocales) {
        // Handle locale resolution for GetX
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return supportedLocales.first;
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
      ],

      // Routing
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      
      // Fallback route if initial route fails
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Page Not Found'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Get.offAllNamed('/login'),
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          ),
        ),
      ),

      // Initial binding
      initialBinding: InitialBinding(),
    );
  }

  static Locale _getInitialLocale() {
    try {
      final storage = GetStorage();
      final language = storage.read<String>(StorageKeys.language) ?? 'en';
      return language == 'ar' 
          ? const Locale('ar', 'SA') 
          : const Locale('en', 'US');
    } catch (e) {
      return const Locale('en', 'US');
    }
  }
}
