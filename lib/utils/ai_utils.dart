
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../model/quotes.dart';

class AIUtils {



  Future<dynamic> callTextBot(String messageRequest, String? botName) async {
    var dio = Dio();
    var key= dotenv.get("LLM_API_KEY", fallback: "");
    var response = await dio.request(
      'https://aiconnect-fjptw3x2.b4a.run/bot/GPT-3.5-Turbo?request="$messageRequest"&apikey=$key',
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
      'https://aiconnect-fjptw3x2.b4a.run/bot/Photo_CreateE?request="$messageRequest$option"&apikey=$key',
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

}