import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:muslim/generated/l10n.dart';
import 'package:muslim/scroll_behavior.dart';
import 'package:muslim/src/core/di/dependency_injection.dart';
import 'package:muslim/src/core/extensions/extension_platform.dart';
import 'package:muslim/src/core/values/constant.dart';
import 'package:muslim/src/features/alarms_manager/data/models/awesome_notification_manager.dart';
import 'package:muslim/src/features/alarms_manager/data/repository/alarm_database_helper.dart';
import 'package:muslim/src/features/alarms_manager/presentation/controller/bloc/alarms_bloc.dart';
import 'package:muslim/src/features/azkar_filters/presentation/controller/cubit/azkar_filters_cubit.dart';
import 'package:muslim/src/features/fake_hadith/data/repository/fake_hadith_database_helper.dart';
import 'package:muslim/src/features/home/data/repository/hisn_db_helper.dart';
import 'package:muslim/src/features/home/presentation/controller/bloc/home_bloc.dart';
import 'package:muslim/src/features/home/presentation/screens/home_screen.dart';
import 'package:muslim/src/features/home_search/presentation/controller/cubit/search_cubit.dart';
import 'package:muslim/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:muslim/src/features/settings/data/repository/app_settings_repo.dart';
import 'package:muslim/src/features/settings/presentation/controller/cubit/settings_cubit.dart';
import 'package:muslim/src/features/tally/data/repository/tally_database_helper.dart';
import 'package:muslim/src/features/themes/presentation/controller/cubit/theme_cubit.dart';
import 'package:muslim/src/features/ui/presentation/components/desktop_window_wrapper.dart';

class App extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const App({super.key});


  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    sl<AwesomeNotificationManager>().listen();
  }

  @override
  Future<void> dispose() async {
    await sl<HisnDBHelper>().close();
    await sl<FakeHadithDBHelper>().close();
    await sl<AlarmDatabaseHelper>().close();
    await sl<TallyDatabaseHelper>().close();
    sl<AwesomeNotificationManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SettingsCubit>()),
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<AzkarFiltersCubit>()),
        BlocProvider(
          create: (_) => sl<AlarmsBloc>()..add(AlarmsStartEvent()),
        ),
        BlocProvider(
          create: (_) => sl<HomeBloc>()..add(HomeStartEvent()),
        ),
        BlocProvider(
          create: (_) => sl<SearchCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: App.navigatorKey,
            onGenerateTitle: (context) => S.of(context).ElmoslemPro,
            scrollBehavior: AppScrollBehavior(),
            locale: state.locale,
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            theme: state.theme,
            navigatorObservers: [
              BotToastNavigatorObserver(),
            ],
            builder: (context, child) {
              if (PlatformExtension.isDesktop) {
                final botToastBuilder = BotToastInit();
                return DesktopWindowWrapper(
                  child: botToastBuilder(context, child),
                );
              }
              return child ?? const SizedBox();
            },
            home: sl<AppSettingsRepo>().currentVersion != kAppVersion
                ? const OnBoardingScreen()
                : const HomeScreen(),
          );
        },
      ),
    );
  }
}
