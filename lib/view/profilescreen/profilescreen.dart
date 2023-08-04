import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahul/constants/textstyleconstants.dart';
import 'package:rahul/view/cartscreen/cartscreen.dart';
import 'package:rahul/view/loginscreen/controllerloginscreen.dart';
import 'package:rahul/view/profilescreen/controllerprofile.dart';
import 'package:rahul/widgets/buttons.dart';
import 'package:rahul/widgets/textfield.dart';

class ProfileScreen extends StatefulWidget {
  int? id;
  ProfileScreen({ this.id});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  List _journals = [];
  List _journal2=[];
  bool _isloading = true;
  String? destinationPath;
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
    TextEditingController _mobileNumberController=TextEditingController();

  void _refreshJournals() async {
    final data = await ProfileSQLHelper.getItems();
    setState(() {
      _journals = data;
      _isloading = false;
    });
  }

  Future<void> _refreshJorunals2() async {
    final data2 = await LoginSQLHelper.getItems();
    setState(() {
      _journal2 = data2;
      if (_journal2.isNotEmpty) {
        _mobileNumberController = TextEditingController(text: _journal2[0]['mobilenumber']);
      } else {
        _mobileNumberController = TextEditingController(text: '');
      }
    });
  }


  @override
  void initState() {
    super.initState();
    _showForm(widget.id);
    _initializeProfile();
  }

  void _initializeProfile() async {
    await _refreshJorunals2();
    _refreshJournals();

    if (_journal2.isNotEmpty) {
      print(_journal2[0]['mobilenumber']);
      _mobileNumberController = TextEditingController(text: _journal2[0]['mobilenumber']);
    } else {
      _mobileNumberController = TextEditingController();
    }
  }


  Future<void> _addItem() async {
    print('print$destinationPath');

    await ProfileSQLHelper.createItem(_nameTextController.text,
        _emailTextController.text,_journal2[0]['mobilenumber'] , destinationPath!);
  }

  Future<void> _updateItem(int id) async {
    await ProfileSQLHelper.updateItem(
        id,
        _nameTextController.text,
        _emailTextController.text,
        _mobileNumberController.text,
        destinationPath!);
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals!.firstWhere((element) => element['id'] == id);
      _nameTextController.text = existingJournal['name'];
      _emailTextController.text = existingJournal['email'];
      _mobileNumberController.text = existingJournal['number'];
      destinationPath = existingJournal['imagepath'];
    }
  }

  @override
  Widget build(BuildContext context) {
   _refreshJournals();

    return Scaffold(
      backgroundColor: const Color(0xFFBDEFE6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 35,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Center(
            child: Text(
          'SETUP YOUR PROFILE',
          style: kTextStyleAppBarText,
        )),
        backgroundColor: const Color(0xFFF8CECE),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      destinationPath =
                      (await ProfileSQLHelper.getImagePath())!;
                      setState(() {

                        _isloading =
                            true; // Set isLoading to true to display the progress indicator
                      });


                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.transparent,
                          backgroundImage: destinationPath != null
                              ? FileImage(File(destinationPath!))
                              : null,
                          child: destinationPath == null
                              ? const CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.black,
                                  ),
                                )
                              : null,
                        ),
                        // Show progress indicator if isLoading is true and no image is selected
                      ],
                    ),
                  ),
                  const SizedBox(height:10),
                  const Text(
                    'Add Profile Photo/Delete',
                    style: kTextStyleRegularOrSalePrice,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  textFieldForm('Full Name', Icons.person, _nameTextController,
                      TextInputType.text, 'Please enter full name'),
                  const SizedBox(
                    height: 20,
                  ),
                  textFieldForm('Email-ID', Icons.email, _emailTextController,
                      TextInputType.emailAddress, 'Please enter your email'),
                  const SizedBox(
                    height: 20,
                  ),
                  textFieldForm(
                    'Mobile Number',
                    Icons.mobile_screen_share_rounded,
                    _mobileNumberController,
                    TextInputType.number,
                    (_journal2.isNotEmpty && _journal2[0]['favoritenumber'] != null)
                        ? _journal2[0]['favoritenumber']!
                        : 'Mobile number not available',
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: buttonElevated(
                        (widget.id == null) ? 'Save' : 'Update Profile',
                        () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (widget.id == null) {
                          await _addItem();
                        }
                        if (widget.id != null) {
                          await _updateItem(widget.id!);
                        }
                        Get.to(() => CartScreen(
                              journal: _journals,
                            ));
                        Get.snackbar('Successfully created',
                            'Your profile created succesfully');
                      }
                      ;
                    }, kTextStyleContinue),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
