import 'package:app/NavbarBottom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var acs = ActionCodeSettings(
    // URL you want to redirect back to. The domain (www.example.com) for this
    // URL must be whitelisted in the Firebase Console.
    url: 'https://www.example.com/finishSignUp?cartId=1234',
    // This must be true
    handleCodeInApp: true,
    androidPackageName: 'com.example.app',
    androidInstallApp: true,
    androidMinimumVersion: '12');

  bool isInitiated = true;
  String? selectedRelationship;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  void registerUser() async {
    try {

    //  await FirebaseAuth.instance
    //   .sendSignInLinkToEmail(
    //     email: emailController.text.trim(),
    //     actionCodeSettings: acs,
    //   )
    //   .then((_) => print('Successfully sent email verification'))
    //   .catchError((error) {
    //     print('Error sending email verification: $error');
    //     throw error;  // Re-throw the error to prevent registration
    //   });

  // Create the user with email and password
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
  );

      await FirebaseFirestore.instance.collection('users').doc(credential.user?.uid).set({
        'fullName': nameController.text,
        'email': emailController.text,
        'url': urlController.text,
        'uid':  credential.user?.uid
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful')),
      );
      Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Navbarbottom()),
                );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Failed: ${e.message}')),
      );
    }
  }


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create your account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
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
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerUser,
                child: Text('REGISTER'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Already registered? Login here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}