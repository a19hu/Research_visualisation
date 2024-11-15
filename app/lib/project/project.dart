import 'package:app/api/PostData.dart';
import 'package:app/api/fetchdata.dart';
import 'package:app/student/student.dart';
import 'package:flutter/material.dart';

class Project extends StatefulWidget {
  final String topicname;

  Project(this.topicname);

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  final TextEditingController projectController = TextEditingController();
  List<dynamic> mes = [];
  final FirebaseFetchingService firebaseService = FirebaseFetchingService();
  final FirebasePostingService firebasePost = FirebasePostingService();

  Future<void> fetchData() async {
    List<dynamic> fetchedData =
        await firebaseService.fetchPojectData(widget.topicname);
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
                  return Container(
                      color: Colors.grey[200],
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        title: Text(mes[index]['name'].toString(),
                            style: TextStyle(fontSize: 16, color: Colors.blue)),
                        trailing:
                            Icon(Icons.arrow_forward_ios, color: Colors.blue),
                        subtitle: Row(
                        children: [
                          TextButton(
                            onPressed: () async {
                              await firebasePost.createProject(
                                  context, mes[index]['name'].toString());
                            },
                            child: Text('Add'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await firebasePost.removeProject(
                                  context, mes[index]['name'].toString());
                              await fetchData();
                            },
                            child: Text('Remove'),
                          ),
                        ],
                      ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Student(mes[index]['name'].toString())));
                        },
                      ));
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
                      if (projectController.text.isNotEmpty) {
                        await firebasePost.PostProjectDatas(
                            context, projectController.text, widget.topicname);
                        projectController.text = "";
                        fetchData();
                      }
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
