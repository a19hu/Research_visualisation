import 'dart:convert';
import 'package:apps/api/config.dart';
import 'package:http/http.dart' as http;

class FirebaseFetchingService {
  Future<List<dynamic>> fetchResearchData() async {
    final url = Uri.parse('$BASE_URL/fetchResearchtopic');
    try {
      final response = await http.get(url);
      List data = [];
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
      }
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> fetchPojectData(topicname) async {
    final url = Uri.parse('$BASE_URL/fetchProject');

    try {
      final response = await http.get(url);
      List filterdata = [];
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        filterdata = data
            .where((item) => item['topicname'] == topicname)
            .toList();
      }
      return filterdata;
    } catch (e) {
      return [];
    }
  }

   Future<List<dynamic>> fetchStudentData(projectname) async {
    final url = Uri.parse('$BASE_URL/fetchstudents');

    try {
      final response = await http.get(url);
      List filterdata = [];
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        filterdata = data
            .where((item) => item['projectname'] == projectname)
            .toList();
      }
      return filterdata;
    } catch (e) {
      return [];
    }
  }


}
