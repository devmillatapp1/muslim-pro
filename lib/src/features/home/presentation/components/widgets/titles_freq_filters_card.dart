import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim/src/core/shared/widgets/loading.dart';
import 'package:muslim/src/features/home/data/models/titles_freq_enum.dart';
import 'package:muslim/src/features/home/presentation/controller/bloc/home_bloc.dart';

class TitleFreqFilterCard extends StatelessWidget {
  const TitleFreqFilterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is! HomeLoadedState) {
          return const Loading();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: TitlesFreqEnum.values.map(
            (e) {
              return Padding(
                padding: const EdgeInsets.all(5),
                child: FilterChip(
                  label: Text(e.localeName(context)),
                  selected: state.freqFilters.contains(e),
                  showCheckmark: false,
                  onSelected: (bool value) {
                    context.read<HomeBloc>().add(HomeToggleFilterEvent(e));
                  },
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
