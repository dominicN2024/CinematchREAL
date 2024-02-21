// ignore_for_file: avoid_print, deprecated_member_use, unused_import, use_key_in_widget_constructors, library_private_types_in_public_api, file_names, annotate_overrides

import 'package:cinematch/AdjustGroupPreferences.dart';
import 'package:cinematch/AllowSwipeBackPageRoute.dart';
import 'package:cinematch/NoSwipeBackPageRoute.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinematch/GroupsListPage.dart';
import 'package:cinematch/RecommendationPage.dart';
import 'package:cinematch/globals.dart';

void main() {

  runApp(
    const MaterialApp(
      home: HomePage(),
    ),
  );
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    late Future<void> _fetchDataFuture;

    void initState() {
      super.initState();
      _fetchDataFuture = loadGroups();
    }

    Future<void> loadGroups() async {
      groupsList.clear();

      username = "guynow";
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
      // userID = "249";
      if (!firstRun) {
        sql = "SELECT name FROM groups WHERE user_id_fk = '$userID' AND name != 'UNSORTED'";
        // print(sql);
        try {
          List<Map<String, dynamic>>? records = await getGroupNames(sql);
          for (var record in records) {
            if (record.containsKey("name") && record["name"] != null) {
              // print("titles found");
              groupsList.add(record["name"].toString());
              // print(record["name"].toString());
            }
          }
        } catch (e) {
          print('Error: $e');
        }
      } else {
        print(groupName);
        groupsList.add(groupName);
      }
      print(groupsList);
      return Future.value();
    }

  Widget build(BuildContext context  ) {
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
        future: _fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator on top of the gradient background
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            // Display the error message on top of the gradient background
            return Center(child: Text('Error: ${snapshot.error}'));
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 80, top: 80, right: 80, bottom: 0),
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
                          Stack(
                            children: [
                              const Positioned(
                                top: 55,
                                left: 27,
                                child: SizedBox(
                                  width: 380,
                                  child: MySeparator(),
                                ),
                              ),
                              ListView.builder(
                                    shrinkWrap: true, // Important when nesting inside another scrollable
                                    physics: const NeverScrollableScrollPhysics(), // Prevents the ListView from scrolling independently
                                    itemCount: groupsList.length,
                                    itemBuilder: (context, index) {
                                      String item = groupsList[index];
                                      return Column(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              onPrimary: Colors.transparent,
                                              primary: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              visualDensity: VisualDensity.compact,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                homeSelectedGroup = groupsList[index];
                                              });
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const RecommendationPage(),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 20),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              const SizedBox(height: 20),
                                                const SizedBox(
                                                  width: 380,
                                                  child: MySeparator(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // This SizedBox acts as a separator between items, so it's included inside the itemBuilder
                                        ],
                                      );
                                    },
                                  ),
                                ],
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
              SvgPicture.asset(
                'assets/home.svg',
                height: 48, // Adjust the height as needed
                color: Colors.white,
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