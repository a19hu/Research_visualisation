import 'package:app/Profile/LoginPage.dart';
import 'package:app/Profile/UserProfile.dart';
import 'package:app/Topic/ResearchTopic.dart';
import 'package:app/home/HomePage.dart';
import 'package:app/project/project.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Navbarbottom extends StatefulWidget {
  const Navbarbottom({super.key});

  @override
  State<Navbarbottom> createState() => _NavbarbottomState();
}

class _NavbarbottomState extends State<Navbarbottom> {
  int _selectedIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

@override
  Widget build(BuildContext context) {
    Widget displayWidget;

    switch (_selectedIndex) {
      case 0:
        displayWidget = Homepage(); 
        break;
      case 1:
        displayWidget = user != null ? Userprofile(): Loginpage();
        break;
      case 2:
        displayWidget = user != null ? Researchtopic(): Loginpage();
        break;
      default:
        displayWidget = Homepage();
    }

    return Scaffold(
     
      body: displayWidget,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            tooltip: 'Home', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            tooltip: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.indeterminate_check_box),
            label: 'Project',
            tooltip: 'Project', 
          )
          
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: const Color.fromARGB(255, 31, 31, 31),
        onTap: _onItemTapped,
      ),
    );
  }
}
