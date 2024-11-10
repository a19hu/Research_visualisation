import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String userId; 

  EditProfilePage({required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData(); 
  }

  void fetchData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users') 
        .doc(widget.userId)
        .get();

    if (userDoc.exists) {
      setState(() {
        fullNameController.text = userDoc['fullName'];
        urlController.text = userDoc['url'];
      });
    }
  }

  void saveData() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'fullName': fullNameController.text,
        'url': urlController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.of(context).pop(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              TextFormField(
                controller: urlController,
                decoration: InputDecoration(labelText: "url"),
              ),
              
             
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveData,
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
