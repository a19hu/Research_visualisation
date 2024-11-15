import 'dart:convert';
import 'package:app/NavbarBottom.dart';
import 'package:app/project/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Researchtopic extends StatefulWidget {
  const Researchtopic({super.key});

  @override
  State<Researchtopic> createState() => _ResearchtopicState();
}

class _ResearchtopicState extends State<Researchtopic> {
  final TextEditingController projectController = TextEditingController();
  List<dynamic> mes = [];
  List<Map<String, dynamic>> messages = [];
  String title = "";
  String date = "";
  int number = 0;
  String contant = "";
  bool AddRemove = false;

  Future<void> PostDatas() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      print(user?.uid);
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      await http.post(
        Uri.parse("http://10.23.24.164:5000/add_post"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': projectController.text,
          // 'Admin': userDoc['fullName'],
          // 'Admin_uid': userDoc['uid']
        }),
      );
      projectController.text = "";
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navbarbottom()),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> connect(String name) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await http.post(
        Uri.parse("http://10.23.24.164:5000/add_topic_prof"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'name': name, "uid": user?.uid}),
      );
      setState(() {
        AddRemove = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Successful')),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteRelation(String name) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await http.post(
        Uri.parse("http://10.23.24.164:5000/delete_topic_prof"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'name': name, "uid": user?.uid}),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Successful')),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://10.23.24.164:5000/fetchResearchtopic');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
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
          backgroundColor: const Color.fromARGB(255, 28, 149, 205),
          title: Text(
            "Research Topic",
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: mes.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey[200],
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(
                        mes[index]['name'].toString(),
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                      subtitle: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              connect(mes[index]['name'].toString());
                            },
                            child: Text('Add'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteRelation(mes[index]['name'].toString());
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: Colors.blue),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  Project(mes[index]['name'].toString())),
                        );
                      },
                    ),
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
                        labelText: 'New Research Topic',
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
