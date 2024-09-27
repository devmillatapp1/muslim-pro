// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'tally_bloc.dart';

sealed class TallyEvent extends Equatable {
  const TallyEvent();

  @override
  List<Object> get props => [];
}

class TallyStartEvent extends TallyEvent {}

class TallyAddCounterEvent extends TallyEvent {
  final DbTally counter;

  const TallyAddCounterEvent({required this.counter});

  @override
  List<Object> get props => [counter];
}

class TallyEditCounterEvent extends TallyEvent {
  final DbTally counter;
  final Completer? completer;
  const TallyEditCounterEvent({
    required this.counter,
    this.completer,
  });

  @override
  List<Object> get props => [counter];
}

class TallyDeleteCounterEvent extends TallyEvent {
  final DbTally counter;
  const TallyDeleteCounterEvent({
    required this.counter,
  });

  @override
  List<Object> get props => [counter];
}

class TallyToggleCounterActivationEvent extends TallyEvent {
  final DbTally counter;
  final bool activate;
  const TallyToggleCounterActivationEvent({
    required this.counter,
    required this.activate,
  });

  @override
  List<Object> get props => [counter, activate];
}

class TallyNextCounterEvent extends TallyEvent {}

class TallyPreviousCounterEvent extends TallyEvent {}

class TallyRandomCounterEvent extends TallyEvent {}

class TallyResetAllCountersEvent extends TallyEvent {}

class TallyResetActiveCounterEvent extends TallyEvent {}

class TallyIncreaseActiveCounterEvent extends TallyEvent {}

class TallyDecreaseActiveCounterEvent extends TallyEvent {}

class TallyToggleIterationModeEvent extends TallyEvent {}

class TallyIterateEvent extends TallyEvent {}
