import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grpc_testing_flutter/generated/stream.pbgrpc.dart';
import 'package:grpc_testing_flutter/utils/proto_utils.dart';

class GrpcTestPage extends StatefulWidget {
  const GrpcTestPage({Key? key}) : super(key: key);

  @override
  State<GrpcTestPage> createState() => _GrpcTestPageState();
}

class _GrpcTestPageState extends State<GrpcTestPage> {
  final stub = StreamClient(ProtoUtils.getChannel());

  List<Item> theList = [
    Item.fromJson(jsonEncode({"1": "E", "2": "O"}))
  ];

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
                stub.source(Empty()).listen((item) {
                  print("${item.body} - ${item.token}");
                }).onDone(() {
                  print("done!");
                });
              },
              child: const Text("Run Source!")),
          TextButton(
              onPressed: () {
                stub.sink(Stream.fromIterable([
                  Item.fromJson(jsonEncode({"1": "JOE", "2": "MAHER"}))
                ]));
              },
              child: const Text("Runk sink!")),
          TextButton(
              onPressed: () {
                stub.pipe(Stream.fromIterable(theList)).listen((Item item) {
                  print("${item.body} - ${item.token}");
                });
              },
              child: const Text("Open Pipe!")),
          TextButton(
              onPressed: () {
                setState(() {
                  theList.add(
                      Item.fromJson(jsonEncode({"1": "JOE", "2": "MAHER"})));

                  print(theList);
                });
              },
              child: const Text("Add to pipe!"))
        ],
      ),
    );
  }
}
