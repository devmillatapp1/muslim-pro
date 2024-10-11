import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim/generated/l10n.dart';
import 'package:muslim/src/core/models/editor_result.dart';
import 'package:muslim/src/core/shared/dialogs/yes_no_dialog.dart';
import 'package:muslim/src/core/shared/widgets/loading.dart';
import 'package:muslim/src/features/tally/data/models/tally.dart';
import 'package:muslim/src/features/tally/presentation/components/dialogs/tally_editor.dart';
import 'package:muslim/src/features/tally/presentation/components/tally_card.dart';
import 'package:muslim/src/features/tally/presentation/controller/bloc/tally_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TallyListView extends StatelessWidget {
  const TallyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TallyBloc, TallyState>(
      builder: (context, state) {
        if (state is! TallyLoadedState) {
          return const Loading();
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: state.allCounters.length,
            itemBuilder: (context, index) {
              return TallyCard(dbTally: state.allCounters[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(height: 0);
            },
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: "add",
                tooltip: S.of(context).add,
                child: Icon(
                  MdiIcons.plus,
                  size: 40,
                ),
                onPressed: () async {
                  final EditorResult<DbTally>? result =
                  await showTallyEditorDialog(
                    context: context,
                  );

                  if (result == null || !context.mounted) return;

                  context
                      .read<TallyBloc>()
                      .add(TallyAddCounterEvent(counter: result.value));
                },
              ),
              FloatingActionButton(
                heroTag: "reset",
                tooltip: S.of(context).reset,
                child: const Icon(
                  Icons.restart_alt,
                  size: 40,
                ),
                onPressed: () async {
                  final bool? confirm = await showDialog(
                    context: context,
                    builder: (_) {
                      return YesOrNoDialog(
                        msg: S.of(context).resetAllCounters,
                      );
                    },
                  );

                  if (confirm == null || !confirm || !context.mounted) {
                    return;
                  }
                  context.read<TallyBloc>().add(TallyResetAllCountersEvent());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
