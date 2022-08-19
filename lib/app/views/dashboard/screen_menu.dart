import 'package:flutter/material.dart';
import 'package:muslim/app/views/dashboard/dashboard_controller.dart';
import 'package:muslim/app/modules/quran/quran_controller.dart';
import 'package:muslim/core/values/constant.dart';
import 'package:muslim/app/shared/transition_animation/transition_animation.dart';
import 'package:muslim/app/shared/widgets/scroll_glow_remover.dart';
import 'package:muslim/core/utils/email_manager.dart';
import 'package:muslim/app/modules/fake_hadith/fake_hadith.dart';
import 'package:muslim/app/modules/quran/quran_read_page.dart';
import 'package:muslim/app/modules/about/about.dart';
import 'package:muslim/app/modules/app_update_news/app_update_news.dart';
import 'package:muslim/app/modules/settings/settings.dart';
import 'package:muslim/app/modules/tally/tally_dashboard.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/themes/theme_services.dart';

class ScreenMenu extends StatelessWidget {
  final DashboardController controller;

  const ScreenMenu({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String appIcon;
    if (ThemeServices.isDarkMode()) {
      appIcon = 'assets/images/app_icon.png';
    } else {
      appIcon = 'assets/images/app_icon_light.png';
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                appIcon,
                scale: 1.5,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Version $appVersion",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.toggleTheme();
                    },
                    icon: const Icon(Icons.dark_mode),
                  ),
                ],
              ),
              const Divider(
                height: 5,
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: ScrollGlowRemover(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        DrawerCard(
                          child: ListTile(
                            leading: const Icon(
                              Icons.watch_rounded,
                            ),
                            title: const Text("السبحة"),
                            onTap: () {
                              transitionAnimation.fromBottom2Top(
                                context: context,
                                goToPage: const Tally(),
                              );
                            },
                          ),
                        ),
                        const DrawerDivider(),
                        DrawerCard(
                          child: ListTile(
                            leading: const Icon(MdiIcons.bookOpenPageVariant),
                            title: const Text("سورة الكهف"),
                            onTap: () {
                              transitionAnimation.fromBottom2Top(
                                context: context,
                                goToPage: const QuranReadPage(
                                  surahName: SurahNameEnum.alKahf,
                                ),
                              );
                            },
                          ),
                        ),
                        DrawerCard(
                          child: ListTile(
                            leading: const Icon(MdiIcons.bookOpenPageVariant),
                            title: const Text("سورة السجدة"),
                            onTap: () {
                              transitionAnimation.fromBottom2Top(
                                context: context,
                                goToPage: const QuranReadPage(
                                  surahName: SurahNameEnum.assajdah,
                                ),
                              );
                            },
                          ),
                        ),
                        DrawerCard(
                          child: ListTile(
                            leading: const Icon(MdiIcons.bookOpenPageVariant),
                            title: const Text("سورة الملك"),
                            onTap: () {
                              transitionAnimation.fromBottom2Top(
                                  context: context,
                                  goToPage: const QuranReadPage(
                                    surahName: SurahNameEnum.alMulk,
                                  ));
                            },
                          ),
                        ),
                        const DrawerDivider(),
                        DrawerCard(
                          child: ListTile(
                            leading: const Icon(Icons.menu_book),
                            title: const Text("أحاديث لا تصح"),
                            onTap: () {
                              transitionAnimation.fromBottom2Top(
                                context: context,
                                goToPage: const FakeHadith(),
                              );
                            },
                          ),
                        ),
                        const DrawerDivider(),
                        DrawerCard(
                          child: ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text("الإعدادات"),
                            onTap: () {
                              transitionAnimation.fromBottom2Top(
                                context: context,
                                goToPage: const Settings(),
                              );
                            },
                          ),
                        ),
                        const DrawerDivider(),
                        DrawerCard(
                          child: ListTile(
                            leading: const Icon(Icons.star),
                            title: const Text("تواصل مع المطور"),
                            onTap: () {
                              EmailManager.sendFeedback();
                            },
                          ),
                        ),
                        DrawerCard(
                          child: ListTile(
                            leading: const Icon(Icons.history),
                            title: const Text("تاريخ التحديثات"),
                            onTap: () {
                              transitionAnimation.fromBottom2Top(
                                context: context,
                                goToPage: const AppUpdateNews(),
                              );
                            },
                          ),
                        ),
                        DrawerCard(
                          child: ListTile(
                            leading: const Icon(Icons.info),
                            title: const Text("عنا"),
                            onTap: () {
                              transitionAnimation.fromBottom2Top(
                                context: context,
                                goToPage: const About(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DrawerDivider(),
              DrawerCard(
                child: ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text("إغلاق"),
                  onTap: () {
                    controller.toggleDrawer();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DrawerCard extends StatelessWidget {
  final Widget? child;

  const DrawerCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }
}

class DrawerDivider extends StatelessWidget {
  const DrawerDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
    );
  }
}
