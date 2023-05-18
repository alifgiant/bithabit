import 'package:bithabit/src/utils/view/view_utils.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/recap_service.dart';
import '../../service/sorting_service.dart';
import '../../utils/res/res_color.dart';
import '../../utils/view/app_bar_title.dart';
import '../../utils/view/app_version.dart';
import '../../utils/view/section_title.dart';
import 'subscribe_tile.dart';

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
              ViewUtils.showOptionListBottomSheet(
                context: context,
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
          ),
          _SettingTile(
            title: 'Recap View Style',
            icon: Icons.calendar_month_outlined,
            onTap: () {
              ViewUtils.showOptionListBottomSheet(
                context: context,
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
          ),
          _SettingTile(
            title: 'Archived Habit',
            icon: BoxIcons.bx_archive_out,
            onTap: () {},
          ),
          _SettingTile(
            title: 'Export/Import Data',
            icon: Icons.import_export,
            onTap: () {},
          ),
          const SubscribeTile(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: screenPadding),
            child: SectionTitle(text: 'About App'),
          ),
          _SettingTile(
            title: 'General Help',
            icon: Icons.help_outline_rounded,
            onTap: () => launchUrl(
              Uri.parse('https://alifgiant.notion.site/BitHabit-Frequently-Asked-Questions-FAQ-39f18303d3ec43589228ca5b1776b23f'),
            ),
          ),
          _SettingTile(
            title: 'Rate the app',
            icon: BoxIcons.bx_star,
            onTap: () {},
          ),
          _SettingTile(
            title: 'Terms of Use',
            icon: Icons.check_outlined,
            onTap: () => launchUrl(
              Uri.parse('https://alifgiant.notion.site/BitHabit-Terms-of-Use-35258a9b7a2140ef9682f5897d8b0fe6'),
            ),
          ),
          _SettingTile(
            title: 'Privacy Policy',
            icon: Icons.lock_outline_rounded,
            onTap: () => launchUrl(
              Uri.parse('https://alifgiant.notion.site/BitHabit-Privacy-Policy-8a58c24dc4934c218002c3e60d2a1205'),
            ),
          ),
          _SettingTile(
            title: 'Send Feedback',
            icon: BoxIcons.bx_message_square_detail,
            onTap: () => launchUrl(Uri.parse('https://instagram.com/luxinfity')),
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
