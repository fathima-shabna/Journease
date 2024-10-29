import 'package:flutter/material.dart';
import 'package:journease/adminmodule/resortapproval.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 items in each row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            _buildDashboardCard(
              context,
              'Manage Resorts',
              Icons.location_city,
              Colors.orange,
              () {
                // Action when tapping Manage Resorts
                Navigator.push(context, MaterialPageRoute(builder: (context) => HostApprovalPage()));
              },
            ),
            // _buildDashboardCard(
            //   context,
            //   'Manage Packages',
            //   Icons.card_giftcard,
            //   Colors.green,
            //   () {
            //     // Action when tapping Manage Packages
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => ManagePackagesPage()));
            //   },
            // ),
            // _buildDashboardCard(
            //   context,
            //   'Manage Bookings',
            //   Icons.book_online,
            //   Colors.blue,
            //   () {
            //     // Action when tapping Manage Bookings
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => HostApprovalPage()));
            //   },
            // ),
            // _buildDashboardCard(
            //   context,
            //   'Manage Users',
            //   Icons.supervised_user_circle,
            //   Colors.purple,
            //   () {
            //     // Action when tapping Manage Users
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => ManageUsersPage()));
            //   },
            // ),
            // _buildDashboardCard(
            //   context,
            //   'Reports',
            //   Icons.bar_chart,
            //   Colors.red,
            //   () {
            //     // Action when tapping Reports
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsPage()));
            //   },
            // ),
            _buildDashboardCard(
              context,
              'Settings',
              Icons.settings,
              Colors.grey,
              () {
                // Action when tapping Settings
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 50.0,
              color: color,
            ),
            SizedBox(height: 16.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy pages for navigation
class ManageResortsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Resorts")),
      body: Center(child: Text("Resorts management page")),
    );
  }
}

class ManagePackagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Packages")),
      body: Center(child: Text("Packages management page")),
    );
  }
}

class ManageBookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Bookings")),
      body: Center(child: Text("Bookings management page")),
    );
  }
}

class ManageUsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Users")),
      body: Center(child: Text("Users management page")),
    );
  }
}

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reports")),
      body: Center(child: Text("Reports page")),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Center(child: Text("Settings page")),
    );
  }
}
