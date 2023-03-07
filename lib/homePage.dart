import 'dart:ui';

import 'package:flutter/material.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  static const String _title = 'X2 Block';

  @override
  Widget build(BuildContext context) {
    int count = 5;
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int count = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2.4, crossAxisCount: 4),
              itemCount: count,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.primaries[index % 10],
                  child: Center(
                    child: Text('$index'),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 80,
            width: 250,
            alignment: Alignment.topCenter,
            child: Container(
              height: 45,
              width: 150,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onPressed: () {
                  setState(() {
                    count++;
                  });
                },
                color: Colors.redAccent,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    )
        // Column(children: [
        //   GridView.builder(
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 4),
        //     itemCount: count,
        //     itemBuilder: (BuildContext context, int index) {
        //       return Card(
        //         color: Colors.primaries[index % 10],
        //         child: Center(child: Text('$index')),
        //       );
        //     },
        //   ),
        //   GestureDetector(
        //     onTap: () {
        //       setState(() {
        //         count++;
        //       });
        //     },
        //     child: const Icon(Icons.add),
        //   ),
        // ]),
        );
  }
}
