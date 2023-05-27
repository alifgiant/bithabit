import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

import 'src/model/habit.dart';
import 'src/pages/archived/archived_page.dart';
import 'src/pages/charts/chart_page.dart';
import 'src/pages/detail/detail_page.dart';
import 'src/pages/export/export_page.dart';
import 'src/pages/home/home_page.dart';
import 'src/pages/subscription/subscription_page.dart';
import 'src/service/habit_service.dart';
import 'src/service/recap_service.dart';
import 'src/service/sorting_service.dart';
import 'src/service/subs_service.dart';
import 'src/service/timeline_service.dart';
import 'src/utils/const/app_route.dart';

class MyApp extends StatelessWidget {
  final Isar isar;
  final Locale? locale;
  final TransitionBuilder? builder;
  final bool useInheritedMediaQuery;

  const MyApp({
    required this.isar,
    this.locale,
    this.builder,
    this.useInheritedMediaQuery = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: isar),
        ChangeNotifierProvider(create: (_) => SubsService()),
        ChangeNotifierProvider(create: (ctx) => HabitService(ctx.read())),
        ChangeNotifierProvider(create: (_) => TimelineService()),
        ChangeNotifierProvider(create: (_) => SortingService()),
        ChangeNotifierProvider(create: (_) => RecapService()),
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
          AppRoute.home: (context) => const HomePage(),
          AppRoute.detail: (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            final habitService = context.read<HabitService>();
            final timelineService = context.read<TimelineService>();

            return DetailPage(
              habit: args is Habit ? args : null,
              habitService: habitService,
              timelineService: timelineService,
            );
          },
          AppRoute.archive: (context) => const ArchivedPage(),
          AppRoute.charts: (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            return ChartPage(habit: args as Habit);
          },
          AppRoute.export: (context) => const ExportPage(),
          AppRoute.premium: (context) => const SubscriptionPage(),
        },
      ),
    );
  }
}
