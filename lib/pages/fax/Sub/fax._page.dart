import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:dialog/dialog.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:fax/controllers/al_v2/controllers.dart';
import 'package:fax/controllers/fax/fax.dart';
import 'package:fax/models/pages/fax_model.dart';
import 'package:fax/models/pages/people_model.dart';
import 'package:fax/models/pages/sub_class_model.dart';
import 'package:fax/pass/value.dart';
import 'package:fax/styles/all/all.dart';
import 'package:fax/styles/page/all/app_config.dart';
import 'package:fax/widgets/all/pages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fax/controllers/classes/sub_class_controller.dart' as sc;
import 'package:fax/controllers/responsible/people_controller.dart' as pc;

// import 'package:dio/dio.dart' as dio;
final _controller = ScrollController();

class FaxPage extends StatefulWidget {
  _FaxPageState createState() => _FaxPageState();
}

class _FaxPageState extends State<FaxPage> {
  var _formatter = new DateFormat('yyyy-MM-dd');
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _isCheckAll = false;
  TextEditingController _tecTitle = TextEditingController(),
      _tecNameSend = TextEditingController(),
      _tecNameRecieve = TextEditingController(),
      _tecFromDate = TextEditingController(),
      _tecToDate = TextEditingController(),
      _tecSerialFax = TextEditingController(),
      _tecSerialFaxIntial = TextEditingController(),
      _tecCertificationNumber = TextEditingController();
  List<int> _checks = List<int>();
  List<FaxModel> _data = List<FaxModel>(), _dataSearch = List<FaxModel>();
  List<SubClassModel> _subClassList = List<SubClassModel>();
  List<PeopleModel> _personList = List<PeopleModel>();
  AppConfig _ac;
  String _strSearch, fromDate, toDate;
  List<bool> isSelected;
  String _subClass = '', _personSend = '', _personRecieve = '';
  List<String> images = List<String>();
  int _isExport = 0, _subClassID, _personSendID, _personRecieveID, _filter = -1;
  bool _isAsending;
  @override
  void initState() {
    super.initState();
    isSelected = [true, false];
    _getDataPerson();
    _getDataSubClass();
  }

  @override
  Widget build(BuildContext context) {
    html.document.addEventListener('keydown', (dynamic event) {
      if (event.code == 'Tab') {
        event.preventDefault();
      }
    });
    print('الفاكس');
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
          nameHeadPage('الفاكسات'),
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
                  // downloudImages();
                  await showDialog(
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
                onTap: () async {
                  _tecClear();

                  await showDialog(
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
    _tecTitle.clear();
    _tecNameSend.clear();
    _tecNameRecieve.clear();
    _tecFromDate.clear();
    _tecToDate.clear();
    _tecSerialFax.clear();
    _tecSerialFaxIntial.clear();
    _tecCertificationNumber.clear();
    images.clear();
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
            child: InkWell(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  _isAsending == false && _filter == 11
                      ? Icon(Icons.keyboard_arrow_up, size: 10.0)
                      : _isAsending == true && _filter == 11
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child:
                                  Icon(Icons.keyboard_arrow_down, size: 10.0))
                          : Visibility(
                              visible: false,
                              child: Icon(Icons.keyboard_hide, size: 10.0),
                            ),
                  nameColumnTable('توع الفاكس'),
                ],
              ),
              onTap: () async {
                if (_filter != 11) _isAsending = null;
                if (_isAsending == null) {
                  _isAsending = true;
                } else if (_isAsending) {
                  _isAsending = false;
                } else if (!_isAsending) {
                  _isAsending = null;
                }
                _filter = 11;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  _isAsending == false && _filter == 10
                      ? Icon(Icons.keyboard_arrow_up, size: 10.0)
                      : _isAsending == true && _filter == 10
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child:
                                  Icon(Icons.keyboard_arrow_down, size: 10.0))
                          : Visibility(
                              visible: false,
                              child: Icon(Icons.keyboard_hide, size: 10.0),
                            ),
                  nameColumnTable('المستلم داخل القسم'),
                ],
              ),
              onTap: () async {
                if (_filter != 10) _isAsending = null;
                if (_isAsending == null) {
                  _isAsending = true;
                } else if (_isAsending) {
                  _isAsending = false;
                } else if (!_isAsending) {
                  _isAsending = null;
                }
                _filter = 10;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  _isAsending == false && _filter == 9
                      ? Icon(Icons.keyboard_arrow_up, size: 10.0)
                      : _isAsending == true && _filter == 9
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child:
                                  Icon(Icons.keyboard_arrow_down, size: 10.0))
                          : Visibility(
                              visible: false,
                              child: Icon(Icons.keyboard_hide, size: 10.0),
                            ),
                  nameColumnTable('المسلم داخل القسم'),
                ],
              ),
              onTap: () async {
                if (_filter != 9) _isAsending = null;
                if (_isAsending == null) {
                  _isAsending = true;
                } else if (_isAsending) {
                  _isAsending = false;
                } else if (!_isAsending) {
                  _isAsending = null;
                }
                _filter = 9;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  _isAsending == false && _filter == 8
                      ? Icon(Icons.keyboard_arrow_up, size: 10.0)
                      : _isAsending == true && _filter == 8
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child:
                                  Icon(Icons.keyboard_arrow_down, size: 10.0))
                          : Visibility(
                              visible: false,
                              child: Icon(Icons.keyboard_hide, size: 10.0),
                            ),
                  nameColumnTable('القسم الفرعي'),
                ],
              ),
              onTap: () async {
                if (_filter != 8) _isAsending = null;
                if (_isAsending == null) {
                  _isAsending = true;
                } else if (_isAsending) {
                  _isAsending = false;
                } else if (!_isAsending) {
                  _isAsending = null;
                }
                _filter = 8;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  _isAsending == false && _filter == 7
                      ? Icon(Icons.keyboard_arrow_up, size: 10.0)
                      : _isAsending == true && _filter == 7
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child:
                                  Icon(Icons.keyboard_arrow_down, size: 10.0))
                          : Visibility(
                              visible: false,
                              child: Icon(Icons.keyboard_hide, size: 10.0),
                            ),
                  nameColumnTable('رقم التصديق'),
                ],
              ),
              onTap: () async {
                if (_filter != 7) _isAsending = null;
                if (_isAsending == null) {
                  _isAsending = true;
                } else if (_isAsending) {
                  _isAsending = false;
                } else if (!_isAsending) {
                  _isAsending = null;
                }
                _filter = 7;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  _isAsending == false && _filter == 6
                      ? Icon(Icons.keyboard_arrow_up, size: 10.0)
                      : _isAsending == true && _filter == 6
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child:
                                  Icon(Icons.keyboard_arrow_down, size: 10.0))
                          : Visibility(
                              visible: false,
                              child: Icon(Icons.keyboard_hide, size: 10.0),
                            ),
                  nameColumnTable('ر ف داخل القسم'),
                ],
              ),
              onTap: () async {
                if (_filter != 6) _isAsending = null;
                if (_isAsending == null) {
                  _isAsending = true;
                } else if (_isAsending) {
                  _isAsending = false;
                } else if (!_isAsending) {
                  _isAsending = null;
                }
                _filter = 6;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  _isAsending == false && _filter == 5
                      ? Icon(Icons.keyboard_arrow_up, size: 10.0)
                      : _isAsending == true && _filter == 5
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child:
                                  Icon(Icons.keyboard_arrow_down, size: 10.0))
                          : Visibility(
                              visible: false,
                              child: Icon(Icons.keyboard_hide, size: 10.0),
                            ),
                  nameColumnTable('رقم الفاكس'),
                ],
              ),
              onTap: () async {
                if (_filter != 5) _isAsending = null;
                if (_isAsending == null) {
                  _isAsending = true;
                } else if (_isAsending) {
                  _isAsending = false;
                } else if (!_isAsending) {
                  _isAsending = null;
                }
                _filter = 5;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  _isAsending == false && _filter == 4
                      ? Icon(Icons.keyboard_arrow_up, size: 10.0)
                      : _isAsending == true && _filter == 4
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child:
                                  Icon(Icons.keyboard_arrow_down, size: 10.0))
                          : Visibility(
                              visible: false,
                              child: Icon(Icons.keyboard_hide, size: 10.0),
                            ),
                  nameColumnTable('تاريخ الاستلام'),
                ],
              ),
              onTap: () async {
                if (_filter != 4) _isAsending = null;
                if (_isAsending == null) {
                  _isAsending = true;
                } else if (_isAsending) {
                  _isAsending = false;
                } else if (!_isAsending) {
                  _isAsending = null;
                }
                _filter = 4;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  _isAsending == false && _filter == 3
                      ? Icon(Icons.keyboard_arrow_up, size: 10.0)
                      : _isAsending == true && _filter == 3
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child:
                                  Icon(Icons.keyboard_arrow_down, size: 10.0))
                          : Visibility(
                              visible: false,
                              child: Icon(Icons.keyboard_hide, size: 10.0),
                            ),
                  nameColumnTable('تاريخ الفاكس'),
                ],
              ),
              onTap: () async {
                if (_filter != 3) _isAsending = null;
                if (_isAsending == null) {
                  _isAsending = true;
                } else if (_isAsending) {
                  _isAsending = false;
                } else if (!_isAsending) {
                  _isAsending = null;
                }
                _filter = 3;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  _isAsending == false && _filter == 2
                      ? Icon(Icons.keyboard_arrow_up, size: 10.0)
                      : _isAsending == true && _filter == 2
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child:
                                  Icon(Icons.keyboard_arrow_down, size: 10.0))
                          : Visibility(
                              visible: false,
                              child: Icon(Icons.keyboard_hide, size: 10.0),
                            ),
                  nameColumnTable('المستلم'),
                ],
              ),
              onTap: () async {
                if (_filter != 2) _isAsending = null;
                if (_isAsending == null) {
                  _isAsending = true;
                } else if (_isAsending) {
                  _isAsending = false;
                } else if (!_isAsending) {
                  _isAsending = null;
                }
                _filter = 2;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  _isAsending == false && _filter == 1
                      ? Icon(Icons.keyboard_arrow_up, size: 10.0)
                      : _isAsending == true && _filter == 1
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child:
                                  Icon(Icons.keyboard_arrow_down, size: 10.0))
                          : Visibility(
                              visible: false,
                              child: Icon(Icons.keyboard_hide, size: 10.0),
                            ),
                  nameColumnTable('الراسل'),
                ],
              ),
              onTap: () async {
                if (_filter != 1) _isAsending = null;
                if (_isAsending == null) {
                  _isAsending = true;
                } else if (_isAsending) {
                  _isAsending = false;
                } else if (!_isAsending) {
                  _isAsending = null;
                }
                _filter = 1;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  _isAsending == false && _filter == 0
                      ? Icon(Icons.keyboard_arrow_up, size: 10.0)
                      : _isAsending == true && _filter == 0
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child:
                                  Icon(Icons.keyboard_arrow_down, size: 10.0))
                          : Visibility(
                              visible: false,
                              child: Icon(Icons.keyboard_hide, size: 10.0),
                            ),
                  nameColumnTable('العنوان'),
                ],
              ),
              onTap: () async {
                if (_filter != 0) _isAsending = null;
                if (_isAsending == null) {
                  _isAsending = true;
                } else if (_isAsending) {
                  _isAsending = false;
                } else if (!_isAsending) {
                  _isAsending = null;
                }
                _filter = 0;
                setState(() {});
              },
            ),
          ),
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
      child: FutureBuilder<List<FaxModel>>(
        future: getDataFax(),
        builder:
            (BuildContext context, AsyncSnapshot<List<FaxModel>> snapshot) {
          _data = snapshot.data;
          if (snapshot.hasData) {
            if (_strSearch != null && _strSearch != '')
              _dataSearch = getDataSearchFax(_data, _strSearch);
            else
              _dataSearch = _data;
            if (_checks.isNotEmpty) _checks.clear();
            if (_isCheckAll)
              _dataSearch.forEach((data) => _checks.add(data.id));
            if (_filter != -1)
              _dataSearch = filterTable(_dataSearch, _filter, _isAsending);

            return Scrollbar(
              child: ListView.builder(
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
                              _dataSearch[index].isExport == 0 ?? '-'
                                  ? 'صادرات'
                                  : 'واردات'),
                        ),
                        Expanded(
                          child: Tooltip(
                            child: dataCellRow(
                                _dataSearch[index].personRecieve ?? '-'),
                            message: _dataSearch[index].personRecieve ?? '-',
                          ),
                        ),
                        Expanded(
                          child: Tooltip(
                            child: dataCellRow(
                                _dataSearch[index].personSend ?? '-'),
                            message: _dataSearch[index].personSend ?? '-',
                          ),
                        ),
                        Expanded(
                          child:
                              dataCellRow(_dataSearch[index].subClass ?? '-'),
                        ),
                        Expanded(
                          child: dataCellRow(
                              _dataSearch[index].certificationNumber ?? '-'),
                        ),
                        Expanded(
                          child: dataCellRow(
                              _dataSearch[index].serialFaxInitial.toString() ??
                                  '-'),
                        ),
                        Expanded(
                          child: dataCellRow(
                              _dataSearch[index].serialFax.toString() ?? '-'),
                        ),
                        Expanded(
                          child: dataCellRow(_dataSearch[index].toDate ?? '-'),
                        ),
                        Expanded(
                          child:
                              dataCellRow(_dataSearch[index].fromDate ?? '-'),
                        ),
                        Expanded(
                          child: Tooltip(
                            child: dataCellRow(
                                _dataSearch[index].nameRecieve ?? '-'),
                            message: _dataSearch[index].nameRecieve ?? '-',
                          ),
                        ),
                        Expanded(
                          child: Tooltip(
                            child:
                                dataCellRow(_dataSearch[index].nameSend ?? '-'),
                            message: _dataSearch[index].nameSend ?? '-',
                          ),
                        ),

                        Expanded(
                          child: Tooltip(
                            child: dataCellRow(_dataSearch[index].title ?? '-'),
                            message: _dataSearch[index].title ?? '-',
                          ),
                        ),
                        // Expanded(
                        //   child: dataCellRow(_dataSearch[index].id?.toString()),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(4.0),
                        //   child: InkWell(
                        //     child: Icon(
                        //       Icons.visibility,
                        //       color: Colors.blue,
                        //     ),
                        //     onTap: () {
                        //       enterData(index);
                        //       showDialog(
                        //         context: context,
                        //         builder: (BuildContext context) =>
                        //             _buildViewDialog(
                        //                 context, 'عرض البيانات', index),
                        //       );
                        //     },
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            child: Icon(
                              Icons.cloud_download,
                              color: Colors.blue,
                            ),
                            onTap: () {
                              enterData(index);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _showImageAndDownloud(context, 'عرض الصورة',
                                        _dataSearch[index].images),
                              );
                            },
                          ),
                        ),
                        //Edit icon
                        if (currentUser.permission >= 2 && false)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              child: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                              onTap: () {
                                // enterData(index);
                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) =>
                                //       _buildAddOrUpdateDialog(
                                //           context,
                                //           'تعديل البيانات',
                                //           _dataSearch[index].id,
                                //           false),
                                // );
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
              ),
            );
          } else if (snapshot.hasError) {}
          return Container(child: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }

  void enterData(int index) {
    _tecTitle.text = _dataSearch[index].title;
    _tecNameSend.text = _dataSearch[index].nameSend;
    _tecNameRecieve.text = _dataSearch[index].nameRecieve;
    _tecFromDate.text = _dataSearch[index].fromDate;
    _tecToDate.text = _dataSearch[index].toDate;
    _tecSerialFax.text = _dataSearch[index].serialFax;
    _tecSerialFaxIntial.text = _dataSearch[index].serialFaxInitial;
    _tecCertificationNumber.text = _dataSearch[index].certificationNumber;
    _subClass = _dataSearch[index].subClass;
    _personSend = _dataSearch[index].personSend;
    _personRecieve = _dataSearch[index].personRecieve;
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
                Text('الأقسام الفرعية',
                    style: TextStyle(color: colorPositiveText)),
                StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return DropdownButton<int>(
                      value: _subClassID,
                      items: _subClassList.map((SubClassModel v) {
                        return DropdownMenuItem(
                          value: v.id,
                          child: Text('${v.mainClass.name}/${v.name}'),
                        );
                      }).toList(),
                      onChanged: (int v) {
                        for (final v1 in _subClassList) {
                          if (v1.id == v) {
                            _subClass = '${v1.mainClass.name}/${v1.name}';
                            break;
                          }
                        }
                        _subClassID = v;
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('الشخص المرسل',
                    style: TextStyle(color: colorPositiveText)),
                StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return DropdownButton<int>(
                      value: _personSendID,
                      items: _personList.map((PeopleModel v) {
                        return DropdownMenuItem(
                          value: v.id,
                          child: Text('${v.rank.name}/${v.name}'),
                        );
                      }).toList(),
                      onChanged: (int v) {
                        for (final v1 in _personList) {
                          if (v1.id == v) {
                            _personSend = '${v1.rank.name}/${v1.name}';
                            break;
                          }
                        }
                        _personSendID = v;
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('الشخص المستلم',
                    style: TextStyle(color: colorPositiveText)),
                StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return DropdownButton<int>(
                      value: _personRecieveID,
                      items: _personList.map((PeopleModel v) {
                        return DropdownMenuItem(
                          value: v.id,
                          child: Text('${v.rank.name}/${v.name}'),
                        );
                      }).toList(),
                      onChanged: (int v) {
                        for (final v1 in _personList) {
                          if (v1.id == v) {
                            _personRecieve = '${v1.rank.name}/${v1.name}';
                            break;
                          }
                        }
                        _personRecieveID = v;
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
            Container(
              width: 240.0,
              child: TextFormField(
                maxLines: null,
                textAlign: TextAlign.end,
                controller: _tecTitle,
                validator: (String v) {
                  String value = v.trim();
                  if (value.isEmpty) return 'الخانة فارغة';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'عنوان الفاكس',
                  labelStyle: TextStyle(
                    color: colorLabelText,
                  ),
                  hintText: '',
                  hintStyle: TextStyle(
                    color: colorHintText,
                  ),
                ),
              ),
            ),
            Container(
              width: 240.0,
              child: TextFormField(
                maxLines: null,
                textAlign: TextAlign.end,
                controller: _tecNameSend,
                validator: (String v) {
                  String value = v.trim();
                  if (value.isEmpty) return 'الخانة فارغة';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'جه الإرسال',
                  labelStyle: TextStyle(
                    color: colorLabelText,
                  ),
                  hintText: '',
                  hintStyle: TextStyle(
                    color: colorHintText,
                  ),
                ),
              ),
            ),
            Container(
              width: 240.0,
              child: TextFormField(
                maxLines: null,
                textAlign: TextAlign.end,
                controller: _tecNameRecieve,
                validator: (String v) {
                  String value = v.trim();
                  if (value.isEmpty) return 'الخانة فارغة';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'جه الإستلام',
                  labelStyle: TextStyle(
                    color: colorLabelText,
                  ),
                  hintText: '',
                  hintStyle: TextStyle(
                    color: colorHintText,
                  ),
                ),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              children: <Widget>[
                Container(
                  width: 180.0,
                  child: TextFormField(
                    enabled: true,
                    controller: _tecFromDate,
                    validator: (String v) {
                      String value = v.trim();
                      if (value.isEmpty) return 'ادخل تاريخ';
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'تاريخ الفاكس',
                      labelStyle: TextStyle(
                        color: colorLabelText,
                      ),
                      hintText: '',
                      hintStyle: TextStyle(
                        color: colorHintText,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                IconButton(
                  hoverColor: Colors.grey,
                  icon: Center(child: Icon(Icons.timer)),
                  onPressed: () async {
                    var date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2050),
                    );
                    if (date != null)
                      _tecFromDate.text = _formatter.format(date).toString();
                  },
                ),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              children: <Widget>[
                Container(
                  width: 180.0,
                  child: TextFormField(
                    controller: _tecToDate,
                    enabled: true,
                    validator: (String v) {
                      String value = v.trim();
                      if (value.isEmpty) return 'ادخل تاريخ';
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'تاريخ التسليم',
                      labelStyle: TextStyle(
                        color: colorLabelText,
                      ),
                      hintText: '',
                      hintStyle: TextStyle(
                        color: colorHintText,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                IconButton(
                  hoverColor: Colors.grey,
                  icon: Center(child: Icon(Icons.timer)),
                  onPressed: () async {
                    var date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2050),
                    );
                    if (date != null)
                      _tecToDate.text = _formatter.format(date).toString();
                  },
                ),
              ],
            ),
            Container(
              width: 240.0,
              child: TextFormField(
                // keyboardType: TextInputType.number,
                // inputFormatters: <TextInputFormatter>[
                //   WhitelistingTextInputFormatter.digitsOnly,
                // ],
                textAlign: TextAlign.end,
                maxLines: null,
                controller: _tecSerialFax,
                validator: (String v) {
                  String value = v.trim();
                  if (value.isEmpty) return 'الخانة فارغة';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'رقم الفاكس',
                  labelStyle: TextStyle(
                    color: colorLabelText,
                  ),
                  hintText: '',
                  hintStyle: TextStyle(
                    color: colorHintText,
                  ),
                ),
              ),
            ),
            Container(
              width: 240.0,
              child: TextFormField(
                textAlign: TextAlign.end,
                maxLines: null,
                controller: _tecSerialFaxIntial,
                validator: (String v) {
                  String value = v.trim();
                  if (value.isEmpty) return 'الخانة فارغة';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'رقم الفاكس داخل القسم',
                  labelStyle: TextStyle(
                    color: colorLabelText,
                  ),
                  hintText: '',
                  hintStyle: TextStyle(
                    color: colorHintText,
                  ),
                ),
              ),
            ),
            Container(
              width: 240.0,
              child: TextFormField(
                // keyboardType: TextInputType.number,
                // inputFormatters: <TextInputFormatter>[
                //   WhitelistingTextInputFormatter.digitsOnly,
                // ],
                textAlign: TextAlign.end,
                maxLines: null,
                controller: _tecCertificationNumber,
                validator: (String v) {
                  String value = v.trim();
                  if (value.isEmpty) return 'الخانة فارغة';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'رقم التصديق',
                  labelStyle: TextStyle(
                    color: colorLabelText,
                  ),
                  hintText: '',
                  hintStyle: TextStyle(
                    color: colorHintText,
                  ),
                ),
              ),
            ),
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
                          'صادرات',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'واردات',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        _isExport = index;
                        for (int i = 0; i < isSelected.length; i++) {
                          if (i == index) {
                            isSelected[i] = true;
                          } else {
                            isSelected[i] = false;
                          }
                        }
                      });
                    },
                    isSelected: isSelected,
                  );
                },
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Center(
              child: IconButton(
                icon: Icon(Icons.file_upload),
                onPressed: () async {
                  images = await setImage();
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
              http.Response response;
              if (isAdd) {
                Map<String, dynamic> mapData = Map<String, dynamic>();
                enterMapData(mapData);
                // print(mapData);
                try {
                  response = await postData(strPath, mapData);
                } catch (e) {
                  print(e);
                }
              } else {
                Map<String, dynamic> mapData = Map<String, dynamic>();
                mapData['id'] = id.toString();
                enterMapData(mapData);
                // print(mapData);
                response = await putData(strPath, mapData);
              }
              if (response.statusCode >= 200 && response.statusCode <= 299) {
                print(response.body);
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

  void enterMapData(Map<String, dynamic> mapData) {
    //
    mapData['title'] = _tecTitle.text.trim();
    mapData['name_send'] = _tecNameSend.text.trim();
    mapData['name_recieve'] = _tecNameRecieve.text.trim();
    mapData['from_date'] = _tecFromDate.text.trim();
    mapData['to_date'] = _tecToDate.text.trim();
    mapData['serial_fax'] = _tecSerialFax.text.trim();
    mapData['serial_fax_initial'] = _tecSerialFaxIntial.text.trim();
    mapData['certification_number'] = _tecCertificationNumber.text.trim();
    mapData['sub_class'] = _subClass;
    mapData['person_send'] = _personSend;
    mapData['person_recieve'] = _personRecieve;
    mapData['is_export'] = _isExport.toString();
    int begin = 0;
  images.first = image64Data(images.first, begin);
    if (images.isNotEmpty) {
      String x = images.first;

      mapData['images'] = x;
    } else
      mapData['images'] = '';
  }

  // Widget _buildViewDialog(BuildContext context, String strTitle, int index) {
  //   return AlertDialog(
  //     title: Text(strTitle),
  //     content: _columnData(),
  //     actions: <Widget>[
  //       FlatButton(
  //         highlightColor: colorFlatHighLightNegative,
  //         hoverColor: colorFlatHoverNegative,
  //         onPressed: () async {
  //           Navigator.of(context).pop();
  //         },
  //         textColor: colorNegativeText,
  //         child: const Text('اغلاق'),
  //       ),
  //     ],
  //   );
  // }

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
    _subClassList = await sc.getDataSubClasses();
    _subClass =
        _subClassList.first.mainClass.name + '/' + _subClassList.first.name;
    _subClassID = _subClassList.first.id;
  }

  void _getDataPerson() async {
    _personList = await pc.getDataPeople();
    _personList.sort(
        (a, b) => ('${a.rank}${a.name}').compareTo(('${b.rank}${b.name}')));
    _personSend = _personList.first.rank.name + '/' + _personList.first.name;
    _personRecieve = _personList.first.rank.name + '/' + _personList.first.name;
    _personSendID = _personList.first.id;
    _personRecieveID = _personList.first.id;
  }
}

Widget _showImageAndDownloud(BuildContext context, String s, String bytes) {
  int begin = 0;
  bytes = image64Data(bytes, begin);
  print(bytes);
  return AlertDialog(
    title: Text(s),
    content: ListView(
      shrinkWrap: true,
      children: <Widget>[
        bytes != null
            ? Container(
                height: 200.0,
                child: imageFromBase64String(bytes),
              )
            : Icon(Icons.not_interested),
      ],
    ),
    actions: <Widget>[
      FlatButton(
        highlightColor: colorFlatHighLightNegative,
        hoverColor: colorFlatHoverNegative,
        onPressed: () async {
          if (bytes != null) downloudImage(bytes);
        },
        textColor: colorNegativeText,
        child: const Text('حفظ'),
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

String image64Data(String bytes, int begin) {
  for (int i = 0; i < bytes.toString()?.length; i++) {
    if (bytes[i].contains(';')) {
      begin = ++i;
      begin += 7;
      break;
    }
  }
  if (bytes.isNotEmpty) bytes = bytes.substring(begin, bytes.length);
  return bytes;
}

imageFromBase64String(String base64String) {
  Uint8List bytes = Base64Codec().decode(base64String);
  // Uint8List uint8list = base64Url.decode(
  //     'iVBORw0KGgoAAAANSUhEUgAAAgAAAAIACAQAAABecRxxAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QAAKqNIzIAAAAHdElNRQfhCRgMLgSMAUvXAAAGcElEQVR42u3dyYtl5RkH4F+lNa1xioktrQYFbZuILWovDLpIdiIqSiCDaBZRcJGFREFdZaWCw0ockk2QBCMS0aWKA7S9C1kocSDi0KbiQNut0uXUQ2mOi7JItV3X7lNW3fd+nuf5/oHf+8H73nPuvd85CQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfI2p6gCM1bHZmNNzak7M2hydI3NQuuzJTLZlOq/nhTyXV6sjAsvt+7k892VLuv2ud/NQfps11YGB5XBoLs/j2XMArb9wzebJXJFDqsMDS3dCbs97PVt/4Xo/t+aE6iKA/o7LH7PrGzT//NqVew0BaMnq/CEfL0Pzz69PclO+V10UcCDOy8vL2Pzz641cWF0Y8PVW5ZZ8tgLtP7fuyxHVBQKjrMnTK9b8c2tLNlYXCSzmx3llhdu/S5dP85vqQoGv2phtY2j/uXVLdbHAQuvzwdjav0uXu6sLBuYdnhfH2v5dutxWXTQw5+9jb/8uXX5XXTaQ/L6k/bvM5mfVpcPQbcjOogHQZWuOqy4fhmxV/lnW/l26POGJElDn2tL2900AFFqbmfIBMOOsINT4c3n7d+nyt+ptgCE6LbPlzd+ly/9yTvVWwPA8UN768+uJ6q2AoVm3gsd++6+fVG8HS/Od6gAs0TVZVR1hgRuqA7A0fsVt02F5J0dWh1jgs5yUd6pD0J8rgDb9eqLaPzkoV1ZHgOHYVH7X/9X1UvWWsBRuAVq0Nm9N1DcAc87Ii9UR6MstQIsumsD2Ty6qDkB/BkCLLqgOsKjzqwPQn1uA9kxla46tDrGIT3J0ZqtD0I8rgPacOpHtnxyWM6oj0JcB0J6zqwOMdGZ1APoyANozuZ+zp1UHoC8DoD2nVAcY6eTqAPRlALTnxOoAI/2oOgB9GQDtmcyvAJPkmOoA9GUAtOeo6gAjTdb5BA6AAdCe1dUBGkzGCAYAy6erDkBfBkB79lQHGGl3dQD6MgDa82F1gJF2VAegLwOgPe9XBxhpe3UA+jIA2vN2dYCRpqsD0JcB0J7/VAcY6bXqAPRlALTn39UBRnq+OgB9GQDteaE6wEjPVgegLw8Eac8hmcl3q0Ms4m1nAdrjCqA9uyb0k3ZTdQD6MwBa9FR1gEU9Wh0AhuHc8rcA7Lt2TvAhJUZyBdCif0zgfwEey0x1BPozAFrU5cHqCPv4S3UAGI7Tyy/5917TE/mqEvbLFUCbXsoz1RH2cmc+r44AQ3Jp+af+/9f2HF69HTAsU/lXeePPr+urNwOG55Lyxp9bb+TQ6q2AIdpU3vxduvyiehtgmDZkT3n7+/9f0/x407JtWZ2flibYkQsn+BFl8C13cJ4t/fz/VfUGwLCtz46y9r+7unjg5/m8pP035+Dq0oHkxoL2fzk/rC4bmHPHmNv/zQl+RzEMzlTuGmP7T2dddcHA3m4e28X/ydWlAvu6agx/DNrs3h8m1bmZXtH2/9NEPo8Y+NIxeXiFmv+D/LK6OGD/rsjWZW//xzz1H1rxg9yZ3cvW/P914g9asz5/zewyXPjf4Lw/tGld7slHS27+6VznYV/QtiNyVTb3PC+wM4/kYofF4dvi+FydR7J9v63/Vu7PZd7yMxTeDjwsU1mfs7Ihp+SkrMlRWZ1kd3Zke6bzWp7Pc9lSHREAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJgYXwDkIdjmGEAY6gAAAC56VFh0ZGF0ZTpjcmVhdGUAAHjaMzIwNNc1sNQ1MgkxNLIyMbMyMNY2MLAyMAAAQhcFEUhA6owAAAAuelRYdGRhdGU6bW9kaWZ5AAB42jMyMDTXNbDUNTIJMTSyMjGzMjDWNjCwMjAAAEIXBRFhf0IEAAAAAElFTkSuQmCC');
  return Image.memory(bytes);
}

void downloudImage(String link) {
  var a = html.document.createElement('a');
  a.setAttribute('href', 'data:application/octet-stream;base64,' + link);
  a.setAttribute('download', 'image.png');
  html.document.body.append(a);
  a.click();
  a.remove();
}
