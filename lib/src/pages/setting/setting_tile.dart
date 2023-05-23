import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/res/res_color.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;

  const SettingTile({required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      horizontalTitleGap: 0,
      onTap: onTap,
      leading: Icon(icon, color: ResColor.black),
      title: Text(title),
      trailing: const Icon(BoxIcons.bx_chevron_right),
    );
  }
}
