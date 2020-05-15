import 'dart:convert';

import 'package:dialog/dialog.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:fax/controllers/al_v2/controllers.dart';
import 'package:fax/controllers/fax/fax.dart';
import 'package:fax/models/pages/fax_model.dart';
import 'package:fax/models/pages/people_model.dart';
import 'package:fax/models/pages/sub_class_model.dart';
import 'package:fax/pages/variables/variables.dart';
import 'package:fax/styles/all/all.dart';
import 'package:fax/styles/page/all/app_config.dart';
import 'package:fax/widgets/all/pages.dart';
import 'package:fax/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:fax/controllers/classes/sub_class_controller.dart' as sc;
import 'package:fax/controllers/responsible/people_controller.dart' as pc;
import 'package:http/http.dart';

class FaxPage extends StatefulWidget {
  _FaxPageState createState() => _FaxPageState();
}

class _FaxPageState extends State<FaxPage> {
  TextEditingController _tecTitle = TextEditingController(),
      _tecNameSend = TextEditingController(),
      _tecNameRecieve = TextEditingController(),
      _tecFromDate = TextEditingController(),
      _tecToDate = TextEditingController(),
      _tecSerialFax = TextEditingController(),
      _tecSerialFaxIntial = TextEditingController(),
      _tecPersonSubRecieve = TextEditingController(),
      _tecCertificationNumber = TextEditingController();
  List<SubClassModel> _subClassList = List<SubClassModel>();
  List<PeopleModel> _personList = List<PeopleModel>();
  List<bool> isSelected;
  String _subClass = '', _personSend = '', _personRecieve = '';
  List<String> images = List<String>();
  int _isExport = 0, _subClassID, _personSendID, _personRecieveID;
  @override
  void initState() {
    super.initState();
    modelName = 'HR';
    pageName = 'Computence Evaluation';
    resWidthPage = 750.0;
    controllerBody = ScrollController();
    data = List<FaxModel>();
    dataSearch = List<FaxModel>();
    linkPath = strPath;
    isCheckAll = false;
    checks.clear();
    strSearch = '';
    isAscending = null;
    filter = -1;
    globalKeyAddAndUpdate = GlobalKey<FormState>();
    globalKeyloading = GlobalKey<FormState>();
    isSelected = [true, false];
    _getDataPerson();
    _getDataSubClass();
    // idPage = 'idPage';
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
    _personList.sort((a, b) =>
        a.rank.name?.toLowerCase()?.compareTo(b.rank.name?.toLowerCase()));
    _personSend = _personList.first.rank.name + '/' + _personList.first.name;
    _personRecieve = _personList.first.rank.name + '/' + _personList.first.name;
    _personSendID = _personList.first.id;
    _personRecieveID = _personList.first.id;
  }

  @override
  Widget build(BuildContext context) {
    ac = AppConfig(context);
    return responsiveWidthPage(
        context,
        resWidthPage,
        Column(
          // shrinkWrap: true,
          children: <Widget>[
            //Head
            headPage(context, modelName, pageName, () async {
              setState(() {});
            }, () {
              tecClearData();
              showDialog(
                context: context,
                builder: (BuildContext context) => buildAddAndUpdateDialog(
                    context,
                    strAddNewItem,
                    _columnData(),
                    () => addFunc(context)),
              );
            }),
            SizedBox(height: 4.0),
            //Body
            _bodyPage(),
            powerdBy()
          ],
        ));
  }

  //Body page
  Widget _bodyPage() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        color: Colors.white,
        height: ac.rH(100.0) - 124.0,
        constraints: BoxConstraints(minWidth: resWidthPage),
        width: ac.rW(99.4),
        child: Column(
          children: <Widget>[
            //Head table
            headTable(EasyStatefulBuilder(
                identifier: idPage,
                builder: (BuildContext context, data) {
                  return Row(
                    children: <Widget>[
                      checkbox(),
                      SizedBox(
                        width: 100,
                        child: headCell(12, nameColumnTable('نوع الفاكس')),
                      ),
                      Expanded(
                        child: headCell(
                          11,
                          nameColumnTable('من ينوب داخل القسم'),
                        ),
                      ),
                      Expanded(
                        child:
                            headCell(10, nameColumnTable('المستلم داخل القسم')),
                      ),
                      Expanded(
                        child:
                            headCell(9, nameColumnTable('المسلم داخل القسم')),
                      ),
                      Expanded(
                        child: headCell(8, nameColumnTable('القسم الفرعي')),
                      ),
                      Expanded(
                        child: headCell(7, nameColumnTable('رقم التصديق')),
                      ),
                      Expanded(
                        child: headCell(6, nameColumnTable('ر ق داخل القسم')),
                      ),
                      Expanded(
                        child: headCell(5, nameColumnTable('رقم الفاكس')),
                      ),
                      Expanded(
                        child: headCell(4, nameColumnTable('تاريخ الاستلام')),
                      ),
                      Expanded(
                        child: headCell(3, nameColumnTable('تاريخ الفاكس')),
                      ),
                      Expanded(
                        child: headCell(2, nameColumnTable('المستلم')),
                      ),
                      Expanded(
                        child: headCell(1, nameColumnTable('الراسل')),
                      ),
                      Expanded(
                        child: headCell(0, nameColumnTable('العنوان')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          height: 20.0,
                          width: 80.0,
                        ),
                      ),
                    ],
                  );
                })),
            SizedBox(height: 8.0),
            //Body table
            _bodyTable()
          ],
        ),
      ),
    );
  }

  //Body table
  Container _bodyTable() {
    return Container(
      height: getBodyTableHeight,
      //rows
      child: FutureBuilder<List<FaxModel>>(
        future: getDataFax(),
        builder:
            (BuildContext context, AsyncSnapshot<List<FaxModel>> snapshot) {
          if (snapshot.hasData) {
            data = snapshot.data;
            return EasyStatefulBuilder(
              identifier: idPage,
              builder: (BuildContext context, d) {
                proccessData();
                return draggableListDataViewWidget(ListView.builder(
                  controller: controllerBody,
                  scrollDirection: Axis.vertical,
                  itemCount: dataSearch.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return containerBodyTable(
                      Row(
                        children: <Widget>[
                          checkboxItem(index),
                          Expanded(
                            child: dataCellRow(
                                dataSearch[index].isExport == 0 ?? '-'
                                    ? 'صادرات'
                                    : 'واردات'),
                          ),
                          Expanded(
                            child: Tooltip(
                              child: dataCellRow(
                                  dataSearch[index].personSubRecieve ?? '-'),
                              message:
                                  dataSearch[index].personSubRecieve ?? '-',
                            ),
                          ),
                          Expanded(
                            child: Tooltip(
                              child: dataCellRow(
                                  dataSearch[index].personRecieve ?? '-'),
                              message: dataSearch[index].personRecieve ?? '-',
                            ),
                          ),
                          Expanded(
                            child: Tooltip(
                              child: dataCellRow(
                                  dataSearch[index].personSend ?? '-'),
                              message: dataSearch[index].personSend ?? '-',
                            ),
                          ),
                          Expanded(
                            child:
                                dataCellRow(dataSearch[index].subClass ?? '-'),
                          ),
                          Expanded(
                            child: dataCellRow(
                                dataSearch[index].certificationNumber ?? '-'),
                          ),
                          Expanded(
                            child: dataCellRow(
                                dataSearch[index].serialFaxInitial.toString() ??
                                    '-'),
                          ),
                          Expanded(
                            child: dataCellRow(
                                dataSearch[index].serialFax.toString() ?? '-'),
                          ),
                          Expanded(
                            child: dataCellRow(dataSearch[index].toDate ?? '-'),
                          ),
                          Expanded(
                            child:
                                dataCellRow(dataSearch[index].fromDate ?? '-'),
                          ),

                          Expanded(
                            child: Tooltip(
                              child: dataCellRow(
                                  dataSearch[index].nameRecieve ?? '-'),
                              message: dataSearch[index].nameRecieve ?? '-',
                            ),
                          ),
                          Expanded(
                            child: Tooltip(
                              child: dataCellRow(
                                  dataSearch[index].nameSend ?? '-'),
                              message: dataSearch[index].nameSend ?? '-',
                            ),
                          ),

                          Expanded(
                            child: Tooltip(
                              child:
                                  dataCellRow(dataSearch[index].title ?? '-'),
                              message: dataSearch[index].title ?? '-',
                            ),
                          ),

                          viewIconWidget(index, context, () {
                            _tecUpdateData(index);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  buildViewDialog(
                                      context, strViewItem, _columnView(index)),
                            );
                          }),
                          //Edit icon
                          // editIconWidget(index, context, () async {
                          //   _tecUpdateData(index);
                          //   showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) =>
                          //         buildAddAndUpdateDialog(
                          //             context,
                          //             strUpdateItem,
                          //             _columnData(),
                          //             () => updateFunc(context, index),
                          //             index: index),
                          //   );
                          // }),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              child: Icon(
                                Icons.cloud_download,
                                color: Colors.green,
                              ),
                              onTap: () {
                                idFile = dataSearch[index].images;
                                downloudFile();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ));
              },
            );
          } else if (snapshot.hasError) {}
          return loadingWiget();
        },
      ),
    );
  }

  void _tecUpdateData(int index) {
    _tecTitle.text = dataSearch[index].title;
    _tecNameSend.text = dataSearch[index].nameSend;
    _tecNameRecieve.text = dataSearch[index].nameRecieve;
    _tecFromDate.text = dataSearch[index].fromDate;
    _tecToDate.text = dataSearch[index].toDate;
    _tecSerialFax.text = dataSearch[index].serialFax;
    _tecSerialFaxIntial.text = dataSearch[index].serialFaxInitial;
    _tecPersonSubRecieve.text = dataSearch[index].personSubRecieve;
    _tecCertificationNumber.text = dataSearch[index].certificationNumber;
    _subClass = dataSearch[index].subClass;
    _personSend = dataSearch[index].personSend;
    _personRecieve = dataSearch[index].personRecieve;
    if (dataSearch[index].isExport == 0) {
      isSelected = [true, false];
    } else {
      isSelected = [false, true];
    }
  }

  void tecClearData() {
    _tecTitle.clear();
    _tecNameSend.clear();
    _tecNameRecieve.clear();
    _tecFromDate.clear();
    _tecToDate.clear();
    _tecSerialFax.clear();
    _tecSerialFaxIntial.clear();
    _tecPersonSubRecieve.clear();
    _tecCertificationNumber.clear();
    isSelected = [true, false];
    _isExport = 0;
    // images.clear();
  }

  void enterMapData(Map<String, dynamic> mapData) {
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
    mapData['person_sub_recieve'] = _tecPersonSubRecieve.text.trim();
    mapData['is_export'] = _isExport.toString();
    // int begin = 0;
    // images.first = image64Data(images.first, begin);
    // if (images.isNotEmpty) {
    //   String x = images.first;

    //   mapData['images'] = x;
    // } else
    //   mapData['images'] = '';
  }

  void proccessData() {
    if (strSearch != null && strSearch != '')
      dataSearch = getDataSearchFax(data, strSearch);
    else
      dataSearch = data;
    if (checks.isNotEmpty) checks.clear();
    if (isCheckAll) {
      dataSearch.forEach((d) => checks.add(d.id));
    }
    if (filter != -1 && isAscending != null)
      dataSearch = filterTable(dataSearch, filter, isAscending);
  }

  addFunc(BuildContext context) async {
    if (globalKeyAddAndUpdate.currentState.validate()) {
      Dialogs.showLoadingDialog(context, globalKeyloading);
      Map<String, dynamic> mapData = Map<String, dynamic>();
      enterMapData(mapData);
      Response response = await postData(linkPath, mapData);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        FaxModel model = FaxModel.fromJson(json.decode(response.body));

        EasyStatefulBuilder.setState(idPage, (state) {
          idFile = model.id;
          if (file != null) uploadFile();
          data.add(model);
        });
        tecClearData();
      } else
        alert('Something Happened!');
      Navigator.of(globalKeyloading.currentContext, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }
  }

  updateFunc(BuildContext context, int index) async {
    if (globalKeyAddAndUpdate.currentState.validate()) {
      Dialogs.showLoadingDialog(context, globalKeyloading);
      Map<String, dynamic> mapData = Map<String, dynamic>();
      mapData['id'] = dataSearch[index].id.toString();
      enterMapData(mapData);
      Response response = await editData(linkPath, mapData);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        FaxModel model = FaxModel.fromJson(json.decode(response.body));
        EasyStatefulBuilder.setState(idPage, (state) {
          for (int i = 0; i < data.length; i++)
            if (data[i].id == model.id) {
              data[i] = model;
              if (file != null) uploadFile();
              data.add(model);
              break;
            }
        });
        tecClearData();
      } else
        alert('Something Happened!');
      Navigator.of(globalKeyloading.currentContext, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }
  }

  Widget _columnView(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        dropdownMenuClasses(),
        SizedBox(height: 8.0),
        deopdownMenuSnederMan(),
        SizedBox(height: 8.0),
        dropdownRecieverMan(),
        SizedBox(height: 8.0),
        textFormFieldShow('من ينوب عنه', _tecPersonSubRecieve),
        SizedBox(height: 8.0),
        textFormFieldShow('عنوان الفاكس', _tecTitle),
        SizedBox(height: 8.0),
        textFormFieldShow('جه الإرسال', _tecNameSend),
        SizedBox(height: 8.0),
        textFormFieldShow('جه الإستلام', _tecNameRecieve),
        SizedBox(height: 8.0),
        textFormFieldShow('تاريخ الفاكس', _tecFromDate),
        SizedBox(height: 8.0),
        textFormFieldShow('تاريخ التسليم', _tecToDate),
        SizedBox(height: 8.0),
        textFormFieldShow('رقم الفاكس', _tecSerialFax),
        SizedBox(height: 8.0),
        textFormFieldShow('رقم الفاكس داخل القسم', _tecSerialFaxIntial),
        SizedBox(height: 8.0),
        textFormFieldShow('رقم التصديق', _tecCertificationNumber),
        SizedBox(height: 8.0),
        rowChoiceType(),
        SizedBox(height: 8.0),
      ],
    );
  }

  Widget _columnData() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          dropdownMenuClasses(),
          SizedBox(height: 8.0),
          deopdownMenuSnederMan(),
          SizedBox(height: 8.0),
          dropdownRecieverMan(),
          SizedBox(height: 8.0),
          textFormField('من ينوب عنه', _tecPersonSubRecieve),
          SizedBox(height: 8.0),
          textFormField('عنوان الفاكس', _tecTitle),
          SizedBox(height: 8.0),
          textFormField('جه الإرسال', _tecNameSend),
          SizedBox(height: 8.0),
          textFormField('جه الإستلام', _tecNameRecieve),
          SizedBox(height: 8.0),
          datePicker(context, _tecFromDate, 'تاريخ الفاكس'),
          SizedBox(height: 8.0),
          datePicker(context, _tecToDate, 'تاريخ التسليم'),
          SizedBox(height: 8.0),
          textFormField('رقم الفاكس', _tecSerialFax),
          SizedBox(height: 8.0),
          textFormField('رقم الفاكس داخل القسم', _tecSerialFaxIntial),
          SizedBox(height: 8.0),
          textFormField('رقم التصديق', _tecCertificationNumber),
          SizedBox(height: 8.0),
          rowChoiceType(),
          SizedBox(height: 8.0),
          IconButton(
              icon: Icon(Icons.cloud_upload),
              onPressed: () async {
                startWebFilePicker(context, globalKeyloading);
              }),
        ]);
  }

  Row rowChoiceType() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 50.0,
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
        ]);
  }

  Row dropdownRecieverMan() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('الشخص المستلم', style: TextStyle(color: colorPositiveText)),
        SizedBox(
          width: 8.0,
        ),
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
        SizedBox(width: 15.0),
      ],
    );
  }

  Row deopdownMenuSnederMan() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('الشخص المرسل', style: TextStyle(color: colorPositiveText)),
        SizedBox(
          width: 8.0,
        ),
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
        SizedBox(width: 15.0),
      ],
    );
  }

  Row dropdownMenuClasses() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('الأقسام الفرعية', style: TextStyle(color: colorPositiveText)),
        SizedBox(
          width: 8.0,
        ),
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
        SizedBox(width: 15.0),
      ],
    );
  }
}
