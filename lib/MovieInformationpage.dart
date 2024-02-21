// ignore_for_file: file_names, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cinematch/globals.dart';
import 'package:flutter_svg/svg.dart';

void main() => runApp(const MovieInformationPage());

class MovieInformationPage extends StatefulWidget {
  const MovieInformationPage({Key? key}) : super(key: key);

  @override
  _MovieInformationPageState createState() => _MovieInformationPageState();
}

class _MovieInformationPageState extends State<MovieInformationPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 80, top: 80, right: 80),
          child: Center(
            child: SvgPicture.asset(
              'assets/logoheader.svg',
              semanticsLabel: 'My SVG Image',
              height: 80,
              fit: BoxFit.fitWidth,
              color: Colors.white,
            ),
          ),
        ),
        Center(
          child: Text(
            homeSelectedGroup,
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontFamily: 'Palatino',
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.only(left: 28),
          child: const Text(
            'Here are your matches!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(left: 28),
            child: const Text(
              'Adjust Preferences',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
        const SizedBox(height: 20),
      ],
    ),
    );
  }
}