import 'package:fax/pass/value.dart';
import 'package:fax/widgets/all/drawer_widget/sub/items/sub/admin.dart';
import 'package:fax/widgets/all/drawer_widget/sub/items/sub/class.dart';
import 'package:fax/widgets/all/drawer_widget/sub/items/sub/fax.dart';
import 'package:fax/widgets/all/drawer_widget/sub/items/sub/responsible.dart';
import 'package:flutter/material.dart';

Widget items() {
  return ListView(
    shrinkWrap: true,
    children: <Widget>[
      SizedBox(height: 5.0),
      CLass(),
      Responsible(),
      Fax(),
      if (currentUser.permission >= 3) Admin(),
      SizedBox(height: 50.0)
    ],
  );
}
