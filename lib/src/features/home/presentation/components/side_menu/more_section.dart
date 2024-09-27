import 'package:flutter/material.dart';
import 'package:muslim/generated/l10n.dart';
import 'package:muslim/src/core/extensions/extension.dart';
import 'package:muslim/src/core/functions/open_url.dart';
import 'package:muslim/src/core/utils/email_manager.dart';
import 'package:muslim/src/core/values/constant.dart';
import 'package:muslim/src/features/about/presentation/screens/about_screen.dart';
import 'package:muslim/src/features/home/presentation/components/side_menu/shared.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MoreSection extends StatelessWidget {
  const MoreSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DrawerCard(
          child: ListTile(
            leading: Icon(MdiIcons.gmail),
            title: Text(S.of(context).contactDev),
            onTap: () {
              EmailManager.messageUS();
            },
          ),
        ),
        DrawerCard(
          child: ListTile(
            leading: Icon(MdiIcons.web),
            title: Text(S.of(context).moreApps),
            onTap: () {
              openURL(kOrgWebsite);
            },
          ),
        ),
        DrawerCard(
          child: ListTile(
            leading: const Icon(Icons.info),
            title: Text(S.of(context).aboutUs),
            onTap: () {
              context.push(
                const AboutScreen(),
              );
            },
          ),
        ),
      ],
    );
  }
}
