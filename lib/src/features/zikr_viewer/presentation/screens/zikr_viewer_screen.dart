import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim/generated/l10n.dart';
import 'package:muslim/src/core/di/dependency_injection.dart';
import 'package:muslim/src/core/extensions/extension_object.dart';
import 'package:muslim/src/core/extensions/extension_platform.dart';
import 'package:muslim/src/core/shared/dialogs/yes_no_dialog.dart';
import 'package:muslim/src/core/shared/widgets/font_settings.dart';
import 'package:muslim/src/core/shared/widgets/loading.dart';
import 'package:muslim/src/features/home/presentation/components/side_menu/toggle_brightness_btn.dart';
import 'package:muslim/src/features/settings/data/repository/app_settings_repo.dart';
import 'package:muslim/src/features/zikr_viewer/data/models/zikr_viewer_mode.dart';
import 'package:muslim/src/features/zikr_viewer/presentation/components/zikr_viewer_card_builder.dart';
import 'package:muslim/src/features/zikr_viewer/presentation/components/zikr_viewer_page_builder.dart';
import 'package:muslim/src/features/zikr_viewer/presentation/components/zikr_viewer_page_mode_bottom_bar.dart';
import 'package:muslim/src/features/zikr_viewer/presentation/components/zikr_viewer_progress_bar.dart';
import 'package:muslim/src/features/zikr_viewer/presentation/components/zikr_viewer_top_bar.dart';
import 'package:muslim/src/features/zikr_viewer/presentation/controller/bloc/zikr_viewer_bloc.dart';

part 'zikr_viewer_card_mode_screen.dart';
part 'zikr_viewer_page_mode_screen.dart';

class ZikrViewerScreen extends StatelessWidget {
  final int index;

  const ZikrViewerScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ZikrViewerBloc>()
        ..add(
          ZikrViewerStartEvent(
            titleIndex: index,
            zikrViewerMode: sl<AppSettingsRepo>().isCardReadMode
                ? ZikrViewerMode.card
                : ZikrViewerMode.page,
          ),
        ),
      child: BlocConsumer<ZikrViewerBloc, ZikrViewerState>(
        listener: (context, state) async {
          if (state is! ZikrViewerLoadedState) return;

          final restoredSession = state.restoredSession;
          if (restoredSession.isEmpty) return;

          final bool? confirm = await showDialog(
            context: context,
            builder: (context) {
              return YesOrNoDialog(
                msg: S.of(context).zikrViewerRestoreSessionMsg,
              );
            },
          );

          if (!context.mounted) return;

          context
              .read<ZikrViewerBloc>()
              .add(ZikrViewerRestoreSessionEvent(confirm ?? false));
        },
        builder: (context, state) {
          if (state is! ZikrViewerLoadedState) {
            return const Loading();
          }

          switch (state.zikrViewerMode) {
            case ZikrViewerMode.page:
              return const _ZikrViewerPageModeScreen();

            case ZikrViewerMode.card:
              return const _ZikrViewerCardModeScreen();
          }
        },
      ),
    );
  }
}
