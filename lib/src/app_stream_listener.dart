import 'dart:async';

import 'package:flutter/widgets.dart';

class AppStreamListener<T> extends StatefulWidget {
  final Stream<T> stream;

  final ValueChanged<T>? onData;

  final ValueChanged<Object>? onError;

  final VoidCallback? onDone;

  final bool cancelOnError;

  final Widget? child;

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
