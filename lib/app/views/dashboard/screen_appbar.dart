import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/app/views/dashboard/dashboard_controller.dart';
import 'package:muslim/app/modules/rearrange_dashboard/rearrange_dashboard_page_controller.dart';
import 'package:muslim/core/values/app_dashboard.dart';
import 'package:muslim/core/values/constant.dart';
import 'package:muslim/app/shared/functions/print.dart';

import '../../../core/themes/theme_services.dart';

class ScreenAppBar extends StatelessWidget {
  final DashboardController controller;

  const ScreenAppBar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String appIcon;
    if (ThemeServices.isDarkMode()) {
      appIcon = 'assets/images/app_icon.png';
    } else {
      appIcon = 'assets/images/app_icon_light.png';
    }
    return SliverAppBar(
      title: controller.isSearching
          ? TextFormField(
              style: TextStyle(color: mainColor, decorationColor: mainColor),
              textAlign: TextAlign.center,
              controller: controller.searchController,
              autofocus: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "البحث",
                  contentPadding: const EdgeInsets.only(
                      left: 15, bottom: 5, top: 5, right: 15),
                  prefix: IconButton(
                    icon: const Icon(Icons.clear_all),
                    onPressed: () {
                      controller.searchController.clear();
                      controller.searchZikr();
                      controller.update();
                    },
                  )),
              onChanged: (value) {
                controller.searchZikr();
              },
            )
          : SizedBox(
              width: 40,
              child: Image.asset(
                appIcon,
              ),
            ),
      pinned: true,
      floating: true,
      snap: true,
      bottom: PreferredSize(
        preferredSize: const Size(0, 48),
        child: GetBuilder<RearrangeDashboardPageController>(
            init: RearrangeDashboardPageController(),
            builder: (rearrangeController) {
              return TabBar(
                indicatorColor: mainColor,
                // labelColor: mainColor,
                // unselectedLabelColor: null,
                // controller: tabController,
                tabs: [
                  ...List.generate(
                    appDashboardItem.length,
                    (index) {
                      hisnPrint("rebuild");
                      return Tab(
                        child: Text(
                          appDashboardItem[rearrangeController.list[index]]
                              .title,
                          style: const TextStyle(
                              fontFamily: "Uthmanic",
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ],
              );
            }),
      ),
      actions: [
        controller.isSearching
            ? IconButton(
                splashRadius: 20,
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.exit_to_app_sharp),
                onPressed: () {
                  controller.isSearching = false;
                  controller.searchedTitle = controller.allTitle;
                  // controller.searchController.clear();
                  controller.update();
                })
            : IconButton(
                splashRadius: 20,
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.search),
                onPressed: () {
                  controller.searchZikr();
                }),
        controller.isSearching
            ? const SizedBox()
            : IconButton(
                splashRadius: 20,
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.vertical_split_rounded),
                onPressed: () {
                  controller.toggleDrawer();
                }),
      ],
    );
  }
}
