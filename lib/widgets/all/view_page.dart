import 'package:fax/pages/admin/admin_page.dart';
import 'package:fax/pages/classes/classes.dart';
import 'package:fax/pages/fax/fax.dart';
import 'package:fax/pages/persons/people.dart';
import 'package:flutter/material.dart';

class ViewPage extends StatefulWidget {
  final int page, child;
  ViewPage(this.page, this.child);
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
    return selectModule(widget.page, widget.child);
  }

  Widget selectModule(int page, int child) {
    switch (widget.page) {
      case 0:
        return Classes(child);
      case 1:
        return People(child);
      case 2:
        return Faxes(child);
      case 3:
        return AdminPage();
    }
  }
}
