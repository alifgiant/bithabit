import 'package:flutter/material.dart';

class RecapPage extends StatelessWidget {
  const RecapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(child: Text(runtimeType.toString())),
    );
  }
}
