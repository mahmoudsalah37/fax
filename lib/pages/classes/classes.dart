import 'package:fax/pages/classes/sub/main_class_page.dart';
import 'package:fax/pages/classes/sub/sub_class_page.dart';
// import 'package:fax/pages/classes/sub/sub_class_page.dart';
import 'package:flutter/material.dart';

class Classes extends StatefulWidget {
  final int child;
  Classes(this.child);
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  @override
  Widget build(BuildContext context) {
    return widget.child == 0
        ? MainCLassPage()
        // : widget.child == 1 ? SubCLassPage()
        : SubClassPage();
  }
}
