import 'package:bithabit/src/service/sorting_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/model/habit.dart';
import 'src/pages/detail/detail_page.dart';
import 'src/pages/home/home_page.dart';
import 'src/service/habit_service.dart';
import 'src/service/timeline_service.dart';
import 'src/utils/res/res_color.dart';

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
      ],
      child: MaterialApp(
        locale: locale,
        builder: builder,
        useInheritedMediaQuery: useInheritedMediaQuery,
        title: 'BitHabit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: ResColor.white,
          primaryTextTheme: const TextTheme(
            titleLarge: TextStyle(color: ResColor.black),
          ),
          appBarTheme: const AppBarTheme(
            color: ResColor.white,
            titleTextStyle: TextStyle(
              color: ResColor.black,
            ),
            toolbarTextStyle: TextStyle(
              color: ResColor.black,
            ),
            iconTheme: IconThemeData(
              color: ResColor.black,
            ),
          ),
        ),
        routes: {
          '/': (context) => const HomePage(),
          '/detail': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            final habitService = context.read<HabitService>();
            final timelineService = context.read<TimelineService>();

            return DetailPage(
              habit: args is Habit ? args : null,
              habitService: habitService,
              timelineService: timelineService,
            );
          }
        },
      ),
    );
  }
}
