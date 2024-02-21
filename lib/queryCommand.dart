// ignore_for_file: unused_local_variable, file_names, avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

class Query {
  Future<List<dynamic>> executeSql(String sqlCommand) async {
    try {
      final response = await http.post(
        Uri.parse('https://dominicn2024.smtchs.org/cinematch/connection.php'),
        body: {'sql_command': sqlCommand},
      );

      if (response.statusCode == 200) {
        dynamic jsonData = json.decode(response.body);
        if (jsonData['success'] && jsonData['data'] is List) {
          return jsonData['data'];
        } else {
          print('Unexpected response format.');
          return [];
        }
      } else {
        print('Server error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
}
}