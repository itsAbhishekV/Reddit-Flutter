import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

Future<FilePickerResult?> pickImage(){
  final image = FilePicker.platform.pickFiles(type: FileType.image);

  return image;
}