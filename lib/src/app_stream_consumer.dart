import 'package:flutter/material.dart';

import 'app_stream_builder.dart';
import 'app_stream_listener.dart';

class AppStreamConsumer<T> extends StatelessWidget {
  final Stream<T> stream;

  final T? initialData;

  final void Function(BuildContext context, T data)? listener;

  final ValueChanged<Object>? onError;

  final VoidCallback? onDone;

  final Widget Function(BuildContext context, T? data) builder;

  final WidgetBuilder? loadingBuilder;

  final Widget Function(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  )?
  errorBuilder;

  final WidgetBuilder? emptyBuilder;

  const AppStreamConsumer({
    super.key,
    required this.stream,
    required this.builder,
    this.initialData,
    this.listener,
    this.onError,
    this.onDone,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final broadcastStream = stream.isBroadcast
        ? stream
        : stream.asBroadcastStream();

    return AppStreamListener<T>(
      stream: broadcastStream,
      onData: (data) => listener?.call(context, data),
      onError: onError,
      onDone: onDone,
      child: AppStreamBuilder<T>(
        stream: broadcastStream,
        initialData: initialData,
        builder: builder,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
        emptyBuilder: emptyBuilder,
      ),
    );
  }
}
