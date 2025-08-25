import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_puzzle/game/bloc/game_event.dart';
import 'game/bloc/game_bloc.dart';
import 'game/game_page.dart';

void main() {
  runApp(const NumberMasterApp());
}

class NumberMasterApp extends StatelessWidget {
  const NumberMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Master (BLoC)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C4DFF)),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => GameBloc()..add(GameStarted(level: 1)),
        child: const GamePage(),
      ),
    );
  }
}
