import 'package:dialog/dialog.dart';
import 'package:fax/controllers/al_v2/controllers.dart';
import 'package:fax/controllers/responsible/rank_controller.dart';
import 'package:fax/models/pages/rank_model.dart';
import 'package:fax/pass/value.dart';
import 'package:fax/styles/all/all.dart';
import 'package:fax/styles/page/all/app_config.dart';
import 'package:fax/widgets/all/pages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RankPage extends StatefulWidget {
  _RankPageState createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _isCheckAll = false;
  TextEditingController _tecName = TextEditingController(),
      _tecDescription = TextEditingController();
  List<int> _checks = List<int>();
  List<RankModel> _data = List<RankModel>(), _dataSearch = List<RankModel>();
  AppConfig _ac;
  String _strSearch;

  @override
  Widget build(BuildContext context) {
    //print('الرتبة');
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
          nameHeadPage('الرتبة'),
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
    _tecName.clear();
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
            child: nameColumnTable('الوصف'),
          ),
          Expanded(
            child: nameColumnTable('الرتبة'),
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
      child: FutureBuilder<List<RankModel>>(
        future: getDataRank(),
        builder:
            (BuildContext context, AsyncSnapshot<List<RankModel>> snapshot) {
          _data = snapshot.data;
          if (snapshot.hasData) {
            if (_strSearch != null && _strSearch != '')
              _dataSearch = getDataSearch(_data, _strSearch);
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
                        child:
                            dataCellRow(_dataSearch[index].description ?? '-'),
                      ),
                      Expanded(
                        child: dataCellRow(_dataSearch[index].name),
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
                            _tecDescription.text =
                                _dataSearch[index].description;
                            _tecName.text = _dataSearch[index].name;
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
                              _tecName.text = _dataSearch[index].name;
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
            TextFormField(
              maxLines: 1,
              controller: _tecName,
              validator: (String v) {
                String value = v.trim();
                if (value.isEmpty) return 'الخانة فارغة';
                return null;
              },
              decoration: InputDecoration(
                labelText: 'الرتبة',
                labelStyle: TextStyle(
                  color: colorLabelText,
                ),
                hintText: '',
                hintStyle: TextStyle(
                  color: colorHintText,
                ),
              ),
            ),
            TextFormField(
              maxLines: 1,
              controller: _tecDescription,
              // validator: (String v) {
              //   String value = v.trim();
              //   if (value.isEmpty) return 'الخانة فارغة';
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: 'الوصف',
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
                mapData['name'] = _tecName.text.trim();
                mapData['description'] = _tecDescription.text.trim();
                response = await postData(strPath, mapData);
              } else {
                Map<String, dynamic> mapData = Map<String, dynamic>();
                mapData['id'] = id.toString();
                mapData['name'] = _tecName.text.trim();
                mapData['description'] = _tecDescription.text.trim();

                response = await putData(strPath, mapData);
              }
              if (response.statusCode >= 200 && response.statusCode <= 299) {
                if (!isAdd) Navigator.of(context).pop();
                _tecClear();
                setState(() {});
              } else {
                alert('حدث خطاء اثناء الاتصال بقاعدة البيانات');
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
              alert('حدث خطاء اثناء الاتصال بقاعدة البيانات');
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
