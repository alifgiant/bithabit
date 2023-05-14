import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  static Future<String> getText() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final currentBuild = packageInfo.buildNumber;

    return 'v$currentVersion-$currentBuild';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: FutureBuilder<String>(
        future: getText(),
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BitHabit ${snapshot.data}',
                style: const TextStyle(color: Colors.black54),
              ),
              const Text(
                'From 🇮🇩 With ❤️ by Alif Akbar',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
