import 'package:flutter/material.dart';

/// Signature for the main UI builder.
///
/// The provided `data` is `null` when the stream has not produced a value yet.
typedef AppStreamWidgetBuilder<T> =
    Widget Function(BuildContext context, T? data);

/// A `StreamBuilder`-like widget with lifecycle callbacks.
///
/// This widget renders:
/// - `emptyBuilder` when the stream is not connected / has no data.
/// - `loadingBuilder` while waiting for the first event.
/// - `builder` once data is available.
/// - `errorBuilder` when the stream emits an error.
///
/// Additionally, it provides optional callbacks:
/// - `onData` for each data event.
/// - `onError` when an error event occurs.
/// - `onDone` when the stream closes.
class AppStreamBuilder<T> extends StreamBuilderBase<T, AsyncSnapshot<T>> {
  /// Initial value used before the stream emits the first event.
  ///
  /// When `initialData` is `null`, the widget shows `emptyBuilder` until the
  /// stream connects and produces a value.
  final T? initialData;

  /// Called whenever the stream emits a data event.
  final ValueChanged<T>? onData;

  /// Called whenever the stream emits an error.
  final ValueChanged<Object>? onError;

  /// Called when the stream closes.
  final VoidCallback? onDone;

  /// Builder shown while waiting for the first event.
  final WidgetBuilder? loadingBuilder;

  /// Main builder for rendering the latest stream value.
  final AppStreamWidgetBuilder<T> builder;

  /// Builder shown when the stream emits an error.
  final Widget Function(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  )?
  errorBuilder;

  /// Builder shown when the stream is not connected and no `initialData` is
  /// available.
  final WidgetBuilder? emptyBuilder;

  /// Creates an [AppStreamBuilder].
  const AppStreamBuilder({
    super.key,
    required Stream<T> stream,
    required this.builder,
    this.initialData,
    this.onData,
    this.onError,
    this.onDone,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
  }) : super(stream: stream);

  @override
  AsyncSnapshot<T> initial() {
    if (initialData != null) {
      return AsyncSnapshot<T>.withData(ConnectionState.none, initialData as T);
    }

    return AsyncSnapshot<T>.nothing();
  }

  @override
  AsyncSnapshot<T> afterConnected(AsyncSnapshot<T> current) {
    return current.inState(ConnectionState.waiting);
  }

  @override
  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) {
    onData?.call(data);

    return AsyncSnapshot<T>.withData(ConnectionState.active, data);
  }

  @override
  AsyncSnapshot<T> afterError(
    AsyncSnapshot<T> current,
    Object error,
    StackTrace stackTrace,
  ) {
    onError?.call(error);

    return AsyncSnapshot<T>.withError(
      ConnectionState.active,
      error,
      stackTrace,
    );
  }

  @override
  AsyncSnapshot<T> afterDone(AsyncSnapshot<T> current) {
    onDone?.call();

    return current.inState(ConnectionState.done);
  }

  @override
  AsyncSnapshot<T> afterDisconnected(AsyncSnapshot<T> current) {
    return current.inState(ConnectionState.none);
  }

  @override
  Widget build(BuildContext context, AsyncSnapshot<T> snapshot) {
    if (snapshot.hasError) {
      return _buildError(context, snapshot);
    }

    switch (snapshot.connectionState) {
      case ConnectionState.none:
        if (snapshot.hasData || initialData != null) {
          return builder(context, snapshot.data ?? initialData);
        }
        return _buildEmpty(context);

      case ConnectionState.waiting:
        if (snapshot.hasData || initialData != null) {
          return builder(context, snapshot.data ?? initialData);
        }
        return loadingBuilder?.call(context) ?? _buildEmpty(context);

      case ConnectionState.active:
      case ConnectionState.done:
        if (snapshot.hasData || initialData != null) {
          return builder(context, snapshot.data ?? initialData);
        }
        return _buildEmpty(context);
    }
  }

  Widget _buildError(BuildContext context, AsyncSnapshot<T> snapshot) {
    final error = snapshot.error;

    if (error == null) {
      return _buildEmpty(context);
    }

    return errorBuilder?.call(context, error, snapshot.stackTrace) ??
        _buildEmpty(context);
  }

  Widget _buildEmpty(BuildContext context) {
    return emptyBuilder?.call(context) ?? const SizedBox.shrink();
  }
}
