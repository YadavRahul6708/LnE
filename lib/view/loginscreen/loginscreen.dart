import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahul/constants/textstyleconstants.dart';
import 'package:rahul/view/loginscreen/controllerloginscreen.dart';
import 'package:rahul/view/otpverifyscreen/otpverifyscreen.dart';
import 'package:rahul/view/profilescreen/profilescreen.dart';
import 'package:rahul/widgets/buttons.dart';
import 'package:rahul/widgets/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mobileNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _journals3 = [];
  final bool _isloading = true;
  bool _isChecked=false;




  Future<void> _addItem() async {
    await LoginSQLHelper.createItem(_mobileNumberController.text,
        );
  }



  @override
  void initState() {
    super.initState();
    _loadRememberMeStatus();
  }
  Future<void> _loadRememberMeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isChecked = prefs.getBool('rememberMe') ?? false;
      if (_isChecked) {
        Get.offAll(ProfileScreen()); // Directly navigate to HomeScreen
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDEFE6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF8CECE),
        title: const Center(child: Text('LOGIN',style:kTextStyleAppBarText,)),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset('images/splashscreenimage.png')),
                  const SizedBox(
                    height: 20,
                  ),
                  textFieldForm(
                      'Mobile Number',
                      Icons.mobile_screen_share_rounded,
                      _mobileNumberController,

                      TextInputType.number,'Please enter the number'),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: buttonElevated('Continue', () async{

                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await _addItem();
                        Get.to(OtpVerify(
                            mobileNumber: _mobileNumberController.text,isChecked: _isChecked,));
                        Get.snackbar('Otp Sent Successfully','Verify Your Otp');

                      };


                    },kTextStyleContinue),
                  )
                  // ElevatedButton(
                  //   style:ElevatedButton.styleFrom(backgroundColor:const Color(0xFFF8CECE), ) ,
                  //
                  //     onPressed: (){
                  //       if (_formKey.currentState!.validate()) {
                  //         _formKey.currentState!.save();
                  //         Get.to(OtpVerify(mobileNumber: _mobileNumberController.text));
                  //
                  //       }
                  //
                  //
                  //
                  // }, child: const Text('Continue'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
