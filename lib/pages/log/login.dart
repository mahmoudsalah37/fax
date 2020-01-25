import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:fax/controllers/users/users.dart';
import 'package:fax/models/page_model.dart';
import 'package:fax/models/pages/user_model.dart';
import 'package:fax/packages/provider/provider.dart';
import 'package:fax/pass/value.dart';
import 'package:fax/widgets/all/view_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  bool _isVisible = false;
  String _text = '';
  Widget _icon = CircularProgressIndicator();
  List<UsersModel> _users;

  var _tecuserName = TextEditingController(),
      _tecPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    getUsersList();
    final emailField = TextField(
      controller: _tecuserName,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "الاسم",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      controller: _tecPassword,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "الباسورد",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          //print('${_tecuserName.text.trim()}:${_tecPassword.text.trim()}');

          if (await checkValid(
              _tecuserName.text.trim(), _tecPassword.text.trim())) {
            final page = Provider.of<PageModel>(context);
            page.setViewPage(ViewPage(0, 0));
          }
        },
        child: Text("دخول",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 700),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 155.0,
                      child: Icon(
                        Icons.filter_hdr,
                        color: Colors.blue,
                        semanticLabel: 'logo',
                        size: 70.0,
                      ),
                    ),
                    SizedBox(height: 45.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        EasyStatefulBuilder(
            identifier: 'loginPage',
            builder: (BuildContext context, data) {
              return Visibility(
                visible: _isVisible,
                child: alertDialog(context, _text, _icon),
              );
            }),
      ],
    );
  }

  Widget alertDialog(BuildContext context, String title, Widget icon) {
    return Center(
      child: Container(
        color: Colors.grey,
        height: 200,
        width: 200,
        child: Card(
          color: Colors.grey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              Text(
                title,
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getUsersList() async {
    _users = await getDataUsers();
  }

  Future<bool> checkValid(String userName, String password) async {
    _isVisible = true;
    _text = 'جاري التحميل';
    _icon = CircularProgressIndicator();
    EasyStatefulBuilder.setState('loginPage', (state) {});

    if (_users.isEmpty) {
      await Future.delayed(const Duration(seconds: 2), () {});
      _text = 'فشل لايوجد مستخدمين';
      _icon = Icon(
        Icons.error,
        color: Colors.yellow,
      );
      EasyStatefulBuilder.setState('loginPage', (state) {});
      await Future.delayed(const Duration(seconds: 2), () {});
      _isVisible = false;
      EasyStatefulBuilder.setState('loginPage', (state) {});

      return false;
    }
    for (UsersModel user in _users) {
      //print('${user.userName}:${user.password}');
      if (user.userName == userName && user.password == password) {
        _text = '${user.userName} اهلا بك';
        _icon = Icon(
          Icons.tag_faces,
          color: Colors.green,
        );
        EasyStatefulBuilder.setState('loginPage', (state) {});
        currentUser = user;
        await Future.delayed(const Duration(seconds: 2), () {});
        _isVisible = false;
        EasyStatefulBuilder.setState('loginPage', (state) {});
        return true;
      }
    }
    _text = 'غير صحيح';
    _icon = Icon(
      Icons.warning,
      color: Colors.red,
    );
    EasyStatefulBuilder.setState('loginPage', (state) {});
    await Future.delayed(const Duration(seconds: 2), () {});
    _isVisible = false;
    EasyStatefulBuilder.setState('loginPage', (state) {});
    return false;
  }
}
