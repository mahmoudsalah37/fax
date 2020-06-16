import 'package:fax/pages/log/login.dart';
import 'package:flutter/material.dart';
import 'package:fax/models/page_model.dart';
import 'package:fax/packages/provider/provider.dart';

import 'home/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الفاكسات',
      theme: ThemeData(),
      home: ChangeNotifierProvider<PageModel>(
        child: Home(),
        create: (BuildContext context) {
          return PageModel(LoginPage());
        },
      ),
    );
  }
}
