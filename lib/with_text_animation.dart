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
  static const int maxRows = 6;
  final Random _rand = Random();

  late List<List<int>> columns;

  int currentCard = 2;
  int nextCard = 4;

  bool shotActive = false;
  late AnimationController _shotController;
  double shotLeft = 0;
  double shotTop = 0;
  double shotTargetTop = 0;
  int shotColumn = 0;
  int shotValue = 2;

  /// Track merged cells for animation ("col-row")
  Set<String> mergedCells = {};

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
        _placeShot(shotColumn, shotValue);
        shotActive = false;
        _shotController.reset();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _shotController.dispose();
    super.dispose();
  }

  int _randomNumber() {
    const choices = [2, 4, 8, 16, 32, 64];
    return choices[_rand.nextInt(choices.length)];
  }

  void startShotAnimation({
    required double left,
    required double top,
    required double targetTop,
    required int columnIndex,
    required int value,
  }) {
    if (!shotActive) return;
    shotLeft = left;
    shotTop = top;
    shotTargetTop = targetTop;
    shotColumn = columnIndex;
    shotValue = value;

    _shotController.forward(from: 0.0);
    setState(() {});
  }

  void _placeShot(int col, int value) {
    columns[col].add(value);
    int idx = columns[col].length - 1;

    // Vertical merges
    while (idx > 0) {
      final below = columns[col][idx];
      final above = columns[col][idx - 1];
      if (below == above) {
        columns[col][idx - 1] = above * 2;
        columns[col].removeAt(idx);
        idx = idx - 1;
        mergedCells.add("$col-$idx");
      } else {
        break;
      }
    }

    // Horizontal merges + chaining
    bool didSomething = true;
    while (didSomething) {
      didSomething = false;
      if (!(idx >= 0 && idx < columns[col].length)) break;
      final rowVal = columns[col][idx];

      List<int> mergeCols = [col];
      int c = col - 1;
      while (c >= 0) {
        if (columns[c].length > idx && columns[c][idx] == rowVal) {
          mergeCols.insert(0, c);
          c--;
        } else {
          break;
        }
      }
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
        for (final mc in mergeCols) {
          if (mc == col) continue;
          columns[mc].removeAt(idx);
        }
        final newValue = rowVal * mergeCols.length;
        columns[col][idx] = newValue;
        mergedCells.add("$col-$idx");
        didSomething = true;

        // Chain vertical after horizontal
        while (idx > 0) {
          final below2 = columns[col][idx];
          final above2 = columns[col][idx - 1];
          if (below2 == above2) {
            columns[col][idx - 1] = above2 * 2;
            columns[col].removeAt(idx);
            idx = idx - 1;
            mergedCells.add("$col-$idx");
            didSomething = true;
          } else {
            break;
          }
        }
      }
    }

    currentCard = nextCard;
    nextCard = _randomNumber();
  }

  void _restart() {
    setState(() {
      columns = List.generate(columnsCount, (_) => []);
      currentCard = _randomNumber();
      nextCard = _randomNumber();
      shotActive = false;
      mergedCells.clear();
    });
  }

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
        final boardTopPadding = 20.0;
        final boardHeight = constraints.maxHeight * 0.67;
        final cellHeight = boardHeight / maxRows;
        final columnWidth = constraints.maxWidth / columnsCount;

        final shooterSize = min(columnWidth * 0.7, 80.0);
        final shooterLeftPositions = List.generate(
            columnsCount, (i) => (i * columnWidth) + (columnWidth - shooterSize) / 2);

        return Stack(children: [
          // Board
          Positioned(
            top: boardTopPadding,
            left: 0,
            right: 0,
            height: boardHeight,
            child: Row(
              children: List.generate(columnsCount, (col) {
                return GestureDetector(
                  onTap: () {
                    if (shotActive) return;
                    if (columns[col].length >= maxRows) return;
                    setState(() {
                      shotActive = true;
                      shotColumn = col;
                      shotValue = currentCard;
                    });

                    final left = shooterLeftPositions[col];
                    final bottomY = boardTopPadding + boardHeight;
                    final startTop = bottomY - shooterSize - 18;
                    final targetRow = columns[col].length;
                    final targetTop = boardTopPadding + (targetRow * cellHeight) + 8;

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
                                  : TweenAnimationBuilder<double>(
                                      key: ValueKey("$col-$cellIndex-$tileValue"),
                                      tween: Tween<double>(
                                        begin: mergedCells.contains("$col-$cellIndex") ? 1.3 : 1.0,
                                        end: 1.0,
                                      ),
                                      duration: const Duration(milliseconds: 350),
                                      curve: Curves.elasticOut,
                                      onEnd: () {
                                        setState(() {
                                          mergedCells.remove("$col-$cellIndex");
                                        });
                                      },
                                      builder: (context, scale, child) {
                                        return Transform.scale(
                                          scale: scale,
                                          child: Text(
                                            tileValue.toString(),
                                            style: tileTextStyle(tileValue),
                                          ),
                                        );
                                      },
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

          // Flying shot
          if (shotActive)
            AnimatedBuilder(
              animation: _shotController,
              builder: (context, child) {
                final t = _shotController.value;
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

          // Bottom UI
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            height: constraints.maxHeight * 0.24,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Shooter',
                            style: TextStyle(fontSize: 14, color: Colors.white70)),
                        const SizedBox(height: 8),
                        Material(
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
                        const SizedBox(height: 10),
                        const Text('Tap a column to shoot',
                            style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                  ),
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
