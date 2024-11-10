import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  final TextEditingController projectController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  List<dynamic> mes = [];
  List<Map<String, dynamic>> messages = [];
  String title = "";
  String date = "";
  int number = 0;
  String contant = "";

  Future<void> fetchData() async {
    final url = Uri.parse('http://10.23.24.164:5000/users');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          mes = data;
        });
      }
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
          backgroundColor: Colors.orange,
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
                    title: Text(mes[index]['age'].toString(),
                        style: TextStyle(fontSize: 16, color: Colors.blue)),
                    subtitle: Text(mes[index]['name']!,
                        style: TextStyle(color: Colors.grey)),
                    trailing: Icon(Icons.web, color: Colors.blue),
                    onTap: () {},
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
              Text("Enter your email to receive the reset link."),
              SizedBox(height: 20),
              TextField(
                controller: urlController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'student name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: urlController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'Website url',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: urlController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'student emailid',
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
              onPressed: () async {},
              child: Text("SAVE"),
            ),
          ],
        );
      },
    );
  }
}
