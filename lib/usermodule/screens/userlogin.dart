import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:journease/authentication/login.dart';
import 'package:journease/authentication/startpage.dart';
import 'package:journease/usermodule/models/userdetailModel.dart';
import 'package:journease/usermodule/screens/home.dart';
import 'package:journease/usermodule/screens/navigation.dart';
import 'package:journease/usermodule/usersignuplogin.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  // Method to handle user login
// Inside _UserLoginState
Future<void> login() async {
  setState(() {
    isLoading = true;
  });

  try {
    // Firebase Authentication: Sign in with email and password
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    showMessage('Login successful!');

    // Retrieve the userId from the userCredential
    String userId = userCredential.user!.uid;

    // Fetch user data from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('appusers')
        .doc(userId)
        .get();

    // Create UserModel instance
    UserDataModel userModel = UserDataModel.fromDocument(userDoc);

    // Navigate to the home page, passing the userModel
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Navigation(user: userModel), // Pass userModel to Home
      ),
    );
  } on FirebaseAuthException catch (e) {
    // Handle Firebase Authentication errors
    if (e.code == 'user-not-found') {
      showMessage('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      showMessage('Incorrect password. Please try again.');
    } else {
      showMessage('An error occurred: ${e.message}');
    }
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  // Method to show messages using SnackBar
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Custom decoration for text fields
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[700]),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color.fromARGB(255, 222, 121, 90), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartPage(),));
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Login'),
        backgroundColor: Color.fromARGB(255, 222, 121, 90),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 222, 121, 90),
                ),
              ),
              SizedBox(height: 24),
              TextField(
                controller: emailController,
                decoration: _buildInputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: _buildInputDecoration('Password'),
                obscureText: true,
              ),
              SizedBox(height: 5,),
              Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Fluttertoast.showToast(msg: "Forgot Password Clicked");
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
              SizedBox(height: 24),
              isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Color.fromARGB(255, 222, 121, 90),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Navigate to the SignUp page
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserSignup(),));
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Color.fromARGB(255, 222, 121, 90)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
