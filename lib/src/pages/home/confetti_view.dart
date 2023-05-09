import 'dart:math';

import 'package:achievement_view/achievement_view.dart';
import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../service/habit_service.dart';
import '../../service/timeline_service.dart';
import '../../utils/res/res_color.dart';

class ConfettiView extends StatefulWidget {
  final Duration? duration;
  const ConfettiView({super.key, this.duration});

  @override
  State<ConfettiView> createState() => _ConfettiViewState();
}

class _ConfettiViewState extends State<ConfettiView> {
  late final confettiController = ConfettiController(
    duration: const Duration(seconds: 6),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final today = DateTime.now();
    final habitService = context.watch<HabitService>();
    final habits = habitService.getHabits(day: today).toList();

    final timelineService = context.watch<TimelineService>();
    final completed = habits
        .where(
          (habit) => timelineService.isHabitChecked(habit, today),
        )
        .length;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if updated time is not today, ignore event
      if (timelineService.lastTimelineUpdated?.isSameDay(today) != true) return;
      if (completed == habits.length && habits.isNotEmpty) startAnimation(context);
    });
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  Future<void> startAnimation(BuildContext context) async {
    AchievementView(
      context,
      title: "Congrats!",
      subTitle: "All today's Habit are done",
      alignment: Alignment.bottomCenter,
      icon: const Icon(BoxIcons.bx_party, color: Colors.white),
      borderRadius: BorderRadius.circular(12.0),
      color: ResColor.darkGreen,
    ).show();
    confettiController.play();
    await Future.delayed(widget.duration ?? const Duration(seconds: 3));
    confettiController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: confettiController,
      blastDirectionality: BlastDirectionality.explosive, // don't specify a direction, blast randomly
      shouldLoop: true, // start again as soon as the animation is finished
      colors: const [
        ResColor.lightGreen,
        ResColor.lightBlue,
        ResColor.pink,
        Colors.orange,
        ResColor.purple
      ], // manually specify the colors to be used
      createParticlePath: drawStar, // define a custom shape/path.
    );
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep), halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
