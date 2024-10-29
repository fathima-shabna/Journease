import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({super.key, this.label, this.controller, this.validator, this.obscureText, this.suffixIcon});

  final label;
  final controller;
  final validator;
  final obscureText;
  final suffixIcon;



  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: controller,
      validator: validator,
      obscureText: obscureText??false,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        
                    // isCollapsed: true,
                    suffixIcon: suffixIcon??SizedBox(),
                    contentPadding: EdgeInsets.all(12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 2,
                        color: Colors.black45,
                      )),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.black45,
                        )
                      ),
                      labelText: label,
                      labelStyle: TextStyle(fontSize: 15,color: Colors.white54)),
                );
    
  }
}