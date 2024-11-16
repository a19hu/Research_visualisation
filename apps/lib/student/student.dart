import 'package:apps/api/PostData.dart';
import 'package:apps/api/fetchdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Student extends StatefulWidget {
  final String projectname;
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
  final FirebaseFetchingService firebaseService = FirebaseFetchingService();
  final FirebasePostingService firebasePost = FirebasePostingService();

  Future<void> fetchData() async {
    print(widget.projectname);
    List<dynamic> fetchedData =
        await firebaseService.fetchStudentData(widget.projectname);
    setState(() {
      mes = fetchedData;
    });
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
                  return  Container(
                      color: Colors.grey[200],
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      child:ListTile(
                    title: Text(mes[index]['name'].toString(),
                        style: TextStyle(fontSize: 16, color: Colors.blue)),
                    subtitle: FirebaseAuth.instance.currentUser?.uid ==
                            mes[index]['uid']
                        ? ElevatedButton(
                            onPressed: () async {
                              await firebasePost.removeStudent(
                                  context,
                                  mes[index]['name'],
                                  mes[index]['email'],
                                  widget.projectname);
                              fetchData();
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
                )  );
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
              TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: urlController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'Website URL',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
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
                await firebasePost.PostStudentData(
                    context,
                    nameController.text,
                    urlController.text,
                    emailController.text,
                    widget.projectname);
                Navigator.of(context).pop();
                fetchData();
              },
              child: Text("SAVE"),
            ),
          ],
        );
      },
    );
  }
}
