import 'package:flutter/material.dart';

class WishList extends StatelessWidget {
  const WishList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_rounded,size: 18,)),
        title: Text("Your wishlist",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            
              
          ],
        ),
      ),
    );
  }
}