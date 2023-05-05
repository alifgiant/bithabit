import 'package:bithabit/src/model/habit.dart';
import 'package:bithabit/src/pages/detail/detail_page.dart';
import 'package:bithabit/src/service/habit_service.dart';
import 'package:bithabit/src/utils/res/res_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/pages/home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HabitService()),
      ],
      child: MaterialApp(
        title: 'BitHabit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
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

            return DetailPage(
              habit: args is Habit ? args : null,
              habitService: habitService,
            );
          }
        },
      ),
    );
  }
}
