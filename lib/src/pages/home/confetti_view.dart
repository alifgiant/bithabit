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
import 'sound_player.dart';

class ConfettiView extends StatefulWidget {
  final Duration? duration;
  const ConfettiView({
    this.duration,
    super.key,
  });

  @override
  State<ConfettiView> createState() => _ConfettiViewState();
}

class _ConfettiViewState extends State<ConfettiView> with SoundPlayer {
  late final confettiController = ConfettiController(
    duration: const Duration(seconds: 6),
  );

  late final HabitService habitService;
  late final TimelineService timelineService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    habitService = context.read<HabitService>();
    timelineService = context.read<TimelineService>();

    /// dont do provider watch,
    /// it'll trigger widget rebuild
    /// doing it this way wont trigger widget rebuild
    habitService.addListener(checkUpdate);
    timelineService.addListener(checkUpdate);
  }

  void checkUpdate() {
    final today = DateTime.now();
    final habits = habitService.getHabits(day: today).toList();
    final completed = habits
        .where(
          (habit) => timelineService.isHabitChecked(habit, today),
        )
        .length;

    final lastAction = timelineService.lastAction;
    if (lastAction == null || lastAction is! CheckAction) return;

    // if action is not "check", ignore event
    if (!lastAction.isCheck) return;

    // if all today habit are completed, trigger award animation
    final isEditingTodayHabit = lastAction.time.isAtSameMomentAs(today.emptyHour());
    if (isEditingTodayHabit == true && completed == habits.length && habits.isNotEmpty) {
      playCompleteSound();
      startAnimation(context);
    } else {
      // else only play step sound
      playCheckSound();
    }
  }

  @override
  void dispose() {
    habitService.removeListener(checkUpdate);
    timelineService.removeListener(checkUpdate);

    confettiController.dispose();
    super.dispose();
  }

  Future<void> startAnimation(BuildContext context) async {
    AchievementView(
      context,
      title: 'Congrats!',
      subTitle: "All today's Habit are done",
      alignment: Alignment.bottomCenter,
      icon: const Icon(BoxIcons.bx_party, color: Colors.white),
      borderRadius: BorderRadius.circular(12),
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
      path
        ..lineTo(
          halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step),
        )
        ..lineTo(
          halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep),
        );
    }
    path.close();
    return path;
  }
}
