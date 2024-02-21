// ignore_for_file: unused_import

import 'dart:collection';
import 'package:cinematch/queryCommand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinematch/SelectServicesPage.dart';
import 'package:cinematch/HomePage.dart';
import 'package:cinematch/globals.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String name = "";
bool CreatingNewMemberForGroup = false;
Set<String> memberNamesREAL = {};
Set<String> newGroupMembers = {};
String groupNameToMemberPage = "";
String newGroupName = '';
String memberNameToEditPage = "";
bool firstRun = false;
String groupIddb = "";
String userIddb = "";
String username = "";
String initialgroupName = "";
String password = "";
// New Group
String groupName = "";
bool isSubmitted = false;
bool wrongPassword = false;
bool usernameExist = false;
List<String> groupsList = [];
List<String> titles = [];
List<String> rating = [];
List<String> duration = [];
String homeSelectedGroup = "";
Set<String> services = {};
Set<String> memberNames = {};
Set<String> selectedButtons = {};
Set<String> allRatingButtons = {};
Set<String> selectedRatingButtons = {};
Map<String, Set<String>> userPreferences = {};
Map<String, String> userMoviePreferences = {};
Map<String, String> userActorsPreferences = {};


List<String> removeCharacters(List<String> inputList, String charactersToRemove) {
  List<String> modifiedList = List.from(inputList); // Create a copy of the input list

  for (int i = 0; i < modifiedList.length; i++) {
    for (int j = 0; j < charactersToRemove.length; j++) {
      modifiedList[i] = modifiedList[i].replaceAll(charactersToRemove[j], '');
    }
  }

  return modifiedList;
}

List<int> extractNumbers(String inputString) {
  // Define a regular expression to match numbers
  RegExp regex = RegExp(r'\d+');

  // Find all matches in the input string
  Iterable<RegExpMatch> matches = regex.allMatches(inputString);

  // Extract and parse numbers from matches
  List<int> numbers = matches.map((match) => int.parse(match.group(0)!)).toList();

  return numbers;
}

String removeCharactersString(String inputString, String charactersToRemove) {
  return inputString.replaceAll(RegExp('[$charactersToRemove]'), '');
}

List<String> extractValues(List<String> inputList) {
  List<String> values = [];

  for (String inputString in inputList) {
    // Extract values between square brackets
    RegExp regExp = RegExp(r'\[([^)]+)\]');
    Iterable<RegExpMatch> matches = regExp.allMatches(inputString);

    for (RegExpMatch match in matches) {
      String matchValue = match.group(1)!;
      values.addAll(matchValue.split(',').map((e) => e.trim()));
    }
  }

  return values;
}

List<String> removeDuplicates(List<String> inputList) {
  Set<String> uniqueValuesSet = Set<String>.from(inputList);
  return List<String>.from(uniqueValuesSet);
}

Future<List<Map<String, dynamic>>> fetchData(String sqlCommand) async {
  var url = 'https://dominicn2024.smtchs.org/cinematch/retrievedata.php';
  var response = await http.post(
    Uri.parse(url),
    body: {'sql': sqlCommand},
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success']) {
      List<dynamic> data = jsonResponse['data'];
      List<Map<String, dynamic>> records = [];

      for (var record in data) {
        // Assuming each record is a Map
        Map<String, dynamic> recordMap = {};
        record.forEach((key, value) {
          recordMap[key] = value;
        });
        records.add(recordMap);
      }
      return records;
    } else {
      throw Exception('Error fetching data: ${jsonResponse['message']}');
    }
  } else {
    throw Exception('Server error: ${response.statusCode}');
  }
}

Future<List<Map<String, dynamic>>> fetchData2(String sqlCommand) async {
  var url = Uri.parse('https://dominicn2024.smtchs.org/cinematch/getMovieRecommendation.php');
  var response = await http.post(url, body: {'sql': sqlCommand});

  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}'); // Log the raw response body

  if (response.statusCode == 200 && response.body.isNotEmpty) {
    var jsonResponse = json.decode(response.body);
    // print('Response: $jsonResponse'); // Debugging

    if (jsonResponse['success'] == true) {
      List<dynamic>? data = jsonResponse['data'] as List<dynamic>?;
      // print(data);
      
      if (data == null) {
        throw Exception('Data is null');
      }

      List<Map<String, dynamic>> records = [];
      for (var record in data) {
        if (record is Map<String, dynamic>) {
          records.add(record);
        } else {
          throw const FormatException('Invalid record format');
        }
      }
      return records;
    } else {
      throw Exception('Error fetching data: ${jsonResponse['message']}');
    }
  } else {
    throw Exception('Server error: ${response.statusCode}, Body: ${response.body}');
  }
}

Future<List<Map<String, dynamic>>> getUserID(String sqlCommand) async {
  var url = 'https://dominicn2024.smtchs.org/cinematch/getID.php';
  var response = await http.post(
    Uri.parse(url),
    body: {'sql': sqlCommand},
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success']) {
      List<dynamic> data = jsonResponse['data'];
      List<Map<String, dynamic>> records = [];

      for (var record in data) {
        // Assuming each record is a Map
        Map<String, dynamic> recordMap = {};
        record.forEach((key, value) {
          recordMap[key] = value;
        });
        records.add(recordMap);
      }
      return records;
    } else {
      throw Exception('Error fetching data: ${jsonResponse['message']}');
    }
  } else {
    throw Exception('Server error: ${response.statusCode}');
  }
}

Future<List<Map<String, dynamic>>> getGroupNames(String sqlCommand) async {
  var url = 'https://dominicn2024.smtchs.org/cinematch/getGroupNames.php';
  var response = await http.post(
    Uri.parse(url),
    body: {'sql': sqlCommand},
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success']) {
      List<dynamic> data = jsonResponse['data'];
      List<Map<String, dynamic>> records = [];

      for (var record in data) {
        // Assuming each record is a Map
        Map<String, dynamic> recordMap = {};
        record.forEach((key, value) {
          recordMap[key] = value;
        });
        records.add(recordMap);
      }
      return records;
    } else {
      throw Exception('Error fetching data: ${jsonResponse['message']}');
    }
  } else {
    throw Exception('Server error: ${response.statusCode}');
  }
}

Future<List<Map<String, dynamic>>> getMemberNames(String sqlCommand) async {
  var url = 'https://dominicn2024.smtchs.org/cinematch/getMemberNames.php';
  var response = await http.post(
    Uri.parse(url),
    body: {'sql': sqlCommand},
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success']) {
      List<dynamic> data = jsonResponse['data'];
      List<Map<String, dynamic>> records = [];

      for (var record in data) {
        // Assuming each record is a Map
        Map<String, dynamic> recordMap = {};
        record.forEach((key, value) {
          recordMap[key] = value;
        });
        records.add(recordMap);
      }
      return records;
    } else {
      throw Exception('Error fetching data: ${jsonResponse['message']}');
    }
  } else {
    throw Exception('Server error: ${response.statusCode}');
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


class DottedLine extends StatelessWidget {
  final double width; // Length of each dash
  final double height; // Thickness of the line
  final Color color; // Color of the line
  final int numberOfDots; // Number of dashes

  const DottedLine({
    Key? key,
    this.width = 4.0,
    this.height = 1.0,
    this.color = Colors.black,
    this.numberOfDots = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height), // Take as much width as possible
      painter: _DottedLinePainter(
        width: width,
        height: height,
        color: color,
        numberOfDots: numberOfDots,
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final double width;
  final double height;
  final Color color;
  final int numberOfDots;

  _DottedLinePainter({
    required this.width,
    required this.height,
    required this.color,
    required this.numberOfDots,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = height;

    double startX = 0;
    final spaceBetweenDots = (size.width - (numberOfDots * width)) / (numberOfDots - 1);

    for (int i = 0; i < numberOfDots; i++) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + width, size.height / 2),
        paint,
      );
      startX += width + spaceBetweenDots;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



Future<List<Map<String, dynamic>>> getGroupID(String sqlCommand) async {
  var url = 'https://dominicn2024.smtchs.org/cinematch/getGroupID.php';
  var response = await http.post(
    Uri.parse(url),
    body: {'sql': sqlCommand},
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success']) {
      List<dynamic> data = jsonResponse['data'];
      List<Map<String, dynamic>> records = [];

      for (var record in data) {
        // Assuming each record is a Map
        Map<String, dynamic> recordMap = {};
        record.forEach((key, value) {
          recordMap[key] = value;
        });
        records.add(recordMap);
      }
      return records;
    } else {
      throw Exception('Error fetching data: ${jsonResponse['message']}');
    }
  } else {
    throw Exception('Server error: ${response.statusCode}');
  }
}

