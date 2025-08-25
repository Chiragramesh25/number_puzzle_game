import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/game_bloc.dart';
import 'bloc/game_event.dart';
import 'bloc/game_state.dart';
import 'grid_widget.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C0033), // dark starry background
      body: SafeArea(
        child: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            final bloc = context.read<GameBloc>();

            return Column(
              children: [
                // ===== Top Bar =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Stage info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Stage", style: _labelStyle()),
                          Text("${state.level}", style: _valueStyle()),
                        ],
                      ),
                      // Score big in center
                      Text(
                        "${state.score}",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                      ),
                      // Trophy & settings
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.emoji_events, color: Colors.white, size: 20),
                              const SizedBox(width: 4),
                              Text("48", style: _valueStyle()),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ===== Grid =====
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const GridWidget(),
                    ),
                  ),
                ),

                // ===== Retry Button =====
Padding(
  padding: const EdgeInsets.only(top: 8, bottom: 4),
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurpleAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
    onPressed: () => context.read<GameBloc>().add(Retry()),
    icon: const Icon(Icons.refresh),
    label: const Text(
      "Retry",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
),

                // ===== Bottom Controls =====
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _roundButton(
                        icon: Icons.add,
                        count: 6,
                        onTap: () => bloc.add(AddRow()),
                      ),
                      _roundButton(
                        icon: Icons.lightbulb,
                        count: 3,
                        onTap: () {
                          // implement hint logic later
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static Widget _roundButton({required IconData icon, required int count, required VoidCallback onTap}) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
        ),
        if (count > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                "$count",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  static TextStyle _labelStyle() => const TextStyle(color: Colors.white70, fontSize: 14);
  static TextStyle _valueStyle() => const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
}
