import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  _submittingMessages() async {
    final _enteredMessage = _messageController.text;

    if (_enteredMessage.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    // firebase logic to store messages

    final theUser =
        FirebaseAuth.instance.currentUser!; // getting logged user data

    final theUserData =
        await FirebaseFirestore.instance // those three line to retrive data
            .collection('users') // from firebase firestore
            .doc(theUser.uid) // based on the logged in user special unique id.
            .get();

    await FirebaseFirestore.instance.collection('chat').add({
      'message_content': _enteredMessage,
      'created_At': Timestamp.now(),
      'user_id': theUser.uid,
      'user_image': theUserData.data()!['user_image'],
      'user_name': theUserData.data()!['username'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: _messageController,
          autocorrect: true,
          textCapitalization: TextCapitalization.sentences,
          enableSuggestions: true,
          decoration: const InputDecoration(label: Text('Enter a message')),
        )),
        IconButton(
          onPressed: _submittingMessages,
          icon: const Icon(Icons.send),
          style: IconButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary),
        )
      ],
    );
  }
}
