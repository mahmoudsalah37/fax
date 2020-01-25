import 'package:flutter/material.dart';

import 'package:fax/pages/persons/sub/person.dart';
import 'package:fax/pages/persons/sub/rank.dart';

class People extends StatefulWidget {
  final int child;
  People(this.child);
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  @override
  Widget build(BuildContext context) {
    return widget.child == 0 ? RankPage() : PersonPage();
  }
}
