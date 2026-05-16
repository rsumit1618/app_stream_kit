import 'package:flutter/material.dart';

typedef AppStreamWidgetBuilder<T> =
    Widget Function(BuildContext context, T? data);

class AppStreamBuilder<T> extends StreamBuilderBase<T, AsyncSnapshot<T>> {
  final T? initialData;

  final ValueChanged<T>? onData;

  final ValueChanged<Object>? onError;

  final VoidCallback? onDone;

  final WidgetBuilder? loadingBuilder;

  final AppStreamWidgetBuilder<T> builder;

  final Widget Function(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  )?
  errorBuilder;

  final WidgetBuilder? emptyBuilder;

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
