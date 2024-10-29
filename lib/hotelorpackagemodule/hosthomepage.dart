import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journease/authentication/hostlogin.dart';
import 'package:journease/hotelorpackagemodule/ListPackage.dart';
import 'package:journease/hotelorpackagemodule/addoffer.dart';
import 'package:journease/hotelorpackagemodule/addpackage.dart';
import 'package:journease/hotelorpackagemodule/bookingspackage.dart';
import 'package:journease/hotelorpackagemodule/hostProfile.dart';
import 'package:journease/hotelorpackagemodule/listproperty.dart';
import 'package:journease/hotelorpackagemodule/models/hostdataModel.dart';
import 'package:journease/hotelorpackagemodule/viewbookings.dart';

class HostHomePage extends StatefulWidget {
  final String hostId; // Use hostId to load data

  const HostHomePage({Key? key, required this.hostId}) : super(key: key);

  @override
  _HostHomePageState createState() => _HostHomePageState();
}

class _HostHomePageState extends State<HostHomePage> {
  late Future<UserModel> _hostDataFuture;

  @override
  void initState() {
    super.initState();
    _hostDataFuture = _fetchHostData(widget.hostId);
  }

  // Fetch host data from Firestore based on hostId
  Future<UserModel> _fetchHostData(String hostId) async {
    DocumentSnapshot hostSnapshot = await FirebaseFirestore.instance
        .collection('hosts') // Assuming your collection is called 'hosts'
        .doc(hostId)
        .get();

    if (hostSnapshot.exists) {
      Map<String, dynamic> hostData = hostSnapshot.data() as Map<String, dynamic>;
      return UserModel(
        id: hostId,
        firstName: hostData['firstName'] ?? '',
        lastName: hostData['lastName'] ?? '',
        email: hostData['email'] ?? '',
      );
    } else {
      throw Exception('Host not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 184, 168),
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        width: 250,
        child: FutureBuilder<UserModel>(
          future: _hostDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            }

            UserModel host = snapshot.data!;
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 222, 121, 90),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://t4.ftcdn.net/jpg/04/83/90/95/360_F_483909569_OI4LKNeFgHwvvVju60fejLd9gj43dIcd.jpg',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${host.firstName} ${host.lastName}', // Display full name
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        host.email, // Display email
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HostProfilePage(hostId: widget.hostId),));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    // Navigate to Settings Page
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<UserModel>(
          future: _hostDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            }

            UserModel host = snapshot.data!;
            return GridView.count(
              crossAxisCount: 2, // Two cards per row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: <Widget>[
                _buildCard(
                  context: context,
                  title: 'Properties',
                  icon: Icons.apartment_outlined,
                  onTap: () {
                    // Navigate to properties page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyListPage(hostId: widget.hostId),
                      ),
                    );
                  },
                ),
                _buildCard(
                  context: context,
                  title: 'Packages',
                  icon: Icons.travel_explore_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PackageListPage(hostId: widget.hostId,)));
                  },
                ),
                _buildCard(
                  context: context,
                  title: 'Property Bookings',
                  icon: Icons.book,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BookingListScreen(hostId: widget.hostId),));
                  },
                ),
                _buildCard(
                  context: context,
                  title: 'Add Offer',
                  icon: Icons.local_offer_rounded,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddOfferPage(hostId: widget.hostId),));
                  },
                ),
                _buildCard(
                  context: context,
                  title: 'Package Bookings',
                  icon: Icons.book,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PackageBookingsPage(hostId: widget.hostId),));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Color.fromARGB(255, 222, 121, 90)),
            SizedBox(height: 10),
            Text(textAlign: TextAlign.center,
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
