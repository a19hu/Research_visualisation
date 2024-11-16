import 'package:apps/api/PostData.dart';
import 'package:apps/api/fetchdata.dart';
import 'package:apps/project/project.dart';
import 'package:flutter/material.dart';

class Researchtopic extends StatefulWidget {
  const Researchtopic({super.key});

  @override
  State<Researchtopic> createState() => _ResearchtopicState();
}

class _ResearchtopicState extends State<Researchtopic> {
  final TextEditingController projectController = TextEditingController();
  List<dynamic> mes = [];
  final FirebaseFetchingService firebaseService = FirebaseFetchingService();
  final FirebasePostingService firebasePost = FirebasePostingService();

  Future<void> fetchData() async {
    List<dynamic> fetchedData = await firebaseService.fetchResearchData();
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
                            onPressed: () async {
                              await firebasePost.createResearchData(
                                  context, mes[index]['name'].toString());
                            },
                            child: Text('Add'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await firebasePost.removeResearchData(
                                  context, mes[index]['name'].toString());
                              await fetchData();
                            },
                            child: Text('Remove'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await firebasePost.DeleteResearchData(
                                  context, mes[index]['name'].toString());
                              await fetchData();
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
                          MaterialPageRoute(
                              builder: (context) =>
                                  Project(mes[index]['name'].toString())),
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
                      if (projectController.text.isNotEmpty) {
                        await firebasePost.PostResearchData(
                            context, projectController.text);
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
