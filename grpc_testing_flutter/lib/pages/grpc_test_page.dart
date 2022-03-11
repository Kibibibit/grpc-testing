import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:grpc_testing_flutter/generated/stream.pbgrpc.dart';
import 'package:grpc_testing_flutter/utils/proto_utils.dart';

class GrpcTestPage extends StatefulWidget {
  const GrpcTestPage({Key? key}) : super(key: key);

  @override
  State<GrpcTestPage> createState() => _GrpcTestPageState();
}

class _GrpcTestPageState extends State<GrpcTestPage> {
  final stub = StreamClient(ProtoUtils.getChannel());
  
  late ResponseStream<Item> stream;
  
  List<Item> theList = [
    Item.fromJson(jsonEncode({"1": "E", "2": "O"}))
  ];

  late Timer timer;

  late ErrorHandler handler;

  final String token = "DO NOT SAVE TOKENS";
  @override
  void initState() {

    setState(() {
      handler = (object, stacktrace) {
        GrpcError error = object as GrpcError;
        print(error.code);
        print(stacktrace);
        timer.cancel();
      };
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TEST PAGE"),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                  stub
                    .connect(
                        Item.fromJson(jsonEncode({"1": token, "2": "Connect"})))
                    .listen((item) {
                  print("${item.body} - ${item.token}");
                }, onDone: () {
                  print("DONE!");
                }, cancelOnError: true)
                .onError(handler);


                setState(() {
                  timer = Timer.periodic(Duration(seconds: 5), (timer) {
                    stub.heartbeat(Item.fromJson(jsonEncode(
                        {"1": token, "2": "{\"heartbeat\":\"heartbeat\"}"})));
                  });
                });
              },
              child: const Text("Run Source!")),
          TextButton(
              onPressed: () {
                stub.sink(Item.fromJson(jsonEncode({
                  "1": token,
                  "2": jsonEncode({
                    "event_type": "AUTH_INIT",
                    "msg_type": "EVT_MSG",
                    "token": token,
                    "data": {
                      "code": "AUTH_INIT",
                      "platform": {"type": "web"},
                      "sessionId": "jti",
                    }
                  })
                })));
              },
              child: const Text("Runk sink!"))
        ],
      ),
    );
  }
}
