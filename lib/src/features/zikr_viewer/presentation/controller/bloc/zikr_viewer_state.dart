// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'zikr_viewer_bloc.dart';

sealed class ZikrViewerState extends Equatable {
  const ZikrViewerState();

  @override
  List<Object> get props => [];
}

final class ZikrViewerLoadingState extends ZikrViewerState {}

class ZikrViewerLoadedState extends ZikrViewerState {
  final DbTitle title;
  final List<DbContent> azkar;
  final List<DbContent> azkarToView;
  final int activeZikrIndex;
  final ZikrViewerMode zikrViewerMode;
  final Map<int, int> restoredSession;

  DbContent? get activeZikr {
    if (azkarToView.isEmpty) return null;
    if (activeZikrIndex == -1) return null;
    return azkarToView[activeZikrIndex];
  }

  double get majorProgress =>
      azkarToView.where((x) => x.count == 0).length / azkarToView.length;

  double get manorProgress =>
      azkarToView.fold(0, (sum, curr) => sum + curr.count) /
      azkar.fold(0, (sum, curr) => sum + curr.count);

  double singleProgress(DbContent content) =>
      content.count / azkar.where((x) => x.id == content.id).first.count;

  const ZikrViewerLoadedState({
    required this.title,
    required this.azkar,
    required this.azkarToView,
    required this.activeZikrIndex,
    required this.zikrViewerMode,
    required this.restoredSession,
  });

  ZikrViewerLoadedState copyWith({
    DbTitle? title,
    List<DbContent>? azkar,
    List<DbContent>? azkarToView,
    int? activeZikrIndex,
    ZikrViewerMode? zikrViewerMode,
    Map<int, int>? restoredSession,
  }) {
    return ZikrViewerLoadedState(
      title: title ?? this.title,
      azkar: azkar ?? this.azkar,
      azkarToView: azkarToView ?? this.azkarToView,
      activeZikrIndex: activeZikrIndex ?? this.activeZikrIndex,
      zikrViewerMode: zikrViewerMode ?? this.zikrViewerMode,
      restoredSession: restoredSession ?? this.restoredSession,
    );
  }

  @override
  List<Object> get props => [
        title,
        azkar,
        azkarToView,
        activeZikrIndex,
        zikrViewerMode,
        restoredSession,
      ];
}
