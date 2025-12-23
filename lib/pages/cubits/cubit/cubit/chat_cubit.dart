import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );

  Future<void> sendMessage(String message, String email) async {
    try {
      await messages.add({
        kMessage: message,
        kCreatedAt: DateTime.now(),
        'id': email,
      });
    } catch (e) {
      emit(ChatFailure(errorMessage: e.toString()));
    }
  }

  void getMessages() {
    messages
        .orderBy(kCreatedAt, descending: true)
        .snapshots()
        .listen(
          (event) {
            List<Message> messageList = [];
            for (var doc in event.docs) {
              messageList.add(Message.fromJson(doc));
            }
            emit(ChatSuccess(messageList: messageList));
          },
          onError: (error) {
            emit(ChatFailure(errorMessage: error.toString()));
          },
        );
  }
}
