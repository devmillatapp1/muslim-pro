import 'package:flutter/material.dart';
import 'package:muslim/generated/l10n.dart';
import 'package:muslim/src/core/extensions/extension_platform.dart';
import 'package:muslim/src/core/values/constant.dart';
import 'package:muslim/src/features/home/presentation/components/side_menu/toggle_brightness_btn.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                S.of(context).ElmoslemProApp,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "${S.of(context).version}: $kAppVersion",
                  ),
                  if (!PlatformExtension.isDesktop)
                    const ToggleBrightnessButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
