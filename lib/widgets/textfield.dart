import 'package:flutter/material.dart';

Widget textFieldForm(String? hintText, IconData iconData, TextEditingController controller, TextInputType keyboardType, String validationText) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF8CECE),
      borderRadius: BorderRadius.circular(5),
    ),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? validationText : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(3.0),
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                iconData,
                color: Color(0xFFF8CECE),
              ),
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        hintText: hintText,
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
  );
}

Widget textField(Controller){
  return Container(
    height: 45,
    width: 45,
    color: Colors.orangeAccent,
    child: TextFormField(
      controller: Controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder()
      ),
    ),
  );

}