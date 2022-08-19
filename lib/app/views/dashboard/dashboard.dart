import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:muslim/app/views/dashboard/dashboard_controller.dart';
import 'package:muslim/app/modules/rearrange_dashboard/rearrange_dashboard_page_controller.dart';
import 'package:muslim/core/values/app_dashboard.dart';
import 'package:muslim/core/values/constant.dart';
import 'package:muslim/app/shared/widgets/loading.dart';
import 'package:muslim/app/shared/widgets/scroll_glow_custom.dart';
import 'package:muslim/app/shared/widgets/scroll_glow_remover.dart';
import 'package:muslim/app/views/dashboard/screen_appbar.dart';
import 'package:muslim/app/views/dashboard/screen_menu.dart';

class AzkarDashboard extends StatelessWidget {
  const AzkarDashboard({
    Key? key,
  }) : super(key: key);

  @override
  build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (controller) => controller.isLoading
          ? const Loading()
          : ZoomDrawer(
              isRtl: true,
              controller: controller.zoomDrawerController,
              menuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
              menuScreen: ScreenMenu(
                controller: controller,
              ),
              mainScreen: MainScreen(
                controller: controller,
              ),
              borderRadius: 24.0,
              showShadow: true,
              angle: 0.0,
              drawerShadowsBackgroundColor: mainColor,
              slideWidth: 250,
            ),
    );
  }
}

class MainScreen extends StatelessWidget {
  final DashboardController controller;

  const MainScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: appDashboardItem.length,
      child: Scaffold(
        body: ScrollGlowRemover(
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                ScreenAppBar(controller: controller),
              ];
            },
            body: ScrollGlowCustom(
              axisDirection: AxisDirection.right,
              child: GetBuilder<RearrangeDashboardPageController>(
                  init: RearrangeDashboardPageController(),
                  builder: (rearrangeController) {
                    return TabBarView(
                      // controller: tabController,
                      children: [
                        ...List.generate(
                          appDashboardItem.length,
                          (index) {
                            return appDashboardItem[
                                    rearrangeController.list[index]]
                                .widget;
                          },
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
