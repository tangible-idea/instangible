
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/model/quotes.dart';
import 'package:instagible/riverpod/quote_provider.dart';
import 'package:instagible/utils/ai_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../riverpod/simple_state_provider.dart';
import '../styles/txt_style.dart';

class QuotePage extends ConsumerStatefulWidget {
  static String id= "QuotePage";

  @override
  QuoteState createState() => QuoteState();
}

class QuoteState extends ConsumerState<QuotePage> {

  WidgetsToImageController controller = WidgetsToImageController();


  @override
  initState() {
  }


  Widget buildQuoteContent(Quote quote) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // save widget to image
        WidgetsToImage(
          controller: controller,
          child: Stack(
            children: [
              // darken image filter with a generated author image.
              ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                child: Image.network(quote.authorImage!, )),
              // Text in center with a quote content.
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                      "${quote.content}\n\n- ${quote.author} -",
                      textAlign: TextAlign.center,
                      style: MyTextStyle.h3),
                ),
              ),

            ]
          ),
        ),
        Text("${quote.caption}"),
        ElevatedButton(
          onPressed: () async {
            Uint8List? bytes = await controller.capture();
            final directory = await getApplicationDocumentsDirectory();
            final pathOfImage = await File('${directory.path}/upload.png').create();

            if(bytes == null) {
              print("image data error!");
            }

            File file= await pathOfImage.writeAsBytes(bytes!);
            var loginData = FormData.fromMap({
              'username' : '',
              'password' : ''
            });

            var dio = Dio();
            var response = await dio.post(
              'https://fastinsta-whulmjii.b4a.run/instagram/login', data: loginData,
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
              'file': [
                await MultipartFile.fromFile(file.path)
              ],
              'sessionid': loginSession,
              'caption': 'test2'
            });

            var response2 = await dio.post(
              'https://fastinsta-whulmjii.b4a.run/instagram/publish', data: data,
            );

            if (response.statusCode == 200) {
              print("upload media key: ${json.encode(response2.data)}");
            }
            else {
              print("upload media error: ${response.statusMessage}");
            }
          },
          child: const Text('Post it'),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    var quoteRef= ref.watch(futureQuoteProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: quoteRef.when(
              data: (data)=> buildQuoteContent(data),
              error: (err, stack) => Text(err.toString()),
              loading: ()=> const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Generating a new quote.")
                ],
            ))),
        ),
      );
  }

}
