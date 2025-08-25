import 'package:flutter/material.dart';
import 'package:number_puzzle/game/models.dart';


class CellWidget extends StatelessWidget {
  final Cell cell;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool invalid;

  const CellWidget({
    super.key,
    required this.cell,
    required this.onTap,
    this.isSelected = false,
    this.invalid = false,
  });

  static const numberColors = {
    1: Colors.white,
    2: Colors.cyan,
    3: Colors.orange,
    4: Colors.pink,
    5: Colors.lightGreen,
    6: Colors.redAccent,
    7: Colors.deepOrange,
    8: Colors.lightBlue,
    9: Colors.purpleAccent,
  };

  @override
  Widget build(BuildContext context) {
    // If matched → faded grey background + dimmed number
    final faded = cell.matched;

    return GestureDetector(
      onTap: cell.value == null ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Colors.yellow
                : faded
                    ? Colors.grey.shade700
                    : Colors.white24,
            width: isSelected ? 2 : 0.5,
          ),
          color: faded ? Colors.grey.shade900.withOpacity(0.6) : Colors.transparent,
        ),
        child: AnimatedOpacity(
          opacity: faded ? 0.4 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            cell.value?.toString() ?? '',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: faded
                  ? Colors.grey.shade400
                  : numberColors[cell.value] ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
