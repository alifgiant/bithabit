import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

mixin SoundPlayer<T extends StatefulWidget> on State<T> {
  final _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void playCheckSound() {
    if (_player.state == PlayerState.playing) _player.stop();
    _player.play(AssetSource('small-step.aac'));
  }

  void playCompleteSound() {
    if (_player.state == PlayerState.playing) _player.stop();
    _player.play(AssetSource('win-sound.aac'));
  }
}
