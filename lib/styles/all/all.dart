import 'package:flutter/material.dart';

/*Color*/
 Gradient colorMain = new LinearGradient(
            colors: [Colors.red, Colors.blue],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp
        );
const Color colorSubMain = Color.fromRGBO(15, 64, 138, 1.0);
final Color colorContext = Colors.black87;
//final Color colorContext = Color.fromRGBO(20, 70, 140, 1.0);
final Color colorFlatHoverPositive = Colors.blueAccent[100];
final Color colorFlatHoverNegative = Colors.redAccent[100];
final Color colorFlatHighLightPositive = Colors.blueAccent[300];
final Color colorFlatHighLightNegative = Colors.redAccent[300];
final Color colorPositiveText = Colors.blue;
final Color colorNegativeText = Colors.red;
final Color colorHintText = Colors.blueAccent[100];
final Color colorLabelText = Colors.blueAccent[100];
final Color colorCheckBox = Colors.blueAccent[200];
const Color colorIcon = Colors.white;


/*Text style*/
final TextStyle textStyleColumnText = TextStyle( color: Colors.black,fontWeight: FontWeight.bold);
const TextStyle tsMainText = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 18.0
);
