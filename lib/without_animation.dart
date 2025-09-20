// lib/main.dart
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const X2BlockShooter());
}

class X2BlockShooter extends StatelessWidget {
  const X2BlockShooter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'x2 Block Shooter - Row Merge',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1724),
        useMaterial3: true,
      ),
      home: const GamePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  static const int columnsCount = 5;
  static const int maxRows = 6; // max stack height per column
  final Random _rand = Random();

  // Each column holds a list where index 0 is top-most cell.
  late List<List<int>> columns;

  // Current card to shoot (bottom card)
  int currentCard = 2;
  int nextCard = 4;

  // Shot animation state
  bool shotActive = false;
  late AnimationController _shotController;
  double shotLeft = 0;
  double shotTop = 0;
  double shotTargetTop = 0;
  int shotColumn = 0;
  int shotValue = 2;

  @override
  void initState() {
    super.initState();
    columns = List.generate(columnsCount, (_) => []);
    currentCard = _randomNumber();
    nextCard = _randomNumber();
    _shotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _shotController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Place and merge logic after shot finishes
        _placeShot(shotColumn, shotValue);
        shotActive = false;
        _shotController.reset();
        setState(() {}); // update
      }
    });
  }

  @override
  void dispose() {
    _shotController.dispose();
    super.dispose();
  }

  int _randomNumber() {
    // pick from 2,4,8,16,32,64 - you can tweak distribution
    const choices = [2, 4, 8, 16, 32, 64];
    return choices[_rand.nextInt(choices.length)];
  }

  // Start shot animation with provided coordinates (called from layout with accurate positions)
  void startShotAnimation({
    required double left,
    required double top,
    required double targetTop,
    required int columnIndex,
    required int value,
  }) {
    if (shotActive == false) {
      // If shotActive was false, the call ordering was off. We don't proceed.
      return;
    }
    shotLeft = left;
    shotTop = top;
    shotTargetTop = targetTop;
    shotColumn = columnIndex;
    shotValue = value;

    // animate by moving a Positioned widget from shotTop to shotTargetTop
    _shotController.forward(from: 0.0);
    setState(() {});
  }

  // Place shot into column and resolve merges (vertical + horizontal row merges + chaining)
  void _placeShot(int col, int value) {
    // 1) Place at bottom of the column
    columns[col].add(value); // placed under existing tiles

    // idx = placed index (bottom-most position before merges)
    int idx = columns[col].length - 1;

    // 2) First resolve vertical merges in this column (merge upward)
    while (idx > 0) {
      final below = columns[col][idx];
      final above = columns[col][idx - 1];
      if (below == above) {
        // merge into above cell (index-1)
        columns[col][idx - 1] = above * 2;
        // remove the below tile (idx)
        columns[col].removeAt(idx);
        // after merging, the surviving tile is now at idx-1
        idx = idx - 1;
      } else {
        break;
      }
    }

    // 3) Now check horizontal (row) merges and allow chaining with vertical merges.
    bool didSomething = true;
    while (didSomething) {
      didSomething = false;

      // Ensure the tile still exists at idx (it might not if something removed it)
      if (!(idx >= 0 && idx < columns[col].length)) break;
      final rowVal = columns[col][idx];

      // find contiguous same-valued tiles in the same row across columns
      List<int> mergeCols = [col];

      // scan left
      int c = col - 1;
      while (c >= 0) {
        if (columns[c].length > idx && columns[c][idx] == rowVal) {
          mergeCols.insert(0, c);
          c--;
        } else {
          break;
        }
      }
      // scan right
      c = col + 1;
      while (c < columnsCount) {
        if (columns[c].length > idx && columns[c][idx] == rowVal) {
          mergeCols.add(c);
          c++;
        } else {
          break;
        }
      }

      if (mergeCols.length > 1) {
        // we have a horizontal merge across mergeCols
        // remove all merged tiles except the one in 'col' (placed column)
        for (final mc in mergeCols) {
          if (mc == col) continue;
          // safe to remove at idx because we confirmed columns[mc].length > idx
          columns[mc].removeAt(idx);
        }

        // combine values: we choose to multiply by mergeCols.length (you can change rule to *2)
        final newValue = rowVal * mergeCols.length;
        columns[col][idx] = newValue;
        didSomething = true;

        // After a horizontal merge, vertical merges in this column might now be possible again.
        while (idx > 0) {
          final below2 = columns[col][idx];
          final above2 = columns[col][idx - 1];
          if (below2 == above2) {
            columns[col][idx - 1] = above2 * 2;
            columns[col].removeAt(idx);
            idx = idx - 1;
            // a vertical merge happened — we should loop again to check horizontal merges for new idx
            didSomething = true;
          } else {
            break;
          }
        }
      }
    }

    // generate next current / next cards
    currentCard = nextCard;
    nextCard = _randomNumber();
  }

  void _restart() {
    setState(() {
      columns = List.generate(columnsCount, (_) => []);
      currentCard = _randomNumber();
      nextCard = _randomNumber();
      shotActive = false;
    });
  }

  // color mapping for numbers
  Color tileColor(int n) {
    switch (n) {
      case 2:
        return const Color(0xFFe8f3ff);
      case 4:
        return const Color(0xFFc8e6ff);
      case 8:
        return const Color(0xFFffd6a5);
      case 16:
        return const Color(0xFFffd080);
      case 32:
        return const Color(0xFFffb86b);
      case 64:
        return const Color(0xFFFF8A65);
      case 128:
        return const Color(0xFFFFAB91);
      case 256:
        return const Color(0xFFFFCC80);
      case 512:
        return const Color(0xFFFFF59D);
      case 1024:
        return const Color(0xFFB39DDB);
      default:
        return const Color(0xFF90CAF9);
    }
  }

  TextStyle tileTextStyle(int n) {
    return TextStyle(
      fontSize: n < 100 ? 22 : 16,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }

  @override
  Widget build(BuildContext context) {
    // main layout: top board (grid of columns), bottom shooter + next + controls
    return Scaffold(
      appBar: AppBar(
        title: const Text('x2 Block Shooter'),
        actions: [
          IconButton(
            onPressed: _restart,
            icon: const Icon(Icons.refresh),
            tooltip: 'Restart',
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        // We'll compute sizes for cells
        final boardTopPadding = 20.0;
        final boardHeight = constraints.maxHeight * 0.67;
        final cellHeight = boardHeight / maxRows;
        final columnWidth = constraints.maxWidth / columnsCount;

        // Coordinates for shooter (bottom card)
        final shooterSize = min(columnWidth * 0.7, 80.0);
        final shooterLeftPositions = List.generate(
            columnsCount, (i) => (i * columnWidth) + (columnWidth - shooterSize) / 2);

        return Stack(children: [
          // Board area
          Positioned(
            top: boardTopPadding,
            left: 0,
            right: 0,
            height: boardHeight,
            child: Row(
              children: List.generate(columnsCount, (col) {
                // Each column is a column of cells from top (index 0) to bottom (maxRows-1)
                return GestureDetector(
                  onTap: () {
                    if (shotActive) return;
                    if (columns[col].length >= maxRows) {
                      // Column full, ignore tap
                      return;
                    }
                    // Start shot animation: compute shotLeft & targetTop using layout values
                    setState(() {
                      shotActive = true;
                      shotColumn = col;
                      shotValue = currentCard;
                    });

                    // coordinates for animation
                    final left = shooterLeftPositions[col];
                    final bottomY = boardTopPadding + boardHeight; // bottom of board in screen coordinates
                    final startTop = bottomY - shooterSize - 18; // some offset above bottom UI
                    final targetRow = columns[col].length; // placed under existing tiles
                    final targetTop = boardTopPadding + (targetRow * cellHeight) + 8;

                    // start animation
                    startShotAnimation(
                      left: left,
                      top: startTop,
                      targetTop: targetTop,
                      columnIndex: col,
                      value: currentCard,
                    );
                  },
                  child: Container(
                    width: columnWidth,
                    height: boardHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Column(
                      children: List.generate(maxRows, (r) {
                        // for display, index 0 is top, so map to columns[col][r] if exists
                        final cellIndex = r;
                        final hasTile = cellIndex < columns[col].length;
                        final tileValue = hasTile ? columns[col][cellIndex] : null;
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: tileValue == null
                                  ? const Color(0xFF061022)
                                  : tileColor(tileValue),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Center(
                              child: tileValue == null
                                  ? const SizedBox.shrink()
                                  : Text(
                                      tileValue.toString(),
                                      style: tileTextStyle(tileValue),
                                    ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Animated shot tile (positioned above bottom area, moves to targetTop)
          if (shotActive)
            AnimatedBuilder(
              animation: _shotController,
              builder: (context, child) {
                final t = _shotController.value;
                // ease-out curve
                final progress = Curves.easeOut.transform(t);
                final curTop = shotTop + (shotTargetTop - shotTop) * progress;
                final left = shooterLeftPositions[shotColumn];
                return Positioned(
                  left: left,
                  top: curTop,
                  width: shooterSize,
                  height: shooterSize,
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: tileColor(shotValue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          shotValue.toString(),
                          style: tileTextStyle(shotValue),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          // Bottom UI: current shooter card, next card, instructions
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            height: constraints.maxHeight * 0.24,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Current shooter (tap columns to shoot)
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Shooter',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            // optionally allow tap to shuffle current card
                            setState(() {
                              currentCard = _randomNumber();
                            });
                          },
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: shooterSize,
                              height: shooterSize,
                              decoration: BoxDecoration(
                                color: tileColor(currentCard),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  currentCard.toString(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Tap a column to shoot',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),

                  // Next card preview
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Next', style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 8),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: tileColor(nextCard),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              nextCard.toString(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Controls
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _restart,
                          icon: const Icon(Icons.restart_alt),
                          label: const Text('Restart'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Quick cheat: add a random tile on a random column
                            final c = _rand.nextInt(columnsCount);
                            if (columns[c].length < maxRows) {
                              setState(() {
                                columns[c].add(_randomNumber());
                              });
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Tile'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);
      }),
    );
  }
}
