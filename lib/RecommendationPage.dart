// ignore_for_file: avoid_print, unused_import, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, unused_local_variable, file_names, deprecated_member_use, unnecessary_null_comparison, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:math';
import 'package:cinematch/AdjustGroupPreferences.dart';
import 'package:cinematch/queryCommand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinematch/GroupsListPage.dart';
import 'package:cinematch/globals.dart';
import 'package:http/http.dart' as http;
  

void main() {
  runApp(
    const MaterialApp(
      home: RecommendationPage(),
    ),
  );
}

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({Key? key}) : super(key: key);

  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  String recommSQL = ""; 
  late ScrollController _scrollController;
  late Future<void> _fetchDataFuture;
  List<String> titles = []; // Assuming these are the lists to be filled with data
  List<String> rating = [];
  List<String> duration = [];
  List<String> posters = [];
  int _currentOffset = 0;
  final int _limit = 3; // Initial fetch size, assuming you want 3 movies initially
  bool _isLoadingMore = false; // To prevent duplicate fetches

  @override
    void initState() {
      super.initState();
      _fetchDataFuture = getMovieRecommendation();
      _scrollController = ScrollController();
      _scrollController.addListener(_scrollListener); // Add the scroll listener
    }

    @override
    void dispose() {
      _scrollController.dispose(); // Dispose the controller
      super.dispose();
    }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 800 && !_isLoadingMore) {
      // Call your method to load more movies here
      print("loading");
      loadMoreMovies();
    }
  }


    void loadMoreMovies() async {
    if (_isLoadingMore) return;
    // print("loading more");
    _isLoadingMore = true;

    // Update SQL query for fetching more movies
    String newSQL = addOffsetLimit(recommSQL);
    // Prepare to fetch the next set of movies
    // print(newSQL);
    // Ensure your SQL query within `displayMovies` or similar method uses the updated `_currentOffset`
    List<Map<String, dynamic>>? newRecords = await fetchData2(newSQL);
    List<String> tempTitles = [];

    if (newRecords != null && newRecords.isNotEmpty) {
      for (var record in newRecords) {
        tempTitles.add(record['title']);
      }
    }

    List<String> tempPosters =  await fetchPosterUrls(tempTitles);
    
    if (newRecords != null && newRecords.isNotEmpty) {
      setState(() {
        // Assuming you have lists for titles, ratings, etc., and each record contains those fields
        for (var record in newRecords) {
          titles.add(record['title']);
          rating.add(record['rating']);
          duration.add(record['duration']);
        }
        for (var poster in tempPosters) {
          posters.add(poster);
        }
  // Update offset for the next fetch
      });
    }

  _isLoadingMore = false;
}


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
        future: _fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator on top of the gradient background
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            // Display the error message on top of the gradient background
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
              return _buildContent();
            }
          },
        ),
        ),
    );
  }

    Widget _buildContent() {
    // print([titles.length, rating.length, duration.length, posters.length].reduce(min));
    return Column(
      children: [
        _buildTopSection(),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: [titles.length, rating.length, duration.length, posters.length].reduce(min), // Ensure this matches your data list's length)
            itemBuilder: (ctx, index) {
              return buildMovieRow(index);
            },
          ),
        ),
        const NavBar(),
      ],
    );
  }

  Widget _buildTopSection() {
    return Column(
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
        GestureDetector(
          onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdjustGroupPreferences(),
            ),
          );
          },
          child: Container(
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
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildMovieRow(int index) {
    if (index < titles.length && index < rating.length && index < duration.length) {
    return Container(
      color: Colors.transparent, // Set your desired background color here
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: SizedBox(
              width: 231,
              height: 294,
              child: Image.network(
                posters[index],
                fit: BoxFit.cover, // This will cover the entire SizedBox, cropping as needed
              ),
            )
          ),
          const SizedBox(width: 8),
          Expanded( // Wrap Column with Expanded
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, right: 15),
                  child: Text(
                    titles[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Palatino',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 44, top: 20),
                  child: Text(
                    rating[index], // Make sure this is not a constant string
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, .8),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 44, top: 20),
                  child: Text(
                    duration[index],
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, .8),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  } else {
    // Return a fallback or empty widget if the index is out of bound
    // print("Title length: " + titles.length.toString());
    // print("rating length: " + rating.length.toString());
    // print("duration length: " + duration.length.toString());
    // print("posters length: " + posters.length.toString());
    // print("index: " + index.toString());
    return Container(child: const Text("okay", style: TextStyle(color: Colors.white)));
  }
}



  Future<void> getMovieRecommendation() async {
    Query query = Query();
    recommSQL = "";
    try {
      List<String> preferences = await recommendationQueries("preferences");
      List<String> actorPreferences = await recommendationQueries("actor_preference");
      List<String> mpaaratings = await recommendationQueries("mpaaratings");

      // Flattening and trimming the preferences list
      List<String> result = [];
      for (int i = 0; i < preferences.length; i++) {
        result.addAll(preferences[i].split(', ').map((g) => g.trim()));
      }

      // Constructing the SQL query
      recommSQL = "SELECT * FROM netflixTitles WHERE ";
      List<String> conditions = [];

      // Adding conditions for genres
      for (String genre in result) {
        conditions.add("listed_in LIKE '%$genre%'");
      }

      // Mandatory country condition
      conditions.add("country = 'United States'");

      // Adding conditions for actors
      for (String actor in actorPreferences) {
        conditions.add("cast LIKE '%$actor%'");
      }

      // Joining conditions with 'OR'
      recommSQL += conditions.join(' OR ');

      // Adding ORDER BY clause to prioritize by number of matching genres
      recommSQL += " ORDER BY (" + conditions.map((condition) => "($condition)").join(" + ") + ") DESC";

      // Limiting the results
      String newSQL = addOffsetLimit(recommSQL);

      // print(sql);

      // Execute the SQL query or use it as needed
      displayMovies(newSQL);
    } catch (e) {
      // Handle exceptions
      print("Error: $e");
    }
    return Future.value();
  }

  String addOffsetLimit(String sql) {
    _currentOffset += 3;
    sql += " LIMIT $_limit OFFSET $_currentOffset";
    return sql;
  }

  Future<void> displayMovies(String sql) async {
    try {
      // print(sql);
      // String sql = "SELECT * FROM netflixTitles WHERE listed_in LIKE '%Crime%' OR listed_in LIKE '%Mystery%' OR listed_in LIKE '%Action & Adventure%' OR listed_in LIKE '%Romance%' OR listed_in LIKE '%Comedies%' OR listed_in LIKE '%Dramas%' OR listed_in LIKE '%Horror%' OR listed_in LIKE '%Romance%' OR listed_in LIKE '%Family%' OR country = 'United States' OR cast LIKE '%Ryan Gosling%' OR cast LIKE '%Ryan Gosling%' ORDER BY ((listed_in LIKE '%Crime%') + (listed_in LIKE '%Mystery%') + (listed_in LIKE '%Action & Adventure%') + (listed_in LIKE '%Romance%') + (listed_in LIKE '%Comedies%') + (listed_in LIKE '%Dramas%') + (listed_in LIKE '%Horror%') + (listed_in LIKE '%Romance%') + (listed_in LIKE '%Family%') + (country = 'United States') + (cast LIKE '%Ryan Gosling%') + (cast LIKE '%Ryan Gosling%')) DESC LIMIT 5";
      List<Map<String, dynamic>>? records = await fetchData2(sql); // Assuming fetchData2 returns a nullable list
      // print("records after");

      // Check if records is null
      if (records == null) {
        print("No records found");
        return; // Early return if records is null
      }

      // Prepare lists to populate
      List<String> tempTitles = [];
      List<String> tempRating = [];
      List<String> tempDuration = [];

      for (var record in records) {
        if (record.containsKey("title") && record["title"] != null) {
          // print("titles found");
          tempTitles.add(record["title"].toString());
        }
        if (record.containsKey("rating") && record["rating"] != null) {
          // print("rating found");
          tempRating.add(record["rating"].toString());
          // print("tempRating $tempRating");
        }
        if (record.containsKey("duration") && record["duration"] != null) {
          // print("duration found");
          tempDuration.add(record["duration"].toString());
        }
      }


      List<String> tempPosters = await fetchPosterUrls(tempTitles);

    // Now update the state
    if (mounted) {
      setState(() {
        titles = tempTitles;
        rating = tempRating;
        duration = tempDuration;
        posters = tempPosters; // Assuming you have a posters list in your state
      });
    }
  } catch (e) {
    print('Error NO: $e');
  }
}
}

  Future<List<String>> fetchPosterUrls(List<String> titles) async {
    List<String> posterUrls = [];
    for (String title in titles) {
      String posterUrl = await fetchPosterUrlForTitle(title);
      posterUrls.add(posterUrl);
    }
    return posterUrls;
  }

Future<String> fetchPosterUrlForTitle(String title) async {
  // Replace with your API key
  String apiKey = '2a3e160a';
  String url = 'http://www.omdbapi.com/?t=$title&apikey=$apiKey';

  // Make HTTP request to OMDB API (you need http package for this)
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    // print(data);
    return data['Poster']; // Get poster URL from the response
  } else {
    // Handle the case when the movie is not found or any other error
    return '/Users/dev/Desktop/CineMatch/cinematch/lib/assets/imagenotfound.png'; // return a default poster URL or handle this case appropriately
  }
}

  Future<List<String>> recommendationQueries(String selectable) async {
    List<String> array = [];
    Query query = Query();
    String sqlCommand = "SELECT m.$selectable FROM members m JOIN groups g ON m.group_id_fk = g.group_id WHERE g.group_id = '$groupIddb'";
    try {
      List<dynamic> result = await query.executeSql(sqlCommand);
      if (result.isNotEmpty) {
        // print("not empty");
        for (var record in result) {
          String value = record[selectable]; // Extract the value directly
          array.addAll(value.split(',').map((item) => item.trim())); // Split and trim if there are multiple values
        }
      } else {
        print("Empty result");
      }
    } catch (e) {
      print("Error: $e");
    }
    return array;
  }

  // Other methods like recommendationQueries, fetchData2, etc., go here...

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 100,
        color: const Color.fromRGBO(6, 0, 60, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              'assets/home.svg',
              height: 48,
              color: Colors.white,
            ),
            SvgPicture.asset(
              'assets/profile.svg',
              height: 48,
              color: Colors.white,
            ),
            GestureDetector(
              onTap: () {
                // Add your navigation logic here
              },
              child: SvgPicture.asset(
                'assets/group.svg',
                height: 48,
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
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.white),
              ),
            );
          }),
        );
      },
    );
  }
}