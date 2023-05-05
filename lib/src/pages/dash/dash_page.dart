import 'package:flutter/material.dart';

class DashPage extends StatelessWidget {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(child: Text(runtimeType.toString())),
    );
  }
}
