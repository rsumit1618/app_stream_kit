# app_stream_kit Usage Guide

This file contains additional examples for `app_stream_kit`.

## AppStreamBuilder

```dart
AppStreamBuilder<int>(
  stream: myStream,
  initialData: 0,
  loadingBuilder: (_) => const CircularProgressIndicator(),
  emptyBuilder: (_) => const Text('No data'),
  errorBuilder: (context, error, _) => Text('Error: $error'),
  builder: (context, data) => Text('Value: ${data ?? '—'}'),
);
```

## AppStreamListener

```dart
AppStreamListener<int>(
  stream: myStream,
  onData: (value) => print('data: $value'),
  onError: (error) => print('error: $error'),
  onDone: () => print('done'),
  child: const SizedBox.shrink(),
);
```

## AppStreamConsumer

```dart
AppStreamConsumer<int>(
  stream: myStream,
  initialData: 0,
  listener: (context, value) => print('consumer: $value'),
  loadingBuilder: (_) => const CircularProgressIndicator(),
  emptyBuilder: (_) => const Text('No data'),
  errorBuilder: (context, error, _) => Text('Error: $error'),
  builder: (context, data) => Text('Value: $data'),
);
```

