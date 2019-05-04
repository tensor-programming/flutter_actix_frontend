import 'dart:convert';
import 'dart:io';

import 'package:fb_auth_example/model.dart';
import 'package:http/http.dart' as http;

class ChatRepository {
  static const _url = "10.0.2.2:8080";

  Future<List<Message>> postApiLogin(Message msg) async {
    http.Response res = await http.post(
      Uri.parse("http://$_url/login"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(
        msg.login(),
      ),
    );

    List j = json.decode(res.body);
    return j.map((msg) => Message.fromJson(msg)).toList();
  }

  Future<void> postApiMessage(Message msg) async {
    await http.post(
      Uri.parse("http://$_url/send"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(
        msg.send(),
      ),
    );
  }

  Future<WebSocket> getWebsocket() async {
    WebSocket websocket = await WebSocket.connect("ws://$_url/get_ws");

    return websocket;
  }
}
