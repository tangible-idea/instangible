import 'dart:ffi';

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
              TextField(
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
              child: Text('OK'),
              onPressed: () {
                ref.read(messageProvider.notifier).state= editedValue;
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
