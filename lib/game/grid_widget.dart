import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_puzzle/game/models.dart';
import '../game/bloc/game_bloc.dart';
import '../game/bloc/game_event.dart';
import '../game/bloc/game_state.dart';
import 'cell_widget.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        final cols = state.config.cols;
        return LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth;
            return SizedBox(
              width: size,
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.grid.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  final cell = state.grid[index];
                  final isSelected = state.selectedIndex == index;
                  final invalid = state.lastOutcome == MatchOutcome.invalid &&
                      isSelected;
                  return CellWidget(
                    cell: cell,
                    isSelected: isSelected,
                    invalid: invalid,
                    onTap: () {
                      context.read<GameBloc>().add(CellTapped(index));
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
