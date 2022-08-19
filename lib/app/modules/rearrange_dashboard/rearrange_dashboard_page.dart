import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/app/modules/rearrange_dashboard/rearrange_dashboard_page_controller.dart';
import 'package:muslim/core/values/app_dashboard.dart';
import 'package:muslim/app/shared/widgets/loading.dart';
import 'package:muslim/app/shared/widgets/scroll_glow_custom.dart';

class RearrangeDashboardPage extends StatelessWidget {
  const RearrangeDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RearrangeDashboardPageController>(
        init: RearrangeDashboardPageController(),
        builder: (controller) {
          return controller.isLoading
              ? const Loading()
              : Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: const Text("ترتيب الشاشة",
                        style: TextStyle(fontFamily: "Uthmanic")),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                  ),
                  body: ScrollGlowCustom(
                    child: ReorderableListView(
                      onReorder: controller.onReorder,
                      children: [
                        for (int index = 0;
                            index < controller.list.length;
                            index += 1)
                          ListTile(
                            key: Key('$index'),
                            tileColor: controller.list[index].isOdd
                                ? controller.oddItemColor
                                : controller.evenItemColor,
                            title: Text(
                                appDashboardItem[controller.list[index]].title),
                            trailing: const Icon(Icons.horizontal_rule),
                          ),
                      ],
                    ),
                  ),
                );
        });
  }
}
