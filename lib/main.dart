import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:journease/adminmodule/adminhome.dart';
import 'package:journease/adminmodule/resortapproval.dart';
import 'package:journease/authentication/hostlogin.dart';
import 'package:journease/authentication/hostsignup.dart';
import 'package:journease/firebase_options.dart';
import 'package:journease/hotelorpackagemodule/hosthomepage.dart';
import 'package:journease/hotelorpackagemodule/listproperty.dart';
import 'package:journease/hotelorpackagemodule/propertydetails.dart';
import 'package:journease/hotelorpackagemodule/resortreg.dart';
import 'package:journease/hotelorpackagemodule/roomtype.dart';
import 'package:journease/splashscreen.dart';
import 'package:journease/usermodule/screens/Home1.dart';
import 'package:journease/usermodule/screens/booknowpackage.dart';
import 'package:journease/usermodule/screens/generaldetails.dart';
import 'package:journease/usermodule/screens/goibibo.dart';
import 'package:journease/usermodule/screens/home.dart';
import 'package:journease/usermodule/screens/hotelontap.dart';
import 'package:journease/usermodule/screens/hotels.dart';
import 'package:journease/usermodule/screens/hotelsearch.dart';
import 'package:journease/authentication/login.dart';
import 'package:journease/usermodule/screens/makemytrip.dart';
import 'package:journease/usermodule/screens/myaccount.dart';
import 'package:journease/usermodule/screens/navigation.dart';
import 'package:journease/usermodule/screens/packages.dart';
import 'package:journease/usermodule/screens/reviewhotelbooking.dart';
import 'package:journease/usermodule/screens/reviewpackagebooking.dart';
import 'package:journease/usermodule/screens/room.dart';
import 'package:journease/usermodule/screens/savedcotraveller.dart';
import 'package:journease/usermodule/screens/placesapi.dart';
import 'package:journease/usermodule/screens/searchpackage.dart';
import 'package:journease/usermodule/screens/selectroom.dart';
import 'package:journease/usermodule/screens/startingfrom2.dart';
import 'package:journease/authentication/startpage.dart';
import 'package:journease/usermodule/screens/testt.dart';
import 'package:journease/usermodule/screens/userlogin.dart';
import 'package:journease/usermodule/screens/wheretogo.dart';
import 'package:journease/test.dart';
import 'package:journease/usermodule/screens/tripdetails.dart';
import 'package:journease/usermodule/screens/cotraveller.dart';
import 'package:journease/test3.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:journease/usermodule/usersignuplogin.dart';
import 'firebase_options.dart';

void main() async{
// ...
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journease',
      
      home: SplashScreen()
    );
  }
}

