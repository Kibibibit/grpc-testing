import 'dart:async';
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

  late Timer timer;

  final String token =
      "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJHLUFkSlpqdDU0OXNnaFltYkE5TmJLb0xsM2szTWxFUW5ER0FVY0pRemlRIn0.eyJleHAiOjE2NDkzMDQ4MjIsImlhdCI6MTY0NjcxMjgyMiwiYXV0aF90aW1lIjoxNjQ1NDg0NjI1LCJqdGkiOiJhYzg3NzY3ZS1lYzJhLTQzZDctODllYS00NTBmMmNlMTMxNDMiLCJpc3MiOiJodHRwczovL2tleWNsb2FrLmdhZGEuaW8vYXV0aC9yZWFsbXMvbG9qaW5nIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6ImVjMTNlMGQ3LWRkOTgtNGU2MS04NjdiLWMwOTk4OWJhZGUwNCIsInR5cCI6IkJlYXJlciIsImF6cCI6ImFseXNvbiIsIm5vbmNlIjoiOFBsc1ZZVG9GUGhhMEtNVGIwVm91QSIsInNlc3Npb25fc3RhdGUiOiJkMzU5OWNiNC1mYjI4LTRjZmUtYWZhMC0zNjdlNTA0ZDQyMGIiLCJhY3IiOiIwIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHBzOi8vIiwiaHR0cHM6Ly9sb2ppbmctZGV2LmdhZGEuaW8iLCIqIiwiaHR0cDovL2xvY2FsaG9zdDozMDAwIl0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJ0ZXN0Iiwic2VydmljZSIsIm9mZmxpbmVfYWNjZXNzIiwiYWRtaW4iLCJ1bWFfYXV0aG9yaXphdGlvbiIsInVzZXIiLCJkZWZhdWx0LXJvbGVzLWxvamluZyJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoiZW1haWwgcHJvZmlsZSIsInNpZCI6ImQzNTk5Y2I0LWZiMjgtNGNmZS1hZmEwLTM2N2U1MDRkNDIwYiIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoidGVzdCB1c2VyIiwicHJlZmVycmVkX3VzZXJuYW1lIjoidGVzdHVzZXJAZ2FkYS5pbyIsImdpdmVuX25hbWUiOiJ0ZXN0IiwiZmFtaWx5X25hbWUiOiJ1c2VyIiwiZW1haWwiOiJ0ZXN0dXNlckBnYWRhLmlvIn0.Bu1mKeI2xnoSdfMmtI0KdRAJWf7vhAH-u6bKueHB5JLFy1-j3VgvskbxRKxykNuqvdmhkGIRv5I2sKljeDRGwtlp4WVWVtT1P5_C7sNATtWuxZerFLxuU_tN7lFoZi2nJTLHAnwnNS8Ka1rp3qJGpK6uMFbHCBnPsoUHUJ8mVX4GnoA1xXrHJ_KADW_xOKepygsR6-TszJ1AZ0UO6Lx-17KlmuYoM_myNeJV8lrzgknlkVyzxHfLe48nhAph-5NTHUz0D70G5TJu_eaKmabPkQX6Dlfi00i7eJpgnNOWs-48iZBT09PL1OsKg9ztgfQzk3DAr8hhNtR7jDpiWLSdIQ";

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
                }).onDone(() {
                  print("connection closed");
                  timer.cancel();
                });
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
