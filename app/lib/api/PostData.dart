import 'dart:convert';
import 'package:app/api/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirebasePostingService {
  Future<void> PostResearchData(BuildContext context, String name) async {
    try {
      await http.post(
        Uri.parse("$BASE_URL/postresearchdata"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': name,
        }),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post Research Data Successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to postb Research data')),
      );
    }
  }

  Future<void> createResearchData(BuildContext context, String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      await http.post(
        Uri.parse("$BASE_URL/createresearchdata"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'name': name, "uid": user?.uid}),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Successful Research topic Add')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Add data')),
      );
    }
  }

  Future<void> removeResearchData(BuildContext context, String name) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await http.post(
        Uri.parse("$BASE_URL/removesearchdata"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'name': name, "uid": user?.uid}),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Successful Remove Search data')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Remove data')),
      );
    }
  }

  Future<void> DeleteResearchData(BuildContext context, String name) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await http.post(
        Uri.parse("$BASE_URL/deleteresearchdata"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'name': name, "uid": user?.uid}),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Successful Delete ReSearch data')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete data')),
      );
    }
  }

  Future<void> PostProjectDatas(
      BuildContext context, String name, String topicname) async {
    try {
      await http.post(
        Uri.parse("$BASE_URL/postproject"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'name': name, "topicname": topicname}),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post Project Data Successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post Project data')),
      );
    }
  }

  Future<void> createProject(BuildContext context, String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      await http.post(
        Uri.parse("$BASE_URL/createproject"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'name': name, "uid": user?.uid}),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Successful Research topic Add')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Add data')),
      );
    }
  }

  Future<void> removeProject(BuildContext context, String name) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await http.post(
        Uri.parse("$BASE_URL/removeproject"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'name': name, "uid": user?.uid}),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Successful Remove Search data')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Remove data')),
      );
    }
  }

  Future<void> PostStudentData(BuildContext context, String name, String url,
      String email, String projectname) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      await http.post(
        Uri.parse("$BASE_URL/add_student"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': name,
          "url": url,
          "email": email,
          "projectname": projectname,
          "uid": user?.uid,
        }),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post Research Data Successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to postb Research data')),
      );
    }
  }

  Future<void> removeStudent(BuildContext context, String name, String email,
      String projectname) async {
    try {
      await http.post(
        Uri.parse("$BASE_URL/removestudent"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {'name': name, "email": email, "projectname": projectname}),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Successful Remove data')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Remove data')),
      );
    }
  }

  Future<void> updateAdmin(
      BuildContext context, String name, String url) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      await http.post(
        Uri.parse("$BASE_URL/updateadmin"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': name,
          "url": url,
          "uid": user?.uid,
        }),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Successful Remove data')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Remove data')),
      );
    }
  }
}
