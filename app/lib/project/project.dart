import 'dart:convert';
import 'package:app/Topic/ResearchTopic.dart';
import 'package:app/provider/Providers.dart';
import 'package:app/student/student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Project extends StatefulWidget {
  final String topicname;

  // Constructor to accept 'name' as an argument
  Project(this.topicname);


  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  final TextEditingController projectController = TextEditingController();
  List<dynamic> mes = [];
  List<Map<String, dynamic>> messages = [];
  String title = "";
  String date = "";
  int number = 0;
  String contant = "";

  Future<void> fetchData() async {
    final url = Uri.parse('http://10.23.24.164:5000/fetchProject');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var filteredData = data.where((item) => item['topicname'] == widget.topicname).toList();
        print(filteredData);
        setState(() {
          mes = filteredData;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> PostDatas() async {
    try {
      await http.post(
        Uri.parse("http://10.23.24.164:5000/add_project"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {'name': projectController.text,
            "topicname":widget.topicname
          }),
      );
      projectController.text = "";
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Researchtopic()),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 28, 149, 205),
          title: Text(
            "Project",
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: mes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(mes[index]['name'].toString(),
                        style: TextStyle(fontSize: 16, color: Colors.blue)),
                    // subtitle: Text(mes[index]['name']!,
                    //     style: TextStyle(color: Colors.grey)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
                    onTap: () {
                      // setState(() {
                      //   title = messages[index]['name']!;
                      //   date = messages[index]['date']!;
                      //   number = index;
                      //   contant = messages[index]["contant"];
                      // });
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Student()));
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: projectController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'New project name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.new_label),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      PostDatas();
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
