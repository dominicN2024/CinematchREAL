// ignore_for_file: unused_local_variable, file_names, library_private_types_in_public_api, avoid_print, deprecated_member_use, unused_import

import 'dart:convert';
import 'package:cinematch/AdjustGroupPreferences.dart';
import 'package:cinematch/AllowSwipeBackPageRoute.dart';
import 'package:cinematch/EditMemberPage.dart';
import 'package:cinematch/NewGroupPage.dart';
import 'package:cinematch/ShowGroupMembersPage.dart';
import 'package:cinematch/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinematch/HomePage.dart';
import 'package:cinematch/CreateNewMemberPage.dart';
import 'package:http/http.dart' as http;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MaterialApp(
    home: const GroupsListPage(),
    navigatorKey: navigatorKey, // Use the navigatorKey
  ));
}


class GroupsListPage extends StatefulWidget {
  const GroupsListPage({Key? key}) : super(key: key);

  @override
  _GroupsListPage createState() => _GroupsListPage();
}

class _GroupsListPage extends State<GroupsListPage> {
  Set<String> groupNames = {};
  late Future<void> _fetchMembersandGroups;

  void initState() {
    super.initState();
    _fetchMembersandGroups = getMembersandGroups();
  }

  Future<void> getMembersandGroups() async {
    groupsList.clear();
    groupNames.clear();
    memberNames.clear();
    String sql = "SELECT user_id FROM user WHERE username = '$username'";
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

  sql = "SELECT group_id FROM groups WHERE user_id_fk = '$userID' AND name = 'UNSORTED'";
  String unsortedGroupID = "";
  try {
        List<Map<String, dynamic>>? records = await getGroupID(sql);
        if (records.isNotEmpty) {
          var record = records.first;
          if (record.containsKey("group_id") && record["group_id"] != null) {
            unsortedGroupID = record["group_id"].toString();
          }
        }
      } catch (e) {
        print('Error: $e');
      }

      sql = "SELECT name FROM groups WHERE user_id_fk = '$userID' AND name != 'UNSORTED'";
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


      sql = "SELECT members FROM groups WHERE user_id_fk = '$userID' AND group_id != '$unsortedGroupID'";
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

      Set<String> unsortedMemberName = {};
      sql = "SELECT members FROM groups WHERE user_id_fk = '$userID' AND group_id = '$unsortedGroupID'";
      try {
          List<Map<String, dynamic>>? records = await getMemberNames(sql);
          for (var record in records) {
            if (record.containsKey("members") && record["members"] != null) {
              setState(() {
                unsortedMemberName.add(record["members"].toString());
              });
            }
          }
        } catch (e) {
          print('Error: $e');
        }

        memberNamesREAL.addAll(memberNames);
        if (!unsortedMemberName.contains("EMPTY")) {
          unsortedMemberName.map((e) => e.replaceAll(RegExp(r' '), ''));
          unsortedMemberName = unsortedMemberName.map((name) => name.replaceAll(RegExp(r'[{}]'), '')).toSet();
          List<String> items = unsortedMemberName.first.split(",");
          for (var name in items) {
            if (name.isNotEmpty) {
              memberNamesREAL.add(name.replaceAll(',', ''));
            }
          }
        }
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
        future: _fetchMembersandGroups,
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
      future: _fetchMembersandGroups,
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
                          const SizedBox(height: 10),
                          Column(                  
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  "Groups",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontFamily: 'Palatino',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.only(left: 24),
                              child: const SizedBox(
                              width: 380,
                              child: MySeparator(),
                            ),
                          ),
                          for (String element in groupNames)
                            Column(
                              children: [
                                displayGroups(element, true), // Call your function for each iteration
                                const SizedBox(
                                  width: 380,
                                  child: MySeparator(),
                                ),
                                // const SizedBox(height: 20), // Add spacing after each DropdownButton
                              ],
                            ),
                          displayAdd(true, context),
                          Container(
                            padding: const EdgeInsets.only(left: 24),
                            child: const SizedBox(   
                                width: 380,
                                child: MySeparator(),
                              ),
                            ),
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.only(left:28),
                            width: 270,
                            child: const Text(
                              'Upgrade to Premium to create more groups',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Center(
                          child: Text(
                            "Members",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontFamily: 'Palatino',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                        padding: const EdgeInsets.only(left: 24),
                        child: const SizedBox(   
                            width: 380,
                            child: MySeparator(),
                          ),
                        ),
                        for (String element in memberNamesREAL)
                          Column(
                            children: [
                              displayGroups(element, false), // Call your function for each iteration
                                const SizedBox(
                                  width: 380,
                                  child: MySeparator(),
                                ),
                              // const SizedBox(height: 20), // Add spacing after each DropdownButton
                            ],
                          ),
                          displayAdd(false, context),
                          Container(
                            padding: const EdgeInsets.only(left: 24),
                            child: const SizedBox(   
                                width: 380,
                                child: MySeparator(),
                              ),
                            ),
                          const SizedBox(height: 20),

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


  Widget displayAdd(bool group, context) {
    return GestureDetector(
      onTap: () {
        if (group) {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewGroupPage(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateNewMemberPage(),
            ),
          );
        }
      },
      child: Container(
        // Adding a minimum height or padding ensures the GestureDetector has a tangible area to detect taps on.
        padding: const EdgeInsets.all(20), // This adds space around the text and separators that is also tappable.
        width: double.infinity, // Match the width of the separators to keep everything aligned.
        color: Colors.transparent, // This makes the container itself invisible, but still tappable.
        child: Column(
          children: [
            // const MySeparator(),
            // const SizedBox(height: 20),
            Center(
              child: Text(
                group ? "+ Group" : "+ Member",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
            // const SizedBox(height: 20),
            // const MySeparator(),
          ],
        ),
      ),
    );
  }

  Widget displayGroups(String text, bool group) {
    return GestureDetector( 
      onTap: () {
        
        if (group) {
          groupNameToMemberPage = text;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ShowGroupMembersPage(),
            ),
          );
        } else {
          memberNameToEditPage = text;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditMemberPage(),
            ),
          );
        }
      },
      child: Container(
        // Adding a minimum height or padding ensures the GestureDetector has a tangible area to detect taps on.
        padding: const EdgeInsets.all(20), // This adds space around the text and separators that is also tappable.
        width: double.infinity, // Match the width of the separators to keep everything aligned.
        color: Colors.transparent, // This makes the container itself invisible, but still tappable.
        child: Column(
          children: [
            // const MySeparator(),
            // const SizedBox(height: 20),
            Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
            // const SizedBox(height: 20),
            // const MySeparator(),
          ],
        ),
      ),
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

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 200, // Set a width constraint for the parent container
      child: MySeparator(),
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
