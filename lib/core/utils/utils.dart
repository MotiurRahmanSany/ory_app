import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// This function is used to show a message to the user accross the app

void showMessageToUser(context, {required String message}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
          ),
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
}

// This function is used to pick image from gallery or camera
final _picker = ImagePicker();

Future<List<XFile>?> pickImagesFromGallery() async {
  final pickedImage = await _picker.pickMultiImage(
    limit: 10,
    imageQuality: 50,
  );
  return pickedImage;
}

// This function is used to take image with camera
Future<XFile?> takeImageWithCamera() async {
  final pickedImage = await _picker.pickImage(
    source: ImageSource.camera,
  );
  return pickedImage;
}


void copyTextToChipboard(BuildContext context, String value) async {
  await Clipboard.setData(ClipboardData(text: value));
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Copied to clipboard')),
  );
}