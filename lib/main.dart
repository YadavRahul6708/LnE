import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahul/view/loginscreen/loginscreen.dart';
import 'package:rahul/view/otpverifyscreen/otpverifyscreen.dart';
import 'package:rahul/view/profilescreen/profilescreen.dart';
import 'package:rahul/view/splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  bool isOTPFilled = await checkOTPStatus();

  runApp(MyApp(isOTPFilled: isOTPFilled));

}
Future<bool> checkOTPStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isOTPFilled = prefs.getBool('isOTPFilled') ?? false;
  return isOTPFilled;
}

class MyApp extends StatelessWidget {
  final bool isOTPFilled;

  MyApp({this.isOTPFilled = false});
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      home: SplashScreen(),



    );
  }
}
