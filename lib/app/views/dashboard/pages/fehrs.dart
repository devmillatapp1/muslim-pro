import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/app/views/dashboard/dashboard_controller.dart';
import 'package:muslim/app/data/models/alarm.dart';
import 'package:muslim/app/data/models/zikr_title.dart';
import 'package:muslim/app/shared/widgets/empty.dart';
import 'package:muslim/app/shared/widgets/scroll_glow_custom.dart';
import 'package:muslim/core/utils/alarm_database_helper.dart';
import 'package:muslim/app/views/dashboard/widgets/title_card.dart';

class AzkarFehrs extends StatelessWidget {
  const AzkarFehrs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      List<DbTitle> titleListToDisplay = controller.searchedTitle;
      return Scaffold(
        body: Scrollbar(
            controller: controller.fehrsScrollController,
            thumbVisibility: false,
            child: titleListToDisplay.isEmpty
                ? const Empty(
                    isImage: false,
                    icon: Icons.search_outlined,
                    title: "لا يوجد عنوان بهذا الاسم",
                    description: "برجاء قم بمراجعة ما كتبت",
                  )
                : ScrollGlowCustom(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: titleListToDisplay.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                            future: alarmDatabaseHelper.getAlarmByZikrTitle(
                                dbTitle: titleListToDisplay[index]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return TitleCard(
                                  index: index,
                                  fehrsTitle: titleListToDisplay[index],
                                  dbAlarm: snapshot.data as DbAlarm,
                                );
                              } else {
                                return const ListTile();
                              }
                            });
                      },
                    ),
                  )),
      );
    });
  }
}
