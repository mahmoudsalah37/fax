// import 'package:fax/pages/Faxes/sub/sub_class_page.dart';
import 'package:fax/pages/fax/Sub/fax._page.dart';
import 'package:flutter/material.dart';

class Faxes extends StatefulWidget {
  final int child;
  Faxes(this.child);
  _FaxesState createState() => _FaxesState();
}

class _FaxesState extends State<Faxes> {
  @override
  Widget build(BuildContext context) {
    return widget.child == 0 ? FaxPage() : FaxPage();
  }
}
