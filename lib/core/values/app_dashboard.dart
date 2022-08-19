import 'package:muslim/app/data/models/app_component.dart';
import 'package:muslim/app/views/dashboard/pages/bookmarks.dart';
import 'package:muslim/app/views/dashboard/pages/favorite_zikr.dart';
import 'package:muslim/app/views/dashboard/pages/fehrs.dart';

final List<AppComponent> appDashboardItem = [
  AppComponent(
    title: "الفهرس",
    widget: const AzkarFehrs(),
  ),
  AppComponent(
    title: "المفضلة",
    widget: const AzkarBookmarks(),
  ),
  AppComponent(
    title: "مفضلة الأذكار",
    widget: const FavouriteZikr(),
  ),
];
