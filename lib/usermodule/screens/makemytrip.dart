import 'package:flutter/material.dart';



class HotelHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.black),
        title: Image.network(
          'https://via.placeholder.com/50x50', // Replace with your app logo URL
          height: 30,
        ),
        actions: [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.account_balance_wallet, color: Colors.red),
          SizedBox(width: 16),
          Icon(Icons.business_center, color: Colors.orange),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Flagship Hotel Stores",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildHotelCard("Lemon Tree Hotels",
                      'https://via.placeholder.com/150x100'), // Replace with actual image URL
                  _buildHotelCard("WelcomHeritage",
                      'https://via.placeholder.com/150x100'), // Replace with actual image URL
                  _buildHotelCard("Lemon Tree Hotels",
                      'https://via.placeholder.com/150x100'), // Replace with actual image URL
                  _buildHotelCard("Wyndham Hotels & Resorts",
                      'https://via.placeholder.com/150x100'), // Replace with actual image URL
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Welcome Offer, Shabna",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildWelcomeOfferCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket),
            label: 'My Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Where2Go',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'TripMoney',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Be A Host',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildHotelCard(String hotelName, String imageUrl) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: [
          Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity),
          Positioned(
            bottom: 8,
            left: 8,
            child: Text(
              hotelName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeOfferCard() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
              'https://via.placeholder.com/300x150', // Replace with actual image URL
              fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Enjoy Up to 20% More Savings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "on Flights, Hotels, Bus, Trains & More",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "21h: 05m: 08s",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                Text(
                  "OFFERS",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
