import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:muslim/src/features/alarms_manager/data/models/alarm.dart';
import 'package:muslim/src/features/alarms_manager/data/repository/alarm_database_helper.dart';
import 'package:muslim/src/features/alarms_manager/presentation/controller/bloc/alarms_bloc.dart';
import 'package:muslim/src/features/azkar_filters/data/models/zikr_filter.dart';
import 'package:muslim/src/features/azkar_filters/data/models/zikr_filter_list_extension.dart';
import 'package:muslim/src/features/azkar_filters/presentation/controller/cubit/azkar_filters_cubit.dart';
import 'package:muslim/src/features/home/data/models/titles_freq_enum.dart';
import 'package:muslim/src/features/home/data/models/zikr_title.dart';
import 'package:muslim/src/features/home/data/repository/hisn_db_helper.dart';
import 'package:muslim/src/features/settings/data/repository/app_settings_repo.dart';
import 'package:muslim/src/features/zikr_viewer/data/models/zikr_content.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AlarmsBloc alarmsBloc;
  final AzkarFiltersCubit zikrFiltersCubit;
  late final StreamSubscription alarmSubscription;
  late final StreamSubscription filterSubscription;
  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();
  final AlarmDatabaseHelper alarmDatabaseHelper;
  final AppSettingsRepo appSettingsRepo;
  final HisnDBHelper hisnDBHelper;
  HomeBloc(
    this.alarmsBloc,
    this.alarmDatabaseHelper,
    this.hisnDBHelper,
    this.appSettingsRepo,
    this.zikrFiltersCubit,
  ) : super(HomeLoadingState()) {
    alarmSubscription = alarmsBloc.stream.listen(_onAlarmBlocChanged);
    filterSubscription =
        zikrFiltersCubit.stream.listen(_onZikrFilterCubitChanged);

    _initHandlers();
  }
  void _initHandlers() {
    on<HomeStartEvent>(_start);
    on<HomeToggleSearchEvent>(_toggleSearch);

    on<HomeToggleTitleBookmarkEvent>(_bookmarkTitle);
    on<HomeToggleContentBookmarkEvent>(_bookmarkContent);
    on<HomeUpdateBookmarkedContentsEvent>(_updateBookmarkedContents);
    on<HomeUpdateAlarmsEvent>(_updateAlarms);
    on<HomeToggleDrawerEvent>(_toggleDrawer);
    on<HomeDashboardReorderedEvent>(_onDashboardReorded);

    on<HomeToggleFilterEvent>(_onFilterToggled);
    on<HomeFiltersChangeEvent>(_filtersChanged);
  }

  Future<void> _onAlarmBlocChanged(AlarmsState alarmState) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    if (alarmState is! AlarmsLoadedState) return;

    add(HomeUpdateAlarmsEvent(alarms: alarmState.alarms));
  }

  FutureOr<void> _updateAlarms(
    HomeUpdateAlarmsEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    final Map<int, DbAlarm> alarms = {
      for (final alarm in event.alarms) alarm.titleId: alarm,
    };

    emit(state.copyWith(alarms: alarms));
  }

  FutureOr<void> _start(
    HomeStartEvent event,
    Emitter<HomeState> emit,
  ) async {
    final filters = zikrFiltersCubit.state.filters;

    final dbTitles = await hisnDBHelper.getAllTitles();
    final List<DbTitle> filtered = await applyFiltersOnTitels(
      dbTitles,
      zikrFilters: filters,
    );

    final alarms = await alarmDatabaseHelper.getAlarms();

    final azkarFromDB = await hisnDBHelper.getFavouriteContents();
    final filteredAzkar = filters.getFilteredZikr(azkarFromDB);

    emit(
      HomeLoadedState(
        titles: filtered,
        alarms: {for (final alarm in alarms) alarm.titleId: alarm},
        bookmarkedContents: filteredAzkar,
        isSearching: false,
        dashboardArrangement: appSettingsRepo.dashboardArrangement,
        freqFilters: appSettingsRepo.getTitlesFreqFilterStatus,
      ),
    );
  }

  FutureOr<void> _toggleSearch(
    HomeToggleSearchEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    emit(
      state.copyWith(
        isSearching: event.isSearching,
      ),
    );
  }

  FutureOr<void> _bookmarkTitle(
    HomeToggleTitleBookmarkEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    if (event.bookmark) {
      await hisnDBHelper.addTitleToFavourite(dbTitle: event.title);
    } else {
      await hisnDBHelper.deleteTitleFromFavourite(dbTitle: event.title);
    }

    final titles = List<DbTitle>.of(state.titles).map((e) {
      if (e.id == event.title.id) {
        return event.title.copyWith(favourite: event.bookmark);
      }
      return e;
    }).toList();

    emit(state.copyWith(titles: titles));
  }

  FutureOr<void> _bookmarkContent(
    HomeToggleContentBookmarkEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    if (event.bookmark) {
      await hisnDBHelper.addContentToFavourite(dbContent: event.content);
    } else {
      await hisnDBHelper.removeContentFromFavourite(
        dbContent: event.content,
      );
    }

    add(HomeUpdateBookmarkedContentsEvent());
  }

  FutureOr<void> _updateBookmarkedContents(
    HomeUpdateBookmarkedContentsEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    final bookmarkedContents = await hisnDBHelper.getFavouriteContents();
    emit(state.copyWith(bookmarkedContents: bookmarkedContents));
  }

  FutureOr<void> _toggleDrawer(
    HomeToggleDrawerEvent event,
    Emitter<HomeState> emit,
  ) async {
    zoomDrawerController.toggle?.call();
  }

  FutureOr<void> _onDashboardReorded(
    HomeDashboardReorderedEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    final List<int> listToSet = List<int>.from(state.dashboardArrangement);

    int newIndex = event.newIndex;

    if (event.oldIndex < newIndex) {
      newIndex -= 1;
    }
    final int item = listToSet.removeAt(event.oldIndex);
    listToSet.insert(newIndex, item);

    appSettingsRepo.changeDashboardArrangement(listToSet);

    emit(state.copyWith(dashboardArrangement: listToSet));
  }

  @override
  Future<void> close() {
    alarmSubscription.cancel();
    filterSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _onFilterToggled(
    HomeToggleFilterEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    /// Handle freq change
    final List<TitlesFreqEnum> newFreq = List.of(state.freqFilters);
    if (newFreq.contains(event.filter)) {
      newFreq.remove(event.filter);
    } else {
      newFreq.add(event.filter);
    }

    await appSettingsRepo.setTitlesFreqFilterStatus(newFreq);

    emit(
      state.copyWith(
        freqFilters: newFreq,
      ),
    );
  }

  Future<List<DbTitle>> applyFiltersOnTitels(
    List<DbTitle> titles, {
    List<Filter>? zikrFilters,
  }) async {
    final List<DbTitle> titlesToSet = [];

    final List<Filter> filters = zikrFilters ?? zikrFiltersCubit.state.filters;
    for (var i = 0; i < titles.length; i++) {
      final title = titles[i];
      final azkarFromDB =
          await hisnDBHelper.getContentsByTitleId(titleId: title.id);
      final azkarToSet = filters.getFilteredZikr(azkarFromDB);
      if (azkarToSet.isNotEmpty) titlesToSet.add(title);
    }

    return titlesToSet;
  }

  Future<void> _onZikrFilterCubitChanged(AzkarFiltersState state) async {
    add(HomeFiltersChangeEvent(state.filters));
  }

  FutureOr<void> _filtersChanged(
    HomeFiltersChangeEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    final dbTitles = await hisnDBHelper.getAllTitles();
    final List<DbTitle> filtered = await applyFiltersOnTitels(
      dbTitles,
      zikrFilters: event.filters,
    );

    final azkarFromDB = await hisnDBHelper.getFavouriteContents();
    final filteredAzkar = event.filters.getFilteredZikr(azkarFromDB);

    emit(
      state.copyWith(
        titles: filtered,
        bookmarkedContents: filteredAzkar,
      ),
    );
  }
}
