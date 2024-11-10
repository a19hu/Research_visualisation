import 'package:app/NavbarBottom.dart';
import 'EditProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Userprofile extends StatefulWidget {
  const Userprofile({super.key});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  final TextEditingController passwordController = TextEditingController();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController uidController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the page loads
  }

  // Fetch user data from Firestore
  void fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    print(userDoc);

    if (userDoc.exists) {
      setState(() {
        fullNameController.text = userDoc['fullName'];
        emailController.text = userDoc['email'];
        urlController.text = userDoc['url'];
        uidController.text = userDoc['uid'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.orange,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              // height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onPressed: () {
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        String userId = user.uid;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfilePage(userId: userId),
                          ),
                        );
                      } else {
                        print("User not logged in");
                      }
                    },
                    child: Text(
                      "EDIT PROFILE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ProfileItem(
                      icon: Icons.person,
                      title: "Full Name",
                      value: fullNameController.text),
                  ProfileItem(
                      icon: Icons.email,
                      title: "Email Address",
                      value: emailController.text),
                  ProfileItem(
                      icon: Icons.web_stories,
                      title: "Url",
                      value: urlController.text),
                      ProfileItem(
                      icon: Icons.man,
                      title: "ID",
                      value: uidController.text),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Navbarbottom()),
                );
              },
              child: Text(
                "BACK TO HOME",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
              onPressed: () {
                _showLanguagePopup(context);
              },
              child: Text(
                "RESET PASSWORD",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Navbarbottom()),
                );
              },
              child: Text(
                "LOGOUT",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reset Password?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Enter New Password With Min 6 Characters"),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
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
                final newPassword = passwordController.text.trim();
                if (newPassword.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Password must be at least 6 characters")),
                  );
                  return;
                }
                try {
                  // Get the currently signed-in user
                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    // Update the password
                    await user.updatePassword(newPassword);

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Password changed successfully")),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("User not logged in")),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.message}")),
                  );
                }
              },
              child: Text("CHANGE"),
            ),
          ],
        );
      },
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileItem(
      {required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
