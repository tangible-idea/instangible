
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GPTUtils {

  OpenAI? openAI;
  GPTUtils() {
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

}