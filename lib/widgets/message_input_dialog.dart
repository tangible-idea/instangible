//import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProvider = StateProvider((ref) => '');
//final showDialogProvider = StateProvider((ref) => false);

class MessageInputDialog {

  static showInputDialog(BuildContext context, WidgetRef ref) {
    String editedValue= "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text('Enter Message'),
              TextFormField(
                initialValue: ref.watch(messageProvider.notifier).state,
                onChanged: (value) {
                  //ref.read(messageProvider.notifier).state= value;
                  editedValue= value;
                },
                decoration: const InputDecoration(hintText: 'Type your message'),
              )
            ],
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {

                if(editedValue.isEmpty) {
                  ref.read(messageProvider.notifier).state= "gymweirdos";
                } else {
                  ref.read(messageProvider.notifier).state= editedValue;
                }
                // Do something with the message
                //print('Message: ${messageRef.state}');
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },

    );
  }
}
