import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:muslim/generated/l10n.dart';
import 'package:muslim/src/core/di/dependency_injection.dart'
    as service_locator;
import 'package:muslim/src/core/di/dependency_injection.dart';
import 'package:muslim/src/core/extensions/extension_platform.dart';
import 'package:muslim/src/core/functions/print.dart';
import 'package:muslim/src/core/utils/app_bloc_observer.dart';
import 'package:muslim/src/core/values/constant.dart';
import 'package:muslim/src/features/alarms_manager/data/models/awesome_notification_manager.dart';
import 'package:muslim/src/features/themes/data/repository/theme_repo.dart';
import 'package:muslim/src/features/ui/data/repository/local_repo.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

Future<void> initServices() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  service_locator.initSL();

  await loadLocalizations();

  await phoneDeviceBars();

  if (PlatformExtension.isDesktopOrWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  try {
    await GetStorage.init(kAppStorageKey);
    await sl<AwesomeNotificationManager>().init();
  } catch (e) {
    hisnPrint(e);
  }

  await initWindowsManager();
}

Future phoneDeviceBars() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Future initWindowsManager() async {
  if (!PlatformExtension.isDesktop) return;

  await windowManager.ensureInitialized();

  final WindowOptions windowOptions = WindowOptions(
    size: sl<UIRepo>().desktopWindowSize,
    center: true,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.show();
    await windowManager.focus();
  });
}

Future loadLocalizations() async {
  Locale? localeToSet = sl<ThemeRepo>().appLocale;
  final languageCode = PlatformExtension.languageCode;
  localeToSet ??= Locale.fromSubtags(languageCode: languageCode ?? "en");
  await S.load(localeToSet);
}
