import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart' as path;

// This function is used to show a message to the user accross the app

enum BudgetPeriod { monthly, weekly, daily }

void showMessageToUser(context, {required String message}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Center(child: Text(message)),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
}

final printLog = Logger();

// This function is used to pick image from gallery or camera
final _picker = ImagePicker();

Future<XFile?> pickImageFromGallery() async {
  final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
  return pickedImage;
}

// This function is used to take image with camera
Future<XFile?> takeImageWithCamera() async {
  final pickedImage = await _picker.pickImage(source: ImageSource.camera);
  return pickedImage;
}

String doctorsList = '''
  Dr. Md. Azizul Islam (Psychiatrist),
  Dr. Asma Islam (Family Medicine),
  Dr. Mahmuda Islam (Internal Medicine),
  Dr. Raisul Islam Khan (Geriatrics & Gerontology),
  Dr. Tanvirul Islam (Colorectal Surgery),
  Dr. M. A. Rahman (Internal Medicine),
  Dr. Sayful Islam (Internal Medicine),
  Dr. Mohammad Manirul Islam (Hematology),
  Prof. Dr. F.M. Mofakkharul Islam (Medicine),
  Prof. Dr. Shahla Khatun (Gynecology & Obstetrics),
  Dr. Md. Shafiqul Islam (Cardiology),
  Dr. Md. Shahinur Rahman (Orthopedic Surgery),
  Dr. Md. Abdul Kader (Nephrology),
  Dr. Md. Mizanur Rahman (Neurology),
  Dr. Md. Mahbubur Rahman (Pediatric Surgery),
  Dr. Md. Abdul Malek (Plastic Surgery),
  Dr. Md. Nurul Islam (Urology),
  Dr. Md. Abdul Hannan (Ophthalmology),
  Dr. Md. Abdul Mannan (ENT),
  Dr. Md. Shahinur Rahman (Dermatology),
  Dr. Md. Abdul Kader (Radiology),
  Dr. Md. Mizanur Rahman (Anesthesiology),
  Dr. Md. Mahbubur Rahman (Pathology),
  Dr. Md. Abdul Malek (Microbiology),
  Dr. Md. Nurul Islam (Biochemistry),
  Dr. Md. Abdul Hannan (Pharmacology),
  Dr. Md. Abdul Mannan (Community Medicine),
  Dr. Md. Shahinur Rahman (Forensic Medicine),
  Dr. Md. Abdul Kader (Occupational Medicine),
  Dr. Md. Mizanur Rahman (Sports Medicine),
  Dr. Md. Mahbubur Rahman (Emergency Medicine),
  Dr. Md. Abdul Malek (Intensive Care Medicine),
  Dr. Md. Nurul Islam (Geriatric Medicine),
  Dr. Md. Abdul Hannan (Palliative Medicine),
  Dr. Md. Abdul Mannan (Addiction Medicine)
''';

Future<String> compressImageFile(String filePath) async {
  final tempDir = await path.getTemporaryDirectory();
  final imgExt = filePath.split('.').last;
  final targetPath =
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.$imgExt';
  final result = await FlutterImageCompress.compressAndGetFile(
    filePath,
    targetPath,
    quality: 90, // 90% compression
  );
  if (result == null) {
    throw Exception("Image compression failed.");
  }

  return result.path;
}

// Extension for TimeOfDay formatting
extension TimeOfDayExtension on TimeOfDay {
  String format(BuildContext context) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, minute);
    return DateFormat.jm().format(dt);
  }
}
