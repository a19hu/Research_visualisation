import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Student extends StatefulWidget {
  final String projectname;


  // Constructor to accept 'name' as an argument
  Student(this.projectname);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  final TextEditingController projectController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<dynamic> mes = [];
  List<Map<String, dynamic>> messages = [];
  String title = "";
  String date = "";
  int number = 0;
  String contant = "";

  Future<void> fetchData() async {
    final url = Uri.parse('http://10.23.24.164:5000/fetchstudents');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var filteredData = data.where((item) => item['projectname'] == widget.projectname).toList();
        print(data);
        setState(() {
          mes = filteredData;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> PostDatas() async {
      User? user = FirebaseAuth.instance.currentUser;

    try {
      await http.post(
        Uri.parse("http://10.23.24.164:5000/add_student"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': nameController.text,
          "url": urlController.text,
          "email": emailController.text,
          "projectname":widget.projectname,
          "uid":user?.uid,
        }),
      );
      projectController.text = "";
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
            "Student",
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
                    subtitle: FirebaseAuth.instance.currentUser?.uid ==
                            mes[index]['uid']
                        ? ElevatedButton(
                            onPressed: () async {
                              
                            },
                            child: Text("Remove"),
                          )
                        : Container(),
                    trailing: IconButton(
                        onPressed: () async {
                          final String email = mes[index]["email"];
                          final String subject = 'Project Details';
                          final String body =
                              'Student Name: ${mes[index]['name']}\n'
                              'Website URL: ${mes[index]["url"]}';
                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: email,
                            query: 'subject=$subject&body=$body',
                          );

                          if (await launchUrl(emailUri)) {
                          } else {}
                        },
                        icon: Icon(
                          Icons.email,
                          color: Colors.blue,
                        )),
                    onTap: () async {
                      Uri _url = Uri.parse(mes[index]["url"]);
                      if (await launchUrl(_url)) {
                      } else {}
                    },
                  );
                },
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                _showLanguagePopup(context);
              },
              child: Text('Add Student'),
            ),
          ],
        ));
  }

  void _showLanguagePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add new student"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text("Enter your email to receive the reset link."),
              TextField(
                controller:
                    nameController, // Use the controller for the student name
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller:
                    urlController, // Use the controller for the website URL
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'Website URL',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller:
                    emailController, // Use the controller for the student email
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Student Email ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("CANCEL"),
            ),
            TextButton(
              onPressed: () async {
                PostDatas();
                Navigator.of(context).pop();
              },
              child: Text("SAVE"),
            ),
          ],
        );
      },
    );
  }
}
