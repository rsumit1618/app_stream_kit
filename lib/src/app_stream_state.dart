/// Base type for simple, typed stream states.
///
/// Note: these classes are utilities and are not automatically used by the
/// widgets in this package.
sealed class AppStreamState<T> {
  /// Creates an [AppStreamState].
  const AppStreamState();
}

/// Represents the initial state.
class AppStreamInitial<T> extends AppStreamState<T> {
  /// Creates an [AppStreamInitial].
  const AppStreamInitial();
}

/// Represents a loading/waiting state.
class AppStreamLoading<T> extends AppStreamState<T> {
  /// Creates an [AppStreamLoading].
  const AppStreamLoading();
}

/// Represents a state with an available value.
class AppStreamData<T> extends AppStreamState<T> {
  /// The latest value.
  final T data;

  /// Creates an [AppStreamData] with [data].
  const AppStreamData(this.data);
}

/// Represents an error state.
class AppStreamError<T> extends AppStreamState<T> {
  /// The error object.
  final Object error;

  /// Optional stack trace.
  final StackTrace? stackTrace;

  /// Creates an [AppStreamError].
  const AppStreamError(this.error, [this.stackTrace]);
}

/// Represents the done/closed state of a stream.
class AppStreamDone<T> extends AppStreamState<T> {
  /// Optional last value (if known/desired by your state management).
  final T? data;

  /// Creates an [AppStreamDone].
  const AppStreamDone([this.data]);
}
