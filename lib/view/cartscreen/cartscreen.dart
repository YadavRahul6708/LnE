import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahul/constants/textstyleconstants.dart';
import 'package:rahul/view/cartscreen/cartscreencontroller.dart';
import 'package:rahul/view/cartscreen/createproductscreen/createproductscreen.dart';
import 'package:rahul/view/profilescreen/profilescreen.dart';

class CartScreen extends StatefulWidget {
  final List journal;
  CartScreen({required this.journal});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List _journals2 = [];
  List _filteredJournals = [];
  bool _isloading2 = true;
  bool _showFavoritesOnly = false;

  Future<void> _deleteItem(int id) async {
    await CartSQLHelper.deleteItem(id);
    _refreshJournals2();
  }

  void _refreshJournals2() async {
    final data3 = await CartSQLHelper.getItems();
    setState(() {
      _journals2 = data3 ;
      _filteredJournals = _showFavoritesOnly
          ? _journals2.where((journal) => journal['favoritenumber'] == '1').toList()
          : _journals2;
      _isloading2 = false;
    });
  }


  @override
  void initState() {
    super.initState();
    print(widget.journal);
    if (widget.journal != null) {
      _refreshJournals2();
    }
    print('...number of items2 ${widget.journal}');
  }

  @override
  Widget build(BuildContext context) {
    _refreshJournals2();
    return
      Scaffold(
      backgroundColor: const Color(0xFFBDEFE6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8CECE),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Padding(
            padding: EdgeInsets.all(2),
          ),
        ),
        title: Text('Hello ${widget.journal[0]['name']}!', style: kTextStyleContinue,),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
            },
            icon: Icon(
              Icons.bookmark_add,
              color: _showFavoritesOnly ? Colors.red: Color(0xFFFFB32C) ,
              size: 35,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.black, size: 35),
            onPressed: () {
              Get.to(CreateProductScreen(
                id: null,
                twoOrOneButton: true,
              ));
            },
          ),
        ],
        leading: GestureDetector(
          onTap: () {
            print('Image Path: ${widget.journal}');
            if (widget.journal.isNotEmpty) {
              Get.to(ProfileScreen(
                id: widget.journal[0]['id'],
              ));
            }
          },
          child: CircleAvatar(
            backgroundImage: FileImage(File(widget.journal[0]['imagepath'])),
          ),
        ),
      ),
      body: _isloading2
          ? CircularProgressIndicator()
          : ListView.builder(
        itemCount: _filteredJournals.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Get.to(CreateProductScreen(
              id: _filteredJournals[index]['id'],
              journa: _filteredJournals,
              twoOrOneButton: false,
            ));
          },
          child: Card(
            color: const Color(0xFFF8CECE),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: _filteredJournals[index]['imagepath'] != null
                            ? Image(
                          image: FileImage(File(_filteredJournals[index]['imagepath'])),
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
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_filteredJournals[index]['title'], style: kTextStyleContinue),
                            const Text('Regular Price', style: kTextStyleRegularOrSalePrice),
                            Text('Rs ${_filteredJournals[index]['regularprice']}', style: kTextStyleContinue),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('', style: kTextStyleContinue),
                            const Text('Sale Price', style: kTextStyleRegularOrSalePrice),
                            Text('Rs ${_filteredJournals[index]['saleprice']}', style: kTextStyleContinue),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: _filteredJournals[index]['favoritenumber'] == '1'
                                ? const Icon(Icons.favorite, color: Colors.red, size: 30)
                                : const Icon(Icons.favorite_border, color: Colors.red, size: 30),
                          ),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'update',
                                child: Text('Update'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                              const PopupMenuItem(
                                value: 'product',
                                child: Text('Update Log'),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'update') {
                                Get.to(CreateProductScreen(
                                  id: _filteredJournals[index]['id'],
                                  journa: _filteredJournals,
                                  twoOrOneButton: true,
                                ));
                              } else if (value == 'delete') {
                                _deleteItem(_filteredJournals[index]['id']);
                              } else if (value == 'product') {
                                // Do something for 'Product' option
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(_filteredJournals[index]['description'], style: kTextStyleRegularOrSalePrice),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
