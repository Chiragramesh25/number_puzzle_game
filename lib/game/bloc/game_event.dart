import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GameStarted extends GameEvent {
  final int level;
  GameStarted({required this.level});
}

class CellTapped extends GameEvent {
  final int index;
  CellTapped(this.index);
}

class AddRow extends GameEvent {}

class Retry extends GameEvent {}

class NextLevel extends GameEvent {}

class TimerTicked extends GameEvent {}
