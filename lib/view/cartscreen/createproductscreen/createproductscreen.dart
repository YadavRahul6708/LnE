import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahul/constants/textstyleconstants.dart';

import 'package:rahul/view/cartscreen/cartscreencontroller.dart';
import 'package:rahul/widgets/buttons.dart';
import 'package:rahul/widgets/textfield.dart';


class CreateProductScreen extends StatefulWidget {
  var id;
  List? journa;
  bool twoOrOneButton;
  CreateProductScreen({required this.id,required this.twoOrOneButton, this.journa});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _regularpriceController = TextEditingController();
  final TextEditingController _salepriceController = TextEditingController();
  String? destinationPath;
  bool _isFavorite =true;
  String favoriteNumber='1' ;


  Future<void> _addItem() async {
    await CartSQLHelper.createItem(
        _titleController.text, _descriptionController.text, destinationPath,_regularpriceController.text,_salepriceController.text,favoriteNumber!);
  }

  Future<void> _updateItem(int id) async {
    await CartSQLHelper.updateItem(id, _titleController.text,
        _descriptionController.text, destinationPath,_regularpriceController.text,_salepriceController.text,favoriteNumber!);
  }
  Future<void> _deleteItem() async {
    if (widget.id != null) {
      await CartSQLHelper.deleteItem(widget.id);
    }
    Navigator.of(context).pop();
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
      widget.journa!.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
      destinationPath = existingJournal['imagepath'];
      _regularpriceController.text=existingJournal['regularprice'];
      _salepriceController.text=existingJournal['regularprice'];
      favoriteNumber=existingJournal['favoritenumber'];

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showForm(widget.id);
    if(_isFavorite=false){
      favoriteNumber='0';
    }
    else if(_isFavorite=true){
      favoriteNumber='1';

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDEFE6),
      appBar:AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
            size:35,
          ), onPressed: () { Get.back();},
        ),
        title: (widget.twoOrOneButton)?((widget.id==null)? const Text('CREATE PRODUCT',style: kTextStyleAppBarText,):const Text('UPDATE PRODUCT',style: kTextStyleAppBarText,)):const Text('PRODUCT DETAILS',style: kTextStyleAppBarText,),
        backgroundColor: const Color(0xFFF8CECE),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text('Product Name',style: kTextStyleRegularOrSalePrice,),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8CECE),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Product Name',
                      contentPadding: EdgeInsets.all(10),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Product Description',style: kTextStyleRegularOrSalePrice,),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8CECE),
                    borderRadius: BorderRadius.circular(5)),

                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Product Description',
                      contentPadding: EdgeInsets.all(35),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 150,
                        child: Text('Regular Price',style: kTextStyleRegularOrSalePrice,)),

                    SizedBox(
                        width: 150,
                        child: Text('Sale Price',style: kTextStyleRegularOrSalePrice,)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                        child: textFieldForm('Price', Icons.currency_rupee, _regularpriceController, TextInputType.number,'Please enter the regular price')),

                    SizedBox(
                        width: 150,
                        child: textFieldForm('Price',Icons.currency_rupee, _salepriceController, TextInputType.number,'Please enter the sale price')),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: _isFavorite
                          ? const Icon(Icons.favorite,size: 30,)
                          : const Icon(Icons.favorite_border,size: 30,),
                      color: Colors.red,
                      onPressed: () {
                        _isFavorite = !_isFavorite;
                        if (_isFavorite == true) {
                          favoriteNumber = '1';
                        } else {
                          favoriteNumber = '0';
                        }

                        setState(() {});
                      },
                    ),
                   // SizedBox(width: 8,),
                    const Text('Make the product as favorite',style: kTextStyleRegularOrSalePrice,)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        destinationPath = (await CartSQLHelper.getImagePath())!;
                        setState(() {});
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: destinationPath != null
                              ? Image.file(
                            File(destinationPath!),
                            fit: BoxFit.cover,
                          )
                              : Container(
                            color: Colors.grey,
                            child: const Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                (widget.twoOrOneButton)?SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: buttonElevated((widget.id == null ? 'Create New' : 'Update'),
                          () async {
                        if (widget.id == null) {
                          await _addItem();
                        }
                        if (widget.id != null) {
                          await _updateItem(widget.id);
                        }
                        _titleController.text = '';
                        _descriptionController.text = '';

                        Navigator.of(context).pop();
                      },
                      kTextStyleContinue),
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 40,
                      child:buttonElevated('Update',() async {

                        if (widget.id != null) {
                          await _updateItem(widget.id);
                        }
                        _titleController.text = '';
                        _descriptionController.text = '';

                        Navigator.of(context).pop();
                      },  kTextStyleContinue),
                    ),
                    SizedBox(
                      width: 150,
                      height: 40,
                      child:buttonElevated('Delete', ()async{
                        await _deleteItem();
                      }, kTextStyleContinue),
                    )

                  ],)


              ],
            ),
          ),
        ),
      ),
    );
  }
}
