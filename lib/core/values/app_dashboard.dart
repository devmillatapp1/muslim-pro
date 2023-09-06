import 'package:get/get.dart';
import "package:muslim/app/data/models/models.dart";
import 'package:muslim/app/views/dashboard/pages/bookmarks.dart';
import 'package:muslim/app/views/dashboard/pages/favorite_zikr.dart';
import 'package:muslim/app/views/dashboard/pages/fehrs.dart';

final List<AppComponent> appDashboardItem = [
  AppComponent(
    title: "index".tr,
    widget: const AzkarFehrs(),
  ),
  AppComponent(
    title: "favourites content".tr,
    widget: const AzkarBookmarks(),
  ),
  AppComponent(
    title: "favourites zikr".tr,
    widget: const FavouriteZikr(),
  ),
];
