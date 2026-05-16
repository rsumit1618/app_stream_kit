import 'package:flutter/material.dart';

import 'app_stream_builder.dart';
import 'app_stream_listener.dart';

/// Combines [AppStreamListener] and [AppStreamBuilder] into a single widget.
///
/// This is useful when you want both:
/// - side effects (via `listener`, `onError`, `onDone`)
/// - UI updates (via `builder`, `loadingBuilder`, `errorBuilder`, `emptyBuilder`).
class AppStreamConsumer<T> extends StatelessWidget {
  /// Stream of values to consume.
  final Stream<T> stream;

  /// Optional initial value used by the internal [AppStreamBuilder].
  final T? initialData;

  /// Callback invoked for each data event emitted by [stream].
  final void Function(BuildContext context, T data)? listener;

  /// Called when [stream] emits an error.
  final ValueChanged<Object>? onError;

  /// Called when [stream] is closed.
  final VoidCallback? onDone;

  /// Builds the main UI using the latest stream value.
  final Widget Function(BuildContext context, T? data) builder;

  /// Builder used while waiting for the first event.
  final WidgetBuilder? loadingBuilder;

  /// Builder used when the stream emits an error.
  final Widget Function(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  )?
  errorBuilder;

  /// Builder used when no data is available yet.
  final WidgetBuilder? emptyBuilder;

  /// Creates an [AppStreamConsumer].
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
