// ignore_for_file: file_names, unused_import

import 'dart:collection';
import 'package:cinematch/CreateGroupPage.dart';
import 'package:cinematch/CreateNewMemberPage.dart';
import 'package:cinematch/NewGroupPage.dart';
import 'package:cinematch/NoSwipeBackPageRoute.dart';
import 'package:cinematch/queryCommand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinematch/SelectServicesPage.dart';
import 'package:cinematch/HomePage.dart';
import 'package:cinematch/globals.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;


void main() {
  runApp(
    const MaterialApp(
      home: NewGroupMemberListPage(),
    ),
  );
}

class NewGroupMemberListPage extends StatefulWidget {
  const NewGroupMemberListPage({Key? key}) : super(key: key);

  @override
  _NewGroupMemberListPageState createState() => _NewGroupMemberListPageState();
}

class _NewGroupMemberListPageState extends State<NewGroupMemberListPage> {


  @override
void initState() {
  super.initState();
}

@override
void dispose() {
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Stack(
      children: [
        SingleChildScrollView(
          child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 80.0, left: 80, right: 80, bottom: 25),
                  child: SvgPicture.asset(
                    'assets/logoheader.svg',
                    semanticsLabel: 'My SVG Image',
                    height: 80,
                    fit: BoxFit.fitWidth,
                    color: Colors.white,
                  ),
                ),
                for (String element in memberNamesREAL)
              Column(
                children: [
                    SizedBox(
                    child: addMemberButton(element, false, context),
                    ), // Call your function for each iteration
                    const SizedBox(
                      width: 340,
                      child: MySeparator(),
                    ),
                  // const SizedBox(height: 20), // Add spacing after each DropdownButton
                ],
              ),
              addMemberButton("Add Member", true, context),
              Container(
                padding: const EdgeInsets.only(left: 44),
                child: const SizedBox(
                  width: 340,
                  child: MySeparator(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(top: 60, right: 28),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewGroupPage(),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 700),
              ],
            ),
          ),
        ),
        const NavBar()
      ],
    ),
    );
  }
    Widget addMemberButton(String name, bool isAddButton, BuildContext context) {
    bool isMemberAdded = newGroupMembers.contains(name);

    return GestureDetector(
      onTap: () {
        if (isAddButton) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateNewMemberPage(),
            ),
          );
        } else {
          setState(() { // Make sure to call this in a Stateful Widget to update the UI
            if (isMemberAdded) {
              newGroupMembers.remove(name);
            } else {
              newGroupMembers.add(name);
            }
          });
          print(newGroupMembers);
        }
      },
      child: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.transparent, // Adjust the color to match your theme
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Use spaceBetween to align items
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              Icon(
                isMemberAdded ? Icons.remove : Icons.add, // Change icon based on condition
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;

  const MySeparator({Key? key, this.height = 1.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        return Container(
          width: boxWidth,
          height: height,
          color: Colors.white, // Use a solid color
        );
      },
    );
  }
}


class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          // padding: EdgeInsets.only(bottom: 20),
          height: 100,
          color: const Color.fromRGBO(6, 0, 60, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                  child: SvgPicture.asset(
                  'assets/home.svg',
                  height: 48, // Adjust the height as needed
                  color: Colors.white,
                ),
              ),
              SvgPicture.asset(
                'assets/profile.svg',
                height: 48, // Adjust the height as needed
                color: Colors.white,
              ),
              // Add more SVG assets as needed
              SvgPicture.asset(
                  'assets/group.svg',
                  height: 48, // Adjust the height as needed
                  color: Colors.white,
                ),
            ],
          ),
        ),
    );
  }
}
