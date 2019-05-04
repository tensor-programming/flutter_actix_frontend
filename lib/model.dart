import 'dart:io';
import 'dart:convert';

import 'package:fb_auth_example/repo.dart';
import 'package:scoped_model/scoped_model.dart';

class Message {
  final String id;
  final String username;
  final String body;
  final String timestamp;

  Message({
    this.id,
    this.username,
    this.body,
    this.timestamp,
  });

  Message.fromJson(Map<String, dynamic> json)
      : this.id = json["id"],
        this.username = json["username"],
        this.body = json["body"],
        this.timestamp = json["ts"];

  Map<String, dynamic> login() {
    return {
      'username': username,
    };
  }

  Map<String, dynamic> send() {
    return {
      'username': username,
      'body': body,
    };
  }
}

class MessageModel extends Model {
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  Future<void> login(ChatRepository repo, Message msg) async {
    List<Message> msgs = await repo.postApiLogin(msg);
    _messages = List.from(msgs);
    notifyListeners();
  }

  Future<void> setUpMessages(ChatRepository repo) async {
    WebSocket websocket = await repo.getWebsocket();
    websocket.pingInterval = Duration(seconds: 5);

    websocket.listen((data) {
      if (websocket.readyState == WebSocket.open) {
        _messages = List.from(_messages)
          ..insert(0, Message.fromJson(json.decode(data)));
        notifyListeners();
      } else {
        websocket.close();
      }
    });
  }
}
