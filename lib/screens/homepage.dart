
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagible/riverpod/videoeditlist_provider.dart';
import 'package:instagible/utils/ai_utils.dart';
import 'package:instagible/utils/youtube_utils.dart';
import 'package:instagible/widgets/message_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../model/user_model.dart';
import '../riverpod/simple_state_provider.dart';
import '../utils/flutter_insta.dart';

import '../utils/gpt_utils.dart';
import '../widgets/my_feed_table.dart';
import '../widgets/message_input_dialog.dart';
import 'edit_youtube_page.dart';

class MyHomePage extends ConsumerWidget with WidgetsBindingObserver {
  static String id = "/home";
  MyHomePage({super.key, required this.title}) {
    //gptUtils.initGPT();
    getClipboardData();
    WidgetsBinding.instance.addObserver(this);
  }

  //final GPTUtils gptUtils= GPTUtils();
  final AIUtils aiUtils= AIUtils();
  final FlutterInsta flutterInsta= FlutterInsta();
  final String title;

  /// App has come to the foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getClipboardData();
    }
  }

  Future<List<int>> _readDocumentData(String name) async {
    File inputFile= File(name);
    Uint8List bytes = inputFile.readAsBytesSync();
    return bytes;
  }


  // downloadReels(String link) async {
  //   String downloadLink =  await flutterInsta.downloadReels(link); //URL
  // }
  //
  // getListOfFeeds(WidgetRef ref, String targetValue) async {
  //
  //   await flutterInsta.getProfileData(targetValue);
  //   // add feed items to state.
  //   flutterInsta.feedImagesUrl?.asMap().forEach((index, element) =>
  //       ref.read(feedEditListProvider.notifier).addFeedModel(
  //         FeedModel(
  //             displayUrl: element,
  //             link: flutterInsta.feedVideosUrl![index].toString() // TODO: exception handling
  //         )
  //       )
  //   );
  // }

  // store clipboard data
  String currClipboard= "";

  getClipboardData() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    currClipboard= data?.text.toString() ?? "";
    //ref.read(messageProvider.notifier).state= currClipboard;
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileRef= ref.watch(fileProvider);
    final responseRef= ref.watch(responseProvider);
    final loadingRef= ref.watch(loadingProvider);
    final videoLink= ref.watch(videoLinkProvider);
    final dialogMessageRef= ref.watch(messageProvider);

    // ref.listen(messageProvider, (previous, next) {
    //   getListOfFeeds(ref, next);
    // });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Instangible", style: Theme.of(context).textTheme.titleLarge),
          actions: [
            IconButton(
            icon: const Icon(Icons.download),
              onPressed: () async {

                if (!context.mounted) return;
                MessageInputDialog().showInputDialog(context, ref);
            },
          ),
        ],
      ),
      body: Column(children: [
        /// Button1. Get youtube video 🎥
        Expanded(
          flex: 1,
          child: Center(
            child: IconButton(onPressed: () {
              showDialog<String>(
                context: context,
                builder: (context) => MessageDialog(
                  initalString: currClipboard,
                  onConfirm: (String value) async {
                    NavigatorState nav = Navigator.of(context);
                    await YoutubeUtils.getYoutubeVideo(value);
                    nav.pushNamed(EditYoutubePage.id);
                  },
                ),
              );
            },
              icon: const FaIcon(FontAwesomeIcons.youtube),
              focusColor: Colors.red,
            ),
          ),
        ),

        /// Button2. get POE bot
        Expanded(
          flex: 1,
          child: Center(
            child: IconButton(onPressed: () async {
              var result= await aiUtils.getQuote();
              print("result from Quote: ${result.author}");

              var imageURL= await aiUtils.callImageGenBOT(result.author ?? "");
              print(imageURL);


            }, icon: const FaIcon(FontAwesomeIcons.robot)),
          ),
        ),
      ],),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> {
        },//getListOfFeeds(ref),
        tooltip: 'put Youtube video link',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

