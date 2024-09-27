import 'package:flutter/material.dart';
import 'package:muslim/generated/l10n.dart';
import 'package:muslim/src/core/di/dependency_injection.dart';
import 'package:muslim/src/features/home/presentation/components/side_menu/shared.dart';
import 'package:muslim/src/features/home/presentation/controller/bloc/home_bloc.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DrawerCard(
            child: ListTile(
              leading: const Icon(Icons.close),
              title: Text(S.of(context).close),
              onTap: () {
                sl<HomeBloc>().add(const HomeToggleDrawerEvent());
              },
            ),
          ),
        ],
      ),
    );
  }
}
