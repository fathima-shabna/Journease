import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journease/hotelorpackagemodule/models/hostdataModel.dart';
import 'package:journease/usermodule/models/userdetailModel.dart';
import 'package:journease/usermodule/screens/generaldetails.dart';
import 'package:journease/usermodule/screens/hotelsearch.dart';
import 'package:journease/usermodule/screens/myaccount.dart';
import 'package:journease/usermodule/screens/mytrip.dart';
import 'package:journease/usermodule/screens/navigation.dart';
import 'package:journease/usermodule/screens/notifications.dart';
import 'package:journease/usermodule/screens/packages.dart';
import 'package:journease/usermodule/screens/support.dart';
import 'package:journease/usermodule/screens/wishlist.dart';

class Home extends StatefulWidget {
  final UserDataModel user;
  Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedFilter = "All"; // Default selected filter
  List<String> filters = ["All", "Hotels", "Resorts", "Apartments", "Packages"];
  List<Map<String, String>> offers = [
    {"type": "Hotels", "description": "Get up to 50% OFF* on package bookings.", "img": "assets/images/package offer.png"},
    {"type": "Resorts", "description": "Vistara Flight at ₹1,578", "img": "assets/images/flight offer.jpg"},
    {"type": "Apartments", "description": "Upto 30% OFF* on resort bookings", "img": "assets/images/hotel offer.jpeg"},
    {"type": "Packages", "description": "Upto 30% OFF* on resort bookings", "img": "assets/images/hotel offer.jpeg"}
    // Add more offers here
  ];

  UserDataModel? currentUser; // Variable to hold the current user data

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  String? getCurrentUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.uid; // Returns the user ID if the user is signed in, otherwise null.
}


  // Fetch the current user data from Firestore
  Future<void> fetchCurrentUser() async {
    String? userId = getCurrentUserId(); // Replace this with actual user ID retrieval logic (e.g., from authentication)
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('appusers').doc(userId).get();

    if (snapshot.exists) {
      setState(() {
        currentUser = UserDataModel.fromDocument(snapshot);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 184, 168),
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search_outlined,
                color: Colors.black,
                size: 18,
              )),
        ],
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) {
            return InkWell (
              onTap: () {
                return Scaffold.of(context).openDrawer();
              },
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.deepOrange,
                    child: Text(
                      currentUser!.fullName[0],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 35,
                  right: 10,
                  child: CircleAvatar(
                    radius: 8,
                    child: Icon(
                      Icons.menu,
                      size: 10,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
              ]),
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white.withOpacity(0.9),
        width: 260,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              SizedBox(height: 25),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GeneralDetails()));
                },
                tileColor: Color.fromARGB(255, 222, 121, 90),
                contentPadding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                leading: CircleAvatar(radius: 30, backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyKLQ_NDd81udMvX8pB7D97hkZxbjehU6WzA&s"),),
                title: Text(
                  "Hi ${currentUser?.fullName ?? 'User'}",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                ),
                subtitle: Text("${currentUser?.phone ?? 'N/A'}", style: TextStyle(fontSize: 12, color: Colors.white)),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15, color: Colors.white),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black26),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyAccount())),
                        child: _buildIconButton(Icons.account_box_outlined, "My Account"),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Support()));
                        },
                        child: _buildIconButton(Icons.message_outlined, "Support"),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications())),
                        child: _buildIconButton(Icons.notifications_none, "Notifications"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black26),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("My Trips"),
                    _buildListTile(Icons.card_travel, "View/Manage Trips", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Navigation(index: 1,user: widget.user,)));
                    }),
                    _buildListTile(Icons.favorite, "Wishlist", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => WishList()));
                    }),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black26),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("About"),
                    _buildListTile(Icons.star_rate, "Rate us", () {}),
                    _buildListTile(Icons.privacy_tip_outlined, "Privacy policy", () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            // SizedBox(height: 10,),
            ListView(
          // scrollDirection: Axis.horizontal,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Card(
                    elevation: 5,
                    // margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/flight1.png",
                            height: 50,
                            width: 74,
                          ),
                          Text(
                            "Flights",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // SizedBox(width: 2,),

                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HotelSearch(selectedvalue: '', rooms: 0, adults: 0, children: 0),)),
                    child: Card(
                      elevation: 5,
                      // margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/hotel2.ico",
                              height: 50,
                              width: 74,
                            ),
                            Text("Hotels", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //  SizedBox(width: 2,),

                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Packages(selectedvalue: '', selectedvalue2: '', rooms: 0, adults: 0, children: 0,userId: widget.user.userId,),)),
                    child: Card(
                      elevation: 5,
                      // margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/package.png",
                              height: 50,
                              width: 74,
                            ),
                            Text("Packages", style: TextStyle(fontSize: 12))
                          ],
                        ),
                      ),
                    ),
                  ),

                  // SizedBox(width: 2,),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider( color: Colors.black26,),
            SizedBox(
              height: 10,
            ),
            Text("Flagship Hotel Stores",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          
                          SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  height: 230,
                  width: MediaQuery.of(context).size.width * 0.46,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZ6nr2OHXEfYtYVRljJgASGiLOu-VbzHALhw&s"),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(children: [

                      Positioned(child: CircleAvatar(radius: 20,
                      backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROJ1uhpgVaapygGjTi2LB71m9diA09C3hKNA&s"),)),


                      Positioned(
                          bottom: 4,
                          child: Text(
                            "Lemon Tree Hotels",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.white),
                          ))
                    ]),
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  children: [
                    Container(
                      height: 110,
                      width: MediaQuery.of(context).size.width * 0.46,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTTC64s5S2NzdB7EeOn9tr1xEM6fyZAyRilA&s"),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(children: [

                           Positioned(child: CircleAvatar(radius: 20,
                      backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvhpl2EG1kE_loAaybl16trd8Af5zq64Kg7x2yWkjLwCE7LkaMSZZGqhlBUQ&s"),)),
                          Positioned(
                              bottom: 4,
                              child: Text(
                                "WelcomHeritage Hotels",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.white),
                              ))
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 110,
                      width: MediaQuery.of(context).size.width * 0.46,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://skift.com/wp-content/uploads/2016/05/Wyndham-Grand-Orlando-Resort-Bonnet-Creek-Orlando-FL.jpg"),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(children: [

                           Positioned(child: CircleAvatar(radius: 20,
                      backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9MBA-oYMTIeKN5tcbEYdKji_44f66eLLzKA&s"),)),
                          Positioned(
                              bottom: 4,
                              child: Text(
                                "Whyndham Hotels",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.white),
                              ))
                        ]),
                      ),
                    ),
                  ],
                ),
                                               
              ],
            ),

            SizedBox(height: 10),
            buildFilters(),
            SizedBox(height: 10),
            buildOfferList(),

          ],
        ),
      ),
    );
  }


  
  Widget buildFilters() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filters[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0,vertical: 3.0),
              child: Chip(
                label: Text(
                  filters[index],textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedFilter == filters[index] ? Colors.white : Colors.black,
                  ),
                ),
                backgroundColor: selectedFilter == filters[index] ? Colors.blue : Colors.grey[200],
              ),
            ),
          );
        },
      ),
    );
  }

Widget buildOfferList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('offers').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator()); // Show a loading spinner
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('No offers available.'));
      }

      // Extracting data from Firestore snapshot
      List<DocumentSnapshot> documents = snapshot.data!.docs;
      List<Map<String, dynamic>> offers = documents.map((doc) => doc.data() as Map<String, dynamic>).toList();

      return Container(
        height: 240,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: offers.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> offer = offers[index];

            // Show offers based on selected filter
            if (selectedFilter == "All" || offer["offerType"] == selectedFilter) {
              return Card(
                margin: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 310,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              image: DecorationImage(
                                image: NetworkImage(
                                  offer["imageUrl"] ??
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJf7CHTL8C0HdQZYot_iuUQuny2kSqMJarZTXvGB3m6vwKweh8UZI781ZnxTXY6YENczY&usqp=CAU"), // Provide a fallback image
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            offer["offerType"] ?? "No Type",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(offer["description"] ?? "No Description"),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Container(); // Return an empty container if the offer doesn't match the filter
            }
          },
        ),
      );
    },
  );
}


  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Color.fromARGB(255, 222, 121, 90),
          child: Icon(icon, color: Colors.white,size: 20,),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }

   Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback? onTap) {
    // final VoidCallback? onTap;

    return ListTile(
      
      visualDensity: VisualDensity(vertical: -4),
      leading: Icon(icon, color: Colors.black45,size: 19,),
      title: Text(title,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
      onTap: onTap,
    );
  }

}