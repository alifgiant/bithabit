import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/model/habit.dart';
import 'src/pages/archived/archived_page.dart';
import 'src/pages/charts/chart_page.dart';
import 'src/pages/detail/detail_page.dart';
import 'src/pages/home/home_page.dart';
import 'src/service/habit_service.dart';
import 'src/service/recap_service.dart';
import 'src/service/sorting_service.dart';
import 'src/service/timeline_service.dart';
import 'src/utils/const/app_route.dart';

class MyApp extends StatelessWidget {
  final Locale? locale;
  final TransitionBuilder? builder;
  final bool useInheritedMediaQuery;

  const MyApp({
    super.key,
    this.locale,
    this.builder,
    this.useInheritedMediaQuery = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitService()),
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
          // To use the Playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
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
        },
      ),
    );
  }
}
