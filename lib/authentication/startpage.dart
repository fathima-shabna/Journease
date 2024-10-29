import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:journease/authentication/login.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          ShaderMask(shaderCallback:  ( Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.7,1.0],
              colors: [Color.fromARGB(255, 210, 227, 240).withOpacity(0.9),Colors.transparent]).createShader(bounds);
          },
          
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/start.jpg"),fit: BoxFit.fill)
            ),
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text("JournEase",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35)),
               Text("Making your trip easy",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 25)),
               SizedBox(height: 40,),
               Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                showModalBottomSheet(
                  backgroundColor: 
                  Color.fromARGB(255, 200, 216, 229).withOpacity(0.7),
                  // Colors.transparent.withOpacity(0.3),
                  barrierColor: Colors.black54,
                  context: context, builder: (context) {
                  return Login();
                },);
              }, child: Row(
                children: [
                  Text("Get Started",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward,size: 22,color: Colors.black,),
                ],
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
              ),
              SizedBox(width: 10,),
              // ElevatedButton(onPressed: (){}, child: Text("SignUp",style: TextStyle(color: Colors.black),),style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white),side: MaterialStatePropertyAll(BorderSide(color: Colors.black))),)

            ],
          )
             ],
           ), 
          ),
          ),
          
          
        ],
      ),
    );
  }
}