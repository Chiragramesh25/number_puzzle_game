import 'package:flutter/material.dart';

enum MatchOutcome { none, valid, invalid }

@immutable
class Cell {
  final int? value; 
  final bool matched;
  final bool highlighted;
  final int id;

  const Cell({
    required this.id,
    required this.value,
    this.matched = false,
    this.highlighted = false,
  });

  Cell copyWith({int? value, bool? matched, bool? highlighted}) {
    return Cell(
      id: id,
      value: value ?? this.value,
      matched: matched ?? this.matched,
      highlighted: highlighted ?? this.highlighted,
    );
  }
}

@immutable
class LevelConfig {
  final int cols;
  final int rows;
  final int initialFilledRows;
  final Duration timeLimit;
  final int rowsToAddPerTap;
  final int maxAddableRows;

  const LevelConfig({
    required this.cols,
    required this.rows,
    required this.initialFilledRows,
    required this.timeLimit,
    this.rowsToAddPerTap = 1,
    this.maxAddableRows = 4,
  });
}
