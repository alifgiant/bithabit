import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/navigation_service.dart';
import '../../service/recap_service.dart';
import '../../service/sorting_service.dart';
import '../../utils/const/app_route.dart';
import '../../utils/view/app_bar_title.dart';
import '../../utils/view/app_version.dart';
import '../../utils/view/section_title.dart';
import '../../utils/view/view_utils.dart';
import 'setting_tile.dart';
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
          SettingTile(
            title: 'Today View Sorting',
            icon: Icons.sort_rounded,
            onTap: () {
              final selected = context.read<SortingService>().selectedOption;
              ViewUtils.showOptionListBottomSheet<void>(
                context: context,
                children: SortingOption.values
                    .map(
                      (e) => ListTile(
                        title: Text(e.title),
                        trailing: selected == e
                            ? Icon(
                                BoxIcons.bx_check,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        onTap: () {
                          context
                              .read<SortingService>()
                              .updateOption(e, 'Setting Page');
                          NavigationService.of(context).maybePop();
                        },
                      ),
                    )
                    .toList(),
              );
            },
          ),
          SettingTile(
            title: 'Recap View Style',
            icon: Icons.calendar_month_outlined,
            onTap: () {
              final selected = context.read<RecapService>().selectedOption;
              ViewUtils.showOptionListBottomSheet<void>(
                context: context,
                children: RecapOption.values
                    .map(
                      (e) => ListTile(
                        title: Text(e.menuTitle),
                        trailing: selected == e
                            ? Icon(
                                BoxIcons.bx_check,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        onTap: () {
                          context
                              .read<RecapService>()
                              .updateOption(e, 'Setting Page');
                          NavigationService.of(context).maybePop();
                        },
                      ),
                    )
                    .toList(),
              );
            },
          ),
          SettingTile(
            title: 'Archived Habit',
            icon: BoxIcons.bx_archive_out,
            onTap: () => NavigationService.of(context).open(AppRoute.archive),
          ),
          SettingTile(
            title: 'Export/Import Data',
            icon: Icons.import_export,
            onTap: () => NavigationService.of(context).open(AppRoute.export),
          ),
          const SubscribeTile(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: screenPadding),
            child: SectionTitle(text: 'About App'),
          ),
          SettingTile(
            title: 'General Help',
            icon: Icons.help_outline_rounded,
            onTap: () => launchUrl(
              Uri.parse(
                'https://alifgiant.notion.site/BitHabit-Frequently-Asked-Questions-FAQ-39f18303d3ec43589228ca5b1776b23f',
              ),
            ),
          ),
          SettingTile(
            title: 'Rate the app',
            icon: BoxIcons.bx_star,
            onTap: () {
              if (kIsWeb) {
                try {
                  launchUrl(Uri.parse(playStoreUrl));
                } catch (e) {
                  FlutterError.reportError(FlutterErrorDetails(exception: e));
                }
                return;
              }
              InAppReview.instance.openStoreListing(
                appStoreId: '...', // TODO: apple app id
              );
            },
          ),
          SettingTile(
            title: 'Terms of Use',
            icon: Icons.check_outlined,
            onTap: () => launchUrl(
              Uri.parse(
                'https://alifgiant.notion.site/BitHabit-Terms-of-Use-35258a9b7a2140ef9682f5897d8b0fe6',
              ),
            ),
          ),
          SettingTile(
            title: 'Privacy Policy',
            icon: Icons.lock_outline_rounded,
            onTap: () => launchUrl(
              Uri.parse(
                'https://alifgiant.notion.site/BitHabit-Privacy-Policy-8a58c24dc4934c218002c3e60d2a1205',
              ),
            ),
          ),
          SettingTile(
            title: 'Send Feedback',
            icon: BoxIcons.bx_message_square_detail,
            onTap: () => launchUrl(
              Uri.parse('https://instagram.com/luxinfity'),
            ),
          ),
          SettingTile(
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

const androidId = 'com.luxinfity.bithabit';
const playStoreUrl = 'https://play.google.com/store/apps/details?id=$androidId';
