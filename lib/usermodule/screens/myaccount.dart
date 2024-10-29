import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journease/usermodule/models/userdetailModel.dart';
import 'package:journease/usermodule/screens/cotraveller.dart';
import 'package:journease/usermodule/screens/generaldetails.dart';
import 'package:journease/usermodule/screens/savedcotraveller.dart';
import 'package:journease/usermodule/screens/userlogin.dart';
import 'package:journease/usermodule/screens/wishlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({super.key});

  Future<UserDataModel?> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('appusers').doc(user.uid).get();
      if (doc.exists) {
        return UserDataModel.fromDocument(doc); // Assuming you have a method to create UserDataModel from Firestore
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'My Personal Account',
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
      body: FutureBuilder<UserDataModel?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No user data found.'));
          }

          UserDataModel userData = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: Text(
                          userData.fullName.isNotEmpty ? userData.fullName[0] : '?', // First letter of name
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData.fullName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle profile edit
                            },
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 14, color: Colors.blue),
                                SizedBox(width: 8),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => GeneralDetails()));
                                  },
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.phone, size: 16),
                              SizedBox(width: 8),
                              Text(userData.phone), // Phone number from user data
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.email, size: 16),
                              SizedBox(width: 8),
                              Text(userData.email), // Email from user data
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 38),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        // ToolkitItem(
                        //   icon: Icons.card_travel_outlined,
                        //   title: 'View/Manage Trips',
                        // ),
                        // InkWell(
                        //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WishList())),
                        //   child: ToolkitItem(
                        //     icon: Icons.favorite_border,
                        //     title: 'Wishlist',
                        //   ),
                        // ),
                        InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SavedCoTraveller())),
                          child: ToolkitItem(
                            icon: Icons.people_outline,
                            title: 'Co-Travellers',
                          ),
                        ),
                        // ToolkitItem(
                        //   icon: Icons.manage_accounts_outlined,
                        //   title: 'Account',
                        // ),
                        InkWell(
                          onTap: () =>  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UserLogin())),
                          child: ToolkitItem(
                            icon: Icons.logout_rounded,
                            title: 'Logout',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ToolkitItem extends StatelessWidget {
  final IconData icon;
  final String title;

  ToolkitItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(fontSize: 14),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
