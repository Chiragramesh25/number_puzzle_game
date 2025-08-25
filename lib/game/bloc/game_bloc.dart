import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models.dart';
import '../utils.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  Timer? _timer;
  int _idSeq = 0;

  static final levelConfigs = <LevelConfig>[
    const LevelConfig(cols: 9, rows: 9, initialFilledRows: 3, timeLimit: Duration(minutes: 2)),
    const LevelConfig(cols: 9, rows: 9, initialFilledRows: 4, timeLimit: Duration(minutes: 2)),
    const LevelConfig(cols: 9, rows: 10, initialFilledRows: 4, timeLimit: Duration(minutes: 2), rowsToAddPerTap: 2, maxAddableRows: 6),
  ];

  GameBloc() : super(_initialState(1)) {
    on<GameStarted>(_onStarted);
    on<CellTapped>(_onCellTapped);
    on<AddRow>(_onAddRow);
    on<Retry>(_onRetry);
    on<NextLevel>(_onNextLevel);
    on<TimerTicked>(_onTick);
  }

  static GameState _initialState(int level) {
    final cfg = levelConfigs[level - 1];
    final totalCells = cfg.cols * cfg.rows;
    final grid = List<Cell>.generate(totalCells, (i) {
      final r = i ~/ cfg.cols;
      if (r < cfg.initialFilledRows) {
        return Cell(id: i, value: nextNumber());
      }
      return Cell(id: i, value: null);
    });
    return GameState(
      grid: grid,
      config: cfg,
      selectedIndex: null,
      lastOutcome: MatchOutcome.none,
      score: 0,
      level: level,
      isOver: false,
      isWon: false,
      addedRows: 0,
      remaining: cfg.timeLimit,
    );
  }

  void _onStarted(GameStarted event, Emitter<GameState> emit) {
    emit(_initialState(event.level));
    _startTimer(event.level, emit);
  }

  void _startTimer(int level, Emitter<GameState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TimerTicked());
    });
  }

  void _onTick(TimerTicked event, Emitter<GameState> emit) {
    final left = state.remaining - const Duration(seconds: 1);
    if (left <= Duration.zero) {
      emit(state.copyWith(isOver: true, isWon: _checkWin()));
      _timer?.cancel();
    } else {
      emit(state.copyWith(remaining: left));
    }
  }

  void _onCellTapped(CellTapped event, Emitter<GameState> emit) {
    if (state.isOver) return;
    final cell = state.grid[event.index];
    if (cell.value == null || cell.matched) return;

    if (state.selectedIndex == null) {
      final g = [...state.grid];
      g[event.index] = g[event.index].copyWith(highlighted: true);
      emit(state.copyWith(grid: g, selectedIndex: event.index));
      return;
    }

    if (state.selectedIndex == event.index) {
      final g = [...state.grid];
      g[event.index] = g[event.index].copyWith(highlighted: false);
      emit(state.copyWith(grid: g, selectedIndex: null));
      return;
    }

    _attemptMatch(state.selectedIndex!, event.index, emit);
  }

  void _attemptMatch(int a, int b, Emitter<GameState> emit) {
    final ca = state.grid[a];
    final cb = state.grid[b];
    final v1 = ca.value, v2 = cb.value;

    final valid = (v1 == v2 || isTenPair(v1!, v2!)) && _isClearPath(a, b);
    if (valid) {
      final g = [...state.grid];
      g[a] = ca.copyWith(matched: true, highlighted: false);
      g[b] = cb.copyWith(matched: true, highlighted: false);
      emit(state.copyWith(
        grid: g,
        selectedIndex: null,
        lastOutcome: MatchOutcome.valid,
        score: state.score + 2,
      ));
    } else {
      emit(state.copyWith(lastOutcome: MatchOutcome.invalid, selectedIndex: null));
    }
  }

  bool _isClearPath(int a, int b) {
    final cols = state.config.cols;
    final ra = a ~/ cols, ca = a % cols;
    final rb = b ~/ cols, cb = b % cols;
    int dr = rb - ra, dc = cb - ca;
    if (dr != 0) dr ~/= dr.abs();
    if (dc != 0) dc ~/= dc.abs();

    if (!((ra == rb) || (ca == cb) || (rb - ra).abs() == (cb - ca).abs())) return false;

    int r = ra + dr, c = ca + dc;
    while (r != rb || c != cb) {
      final idx = r * cols + c;
      if (state.grid[idx].value != null) return false;
      r += dr; c += dc;
    }
    return true;
  }

  void _onAddRow(AddRow event, Emitter<GameState> emit) {
    if (state.addedRows >= state.config.maxAddableRows) return;
    final cols = state.config.cols;
    final g = [...state.grid];
    final nums = generateSequence(cols);
    int targetRow = -1;
    for (int r = 0; r < state.config.rows; r++) {
      final start = r * cols;
      final row = g.sublist(start, start + cols);
      if (row.any((c) => c.value == null)) {
        targetRow = r;
        break;
      }
    }
    if (targetRow == -1) return;
    final start = targetRow * cols;
    for (int i = 0; i < cols; i++) {
      if (g[start + i].value == null) {
        g[start + i] = g[start + i].copyWith(value: nums[i], matched: false, highlighted: false);
      }
    }
    emit(state.copyWith(grid: g, addedRows: state.addedRows + 1));
  }

  void _onRetry(Retry event, Emitter<GameState> emit) {
    emit(_initialState(state.level));
  }

  void _onNextLevel(NextLevel event, Emitter<GameState> emit) {
    final next = (state.level % levelConfigs.length) + 1;
    emit(_initialState(next));
  }

  bool _checkWin() => state.score >= 20;
}
