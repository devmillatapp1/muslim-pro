import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/app/modules/fake_hadith/fake_hadith_controller.dart';
import 'package:muslim/app/modules/fake_hadith/pages/fake_hadith_read_page.dart';
import 'package:muslim/app/modules/fake_hadith/pages/fake_hadith_unread_page.dart';
import 'package:muslim/app/modules/fake_hadith/widgets/fake_hadith_appbar.dart';
import 'package:muslim/app/shared/widgets/font_settings.dart';

class FakeHadith extends StatelessWidget {
  const FakeHadith({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FakeHadithController>(
      init: FakeHadithController(),
      builder: (controller) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            body: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  const FakehadithAppBar(),
                ];
              },
              body: TabBarView(
                // controller: tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  FakeHadithUnreadPage(controller: controller),
                  FakeHadithReadPage(controller: controller),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: FontSettingsToolbox(
                      controllerToUpdate: controller,
                      showTashkelControllers: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
