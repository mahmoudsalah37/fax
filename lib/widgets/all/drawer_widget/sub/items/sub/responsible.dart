import 'package:flutter/material.dart';
import 'package:fax/models/page_model.dart';
import 'package:fax/packages/font_size/auto_size_text.dart';
import 'package:fax/packages/provider/src/provider.dart';
import 'package:fax/styles/drawer_widget/items/style_item.dart';

import '../../../../view_page.dart';

class Responsible extends StatefulWidget {
  _ResponsibleState createState() => _ResponsibleState();
}

class _ResponsibleState extends State<Responsible> {
  bool show = false, isHover0 = false, isHover1 = false;
  double x = 1.0;
  IconData icon = Icons.expand_more;
  @override
  Widget build(BuildContext context) {
    final page = Provider.of<PageModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white,
                width: x,
              ),
              top: BorderSide(
                color: Colors.white,
                width: 1.0,
              ),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                        height: 20.0,
                        width: 20.0, // fixed width and height
                        child: Image.asset('icons/hr.png')),
                  ),
                  Expanded(
                    child: AutoSizeText(
                      'المسوْلين',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      minFontSize: 8.0,
                      maxFontSize: 25.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                    width: 20.0, // fixed width and height
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                setState(() {
                  show = !show;
                  if (show) {
                    x = 0.0;
                    icon = Icons.expand_less;
                  } else {
                    x = 1.0;
                    icon = Icons.expand_more;
                  }
                });
              },
            ),
          ),
        ),

        //sub
        Visibility(
          visible: show,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //QMS Responsible
              InkWell(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 35.0, bottom: 8.0),
                  child: Text(
                    '• الرتب',
                    style:
                        TextStyle(color: isHoverItem(isHover0), fontSize: 18.0),
                    textAlign: TextAlign.left,
                  ),
                ),
                onHover: (bool onHover) async {
                  isHover0 = onHover;
                  setState(() {});
                },
                onTap: () async {
                  Navigator.of(context).pop();
                  page.setViewPage(ViewPage(1, 0));
                  //popNavigationBarMenu(context);
                },
              ),
              //Exclusions
              InkWell(
                child: Padding(
                  padding: EdgeInsets.only(left: 35.0, bottom: 8.0),
                  child: Text(
                    '• الأشخاص',
                    style:
                        TextStyle(color: isHoverItem(isHover1), fontSize: 18.0),
                    textAlign: TextAlign.left,
                  ),
                ),
                onHover: (bool onHover) async {
                  isHover1 = onHover;
                  setState(() {});
                },
                onTap: () async {
                  Navigator.of(context).pop();
                  page.setViewPage(ViewPage(1, 1));
                  // //popNavigationBarMenu(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
