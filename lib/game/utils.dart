import 'dart:math';

final _rng = Random();

int nextNumber() => _rng.nextInt(9) + 1;

List<int> generateSequence(int count) =>
    List.generate(count, (_) => nextNumber());

bool isTenPair(int a, int b) => a + b == 10;
