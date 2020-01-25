import 'package:fax/pages/log/login.dart';
import 'package:flutter/material.dart';
import 'package:fax/models/page_model.dart';
import 'package:fax/packages/provider/provider.dart';

import 'home/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الفاكسات',
      theme: ThemeData(),
      home: ChangeNotifierProvider<PageModel>(
        child: Home(),
        create: (BuildContext context) {
          return PageModel(LoginPage());
        },
      ),
    );
  }
}

// Future<List<String>> setImage() async {
//   final completer = Completer<List<String>>();
//   html.InputElement uploadInput = html.FileUploadInputElement();
//   uploadInput.multiple = true;
//   uploadInput.accept = 'image/*';
//   uploadInput.click();
//   List<html.File> files;
//   //* onChange doesn't work on mobile safari
//   uploadInput.addEventListener('change', (e) async {
//     // read file content as dataURL
//     files = uploadInput.files;

//     Iterable<Future<String>> resultsFutures = files.map((file) {
//       final reader = html.FileReader();
//       // reader.result;
//       reader.readAsDataUrl(file);
//       reader.onError.listen((error) => completer.completeError(error));
//       return reader.onLoad.first.then((_) => reader.result as String);
//     });

//     final results = await Future.wait(resultsFutures);
//     completer.complete(results);
//   });
//   //* need to append on mobile safari
//   html.document.body.append(uploadInput);
//   final List<String> images = await completer.future;
//   uploadInput.remove();
//   return images;
//   //* this also works
//   // final completer = Completer<List<String>>();
//   // final InputElement input = document.createElement('input');
//   // input
//   //   ..type = 'file'
//   //   ..multiple = true
//   //   ..accept = 'image/*';
//   // input.click();
//   //* onChange doesn't work on mobile safari
//   // input.addEventListener('change', (e) async {
//   //   final List<File> files = input.files;
//   //   Iterable<Future<String>> resultsFutures = files.map((file) {
//   //     final reader = FileReader();
//   //     reader.readAsDataUrl(file);
//   //     reader.onError.listen((error) => completer.completeError(error));
//   //     return reader.onLoad.first.then((_) => reader.result as String);
//   //   });
//   //   final results = await Future.wait(resultsFutures);
//   //   completer.complete(results);
//   // });
//   //* need to append on mobile safari
//   // document.body.append(input);
//   // // input.click(); can be here
//   // final List<String> images = await completer.future;
//   // setState(() {
//   //   _uploadedImages = images;
//   // });
//   // input.remove();
// }

//   void file2Zip() {
//     // // Read the Zip file from disk.
//     // Uint8List bytes = File('test.zip').readAsBytesSync();

//     // // Decode the Zip file
//     // Archive archive = ZipDecoder().decodeBytes(bytes);

//     // // Extract the contents of the Zip archive to disk.
//     // for (final file in archive) {
//     //   final filename = file.name;
//     //   if (file.isFile) {
//     //     List<int> data = file.content as List<int>;
//     //     File('out/' + filename)
//     //       ..createSync(recursive: true)
//     //       ..writeAsBytesSync(data);
//     //   } else {
//     //     Directory('out/' + filename)..create(recursive: true);
//     //   }
//     // }

//     // Encode the archive as a BZip2 compressed Tar file.
//     Uint8List bytes = files.readAsBytesSync() as Uint8List;
//     List<int> tar_data = TarEncoder().encode(archive);
//     List<int> tar_bz2 = BZip2Encoder().encode(tar_data);
  
//     // Write the compressed tar file to disk.
//     File fp = File('test.tbz');
//     fp.writeAsBytesSync(tar_bz2);

//     // Zip a directory to out.zip using the zipDirectory convenience method
//     ZipFileEncoder encoder = ZipFileEncoder();
//     encoder.zipDirectory(Directory('out'), filename: 'out.zip');

//     // Manually create a zip of a directory and individual files.
//     encoder.create('out2.zip');
//     encoder.addDirectory(Directory('out'));
//     encoder.addFile(File('test.zip'));
//     encoder.close();
//   }