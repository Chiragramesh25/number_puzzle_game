import 'package:equatable/equatable.dart';
import '../models.dart';

class GameState extends Equatable {
  final List<Cell> grid;
  final LevelConfig config;
  final int? selectedIndex;
  final MatchOutcome lastOutcome;
  final int score;
  final int level;
  final bool isOver;
  final bool isWon;
  final int addedRows;
  final Duration remaining;

  const GameState({
    required this.grid,
    required this.config,
    required this.selectedIndex,
    required this.lastOutcome,
    required this.score,
    required this.level,
    required this.isOver,
    required this.isWon,
    required this.addedRows,
    required this.remaining,
  });

  GameState copyWith({
    List<Cell>? grid,
    LevelConfig? config,
    int? selectedIndex,
    MatchOutcome? lastOutcome,
    int? score,
    int? level,
    bool? isOver,
    bool? isWon,
    int? addedRows,
    Duration? remaining,
  }) {
    return GameState(
      grid: grid ?? this.grid,
      config: config ?? this.config,
      selectedIndex: selectedIndex,
      lastOutcome: lastOutcome ?? this.lastOutcome,
      score: score ?? this.score,
      level: level ?? this.level,
      isOver: isOver ?? this.isOver,
      isWon: isWon ?? this.isWon,
      addedRows: addedRows ?? this.addedRows,
      remaining: remaining ?? this.remaining,
    );
  }

  @override
  List<Object?> get props =>
      [grid, config, selectedIndex, lastOutcome, score, level, isOver, isWon, addedRows, remaining];
}
