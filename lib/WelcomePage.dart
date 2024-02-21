// ignore_for_file: file_names, deprecated_member_use

import 'package:cinematch/NoSwipeBackPageRoute.dart';
import 'package:flutter/material.dart';
import 'package:cinematch/CreateAccountPage.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(
    const MaterialApp(
      home: WelcomePage(),
    ),
  );
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(4, 0, 59, 1),
                  Color.fromRGBO(90, 0, 90, 1),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                        'assets/logoheader.svg',
                        semanticsLabel: 'My SVG Image',
                        height: 55,
                        fit: BoxFit.fitWidth,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 45),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(NoSwipeBackPageRoute(page: const CreateAccountPage()));
                    },
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 100, // Adjust the height as needed
              color: const Color.fromRGBO(6, 0, 60, 1), // Adjust the color as needed
              child: const NavBar(), // Your custom bottom navigation bar widget
            ),
          ),
        ],
      ),
    );
  }
}

