
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:instagible/utils/textpainter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

import '../styles/my_color.dart';
import 'image_util.dart';

extension on String {
  List<String> splitByLength(int length) =>
      [substring(0, length), substring(length)];
}

class PostingHelper {

  static const _shareInstaChannel = MethodChannel("instangible/shareinsta");

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // 인스타에 공유하기
  static Future<String> shareOnInstagram({String message = '', Uint8List? profileImageBytes}) async {

    // get path to save image.
    String dirToSave= await _localPath;

    // Load story background image.
    File backgroundImage= await ImageUtils.imageToFile(imageName: 'background9.png');
    final image = decodeImage(backgroundImage.readAsBytesSync())!;

    // Text를 이미지로 전환한다.
    final painterDesc = CustomTextPainter(message, 60.0, color: MyColor.kGrey1);
    final imageDesc = await painterDesc.toImageData();
    //final imageOfFont= await painterDesc.toImage();

    List<int>? listFont= imageDesc?.buffer.asUint8List().toList(growable: false);

    const onCenter= false;
    if(onCenter) {
      // 원본 이미지에 텍스트를 canvas로 그려서 입힌다. (가운데 좌표)
      drawImage(image, decodePng(listFont!)!,
          dstX: image.width~/2 - painterDesc.pictureW~/2 + 30,
          dstY: image.height~/2 - painterDesc.pictureH~/2 - 325,
          dstW: painterDesc.pictureW.toInt(),
          dstH: painterDesc.pictureH.toInt());
    }else{
      // 원본 이미지에 텍스트를 canvas로 그려서 입힌다. (가운데 좌표)
      drawImage(image, decodePng(listFont!)!,
          dstX: 150,
          dstY: 520,
          dstW: painterDesc.pictureW.toInt(),
          dstH: painterDesc.pictureH.toInt());
    }


    // Save the image to disk as a PNG
    String filePath= '$dirToSave/export.png';
    File(filePath).writeAsBytesSync(encodePng(image));


    Map<String, dynamic> arguments = {
      "imagePath": filePath,
    };
    final String resultFromNative= await _shareInstaChannel.invokeMethod("shareInstagramImageStoryWithSticker", arguments);

    //Log.d(resultFromAndroid);
    return resultFromNative;
  }


  // 인스타에 공유하기
  static Future<String> shareOnInstagramReply(Uint8List imageBytes) async {

    // get path to save image.
    String dirToSave= await _localPath;

    // Load story background image.
    var backgroundImage= await ImageUtils.imageToFile(imageName: 'background7.png');
    final decodedBackgroundImage = decodeImage(File(backgroundImage.path).readAsBytesSync())!;
    final decodedAnswerImage= decodeImage(imageBytes)!;

    const onCenter= true;
    if(onCenter) {
      double fScale= 3.0;
      int targetW= decodedAnswerImage.width.toInt()~/fScale;
      int targetH= decodedAnswerImage.height.toInt()~/fScale;

      // 원본 이미지에 텍스트를 canvas로 그려서 입힌다. (가운데 좌표)
      drawImage(decodedBackgroundImage, decodedAnswerImage,
          dstX: decodedBackgroundImage.width ~/ 2 - targetW~/2,
          dstY: decodedBackgroundImage.height ~/ 2 - targetH~/2,
          dstW: targetW,
          dstH: targetH);
    }

    // Save the image to disk as a PNG
    String filePath= '$dirToSave/export.png';
    File(filePath).writeAsBytesSync(encodePng(decodedBackgroundImage));

    Map<String, dynamic> arguments = {
      "imagePath": filePath,
      "link": ""
    };
    final String resultFromNative= await _shareInstaChannel.invokeMethod("shareInstagramImageStoryWithSticker", arguments);

    return resultFromNative;
  }


}