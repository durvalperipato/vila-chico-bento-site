import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nano_core/nano_core.dart';
import 'package:vila_chico_bento_site/firebase_options.dart';
import 'core/injections/app_injections.dart';
import 'core/routes/app_router.dart';
import 'core/settings/app_settings.dart';
import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NanoLogger.init(
    enabled: !NanoEnv.isProduction,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await const AppInjections()();
  runApp(const VilaChicoBentoApp());
}

class VilaChicoBentoApp extends StatelessWidget {
  const VilaChicoBentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        AppSettings.localeNotifier,
        AppSettings.themeModeNotifier,
      ]),
      builder: (context, _) {
        return NanoApp(
          router: appRouter,
          title: 'Vila Chico Bento | Creche e Hospedagem para Cães em Pinhais',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: AppSettings.themeModeNotifier.value,
          locale: AppSettings.localeNotifier.value,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
