import 'package:bithabit/src/utils/view/floating_modal.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../service/recap_service.dart';
import '../../service/sorting_service.dart';
import '../../utils/res/res_color.dart';
import '../../utils/view/app_bar_title.dart';
import '../../utils/view/app_version.dart';
import '../../utils/view/section_title.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(text: 'Setting'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          bottom: kBottomNavigationBarHeight * 2,
        ),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: screenPadding),
            child: SectionTitle(text: 'Personalization'),
          ),
          _SettingTile(
            title: 'Today View Sorting',
            icon: Icons.sort_rounded,
            onTap: () {
              showFloatingModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: SortingOption.values
                        .map(
                          (e) => ListTile(
                            title: Text(e.title),
                            onTap: () {
                              context.read<SortingService>().updateOption(e);
                              Navigator.maybePop(context);
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              );
            },
          ),
          _SettingTile(
            title: 'Recap View Style',
            icon: Icons.calendar_month_outlined,
            onTap: () {
              showFloatingModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: RecapOption.values
                        .map(
                          (e) => ListTile(
                            title: Text(e.menuTitle),
                            onTap: () {
                              context.read<RecapService>().updateOption(e);
                              Navigator.maybePop(context);
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              );
            },
          ),
          _SettingTile(
            title: 'Archieved Habit',
            icon: BoxIcons.bx_archive_out,
            onTap: () {},
          ),
          _SettingTile(
            title: 'Data Export/Import',
            icon: Icons.import_export,
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: screenPadding),
            child: SectionTitle(text: 'About App'),
          ),
          _SettingTile(
            title: 'General Help',
            icon: Icons.help_outline_rounded,
            onTap: () {},
          ),
          _SettingTile(
            title: 'Rate the app',
            icon: BoxIcons.bx_star,
            onTap: () {},
          ),
          _SettingTile(
            title: 'Terms of Use',
            icon: Icons.check_outlined,
            onTap: () {},
          ),
          _SettingTile(
            title: 'Privacy Policy',
            icon: Icons.lock_outline_rounded,
            onTap: () {},
          ),
          _SettingTile(
            title: 'Send Feedback',
            icon: BoxIcons.bx_message_square_detail,
            onTap: () {},
          ),
          _SettingTile(
            title: 'Licenses',
            icon: BoxIcons.bx_file_blank,
            onTap: () async => showLicensePage(
              context: context,
              applicationVersion: await AppVersion.getText(),
            ),
          ),
          const AppVersion(),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;

  const _SettingTile({required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      // contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      onTap: onTap,
      leading: Icon(icon, color: ResColor.black),
      title: Text(title),
      trailing: const Icon(BoxIcons.bx_chevron_right),
    );
  }
}
