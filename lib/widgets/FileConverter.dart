import 'dart:convert';
import 'dart:io';

class FileConverter {
  static String getBase64FormateFile(String path) {
    File file = File(path);
    print('File is = $file');
    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);
    print("coonvertbase64 $fileInBase64");
    return fileInBase64;

  }
}