sealed class AppStreamState<T> {
  const AppStreamState();
}

class AppStreamInitial<T> extends AppStreamState<T> {
  const AppStreamInitial();
}

class AppStreamLoading<T> extends AppStreamState<T> {
  const AppStreamLoading();
}

class AppStreamData<T> extends AppStreamState<T> {
  final T data;

  const AppStreamData(this.data);
}

class AppStreamError<T> extends AppStreamState<T> {
  final Object error;
  final StackTrace? stackTrace;

  const AppStreamError(this.error, [this.stackTrace]);
}

class AppStreamDone<T> extends AppStreamState<T> {
  final T? data;

  const AppStreamDone([this.data]);
}
