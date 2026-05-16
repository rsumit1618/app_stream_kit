import 'dart:async';

import 'package:flutter/widgets.dart';

/// Lifecycle-aware stream subscription.
///
/// This widget subscribes to [stream] in `initState`, resubscribes when the
/// stream instance changes, and cancels the subscription on `dispose`.
class AppStreamListener<T> extends StatefulWidget {
  /// Stream of values to listen to.
  final Stream<T> stream;

  /// Called for each data event emitted by [stream].
  final ValueChanged<T>? onData;

  /// Called when [stream] emits an error.
  final ValueChanged<Object>? onError;

  /// Called when [stream] is closed.
  final VoidCallback? onDone;

  /// Whether to cancel the subscription when an error occurs.
  ///
  /// See [StreamSubscription.cancelOnError].
  final bool cancelOnError;

  /// Optional widget displayed by this listener.
  final Widget? child;

  /// Creates an [AppStreamListener].
  const AppStreamListener({
    super.key,
    required this.stream,
    this.onData,
    this.onError,
    this.onDone,
    this.cancelOnError = false,
    this.child,
  });

  @override
  State<AppStreamListener<T>> createState() => _AppStreamListenerState<T>();
}

class _AppStreamListenerState<T> extends State<AppStreamListener<T>> {
  StreamSubscription<T>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant AppStreamListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.stream != widget.stream) {
      _unsubscribe();
      _subscribe();
    }
  }

  void _subscribe() {
    _subscription = widget.stream.listen(
      (data) {
        if (!mounted) return;

        widget.onData?.call(data);
      },
      onError: (Object error) {
        if (!mounted) return;

        widget.onError?.call(error);
      },
      onDone: () {
        if (!mounted) return;

        widget.onDone?.call();
      },
      cancelOnError: widget.cancelOnError,
    );
  }

  Future<void> _unsubscribe() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox.shrink();
  }
}
