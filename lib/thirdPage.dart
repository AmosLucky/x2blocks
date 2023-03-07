import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:block_app/main.dart';
import 'package:block_app/homePage.dart';

class ThirdPageScreen extends StatefulWidget {
  ThirdPageScreen({Key? key}) : super(key: key);

  static const String _title = 'Third Trial';

  @override
  State<ThirdPageScreen> createState() => _ThirdPageScreenState();
}

class _ThirdPageScreenState extends State<ThirdPageScreen> {
  List<List> matrix = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  ];

  int num = 1;

  void generate() {
    Random rand = Random();
    setState(() {
      num = rand.nextInt(100);
    });
  }

  void insertAtPosition(int column, int num) {
    for (int i = 0; i < matrix[column].length; i++) {
      if (matrix[column][i] == 0) {
        setState(() {
          matrix[column][i] = num;
        });
        print(matrix);
        generate();
        return;
      }
    }
  }

  @override
  void initState() {
    generate();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(num.toString())),
        body: Container(
            child: Stack(
          children: [
            GridView.builder(
              itemCount: matrix.length * matrix.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                crossAxisCount: 10,
              ),
              itemBuilder: (BuildContext ctx, int index) {
                int column = index % matrix.length;
                int row = index ~/ matrix.length;
                return matrix[column][row] != 0
                    ? Container(
                        color: Colors.red,
                        child:
                            Center(child: Text(matrix[column][row].toString())),
                      )
                    : Container();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    insertAtPosition(0, num);
                  },
                  child: Container(
                    height: 500,
                    width: MediaQuery.of(context).size.width / 4,
                    color: Colors.amber.withOpacity(0.2),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    insertAtPosition(1, num);
                  },
                  child: Container(
                    height: 500,
                    color: Colors.green.withOpacity(0.2),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    insertAtPosition(2, num);
                  },
                  child: Container(
                    height: 500,
                    color: Colors.amber.withOpacity(0.2),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    insertAtPosition(3, num);
                  },
                  child: Container(
                    height: 500,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    insertAtPosition(4, num);
                  },
                  child: Container(
                    height: 500,
                    color: Colors.orangeAccent.withOpacity(0.2),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    insertAtPosition(5, num);
                  },
                  child: Container(
                    height: 500,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    insertAtPosition(6, num);
                  },
                  child: Container(
                    height: 500,
                    color: Colors.greenAccent.withOpacity(0.2),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    insertAtPosition(7, num);
                  },
                  child: Container(
                    height: 500,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    insertAtPosition(8, num);
                  },
                  child: Container(
                    height: 500,
                    color: Colors.greenAccent.withOpacity(0.2),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    insertAtPosition(9, num);
                  },
                  child: Container(
                    height: 500,
                    color: Colors.orangeAccent.withOpacity(0.2),
                  ),
                )),
              ],
            ),
          ],
        )));
  }
}
