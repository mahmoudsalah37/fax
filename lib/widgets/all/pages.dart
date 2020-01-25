import 'package:fax/models/pages/fax_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fax/styles/all/all.dart';

Color bgcolor = Colors.grey;
bool co = false;
int counter = 0;
int counter2 = 0;
Widget nameHeadPage(String namePage) {
  return Text(
    namePage,
    style: tsMainText,
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

Widget nameColumnTable(String strName) {
  return Container(
    /* decoration: BoxDecoration(
      border: Border(
        right: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    ),
    */
    child: Center(
        child: Text(
      strName,
      style: textStyleColumnText,
    )),
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
      child: Text(
        '$data',
      ),
    ),
  );
}

//input text
TextFormField inputTextField(TextEditingController textEditingController,
    String labelText, TextInputType textInputType) {
  return TextFormField(
    keyboardType: TextInputType.multiline,
    maxLines: null,
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

List<FaxModel> filterTable(List<FaxModel> faxes, int index, bool isAscending) {
  switch (index) {
    case 0:
      faxes?.sort(
          (a, b) => a.title?.toLowerCase()?.compareTo(b.title?.toLowerCase()));
      break;
    case 1:
      faxes?.sort((a, b) =>
          a.nameSend?.toLowerCase()?.compareTo(b.nameSend?.toLowerCase()));
      break;
    case 2:
      faxes?.sort((a, b) =>
          a.nameRecieve?.toLowerCase()?.compareTo(b.nameRecieve?.toLowerCase()));
      break;
    case 3:
      faxes?.sort((a, b) =>
          a.fromDate?.toLowerCase()?.compareTo(b.fromDate?.toLowerCase()));
      break;
    case 4:
      faxes?.sort(
          (a, b) => a.toDate?.toLowerCase()?.compareTo(b.toDate?.toLowerCase()));
      break;
    case 5:
      faxes?.sort((a, b) =>
          a.serialFax?.toLowerCase()?.compareTo(b.serialFax?.toLowerCase()));
      break;
    case 6:
      faxes?.sort((a, b) => a.serialFaxInitial
          ?.toLowerCase()
          ?.compareTo(b.serialFaxInitial?.toLowerCase()));
      break;
    case 7:
      faxes?.sort((a, b) => a.certificationNumber
          ?.toLowerCase()
          ?.compareTo(b.certificationNumber?.toLowerCase()));
      break;
    case 8:
      faxes?.sort((a, b) =>
          a.subClass?.toLowerCase()?.compareTo(b.subClass?.toLowerCase()));
      break;
    case 9:
      faxes?.sort((a, b) =>
          a.personSend?.toLowerCase()?.compareTo(b.personSend?.toLowerCase()));
      break;
    case 10:
      faxes?.sort((a, b) => a.personRecieve
          ?.toLowerCase()
          ?.compareTo(b.personRecieve?.toLowerCase()));
      break;
    case 11:
      faxes?.sort((a, b) => a.isExport?.compareTo(b.isExport));
      break;
    default:
      return faxes;
  }

  if (!isAscending) faxes = faxes.reversed.toList();
  return faxes;
}
