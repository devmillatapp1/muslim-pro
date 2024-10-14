import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:muslim/generated/l10n.dart';
import 'package:muslim/src/core/functions/open_url.dart';
import 'package:muslim/src/core/shared/widgets/empty.dart';
import 'package:muslim/src/core/utils/volume_button_manager.dart';
import 'package:muslim/src/core/values/constant.dart';
import 'package:muslim/src/features/settings/data/repository/app_settings_repo.dart';

part 'onboard_state.dart';

class OnboardCubit extends Cubit<OnboardState> {
  final AppSettingsRepo appSettingsRepo;
  final VolumeButtonManager volumeButtonManager;
  PageController pageController = PageController();
  OnboardCubit(this.appSettingsRepo, this.volumeButtonManager)
      : super(OnboardLoadingState()) {
    _init();
  }

  void _init() {
    volumeButtonManager.toggleActivation(activate: true);
    volumeButtonManager.listen(
      onVolumeDownPressed: () {
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      },
      onVolumeUpPressed: () {
        pageController.previousPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      },
    );

    pageController.addListener(
          () {
        final int index = pageController.page!.round();
        onPageChanged(index);
      },
    );
  }

  ///TODO: Change every release
  List<Empty> get pageData {
    return [
//       const Empty(
//         title: "المسلم برو الإصدار $kAppVersion",
//         description: '''
// السلام عليكم أيها الكريم
// أهلا بك في تحديث جديد من المسلم برو
// قم بسحب الشاشة لتقليب الصفحات
// أو استخدم مفاتيح الصوت لرؤية الميزات الجديدة
// ''',
//       ),
      const Empty(
        title: "إصدار ثانوي محسن",
        isImage: false,
        icon: Icons.new_releases,
        description: """
- ⚙️ التحكم في نافذة استعادة جلسة الذكر: من الإعدادات.
- 🔕 إمكانية حذف التنبيهات: مباشرة من المحرر عبر الضغط المطوّل على أيقونة الجرس.
- 🧮 حذف عدادات السبحة: يمكنك الآن حذفها مباشرة من المحرر.
- 📝 تحسين نظام تصفية الأذكار: المأخوذة من "موطأ مالك".
- 🌅 حل مشكلة اختفاء الذكر الأخير: في أذكار الصباح والمساء عند تفعيل تصفية مصادر الأذكار.
- 🛠️ إصلاح مشكلة تعطل التطبيق: عند عدم منح الأذونات الخاصة بالإشعارات.
""",
      ),
      const Empty(
        title: "التحسينات",
        isImage: false,
        icon: Icons.more_horiz,
        description: """
- 📿 تحسين على السبحة  
- ➡️ إمكانية الانتقال للذكر التالي حتى بعد انتهاء الذكر  
- 🔍 صفحة البحث عن الأبواب  
- 💳 تحسين بطاقات وشكل السبحة  
- ❤️ بطاقات الذكر المفضل على الواجهة  
- ✨ تفعيل المؤثرات لبطاقات الذكر المفضل على الواجهة  
- 📱 تحسين النوافذ المنبثقة  
- ✍️ تحسين عناصر الإدخال  
- 🔒 تعطيل رؤية التطبيق بعد قفل الشاشة
""",
      ),
      const Empty(
        title: "الأعطال التي تم حلها",
        isImage: false,
        icon: Icons.bug_report_outlined,
        description: """
- 🔔 إصلاح مشكلة عداد الإشعارات  
- ⏰ إصلاح مشكلة الانتقال لذكر آخر عند الضغط على منبه لذكر معين  
- 📝 تصويب خطأ إملائي "أعناقكم"
""",
      ),
      Empty(
        title: "المزيد من تطبيقاتنا",
        isImage: false,
        icon: MdiIcons.web,
        description: """
يمكنك دائما الإطلاع على المزيد من تطبيقاتنا
ومشاركة الرابط مع أصدقائك 
تم إضافة زر جديد للقائمة الجانبية في الواجهة
""",
        buttonText: S.current.moreApps,
        onButtonCLick: () {
          openURL(kOrgWebsite);
        },
      ),
    ];
  }

  Future start() async {
    emit(
      OnboardLoadedState(
        showSkipBtn: false,
        currentPageIndex: 0,
        pages: pageData,
      ),
    );
  }

  Future onPageChanged(int index) async {
    final state = this.state;
    if (state is! OnboardLoadedState) return;
    emit(state.copyWith(currentPageIndex: index));
  }

  Future done() async {
    await appSettingsRepo.changCurrentVersion(value: kAppVersion);
    volumeButtonManager.dispose();
    emit(OnboardDoneState());
  }

  @override
  Future<void> close() {
    pageController.dispose();
    volumeButtonManager.dispose();
    return super.close();
  }
}
