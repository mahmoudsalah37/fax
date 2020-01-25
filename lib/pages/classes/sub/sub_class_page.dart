import 'package:dialog/dialog.dart';
import 'package:fax/controllers/al_v2/controllers.dart';
import 'package:fax/controllers/classes/main_class_controller.dart' as mc;
import 'package:fax/controllers/classes/sub_class_controller.dart';
import 'package:fax/models/pages/main_class_model.dart';
import 'package:fax/models/pages/sub_class_model.dart';
import 'package:fax/pass/value.dart';
import 'package:fax/styles/all/all.dart';
import 'package:fax/styles/page/all/app_config.dart';
import 'package:fax/widgets/all/pages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SubClassPage extends StatefulWidget {
  _SubClassPageState createState() => _SubClassPageState();
}

class _SubClassPageState extends State<SubClassPage> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _isCheckAll = false;
  TextEditingController _tecNameMainClass = TextEditingController();
  List<int> _checks = List<int>();
  List<SubClassModel> _data = List<SubClassModel>(),
      _dataSearch = List<SubClassModel>();
  List<MainClassModel> _mainClassList = List<MainClassModel>();
  AppConfig _ac;
  String _strSearch;
  int _mainClassID = -1;
  @override
  Widget build(BuildContext context) {
    _getDataSubClass();
    print('القسم ألفرعي');
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
          _bodyPage()
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
          nameHeadPage('الأقسام الفرعية'),
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
          if (currentUser.permission >= 2)
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
          if (currentUser.permission >= 1)
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
                        context, 'إضافة عنصر', -1, true),
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
    _tecNameMainClass.clear();
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
            child: nameColumnTable('القسم الفرعي'),
          ),
          Expanded(
            child: nameColumnTable('القسم الرئيسي'),
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
      height: _ac.rH(80.0),
      //rows
      child: FutureBuilder<List<SubClassModel>>(
        future: getDataSubClasses(),
        builder: (BuildContext context,
            AsyncSnapshot<List<SubClassModel>> snapshot) {
          _data = snapshot.data;
          if (snapshot.hasData) {
            if (_strSearch != null && _strSearch != '')
              _dataSearch = getDataSearchSubClass(_data, _strSearch);
            else
              _dataSearch = _data;
            if (_checks.isNotEmpty) _checks.clear();
            if (_isCheckAll)
              _dataSearch.forEach((data) => _checks.add(data.id));
            return ListView.builder(
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
                        child: dataCellRow(_dataSearch[index].name),
                      ),
                      Expanded(
                        child: dataCellRow(_dataSearch[index].mainClass.name),
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
                            _tecNameMainClass.text = _dataSearch[index].name;
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
                      if (currentUser.permission >= 2)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            onTap: () {
                              _tecNameMainClass.text = _dataSearch[index].name;
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
                        )
                      else
                        SizedBox(
                          width: 40,
                        )
                    ],
                  ),
                );
              },
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('الأقسام الرئيسية',
                    style: TextStyle(color: colorPositiveText)),
                StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return DropdownButton<int>(
                      value: _mainClassID,
                      items: _mainClassList.map((MainClassModel v) {
                        return DropdownMenuItem(
                          value: v.id,
                          child: Text(v.name),
                        );
                      }).toList(),
                      onChanged: (int v) {
                        _mainClassID = v;
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
            TextFormField(
              maxLines: 1,
              controller: _tecNameMainClass,
              validator: (String v) {
                String value = v.trim();
                if (value.isEmpty) return 'الخانة فارغة';
                return null;
              },
              decoration: InputDecoration(
                labelText: 'اسم القسم-ف',
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
                mapData['name'] = _tecNameMainClass.text;
                mapData['id_main_class'] = _mainClassID.toString();
                response = await postData(strPath, mapData);
              } else {
                Map<String, dynamic> mapData = Map<String, dynamic>();
                mapData['id'] = id.toString();
                mapData['name'] = _tecNameMainClass.text.trim();
                mapData['id_main_class'] = _mainClassID.toString();
                response = await putData(strPath, mapData);
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

  void _getDataSubClass() async {
    _mainClassList = await mc.getDataMaimClasses();
    _mainClassID = _mainClassList.first.id;
  }
}
