import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:rahul/constants/textstyleconstants.dart';
import 'package:rahul/view/profilescreen/profilescreen.dart';
import 'package:rahul/widgets/buttons.dart';
import 'package:rahul/widgets/textfield.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerify extends StatefulWidget {
  final String mobileNumber;
  bool isChecked;
  OtpVerify({required this.mobileNumber,required this.isChecked});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final _OtpController = TextEditingController();
  int _secondsRemaining = 60;
  late Timer _timer;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _saveRememberMeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', widget.isChecked);
  }



  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          _isResendEnabled = true;
        }
      });
    });
  }
  void restartTimer() {
    setState(() {
      _secondsRemaining = 60;
      _isResendEnabled = false;
      startTimer();
    });
  }

  String formatTime(int seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDEFE6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
            size:35,
          ), onPressed: () { Get.back();},
        ),
        title: const Center(child: Text('VERIFY OTP',style: kTextStyleAppBarText,)),
        backgroundColor: const Color(0xFFF8CECE),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Center(child: Text('Enter 6 digit OTP sent to',style: kTextStyleSixDigitText,)),
              const SizedBox(height: 10),
              Text(widget.mobileNumber,style: kTextStyleContinue,),
              const SizedBox(height: 30),
              Pinput(
                length: 6,
                controller:_OtpController,
                defaultPinTheme:  PinTheme(
                  height: 55,
                  width: 55,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFF8CECE),
                  ),

                ),


              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: buttonElevated('Verify OTP',
                    () async{
                          if ('686230' == _OtpController.text ){
                            widget.isChecked=true;
                            await _saveRememberMeStatus();
                            Get.to(ProfileScreen());
                            Get.snackbar('Successfully', 'Login Successfully');
                          }
                          else {

                            Get.snackbar('Error', 'OTP not matched');
                          }
                    },
                    kTextStyleContinue),
              ),

              const SizedBox(height: 30),
              Text(formatTime(_secondsRemaining),style: kTextStyleTimer,),
              const SizedBox(height: 30),
              const Text('Didn\'t receive any code ?',style: kTextStyleSixDigitText,),
              TextButton(
                onPressed: _isResendEnabled ? () {
                  restartTimer();
                  Get.snackbar('New Otp', 'Successfully got new otp ');} : null,
                child: const Text('Resend a new Code',style: kTextStyleResendTextButton,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
