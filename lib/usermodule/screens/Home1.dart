import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home1 extends StatefulWidget {
  Home1({super.key});

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  String selectedFilter = "All"; 
  List<String> filters = ["All", "Bank Offers", "Flights", "Hotels", "Cabs", "Bus"];

  List<Map<String, String>> offers = [
    {"type": "Bank Offers", "description": "Get up to 50% OFF* on travel bookings."},
    {"type": "Flights", "description": "Vistara Flight at ₹1,578"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildCard("Flights", "assets/images/flight1.png"),
                  buildCard("Hotels", "assets/images/hotel2.ico"),
                  buildCard("Packages", "assets/images/package.png"),
                  buildCard("Trains/bus", "assets/images/train bus.png"),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Flagship Hotel Stores",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                buildHotelCard("Lemon Tree Hotels", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZ6nr2OHXEfYtYVRljJgASGiLOu-VbzHALhw&s", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROJ1uhpgVaapygGjTi2LB71m9diA09C3hKNA&s"),
                SizedBox(width: 8),
                Column(
                  children: [
                    buildHotelCard("WelcomHeritage Hotels", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTTC64s5S2NzdB7EeOn9tr1xEM6fyZAyRilA&s", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvhpl2EG1kE_loAaybl16trd8Af5zq64Kg7x2yWkjLwCE7LkaMSZZGqhlBUQ&s", height: 110),
                    SizedBox(height: 8),
                    buildHotelCard("Whyndham Hotels", "https://skift.com/wp-content/uploads/2016/05/Wyndham-Grand-Orlando-Resort-Bonnet-Creek-Orlando-FL.jpg", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9MBA-oYMTIeKN5tcbEYdKji_44f66eLLzKA&s", height: 110),
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

  Widget buildCard(String title, String imagePath) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 50, width: 55),
            Text(title, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget buildHotelCard(String title, String imageUrl, String avatarUrl, {double height = 230}) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width * 0.46,
      decoration: BoxDecoration(
        color: Colors.amber,
        image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.fill),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
              child: CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatarUrl)),
            ),
            Positioned(
              bottom: 4,
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilters() {
    return Container(
      height: 50,
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Chip(
                label: Text(
                  filters[index],
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
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        if (selectedFilter == "All" || offers[index]["type"] == selectedFilter) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(offers[index]["type"] ?? "No text"),
              subtitle: Text(offers[index]["description"] ?? "No text"),
            ),
          );
        } else {
          return Container(); // Return an empty container if the offer doesn't match the filter
        }
      },
    );
  }
}