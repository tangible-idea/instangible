
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../model/quotes.dart';

class AIUtils {

  String LLMserver= "https://aiconnect-fjptw3x2.b4a.run";
  String instaServer= "https://connect-kgdbk9r6.b4a.run"; // https://fastinsta1-ry99i1yh.b4a.run



  void callInstaPublish(file) async {
    var loginData = FormData.fromMap({
      'username' : dotenv.get("INSTAGRAM_USERNAME", fallback: ""),
      'password' : dotenv.get("INSTAGRAM_PASSWORD", fallback: "")
    });

    final directory = await getApplicationDocumentsDirectory();
    final pathOfImage = await File('${directory.path}/upload_compress.jpg').create();

    var compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, pathOfImage.path,
      quality: 20,
      format: CompressFormat.jpeg,
    );

    print(compressedFile?.path);
    //assert(compressedFile == null);

    var dio = Dio();
    var response = await dio.post(
      '$instaServer/instagram/login', data: loginData,
    );

    String loginSession= "";

    if (response.statusCode == 200) {
      loginSession= response.data.toString();
      print("loginSession: $loginSession");
    }
    else {
      print("login status error: ${response.statusMessage}");
      return;
    }

    var data = FormData.fromMap({
      'image': [
        await MultipartFile.fromFile(compressedFile!.path)
      ],
      'sessionid': loginSession,
      'caption': 'test2'
    });

    var response2 = await dio.post(
      '$instaServer/instagram/publish', data: data,
    );

    if (response.statusCode == 200) {
      print("upload media key: ${json.encode(response2.data)}");
    }
    else {
      print("upload media error: ${response.statusMessage}");
    }
  }


  Future<dynamic> callTextBot(String messageRequest, String? botName) async {
    var dio = Dio();
    var key= dotenv.get("LLM_API_KEY", fallback: "");

    var response = await dio.request(
      '$LLMserver/bot/GPT-3.5-Turbo?request="$messageRequest"&apikey=$key',
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> dataMap = jsonDecode(json.encode(response.data));
      if(dataMap.containsKey('message')) {
        return dataMap['message'];
      }
      else return "";
    }
    else {
      return response.statusMessage ?? "";
    }
  }

  Future<Quote> getQuote() async {
    var dio = Dio();
    var response = await dio.request(
      'https://api.quotable.io/random',
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> dataMap = jsonDecode(json.encode(response.data));
      var quote= Quote.fromJson(dataMap);
      return quote;
    }
    else {
      return Quote(id: "", content: "", author: "");
    }
  }


  Future<String> callImageGenBOT(String messageRequest) async {

    String option= ", Dark Grayscale, small image";

    var dio = Dio();
    var key= dotenv.get("LLM_API_KEY", fallback: "");
    var response = await dio.request(
      '$LLMserver/bot/Photo_CreateE?request="$messageRequest$option"&apikey=$key',
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      RegExp regExp = RegExp(r'(http.*?)(?=\))');
      var match = regExp.firstMatch(json.encode(response.data));

      if (match != null) {
        String imageUrl = match.group(1) ?? "";
        return imageUrl;
      }
      else {
        return "";
      }
    }
    else {
      return response.statusMessage ?? "";
    }
  }


  Future<String> callGetDescrption(String messageRequest) async {

    String requestToBot= "'$messageRequest' as Instagram post caption less than 50words with some hashtags.";

    var dio = Dio();
    var key= dotenv.get("LLM_API_KEY", fallback: "");
    var response = await dio.request(
      '$LLMserver/bot/GPT3.5-Turbo?request="$requestToBot"&apikey=$key',
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> dataMap = jsonDecode(json.encode(response.data));
      if(dataMap.containsKey('message')) {
        return dataMap['message'].toString().replaceAll('"', '');
      }
      else {
        return "";
      }
    }
    else {
      return response.statusMessage ?? "";
    }
  }

}