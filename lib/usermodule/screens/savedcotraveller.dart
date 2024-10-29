import 'package:flutter/material.dart';
import 'package:journease/usermodule/screens/cotraveller.dart';

class SavedCoTraveller extends StatelessWidget {
  const SavedCoTraveller({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_rounded,size: 18,)),
        title: Text("Saved Co-Travellers",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
      ),
      body: Column(
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),color: Color.fromARGB(255, 222, 121, 90)),
              child: TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddCoTravellerScreen(),));
              }, child: Text("+ ADD NEW TRAVELLER",style: TextStyle(color: Colors.white),)),
            ),
          ),
        ],
      ),
    );
  }
}