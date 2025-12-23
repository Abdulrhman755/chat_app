import 'package:chat_app/constants.dart';

class Message {
  final String message;
  final String id;
  Message(this.id, {required this.message});

  factory Message.fromJson(jsonData) {
    return Message(jsonData['id'] ?? '', message: jsonData[kMessage] ?? '');
  }
}
