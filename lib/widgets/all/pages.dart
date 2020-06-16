import 'package:fax/controllers/al_v2/controllers.dart';
import 'package:fax/models/pages/fax_model.dart';
import 'package:fax/packages/draggable_scroll_bar/draggable_scroll_bar.dart';
import 'package:fax/packages/month_picker/month_picker.dart';
import 'package:fax/packages/smooth_star_rating/smooth_star_rating.dart';
import 'package:fax/pages/variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fax/styles/all/all.dart';
import 'package:dialog/dialogs/alert.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:dialog/dialogs/alert.dart';

import '../dialogs.dart';

Widget nameHeadPage(String namePage) {
  return Text(
    namePage,
    style: tsMainText,
  );
}

Color bgcolor = Colors.grey;
bool co = false;
int counter = 0;
int counter2 = 0;
Widget nameSubHeadPage(String namePage) {
  return Text(
    namePage,
    style: tsMainText,
  );
}

Widget powerdBy() {
  return Container(
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
            child: Text(
          'PoweredBy:KeepDev',
          style: TextStyle(color: Colors.grey),
        ))
      ],
    ),
  );
}

Widget nameMainHeadPage(String namePage) {
  return Text(
    namePage,
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );
}

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    border: Border.all(width: 3.0),
    borderRadius: BorderRadius.all(
        Radius.circular(8.0) //                 <--- border radius here
        ),
  );
}

Widget nameColumnTable(String strName, {double fontSize}) {
  return Expanded(
    child: Center(
      child: Text(
        strName,
        maxLines: 3,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    ),
  );
}

Widget dataCellRoww(String data, int numOfcell) {
  if (co && counter < numOfcell) {
    bgcolor = Colors.white;
    co = !co;
    counter2 = counter2 + 1;
    if (counter2 == numOfcell) {
      counter = 0;
    }
  } else {
    bgcolor = Colors.grey;
    co = !co;
    counter = counter + 1;
  }
  return Container(
    color: bgcolor,
    /*  decoration: BoxDecoration(
      border: Border(
        right: BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
    ),*/
    child: Center(
      child: Text(
        '$data',
      ),
    ),
  );
}

Widget dataCellRow(String data) {
  return Container(
    //color:bgcolor,
    /*  decoration: BoxDecoration(
      border: Border(
        right: BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
    ),*/
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '$data',
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );
}

//input text
TextFormField inputTextField(TextEditingController textEditingController,
    String labelText, TextInputType textInputType) {
  return TextFormField(
    keyboardType: TextInputType.multiline,
    maxLines: 3,
    minLines: 1,
    controller: textEditingController,
    validator: (String v) {
      String value = v.trim();
      if (value.isEmpty) return 'Empty field!';
      return null;
    },
    inputFormatters: textInputType == TextInputType.number
        ? [WhitelistingTextInputFormatter.digitsOnly]
        : null,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: colorLabelText,
      ),
      hintText: '',
      hintStyle: TextStyle(
        color: colorHintText,
      ),
    ),
  );
}

TextFormField inputTextFieldView(TextEditingController textEditingController,
    String labelText, TextInputType textInputType) {
  return TextFormField(
    readOnly: true,
    keyboardType: TextInputType.multiline,
    maxLines: 5,
    minLines: 1,
    controller: textEditingController,
    validator: (String v) {
      String value = v.trim();
      if (value.isEmpty) return 'Empty field!';
      return null;
    },
    inputFormatters: textInputType == TextInputType.number
        ? [WhitelistingTextInputFormatter.digitsOnly]
        : null,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: colorLabelText,
      ),
      hintText: '',
      hintStyle: TextStyle(
        color: colorHintText,
      ),
    ),
  );
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.parse(s) != null;
}

TextFormField inputTextFieldNUM(TextEditingController textEditingController,
    String labelText, TextInputType textInputType) {
  return TextFormField(
    keyboardType: TextInputType.multiline,
    maxLines: null,
    controller: textEditingController,
    validator: (String v) {
      String value = v.trim();
      if (value.isEmpty) {
        return 'Empty field';
      } else if (!isNumeric(value.toString())) {
        return 'input numbers > or =0';
      } else if (double.parse(value.toString()) < 0) {
        return 'input numbers > or =0';
      } else if (double.parse(value.toString()) > 100) {
        return 'input numbers less than or equal 100';
      }
      return null;
    },
    inputFormatters: textInputType == TextInputType.number
        ? [WhitelistingTextInputFormatter.digitsOnly]
        : null,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: colorLabelText,
      ),
      hintText: '',
      hintStyle: TextStyle(
        color: colorHintText,
      ),
    ),
  );
}

/*Dialog*/
// Delete items
Widget alertDialog(BuildContext context, String title, int type) {
  return Center(
    child: Container(
      // color: Colors.grey,
      height: 200,
      width: 200,
      child: Card(
          color: Colors.grey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (type == 0)
                CircularProgressIndicator()
              else if (type == 1)
                Icon(
                  Icons.done,
                  size: 70.0,
                  color: Colors.green,
                )
              else if (type == 2)
                Icon(
                  Icons.warning,
                  size: 70.0,
                  color: Colors.green,
                ),
              Text(
                title,
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          )),
    ),
  );
}

bool isAscending;
int filter = -1;
String idPage = 'iddPage';
Widget headCell(int numCell, Widget nameColumnTable) {
  return InkWell(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Expanded(
        // child:
        //  Container(),
        // ),
        isAscending == false && filter == numCell
            ? Icon(Icons.keyboard_arrow_up, size: 10.0)
            : isAscending == true && filter == numCell
                ? Container(
                    width: 20.0,
                    height: 20.0,
                    child: Icon(Icons.keyboard_arrow_down, size: 10.0))
                : Visibility(
                    visible: false,
                    child: Icon(Icons.keyboard_hide, size: 10.0),
                  ),
        nameColumnTable,
        // Expanded(
        //   child:
        Container(),
        // ),
      ],
    ),
    onTap: () async {
      if (filter != numCell) isAscending = null;
      if (isAscending == null) {
        isAscending = true;
      } else if (isAscending) {
        isAscending = false;
      } else if (!isAscending) {
        isAscending = null;
      }
      filter = numCell;
      EasyStatefulBuilder.setState(idPage, (state) {});
    },
  );
}

//Head page
Widget headPage(BuildContext context, String modelName, String pageName,
    Function funcSearch, Function funcAddAndUpdateItem) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Container(
      width: ac.rW(99.4),
      constraints: BoxConstraints(minWidth: 800.0),
      height: 40.0,
      color: colorContext,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 4.0,
          ),
          nameMainHeadPage('$modelName/'),
          //Page name
          nameSubHeadPage(pageName),
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
                onTap: funcSearch),
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
                        EasyStatefulBuilder.setState(idPage, (state) {
                          strSearch = v.trim().toLowerCase();
                        });
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
                  builder: (BuildContext context) => buildDeleteDialog(context),
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
                    'Add New',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              onTap: funcAddAndUpdateItem,
            ),
          ),
          SizedBox(width: 20.0),

          SizedBox(width: 20.0),
        ],
      ),
    ),
  );
}

// Delete items
Widget buildDeleteDialog(BuildContext context) {
  bool istrue = checks.isNotEmpty;
  return AlertDialog(
    title: Text('Delete ${checks.length} items'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    ),
    actions: <Widget>[
      if (istrue)
        FlatButton(
          highlightColor: colorFlatHighLightNegative,
          hoverColor: colorFlatHoverNegative,
          onPressed: () async {
            bool done = false;
            if (istrue) {
              Dialogs.showLoadingDialog(context, globalKeyloading);

              done = await deleteData(linkPath, checks);
              //close the dialoge
            }
            if (done) {
              for (int i = 0; i < checks.length; i++)
                for (int j = 0; j < data.length; j++)
                  if (data[j].id == checks[i]) {
                    data.removeAt(j);
                    break;
                  }

              isCheckAll = false;
              checks.clear();
              EasyStatefulBuilder.setState(idPage, (state) {});
              Navigator.of(globalKeyloading.currentContext, rootNavigator: true)
                  .pop();
              Navigator.of(context).pop();
            } else {
              alert('Check internet');
            }
          },
          textColor: colorNegativeText,
          child: const Text('Ok'),
        ),
      FlatButton(
        highlightColor: colorFlatHighLightPositive,
        hoverColor: colorFlatHoverPositive,
        onPressed: () async {
          Navigator.of(context).pop();
        },
        textColor: colorPositiveText,
        child: const Text('cancel'),
      ),
    ],
  );
}

TextFormField textFormFieldShow(
    String labelText, TextEditingController controller) {
  return TextFormField(
    readOnly: true,
    keyboardType: TextInputType.multiline,
    maxLines: 5,
    minLines: 1,
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: colorLabelText,
      ),
      hintText: '',
      hintStyle: TextStyle(
        color: colorHintText,
      ),
    ),
  );
}

TextFormField stringFormFieldShow(String labelText, String value) {
  TextEditingController controller = TextEditingController();
  controller.text = value;
  return TextFormField(
    readOnly: true,
    keyboardType: TextInputType.multiline,
    maxLines: 5,
    minLines: 1,
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: colorLabelText,
      ),
      hintText: '',
      hintStyle: TextStyle(
        color: colorHintText,
      ),
    ),
  );
}

Row dropDowmMenuShow(String text, String strData) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(text,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: colorLabelText)),
              ),
            ),
            SizedBox(height: 2.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(strData,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: colorContext)),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Row dropDowmMenu(String text, List data, int id) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(text,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: colorLabelText)),
              ),
            ),
            SizedBox(height: 2.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(data[data.indexWhere((c) => c.id == id)].name,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: colorContext)),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

TextFormField textFormField(String labelText, TextEditingController controller,
    {bool isNullable}) {
  return TextFormField(
    keyboardType: TextInputType.multiline,
    maxLines: 5,
    minLines: 1,
    controller: controller,
    validator: isNullable ?? false
        ? null
        : (String v) {
            if (v.isEmpty) return 'Empty field!';
            return null;
          },
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: colorLabelText,
      ),
      hintText: '',
      hintStyle: TextStyle(
        color: colorHintText,
      ),
    ),
  );
}

//Add item
Widget buildAddAndUpdateDialog(
    BuildContext context, String title, Widget _columnData, Function func,
    {int index}) {
  return AlertDialog(
    title: Text(title),
    content: mainCloumnWidget(_columnData),
    actions: <Widget>[
      FlatButton(
        highlightColor: colorFlatHighLightPositive,
        hoverColor: colorFlatHoverPositive,
        onPressed: func,
        textColor: colorPositiveText,
        child: Text('save'),
      ),
      FlatButton(
        highlightColor: colorFlatHighLightNegative,
        hoverColor: colorFlatHoverNegative,
        onPressed: () async {
          Navigator.of(context).pop();
        },
        textColor: colorNegativeText,
        child: Text('cancel'),
      ),
    ],
  );
}

Widget buildViewDialog(
    BuildContext context, String strTitle, Widget columnView) {
  return AlertDialog(
    title: Text(strTitle),
    content: mainCloumnWidget(columnView),
    actions: <Widget>[
      FlatButton(
        highlightColor: colorFlatHighLightNegative,
        hoverColor: colorFlatHoverNegative,
        onPressed: () async {
          Navigator.of(context).pop();
        },
        textColor: colorNegativeText,
        child: const Text('cancel'),
      ),
    ],
  );
}

Checkbox checkbox() {
  return Checkbox(
    value: isCheckAll,
    activeColor: colorCheckBox,
    onChanged: (bool isCheck) async {
      isCheckAll = isCheck;
      EasyStatefulBuilder.setState(idPage, (state) {});
    },
  );
}

StatefulBuilder checkboxItem(int index) {
  return StatefulBuilder(
    builder: (BuildContext context, setState) {
      return Checkbox(
        value: checks.contains(dataSearch[index].id),
        activeColor: colorCheckBox,
        onChanged: (bool isCheck) async {
          int id = dataSearch[index].id;
          isCheck ? checks.add(id) : checks.remove(id);
          setState(() {});
        },
      );
    },
  );
}

Container loadingWiget() =>
    Container(child: Center(child: CircularProgressIndicator()));

Padding viewIconWidget(int index, BuildContext context, Function func) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: InkWell(
      child: Icon(
        Icons.visibility,
        color: Colors.blue,
      ),
      onTap: func,
    ),
  );
}

Padding editIconWidget(int index, BuildContext context, Function func) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: InkWell(
      child: Icon(
        Icons.edit,
        color: Colors.green,
      ),
      onTap: func,
    ),
  );
}

SingleChildScrollView responsiveWidthPage(
    BuildContext context, double _resWidthPage, Widget column) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Container(
      // constraints: BoxConstraints(minWidth: _resWidthPage),
      width: ac.rW(99.4),
      child: column,
    ),
  );
}

DraggableScrollbar draggableListDataViewWidget(ListView listView) {
  return DraggableScrollbar(
    controller: controllerBody,
    heightScrollThumb: 40.0,
    child: listView,
  );
}

Widget mainCloumnWidget(Widget column) {
  ScrollController _scrollController = ScrollController();
  return SingleChildScrollView(
    controller: _scrollController,
    child: Form(
      key: globalKeyAddAndUpdate,
      child: DraggableScrollbar(
        heightScrollThumb: 40.0,
        controller: _scrollController,
        child: Container(
          constraints: BoxConstraints(maxWidth: 400.0),
          margin: EdgeInsets.only(right: 25.0),
          child: column,
        ),
      ),
    ),
  );
}

//Head table
Container headTable(Widget rowHeadTable) {
  return Container(
    padding: EdgeInsets.only(right: 25.0),
    height: 60.0,
    decoration: myBoxDecoration(),
    //Columns Heads
    child: rowHeadTable,
  );
}

Container containerBodyTable(Widget row) {
  return Container(
    margin: EdgeInsets.only(right: 25.0),
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
    child: row,
  );
}

Widget statusDropdownMenu() {
  return StatefulBuilder(
    builder: (BuildContext context, setState) {
      return DropdownButton<String>(
        value: selectedStatus,
        items: statusList.map((String v) {
          return DropdownMenuItem(
            value: v,
            child: Text(v),
          );
        }).toList(),
        onChanged: (String v) {
          selectedStatus = v;
          setState(() {});
        },
      );
    },
  );
}

Widget yearPicker(context, controller, String strName) {
  return Wrap(
    children: <Widget>[
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 180.0,
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              readOnly: true,
              controller: controller,
              validator: (String v) {
                String value = v.trim();
                if (value.isEmpty) return 'Enter Value';
                return null;
              },
              decoration: InputDecoration(
                labelText: strName,
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
                initialDatePickerMode: DatePickerMode.year,
                lastDate: DateTime(2050),
              );
              if (date != null)
                controller.text = yearFormater.format(date).toString();
            },
          ),
          SizedBox(width: 15.0),
        ],
      ),
    ],
  );
}

Widget monthPicker(
    BuildContext context, TextEditingController controller, String strName) {
  return Wrap(
    children: <Widget>[
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 180.0,
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              readOnly: true,
              controller: controller,
              validator: (String v) {
                String value = v.trim();
                if (value.isEmpty) return 'Enter Value';
                return null;
              },
              decoration: InputDecoration(
                labelText: strName,
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
              var date = await showMonthPicker(
                context: context,
                firstDate: DateTime(1950),
                initialDate: DateTime.now(),
                lastDate: DateTime(2050),
              );
              if (date != null) controller.text = date.month.toString();
            },
          ),
          SizedBox(width: 15.0),
        ],
      ),
    ],
  );
}

Widget datePicker(
    BuildContext context, TextEditingController controller, String strName,
    {bool isNullable = false}) {
  return Wrap(
    children: <Widget>[
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 180.0,
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              readOnly: true,
              controller: controller,
              validator: isNullable
                  ? null
                  : (String v) {
                      String value = v.trim();
                      if (value.isEmpty) return 'Enter Value';
                      return null;
                    },
              decoration: InputDecoration(
                labelText: strName,
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
                firstDate: DateTime(1950),
                initialDate: DateTime.now(),
                lastDate: DateTime(2050),
              );
              if (date != null) controller.text = dataFormater.format(date);
            },
          ),
          SizedBox(width: 15.0),
        ],
      ),
    ],
  );
}

Widget numberFormField(String strName, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: <TextInputFormatter>[
      WhitelistingTextInputFormatter.digitsOnly
    ],
    validator: (String v) {
      String value = v.trim();
      if (value.isEmpty) {
        return 'Empty field';
      } else if (!isNumeric(value.toString())) {
        return 'input numbers > or =0';
      } else if (int.parse(value.toString()) < 1) {
        return 'input numbers > or =0';
      }
      return numberValidator(value);
    },
    decoration: InputDecoration(
      labelText: strName,
      labelStyle: TextStyle(
        color: colorLabelText,
      ),
      hintText: '',
      hintStyle: TextStyle(
        color: colorHintText,
      ),
    ),
  );
}

Row ratingWidget(String text, TextEditingController v,
    {bool isEnabled = true, int starCount = 5}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(text),
      RatingWidget(v, (rate) {
        v.text = rate.toString();
      }, isEnabled, starCount)
    ],
  );
}

typedef void Ratingoutput(double rate);

class RatingWidget extends StatefulWidget {
  final Ratingoutput _ratingoutput;
  final TextEditingController initalRate;
  final bool isEnabled;
  final int starCount;
  RatingWidget(
      this.initalRate, this._ratingoutput, this.isEnabled, this.starCount);
  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _rate = 0;
  @override
  void initState() {
    _rate = double.parse(widget.initalRate.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
      starCount: widget.starCount,
      rating: _rate,
      size: 25,
      color: Colors.yellow,
      borderColor: Colors.yellow,
      spacing: 0.0,
      allowHalfRating: false,
      onRatingChanged: widget.isEnabled
          ? (double v) {
              widget._ratingoutput(v);
              _rate = v;
              setState(() {});
            }
          : null,
    );
  }
}

// Color bgcolor = Colors.grey;
// bool co = false;
// int counter = 0;
// int counter2 = 0;
// Widget nameHeadPage(String namePage) {
//   return Text(
//     namePage,
//     style: tsMainText,
//   );
// }

// BoxDecoration myBoxDecoration() {
//   return BoxDecoration(
//     border: Border.all(width: 3.0),
//     borderRadius: BorderRadius.all(
//         Radius.circular(8.0) //                 <--- border radius here
//         ),
//   );
// }

// Widget nameColumnTable(String strName) {
//   return Container(
//     /* decoration: BoxDecoration(
//       border: Border(
//         right: BorderSide(
//           color: Colors.black,
//           width: 2.0,
//         ),
//       ),
//     ),
//     */
//     child: Center(
//         child: Text(
//       strName,
//       style: textStyleColumnText,
//     )),
//   );
// }

// Widget dataCellRoww(String data, int numOfcell) {
//   if (co && counter < numOfcell) {
//     bgcolor = Colors.white;
//     co = !co;
//     counter2 = counter2 + 1;
//     if (counter2 == numOfcell) {
//       counter = 0;
//     }
//   } else {
//     bgcolor = Colors.grey;
//     co = !co;
//     counter = counter + 1;
//   }
//   return Container(
//     color: bgcolor,
//     /*  decoration: BoxDecoration(
//       border: Border(
//         right: BorderSide(
//           color: Colors.grey,
//           width: 1.0,
//         ),
//       ),
//     ),*/
//     child: Center(
//       child: Text(
//         '$data',
//       ),
//     ),
//   );
// }

// Widget dataCellRow(String data) {
//   return Container(
//     //color:bgcolor,
//     /*  decoration: BoxDecoration(
//       border: Border(
//         right: BorderSide(
//           color: Colors.grey,
//           width: 1.0,
//         ),
//       ),
//     ),*/
//     child: Center(
//       child: Text(
//         '$data',
//       ),
//     ),
//   );
// }

// //input text
// TextFormField inputTextField(TextEditingController textEditingController,
//     String labelText, TextInputType textInputType) {
//   return TextFormField(
//     keyboardType: TextInputType.multiline,
//     maxLines: null,
//     controller: textEditingController,
//     validator: (String v) {
//       String value = v.trim();
//       if (value.isEmpty) return 'Empty field!';
//       return null;
//     },
//     inputFormatters: textInputType == TextInputType.number
//         ? [WhitelistingTextInputFormatter.digitsOnly]
//         : null,
//     decoration: InputDecoration(
//       labelText: labelText,
//       labelStyle: TextStyle(
//         color: colorLabelText,
//       ),
//       hintText: '',
//       hintStyle: TextStyle(
//         color: colorHintText,
//       ),
//     ),
//   );
// }

// /*Dialog*/
// // Delete items
// Widget alertDialog(BuildContext context, String title, int type) {
//   return Center(
//     child: Container(
//       // color: Colors.grey,
//       height: 200,
//       width: 200,
//       child: Card(
//           color: Colors.grey[100],
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               if (type == 0)
//                 CircularProgressIndicator()
//               else if (type == 1)
//                 Icon(
//                   Icons.done,
//                   size: 70.0,
//                   color: Colors.green,
//                 )
//               else if (type == 2)
//                 Icon(
//                   Icons.warning,
//                   size: 70.0,
//                   color: Colors.green,
//                 ),
//               Text(
//                 title,
//                 style:
//                     TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//               ),
//             ],
//           )),
//     ),
//   );
// }
