///
//  Generated code. Do not modify.
//  source: stream.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'stream.pb.dart' as $0;
export 'stream.pb.dart';

class StreamClient extends $grpc.Client {
  static final _$source = $grpc.ClientMethod<$0.Empty, $0.Item>(
      '/stream.Stream/Source',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Item.fromBuffer(value));
  static final _$sink = $grpc.ClientMethod<$0.Item, $0.Empty>(
      '/stream.Stream/Sink',
      ($0.Item value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$pipe = $grpc.ClientMethod<$0.Item, $0.Item>(
      '/stream.Stream/Pipe',
      ($0.Item value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Item.fromBuffer(value));

  StreamClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseStream<$0.Item> source($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$source, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.Empty> sink($async.Stream<$0.Item> request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$sink, request, options: options).single;
  }

  $grpc.ResponseStream<$0.Item> pipe($async.Stream<$0.Item> request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$pipe, request, options: options);
  }
}

abstract class StreamServiceBase extends $grpc.Service {
  $core.String get $name => 'stream.Stream';

  StreamServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Item>(
        'Source',
        source_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Item value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Item, $0.Empty>(
        'Sink',
        sink,
        true,
        false,
        ($core.List<$core.int> value) => $0.Item.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Item, $0.Item>(
        'Pipe',
        pipe,
        true,
        true,
        ($core.List<$core.int> value) => $0.Item.fromBuffer(value),
        ($0.Item value) => value.writeToBuffer()));
  }

  $async.Stream<$0.Item> source_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async* {
    yield* source(call, await request);
  }

  $async.Stream<$0.Item> source($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> sink(
      $grpc.ServiceCall call, $async.Stream<$0.Item> request);
  $async.Stream<$0.Item> pipe(
      $grpc.ServiceCall call, $async.Stream<$0.Item> request);
}
