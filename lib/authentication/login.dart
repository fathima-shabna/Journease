import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:journease/authentication/adminlogin.dart';
import 'package:journease/authentication/hostlogin.dart';
import 'package:journease/customwidget/textfield.dart';
import 'package:journease/usermodule/screens/userlogin.dart';

class Login extends StatelessWidget {
   Login({super.key});
  // TextEditingController _phoneController = TextEditingController();
  // TextEditingController _passwordController = TextEditingController();
  // var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return 
    BackdropFilter(
      filter:  ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: 
      Container(
        height: 250,
        width: double.infinity,
       decoration: BoxDecoration(
        // color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
        border: Border.all(
              color: Colors.white.withOpacity(0.2), 
              width: 2.5),
       ), 
       child: Padding(
         padding: const EdgeInsets.all(18.0),
         child: Column(
          children: [
            // SizedBox(height: 30,),
            Text("Choose your role",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 22,color: Colors.black),),
            SizedBox(height: 30,),
            ElevatedButton.icon(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLogin(),));
            }, icon: Icon(Icons.admin_panel_settings_rounded,color: Colors.black,), label: Text("Admin",style: TextStyle(color: Colors.black),),style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 181, 188, 194).withOpacity(0.7),padding: EdgeInsets.only(left: 60,right: 60))),
            SizedBox(height: 15,),
            // ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.maps_home_work,color: Colors.black,), label: Text("Resort",style: TextStyle(color: Colors.black)),style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 181, 188, 194).withOpacity(0.7),padding: EdgeInsets.only(left: 60,right: 60))),
            // SizedBox(height: 15,),
            ElevatedButton.icon(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
            }, icon: Icon(Icons.emoji_transportation,color: Colors.black,), label: Text("Host",style: TextStyle(color: Colors.black)),style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 181, 188, 194).withOpacity(0.7),padding: EdgeInsets.only(left: 55,right: 55))),
            SizedBox(height: 15,),
            ElevatedButton.icon(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserLogin(),));
            }, icon: Icon(Icons.person_2_rounded,color: Colors.black,), label: Text("User",style: TextStyle(color: Colors.black)),style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 181, 188, 194).withOpacity(0.7),padding: EdgeInsets.only(left: 64,right: 64))),
            
         
          ],
         ),
       ),
      )
    );
  }
}