import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:muslim/app/data/models/models.dart";
import 'package:muslim/app/shared/widgets/empty.dart';
import 'package:muslim/app/views/dashboard/dashboard_controller.dart';
import 'package:muslim/app/views/dashboard/widgets/title_card.dart';
import 'package:muslim/core/utils/alarm_database_helper.dart';

class AzkarFehrs extends StatelessWidget {
  const AzkarFehrs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        final List<DbTitle> titleListToDisplay = controller.searchedTitle;
        return Scaffold(
          body: Scrollbar(
            controller: controller.fehrsScrollController,
            thumbVisibility: false,
            child: titleListToDisplay.isEmpty
                ? Empty(
                    isImage: false,
                    icon: Icons.search_outlined,
                    title: "no title with this name".tr,
                    description: "please review the index of the book".tr,
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: titleListToDisplay.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: alarmDatabaseHelper.getAlarmByZikrTitle(
                          dbTitle: titleListToDisplay[index],
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return TitleCard(
                              index: index,
                              fehrsTitle: titleListToDisplay[index],
                              dbAlarm: snapshot.data!,
                            );
                          } else {
                            return const ListTile();
                          }
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
