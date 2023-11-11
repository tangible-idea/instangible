import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageDialog extends StatefulWidget {
  @override
  _MessageDialogState createState() => _MessageDialogState();

  // The callback function with data you want to return -------|
  final Function(String value) onConfirm;      // <------------|

  const MessageDialog({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);
}

class _MessageDialogState extends State<MessageDialog> {
  String result = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          const Text('Enter URL'),
          TextFormField(
            initialValue: result,
            onChanged: (value) {
              //ref.read(messageProvider.notifier).state= value;
              result= value;
            },
            decoration: const InputDecoration(hintText: 'Type your message'),
          ),
          ElevatedButton(
            onPressed: () {
              // Call the function here to pass back the value -----|
              widget.onConfirm(result);       // <-------------------|
              Navigator.pop(context);
            },
            child: const Text('confirm'),
          ),
        ],
      ),
    );
  }
}