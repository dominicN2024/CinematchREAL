// ignore_for_file: unused_import, library_private_types_in_public_api
import 'dart:convert';
import 'package:cinematch/AdjustGroupPreferences.dart';
import 'package:cinematch/GroupsListPage.dart';
import 'package:cinematch/NewGroupPage.dart';
import 'package:cinematch/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinematch/HomePage.dart';
import 'package:cinematch/EditMemberPage.dart';
import 'package:http/http.dart' as http;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MaterialApp(
    home: const ShowGroupMembersPage(),
    navigatorKey: navigatorKey, // Use the navigatorKey
  ));
}


class ShowGroupMembersPage extends StatefulWidget {
  const ShowGroupMembersPage({Key? key}) : super(key: key);

  @override
  _ShowGroupMembersPageState createState() => _ShowGroupMembersPageState();
}

class _ShowGroupMembersPageState extends State<ShowGroupMembersPage> {
  late Future<void> _fetchmemberNames;
  String selectedUser = '';
  Set<String> groupNames = {};
  Set<String> memberNamesREAL = {};
  Set<String> selectedCustomButtons = {};
  Map<String, Set<String>> userSelectedButtons = {};
  TextEditingController movieController = TextEditingController();
  TextEditingController actorController = TextEditingController();

   @override
    void initState() {
      super.initState();
      _fetchmemberNames = getMembersandGroups();
    }

  Future<void> getMembersandGroups() async {
    groupsList.clear();
    groupNames.clear();
    memberNames.clear();

    String sql = "SELECT user_id FROM user WHERE username = '$username'";
    print(sql);
    String userID = "";
    try {
      List<Map<String, dynamic>>? records = await getUserID(sql);
      if (records.isNotEmpty) {
        var record = records.first;
        if (record.containsKey("user_id") && record["user_id"] != null) {
          userID = record["user_id"].toString();
        }
      }
    } catch (e) {
      print('Error: $e');
    }

    sql = "SELECT name FROM groups WHERE user_id_fk = '$userID'";
    try {
        List<Map<String, dynamic>>? records = await getGroupNames(sql);
        for (var record in records) {
          if (record.containsKey("name") && record["name"] != null) {
            setState(() {
              groupNames.add(record["name"].toString());
            });
          }
        }
      } catch (e) {
        print('Error: $e');
      }
      groupsList.addAll(groupNames);

      sql = "SELECT members FROM groups WHERE user_id_fk = '$userID' AND name != 'UNSORTED'";
      try {
          List<Map<String, dynamic>>? records = await getMemberNames(sql);
          for (var record in records) {
            if (record.containsKey("members") && record["members"] != null) {
              setState(() {
                memberNames.add(record["members"].toString());
              });
            }
          }
        } catch (e) {
          print('Error: $e');
        }

        // Splitting the groupNames string into individual names and adding them to groupsList
      Set<String> temp = {};
      for (String member in memberNames) {
        temp.addAll(member.split(','));
      }
      memberNamesREAL = temp.map((name) => name.replaceAll(RegExp(r'[{}]'), '')).toSet();

      print(memberNamesREAL);

      return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: FutureBuilder(
          future: _fetchmemberNames,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator on top of the gradient background
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              // Display the error message on top of the gradient background
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Once data is loaded, display your page content here
              return buildContent(context); // Assuming buildContent is your method to build the page content
            }
          },
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
      future: _fetchmemberNames,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
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
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
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
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              groupNameToMemberPage,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: Wrap(
                              spacing: 20,
                              children: [
                                for (String element in memberNamesREAL)
                                  Column(
                                    children: [
                                        buildNameRow(element, context),
                                        const SizedBox(
                                          width: 380,
                                          child: MySeparator(),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 24, top: 35),
                                      width: 320,
                                      child: const Text(
                                        "Add More members with a Cinematch Premium Account",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                     Container(
                                      padding: const EdgeInsets.only(left: 24),
                                      height: 100,
                                      width: 320,
                                      child: const DottedLine(
                                        width: 5, // For a horizontal line, this will be the diameter of the dots.
                                        height: 1.0, // For a vertical line, this will be the diameter of the dots.
                                        color: Colors.white, // Color of the dots.
                                        numberOfDots: 40, // Number of dots in the line.
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                        ),
                      ),
                    ),
                    const NavBar(),
                  ],
                ),
              );
            }
          },
        ),
      );
    }
  }

  Widget buildNameRow(String name, context) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 8.0),
    child: Material(
      color: Colors.transparent, // Background color of the Material
      child: InkWell(
        splashColor: Colors.transparent, // Removes the splash effect on tap
        highlightColor: Colors.transparent, // Removes the highlight effect on tap
        onTap: () {
          memberNameToEditPage = name;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditMemberPage(),
              settings: const RouteSettings(name: '/EditMemberPage'),
            ),
          );// This will print the name when the Row or blank space is tapped
        },
        child: Container(
          width: double.infinity, // Ensures the InkWell takes up all available width
          padding: const EdgeInsets.only(right: 8.0), // Padding inside the container
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
              Expanded(
                child: Container(), // Acts as a flexible spacer
              ),
              const Padding(
                padding: EdgeInsets.only(right: 28),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GroupsListPage(),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  'assets/group.svg',
                  height: 48, // Adjust the height as needed
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
    );
  }
}

