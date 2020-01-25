import 'package:flutter/material.dart';
import 'sub/items/items.dart';

class DrawerWidget extends StatefulWidget {
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: MediaQuery.of(context).size.width <=1024? MediaQuery.of(context).size.width * 0.85:
      MediaQuery.of(context).size.width * 0.30,

      child: Container(
        decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [Colors.cyan, Colors.indigo],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp
        ),
      ),
      child: items(),
      ),
    );
  }
}
