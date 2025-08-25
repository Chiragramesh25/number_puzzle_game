# number_puzzle_game
***
A Flutter puzzle game inspired by Number Master, built with BLoC state management.
Match numbers that are equal or sum to 10, with path-clearing rules.
No Tutorials, No Login/Signups -> Direct Gameplay....
***
To run this game on your system--->>
--------------------------------
git clone https://github.com/yourusername/number_master_flutter.git
cd number_master_flutter
flutter pub get
flutter run.

All the file structure you can understand it in the repository section. I've made it simple, not very complex at all.

**RULES**

-Pairs:
  Tap two numbers to form a pair.
  Valid if:
  Numbers are equal
  OR they add up to 10
  They must be connectable by a straight line (horizontal, vertical, diagonal) without other numbers in between.
-Matched cells:
  Do not disappear.
  They fade and turn grey, staying as placeholders.
-Add Row:
  Use the “+” button to insert a new row when you get stuck.
  Limited per level.
-Retry:
  Restart the current level with the Retry button below the grid.
-Levels:
  Each level has a 2-minute timer.
  Clear enough pairs before the timer runs out to unlock the next stage.
