import 'package:fax/models/page_model.dart';
import 'package:fax/packages/provider/provider.dart';
import 'package:fax/pass/value.dart';
import 'package:fax/styles/page/all/app_config.dart';
import 'package:fax/widgets/all/drawer_widget/drawer_widget.dart';
import 'package:flutter/material.dart';

import 'package:gradient_app_bar/gradient_app_bar.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AppConfig ac;
  @override
  Widget build(BuildContext context) {
    ac = AppConfig(context);
    final page = Provider.of<PageModel>(context);
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: GradientAppBar(
        title: Text(
          'الفاكسات',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColorStart: Colors.indigo,
        backgroundColorEnd: Colors.cyan,
      ),
      drawer: currentUser == null ? Container() : DrawerWidget(),
      body: SafeArea(
        child: Container(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              //Drawer
              Visibility(
                visible: false,
                child: Container(
                  width: ac.rW(20),
                  child: DrawerWidget(),
                ),
              ),

              //View
              Container(
                width: MediaQuery.of(context).size.width * 1.0,
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 1.0,
                ),
                color: Colors.grey[200],
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: page.getViewPage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
