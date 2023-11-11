
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagible/riverpod/videoeditlist_provider.dart';
import 'package:instagible/widgets/message_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../model/user_model.dart';
import '../riverpod/simple_state_provider.dart';
import '../utils/flutter_insta.dart';

import '../widgets/my_feed_table.dart';
import '../widgets/message_input_dialog.dart';
import 'edit_youtube_page.dart';

class MyHomePage extends ConsumerWidget {
  static String id = "/home";
  MyHomePage({super.key, required this.title}) {
    initGPT();
    getClipboardData();
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

  downloadReels(String link) async {
    String downloadLink =  await flutterInsta.downloadReels(link); //URL
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

  getYoutubeVideo(String videoLink) async {

    try {
      var yt = YoutubeExplode();
      /*var title = video.title; // "Scamazon Prime"
      var author = video.author; // "Jim Browning"
      var duration = video.duration; // Instance of Duration - 0:19:48.00000*/

      RegExp regYoutubeSlug = RegExp(r"\w{11}", // parse 11 digits video slug.
        caseSensitive: false,
        multiLine: false,
      );

      var youtubeLink = regYoutubeSlug.firstMatch(videoLink);
      var youtubeSlug = youtubeLink?.group(0);
      print("regexed slug: $youtubeSlug");

      /// link sample1: https://youtube.com/watch?v=SXZLNeVDfRA
      /// link sample2: https://www.youtube.com/shorts/oV1xt7Lo61c?feature=share
      /// slug sample: 'SXZLNeVDfRA'
      var manifest = await yt.videos.streamsClient.getManifest(youtubeSlug);
      // Get highest quality muxed stream
      var streamInfo = manifest.muxed.bestQuality;
      // Get the actual stream
      var stream = yt.videos.streams.get(streamInfo);

      Directory appDocDirectory = await getApplicationDocumentsDirectory();

      await Directory('${appDocDirectory.path}/dir').create(recursive: true)
      // The created directory is returned as a Future.
          .then((Directory directory) async {
            EditYoutubeState.targetFilePath =
            '${directory.path}/download_youtube.mp4';

            // Open a file for writing.
            var file = File(EditYoutubeState.targetFilePath);
            var fileStream = file.openWrite();

            // Pipe all the content of the stream into the file.
            await stream.pipe(fileStream);

            // Close the file.
            await fileStream.flush();
            await fileStream.close();
      });
    }on Exception catch (_, ex) {
      print(ex.toString());
    }
  }


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
                    await getYoutubeVideo(value);
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
            child: IconButton(onPressed: () {
              MessageDialog(
                initalString: currClipboard,
                onConfirm: (String value) {
                  print('Dialog returned value ---> $value');
                },
              );
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

