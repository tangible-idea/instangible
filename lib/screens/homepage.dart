
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dart_pdf_reader/dart_pdf_reader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/riverpod/user_profilelist_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../model/user_model.dart';
import '../riverpod/simple_state_provider.dart';
import '../widgets/circular_progress.dart';

import 'package:flutter_insta/flutter_insta.dart';

class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key, required this.title}) {
    initGPT();
  }

  FlutterInsta flutterInsta= new FlutterInsta();
  final String title;

  Future<List<int>> _readDocumentData(String name) async {
    File inputFile= File(name);
    Uint8List bytes = inputFile.readAsBytesSync();
    return bytes;
  }

  OpenAI? openAI;
  Future<void> initGPT() async {
    openAI = OpenAI.instance.build(
        token: dotenv.get("API_KEY", fallback: ""),
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)),
        enableLog: true);

  }

  /// request to LLM
  Future<String> chatComplete(String messageRequest) async {

    final request = ChatCompleteText(messages: [
      Messages(role: Role.system, content: messageRequest)
    ], maxToken: 8096, model: GptTurbo16k0631Model());


    String resume= "";
    final response = await openAI?.onChatCompletion(request: request);
    for (var element in response!.choices) {
      //print("data -> ${element.message?.content}");
      resume += element.message!.content;
    }
    return resume;
  }

  downloadReels() async {
    String downloadLink =  await flutterInsta.downloadReels("https://www.instagram.com/reel/CDlGkdZgB2y/"); //URL
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileRef= ref.watch(fileProvider);
    final responseRef= ref.watch(responseProvider);
    final loadingRef= ref.watch(loadingProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Instagible", style: Theme.of(context).textTheme.titleLarge),
          actions: [
            IconButton(
            icon: const Icon(Icons.import_export),
              onPressed: () {
            },
        ),
        ],
      ),
      body: const SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> downloadReels(),
        tooltip: 'pick files',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

