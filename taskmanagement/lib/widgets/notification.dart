import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/item.dart';
import 'message.dart';

class ItemNotification extends StatelessWidget {
  final channel = WebSocketChannel.connect(Uri.parse('ws://172.30.113.160:2425'));

  ItemNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        builder: (context, snapshot) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (snapshot.hasData) {
              var item = Item.fromJson(jsonDecode(snapshot.data.toString()));
              Logger().log(Level.info, item);
              message(context, item.toString(), "Item added");
            }
          });
          return const Text('');
        },
        stream: channel.stream.asBroadcastStream());
  }
}
