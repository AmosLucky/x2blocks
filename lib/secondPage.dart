import 'dart:math';
import 'dart:ui';

import 'package:block_app/homePage.dart';
import 'package:flutter/material.dart';

class SecondPageScreen extends StatefulWidget {
  SecondPageScreen({Key? key}) : super(key: key);

  static const String _title = 'Second Trial';

  @override
  State<SecondPageScreen> createState() => _SecondPageScreenState();
}

class _SecondPageScreenState extends State<SecondPageScreen> {
  List<List> matrix = [
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
  ];

  int num = 1;
  List sponge = [];

  int generate() {
    Random rand = Random();
    List arr = [2, 4, 8, 16, 32, 64];
    int i = rand.nextInt(6) + 0;
    //setState(() {
    // num = arr[i];
    // });
    sponge.add(arr[i]);
    sponge.removeAt(0);
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
    sponge = [generate(), generate()];
    generate();

    // TODO: implement initState
    super.initState();
  }

  Color returnColor(int i) {
    switch (i) {
      case 2:
        return Colors.lightBlue;
      case 4:
        return Colors.green;
      case 8:
        return Colors.pink;
      case 16:
        return Colors.amber;
      case 32:
        return Colors.indigo;
      case 64:
        return Colors.black;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Second trial")),
        body: Container(
            child: Stack(
          children: [
            GridView.builder(
              itemCount: matrix.length * matrix.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 6,
              ),
              itemBuilder: (BuildContext context, int index) {
                int column = index % matrix.length;
                int row = index ~/ matrix.length;
                return matrix[column][row] != 0
                    ? Card(
                        elevation: 5,
                        color: returnColor(matrix[column][row]),
                        child: Center(
                            child: Text(
                          matrix[column][row].toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                      )
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
                        insertAtPosition(0, sponge[0]);
                      },
                      child: Container(
                        height: 500,
                        width: MediaQuery.of(context).size.width / 4,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(1, sponge[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.green.withOpacity(0.2),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(2, sponge[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(3, sponge[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.green.withOpacity(0.2),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(4, sponge[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        insertAtPosition(5, sponge[0]);
                      },
                      child: Container(
                        height: 500,
                        color: Colors.green.withOpacity(0.2),
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
                                  color: returnColor(sponge[0])),
                              height: 50,
                              width: 50,
                              child: Center(
                                  child: Text(
                                sponge[0].toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ))),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Card(
                          child: Container(
                              decoration: BoxDecoration(
                                  //border: Border.all(),
                                  color: returnColor(sponge[1])),
                              height: 30,
                              width: 30,
                              child: Center(
                                  child: Text(
                                sponge[1].toString(),
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
