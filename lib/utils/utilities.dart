import 'dart:io';
import 'dart:math';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static String getUsername(String? email) {
    return "live:${email?.split('@')[0]}";
  }

  static String getInitials(String? name) {
    List<String> nameSplit = name!.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String secondNameInitial = nameSplit[1][0];
    return firstNameInitial + secondNameInitial;
  }

  static Future<File> pickImage({required ImageSource source}) async {
    File selectedImage = await pickImage(source: source);
    return await compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);
    final image = decodeImage(File('test.webp').readAsBytesSync())!;
    copyResize(image, width: 500, height: 500);

    return File('$path/img_$rand.jpg')
      ..writeAsBytesSync(encodeJpg(image, quality: 85));
  }
}
