import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim/generated/l10n.dart';
import 'package:muslim/src/core/di/dependency_injection.dart';
import 'package:muslim/src/core/models/editor_result.dart';
import 'package:muslim/src/core/shared/widgets/loading.dart';
import 'package:muslim/src/features/tally/data/models/tally.dart';
import 'package:muslim/src/features/tally/data/models/tally_iteration_mode.dart';
import 'package:muslim/src/features/tally/presentation/components/dialogs/tally_editor.dart';
import 'package:muslim/src/features/tally/presentation/controller/bloc/tally_bloc.dart';
import 'package:muslim/src/features/tally/presentation/screens/tally_counter_view.dart';
import 'package:muslim/src/features/tally/presentation/screens/tally_list_view.dart';

class TallyDashboardScreen extends StatelessWidget {
  const TallyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TallyBloc>()..add(TallyStartEvent()),
      child: BlocBuilder<TallyBloc, TallyState>(
        builder: (context, state) {
          if (state is! TallyLoadedState) {
            return const Loading();
          }
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text(S.of(context).tally),
                centerTitle: true,
                actions: [
                  if (state.activeCounter == null)
                    const SizedBox()
                  else
                    IconButton(
                      tooltip: S.of(context).edit,
                      onPressed: () async {
                        final DbTally dbTally = state.activeCounter!;
                        final EditorResult<DbTally>? result =
                        await showTallyEditorDialog(
                          context: context,
                          dbTally: dbTally,
                        );

                        if (result == null || !context.mounted) return;
                        switch (result.action) {
                          case EditorActionEnum.edit:
                            context.read<TallyBloc>().add(
                              TallyEditCounterEvent(
                                counter: result.value,
                              ),
                            );
                          case EditorActionEnum.delete:
                            context.read<TallyBloc>().add(
                              TallyDeleteCounterEvent(
                                counter: result.value,
                              ),
                            );
                          default:
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  IconButton(
                    tooltip: state.iterationMode.localeName(context),
                    onPressed: () {
                      context
                          .read<TallyBloc>()
                          .add(TallyToggleIterationModeEvent());
                    },
                    icon: Icon(
                      switch (state.iterationMode) {
                        TallyIterationMode.circular => Icons.repeat_rounded,
                        TallyIterationMode.shuffle => Icons.shuffle_rounded,
                        TallyIterationMode.none => Icons.repeat_one_rounded,
                      },
                    ),
                  ),
                ],
                bottom: TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        S.of(context).activeTally,
                      ),
                    ),
                    Tab(
                      child: Text(
                        S.of(context).counters,
                      ),
                    ),
                  ],
                ),
              ),
              resizeToAvoidBottomInset: false,
              body: const TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  TallyCounterView(),
                  TallyListView(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
