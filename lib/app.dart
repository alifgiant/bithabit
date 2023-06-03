import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/model/habit.dart';
import 'src/pages/archived/archived_page.dart';
import 'src/pages/charts/chart_page.dart';
import 'src/pages/detail/detail_page.dart';
import 'src/pages/export/export_page.dart';
import 'src/pages/home/home_page.dart';
import 'src/pages/subscription/subscription_page.dart';
import 'src/service/analytic_service.dart';
import 'src/service/cache/cache.dart';
import 'src/service/cache/pref_cache.dart';
import 'src/service/database/database.dart';
import 'src/service/database/database_service.dart';
import 'src/service/exporter/exporter_service.dart';
import 'src/service/habit_service.dart';
import 'src/service/notification/notification_manager.dart';
import 'src/service/recap_service.dart';
import 'src/service/sorting_service.dart';
import 'src/service/subs_service.dart';
import 'src/service/timeline_service.dart';
import 'src/utils/const/app_route.dart';

class MyApp extends StatelessWidget {
  final Locale? locale;
  final TransitionBuilder? builder;
  final bool useInheritedMediaQuery;

  const MyApp({
    this.locale,
    this.builder,
    this.useInheritedMediaQuery = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Cache>(create: (_) => const PrefCache()),
        Provider(create: (_) => NotificationManager()..init()),
        Provider<DatabaseService>(create: (ctx) => Database.create(ctx.read())),
        Provider(create: (ctx) => ExporterService(ctx.read())),
        ChangeNotifierProvider(create: (_) => SubsService()),
        ChangeNotifierProvider(
          create: (ctx) => HabitService(ctx.read(), ctx.read()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TimelineService(ctx.read(), ctx.read()),
        ),
        ChangeNotifierProvider(create: (ctx) => SortingService(ctx.read())),
        ChangeNotifierProvider(create: (ctx) => RecapService(ctx.read())),
      ],
      child: MaterialApp(
        locale: locale,
        builder: builder,
        useInheritedMediaQuery: useInheritedMediaQuery,
        title: 'BitHabit',
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(
          scheme: FlexScheme.sanJuanBlue,
          subThemesData: const FlexSubThemesData(
            inputDecoratorBorderType: FlexInputBorderType.underline,
            tooltipSchemeColor: SchemeColor.inverseSurface,
          ),
          keyColors: const FlexKeyColors(),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
        ),
        themeMode: ThemeMode.light,
        routes: {
          AppRoute.home: (context) {
            Analytic.get().logScreenView(
              screenName: 'Home Page',
              screenClass: 'home_page.dart',
            );
            return const HomePage();
          },
          AppRoute.detail: (context) {
            Analytic.get().logScreenView(
              screenName: 'Detail Page',
              screenClass: 'detail_page.dart',
            );
            final args = ModalRoute.of(context)?.settings.arguments;
            final habitService = context.read<HabitService>();
            final timelineService = context.read<TimelineService>();
            final notifManager = context.read<NotificationManager>();

            return DetailPage(
              habit: args is Habit ? args : null,
              habitService: habitService,
              timelineService: timelineService,
              notificationManager: notifManager,
            );
          },
          AppRoute.archive: (context) {
            Analytic.get().logScreenView(
              screenName: 'Archive Page',
              screenClass: 'archived_page.dart',
            );
            return const ArchivedPage();
          },
          AppRoute.charts: (context) {
            Analytic.get().logScreenView(
              screenName: 'Chart Page',
              screenClass: 'chart_page.dart',
            );
            final args = ModalRoute.of(context)?.settings.arguments;
            return ChartPage(habit: args! as Habit);
          },
          AppRoute.export: (context) {
            Analytic.get().logScreenView(
              screenName: 'Export/Import Data Page',
              screenClass: 'export_page.dart',
            );
            return const ExportPage();
          },
          AppRoute.premium: (context) {
            Analytic.get().logScreenView(
              screenName: 'Subscription Page',
              screenClass: 'subscription_page.dart',
            );
            return const SubscriptionPage();
          },
        },
      ),
    );
  }
}
