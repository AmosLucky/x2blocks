import 'package:block_app/secondPage.dart';
import 'package:flutter/material.dart';
import 'package:block_app/thirdPage.dart';

import 'homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'X2 Block',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // void _navigateToPage1() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => SplashScreen()),
  //   );
  // }

  void _navigateToPage1() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePageScreen()),
    );
  }

  void _navigateToPage2() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondPageScreen()),
    );
  }

  void _navigateToPage3() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThirdPageScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 150),
        child: Center(
          child: Container(
            child: Column(
              children: [
                const Text(
                  'Welcome to my app!',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _navigateToPage1,
                  child: const Text('Go to First Trial'),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _navigateToPage2,
                  child: const Text('Go to Second Trial'),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _navigateToPage3,
                  child: const Text('Go to Third Trial'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
