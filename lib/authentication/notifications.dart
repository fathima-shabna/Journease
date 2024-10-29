import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
          onPressed: () {
            
          },
        ),
        title: Text('Notification', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 17)),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: 3, // You can change this based on your needs
        itemBuilder: (context, index) {
          return NotificationTile();
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: ListTile(
        visualDensity: VisualDensity.standard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 20,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You have won a gift from the INCO',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            // SizedBox(height: 10), // Spacing between title and bottom content
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Sep 17 2024',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
