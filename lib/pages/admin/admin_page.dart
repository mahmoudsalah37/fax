import 'package:dialog/dialogs/alert.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:fax/controllers/al_v2/controllers.dart';
import 'package:fax/controllers/users/users.dart';
import 'package:fax/models/pages/user_model.dart';
import 'package:fax/styles/all/all.dart';
import 'package:fax/styles/page/all/app_config.dart';
import 'package:fax/widgets/all/pages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

final _controller = ScrollController();

class AdminPage extends StatefulWidget {
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _isCheckAll = false;
  TextEditingController _tecUserName = TextEditingController(),
      _tecPassword = TextEditingController();
  int _permissions;
  List<int> _checks = List<int>();
  List<UsersModel> _data = List<UsersModel>(), _dataSearch = List<UsersModel>();
  AppConfig _ac;
  String _strSearch;

  List<bool> _isSelected;

  @override
  void initState() {
    _isSelected = [true, false, false, false];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('الأدمن');
    _ac = AppConfig(context);
    return Container(
      child: ListView(
        // shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          //Head
          _headPage(context),
          SizedBox(height: 4.0),
          //Body
          _bodyPage(),SizedBox(height: 8.0),
        ],
      ),
    );
  }

  //Head page
  Container _headPage(BuildContext context) {
    return Container(
      height: 40.0,
      color: colorContext,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10.0,
          ),
          //Page name
          nameHeadPage('الدعم'),
          Expanded(
            child: Container(),
          ),
          //Search Icon
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              child: Icon(
                Icons.search,
                color: colorIcon,
              ),
              onTap: () async {
                setState(() {});
              },
            ),
          ),
          //Search text
          Container(
            width: 178.0,
            child: Row(
              children: <Widget>[
                SizedBox(width: 20.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    width: 150,
                    height: 37.0,
                    color: Colors.white,
                    child: TextField(
                      maxLines: 1,
                      onChanged: (String v) async {
                        _strSearch = v.trim().toLowerCase();
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.0),
          //Delete icon
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              child: Icon(
                Icons.delete,
                color: colorIcon,
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildDeleteDialog(context),
                );
              },
            ),
          ),
          SizedBox(width: 20.0),
          //Add new item
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: colorIcon,
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    'إضافة جديد',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              onTap: () {
                _tecClear();
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildAddOrUpdateDialog(
                      context, 'إضافة عنصر جديد', -1, true),
                );
              },
            ),
          ),
          SizedBox(width: 20.0),
          SizedBox(width: 20.0),
        ],
      ),
    );
  }

  void _tecClear() {
    _tecUserName.clear();
    _tecPassword.clear();
  }

  //Body page
  Container _bodyPage() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          //Head table
          _headTable(),
          SizedBox(height: 8.0),
          //Body table
          _bodyTable()
        ],
      ),
    );
  }

  //Head table
  Container _headTable() {
    return Container(
      height: 40.0,
      decoration: myBoxDecoration(),
      //Columns Heads
      child: Row(
        children: <Widget>[
          Checkbox(
            value: this._isCheckAll,
            activeColor: colorCheckBox,
            onChanged: (bool isCheck) async {
              this._isCheckAll = isCheck;
              setState(() {});
            },
          ),

          Expanded(
            child: nameColumnTable('الإذونات'),
          ),
          Expanded(
            child: nameColumnTable('الرقم السري'),
          ),
          Expanded(
            child: nameColumnTable('الاسم'),
          ),
          SizedBox(
            width: 15.0,
          ),
          // Expanded(
          //   child: nameColumnTable('الرقم التسلسلي'),
          // ),
          Opacity(
            opacity: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: 20.0,
                width: 40.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Body table
  Container _bodyTable() {
    return Container(
      height: _ac.rH(75.0),
      //rows
      child: FutureBuilder<List<UsersModel>>(
        future: getDataUsers(),
        builder:
            (BuildContext context, AsyncSnapshot<List<UsersModel>> snapshot) {
          _data = snapshot.data;
          if (snapshot.hasData) {
            if (_strSearch != null && _strSearch != '')
              _dataSearch = getDataSearch(_data, _strSearch);
            else
              _dataSearch = _data;
            if (_checks.isNotEmpty) _checks.clear();
            if (_isCheckAll)
              _dataSearch.forEach((data) => _checks.add(data.id));
            return DraggableScrollbar.arrows(
              backgroundColor: Colors.blue,
              alwaysVisibleScrollThumb:
                  true, //use this to make scroll thumb always visible
              // labelTextBuilder: (double offset) => Text("${offset ~/ 100}"),
              controller: _controller,
              child: ListView.builder(
                controller: _controller,
                scrollDirection: Axis.vertical,
                itemCount: _dataSearch.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        StatefulBuilder(
                          builder: (BuildContext context, setState) {
                            return Checkbox(
                              value: _checks.contains(_dataSearch[index].id),
                              activeColor: colorCheckBox,
                              onChanged: (bool isCheck) async {
                                int id = _dataSearch[index].id;
                                isCheck ? _checks.add(id) : _checks.remove(id);
                                setState(() {});
                              },
                            );
                          },
                        ),
                        Expanded(
                          child: dataCellRow(
                              permissionSwitch(_dataSearch[index].permission)),
                        ),
                        Expanded(
                          child: dataCellRow(_dataSearch[index].password),
                        ),
                        Expanded(
                          child: dataCellRow(_dataSearch[index].userName),
                        ),
                        // Expanded(
                        //   child: dataCellRow(_dataSearch[index].id.toString()),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            child: Icon(
                              Icons.visibility,
                              color: Colors.blue,
                            ),
                            onTap: () {
                              _tecUserName.text = _dataSearch[index].userName;
                              _tecPassword.text = _dataSearch[index].password;
                              _permissions = _dataSearch[index].permission;
                              for (int i = 0; i < _isSelected.length; i++)
                                if (i <= _permissions)
                                  _isSelected[i] = true;
                                else
                                  _isSelected[i] = false;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildViewDialog(
                                        context, 'عرض البيانات', index),
                              );
                            },
                          ),
                        ),
                        //Edit icon
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            onTap: () {
                              _tecUserName.text = _dataSearch[index].userName;
                              _tecPassword.text = _dataSearch[index].password;
                              _permissions = _dataSearch[index].permission;
                              for (int i = 0; i < _isSelected.length; i++)
                                if (i <= _permissions)
                                  _isSelected[i] = true;
                                else
                                  _isSelected[i] = false;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildAddOrUpdateDialog(
                                        context,
                                        'تعديل البيانات',
                                        _dataSearch[index].id,
                                        false),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {}
          return Container(child: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }

  Widget _columnData() {
    return SingleChildScrollView(
      child: Form(
        key: _globalKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 8.0),
            TextFormField(
              maxLines: 1,
              controller: _tecUserName,
              validator: (String v) {
                String value = v.trim();
                if (value.isEmpty) return 'الخانة فارغة';
                return null;
              },
              decoration: InputDecoration(
                labelText: 'الاسم',
                labelStyle: TextStyle(
                  color: colorLabelText,
                ),
                hintText: '',
                hintStyle: TextStyle(
                  color: colorHintText,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              maxLines: 1,
              controller: _tecPassword,
              decoration: InputDecoration(
                labelText: 'الباسورد',
                labelStyle: TextStyle(
                  color: colorLabelText,
                ),
                hintText: '',
                hintStyle: TextStyle(
                  color: colorHintText,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Center(
              child: StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return ToggleButtons(
                    borderColor: Colors.green[200],
                    fillColor: Colors.green,
                    borderWidth: 2,
                    selectedBorderColor: Colors.green,
                    selectedColor: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'قراءة',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'إضافة',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'تعديل',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'أدمن',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        _permissions = index;
                        for (int i = 0; i < _isSelected.length; i++) {
                          if (i <= index)
                            _isSelected[i] = true;
                          else
                            _isSelected[i] = false;
                        }
                      });
                    },
                    isSelected: _isSelected,
                  );
                },
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  //Add item
  Widget _buildAddOrUpdateDialog(
      BuildContext context, String strTitle, int id, bool isAdd) {
    return AlertDialog(
      title: Text(strTitle),
      content: _columnData(),
      actions: <Widget>[
        FlatButton(
          highlightColor: colorFlatHighLightPositive,
          hoverColor: colorFlatHoverPositive,
          onPressed: () async {
            if (_globalKey.currentState.validate()) {
              Response response;
              if (isAdd) {
                Map<String, dynamic> mapData = Map<String, dynamic>();
                mapData['user_name'] = _tecUserName.text.trim();
                mapData['password'] = _tecPassword.text.trim();
                mapData['permission'] = _permissions.toString();
                response = await postData(strPath, mapData);
              } else {
                Map<String, dynamic> mapData = Map<String, dynamic>();
                mapData['id'] = id.toString();
                mapData['user_name'] = _tecUserName.text.trim();
                mapData['password'] = _tecPassword.text.trim();
                mapData['permission'] = _permissions.toString();
                response = await editData(strPath, mapData);
              }
              if (response.statusCode >= 200 && response.statusCode <= 299) {
                if (!isAdd) Navigator.of(context).pop();
                _tecClear();
                setState(() {});
              } else {
                alert('حدث خطاء أثناء الإتصال بقاعدة البيانات');
              }
            }
          },
          textColor: colorPositiveText,
          child: const Text('حفظ'),
        ),
        FlatButton(
          highlightColor: colorFlatHighLightNegative,
          hoverColor: colorFlatHoverNegative,
          onPressed: () async {
            Navigator.of(context).pop();
          },
          textColor: colorNegativeText,
          child: const Text('الغاء'),
        ),
      ],
    );
  }

  Widget _buildViewDialog(BuildContext context, String strTitle, int index) {
    return AlertDialog(
      title: Text(strTitle),
      content: _columnData(),
      actions: <Widget>[
        FlatButton(
          highlightColor: colorFlatHighLightNegative,
          hoverColor: colorFlatHoverNegative,
          onPressed: () async {
            Navigator.of(context).pop();
          },
          textColor: colorNegativeText,
          child: const Text('اغلاق'),
        ),
      ],
    );
  }

  // Delete items
  Widget _buildDeleteDialog(BuildContext context) {
    return AlertDialog(
      title: Text('عنصر ${_checks.length} حذف'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[],
      ),
      actions: <Widget>[
        FlatButton(
          highlightColor: colorFlatHighLightNegative,
          hoverColor: colorFlatHoverNegative,
          onPressed: () async {
            bool done = false;
            if (_checks.isNotEmpty) {
              done = await deleteData(strPath, _checks);
            }
            if (done) {
              this._isCheckAll = false;
              _checks.clear();
              Navigator.of(context).pop();
            } else {
              alert('حدث خطاء أثناء الإتصال بقاعدة البيانات');
            }
            setState(() {});
          },
          textColor: colorNegativeText,
          child: const Text('حذف'),
        ),
        FlatButton(
          highlightColor: colorFlatHighLightPositive,
          hoverColor: colorFlatHoverPositive,
          onPressed: () async {
            Navigator.of(context).pop();
          },
          textColor: colorPositiveText,
          child: const Text('الغاء'),
        ),
      ],
    );
  }
}
