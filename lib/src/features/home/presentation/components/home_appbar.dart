// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim/generated/l10n.dart';
import 'package:muslim/src/core/di/dependency_injection.dart';
import 'package:muslim/src/features/home/data/data_source/app_dashboard_tabs.dart';
import 'package:muslim/src/features/home/presentation/controller/bloc/home_bloc.dart';
import 'package:muslim/src/features/home_search/presentation/components/home_search_box.dart';
import 'package:muslim/src/features/home_search/presentation/controller/cubit/search_cubit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeAppBar extends StatelessWidget {
  final TabController tabController;
  const HomeAppBar({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is! HomeLoadedState) {
          return const SizedBox();
        }
        return SliverAppBar(
          leading: !state.isSearching
              ? Padding(
                  padding: const EdgeInsets.all(7),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    fit: BoxFit.cover,
                  ),
                )
              : IconButton(
                  tooltip: S.of(context).close,
                  padding: EdgeInsets.zero,
                  icon: Icon(MdiIcons.close),
                  onPressed: () {
                    context
                        .read<HomeBloc>()
                        .add(const HomeToggleSearchEvent(isSearching: false));
                  },
                ),
          title: !state.isSearching ? null : const HomeSearchBox(),
          pinned: true,
          floating: true,
          snap: true,
          bottom: state.isSearching &
                  context.watch<SearchCubit>().state.searchText.isNotEmpty
              ? null
              : PreferredSize(
                  preferredSize: const Size(0, 48),
                  child: TabBar(
                    controller: tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    tabs: List.generate(
                      appDashboardTabs.length,
                      (index) {
                        return Tab(
                          child: Text(
                            appDashboardTabs[state.dashboardArrangement[index]]
                                .title(context),
                          ),
                        );
                      },
                    ),
                  ),
                ),
          actions: [
            if (!state.isSearching) ...[
              IconButton(
                tooltip: S.of(context).search,
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.search),
                onPressed: () {
                  context
                      .read<HomeBloc>()
                      .add(const HomeToggleSearchEvent(isSearching: true));
                },
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.vertical_split_rounded),
                onPressed: () {
                  sl<HomeBloc>().add(const HomeToggleDrawerEvent());
                },
              ),
            ],
          ],
        );
      },
    );
  }
}
