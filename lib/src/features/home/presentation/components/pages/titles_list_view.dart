// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:muslim/src/features/alarms_manager/data/models/alarm.dart';
import 'package:muslim/src/features/home/data/models/zikr_title.dart';
import 'package:muslim/src/features/home/presentation/components/widgets/title_card.dart';

class HomeTitlesListView extends StatelessWidget {
  final List<DbTitle> titles;
  final Map<int, DbAlarm> alarms;
  const HomeTitlesListView({
    super.key,
    required this.titles,
    required this.alarms,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return TitleCard(
          dbTitle: titles[index],
          dbAlarm: alarms[titles[index].id],
        );
      },
      itemCount: titles.length,
    );
  }
}
