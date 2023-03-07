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
  List zim = [];

  int generate() {
    Random rand = Random();
    List arr = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024];
    int i = rand.nextInt(10) + 0;
    zim.add(arr[i]);
    zim.removeAt(0);
    setState(() {});
    return arr[i];
  }

  insertAtPosition(int column, int num) {
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
    zim = [generate(), generate()];
    generate();
    // TODO: implement initState
    super.initState();
  }

  Color returnColor(int i) {
    switch (i) {
      case 2:
        return Colors.greenAccent;
      case 4:
        return Colors.amber;
      case 8:
        return Colors.grey;
      case 16:
        return Colors.blue;
      case 32:
        return Colors.redAccent;
      case 64:
        return Colors.pinkAccent;
      case 128:
        return Colors.indigo;
      case 256:
        return Colors.yellowAccent;
      case 512:
        return Colors.orangeAccent;
      case 1024:
        return Colors.amberAccent;
      default:
        return Colors.black;
    }
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
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                int column = index % matrix.length;
                int row = index ~/ matrix.length;
                return matrix[column][row] != 0
                    ? Card(
                        elevation: 9,
                        color: returnColor(matrix[column][row]),
                        child: Center(
                          child: Text(matrix[column][row].toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ))
                    : Container();
              },
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(0, zim[0]);
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
                        insertAtPosition(1, zim[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.green.withOpacity(0.2),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(2, zim[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.amber.withOpacity(0.2),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(3, zim[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(4, zim[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.orangeAccent.withOpacity(0.2),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(5, zim[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(6, zim[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.greenAccent.withOpacity(0.2),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(7, zim[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(8, zim[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.greenAccent.withOpacity(0.2),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(9, zim[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.orangeAccent.withOpacity(0.2),
                      ),
                    )),
                  ],
                ),
                Container(
                  color: Colors.grey.withOpacity(0.5),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          child: Container(
                              decoration: BoxDecoration(

                                  /// border: Border.all(),
                                  color: returnColor(zim[0])),
                              height: 50,
                              width: 50,
                              child: Center(
                                  child: Text(
                                zim[0].toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ))),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Card(
                          child: Container(
                              decoration: BoxDecoration(
                                  //border: Border.all(),
                                  color: returnColor(zim[1])),
                              height: 30,
                              width: 30,
                              child: Center(
                                  child: Text(
                                zim[1].toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ))),
                        ),
                      ]),
                )
              ],
            ),
          ],
        )));
  }
}
