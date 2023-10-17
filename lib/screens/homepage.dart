
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagible/riverpod/videoeditlist_provider.dart';
import 'package:video_player/video_player.dart';

import '../model/user_model.dart';
import '../riverpod/simple_state_provider.dart';
import '../utils/flutter_insta.dart';

import '../widgets/my_feed_table.dart';
import '../widgets/message_input_dialog.dart';

class MyHomePage extends ConsumerWidget {
  static String id = "/home";
  MyHomePage({super.key, required this.title}) {
    initGPT();
  }

  final FlutterInsta flutterInsta= FlutterInsta();
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

  getListOfFeeds(WidgetRef ref, String targetValue) async {

    await flutterInsta.getProfileData(targetValue);
    // add feed items to state.
    flutterInsta.feedImagesUrl?.asMap().forEach((index, element) =>
        ref.read(feedEditListProvider.notifier).addFeedModel(
          FeedModel(
              displayUrl: element,
              link: flutterInsta.feedVideosUrl![index].toString() // TODO: exception handling
          )
        )
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileRef= ref.watch(fileProvider);
    final responseRef= ref.watch(responseProvider);
    final loadingRef= ref.watch(loadingProvider);
    final videoLink= ref.watch(videoLinkProvider);
    final dialogMessageRef= ref.watch(messageProvider);

    ref.listen(messageProvider, (previous, next) {
      getListOfFeeds(ref, next);
    });


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Instangible", style: Theme.of(context).textTheme.titleLarge),
          actions: [
            IconButton(
            icon: const Icon(Icons.download),
              onPressed: () {

            },
          ),
        ],
      ),
      body: FeedTable(),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> {
          //showDialog(context: context, builder: ()=> {return MessageInputDialog()})
          MessageInputDialog.showInputDialog(context, ref)
          //ref.read(showDialogProvider.notifier).state= true
        },//getListOfFeeds(ref),
        tooltip: 'pick files',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

