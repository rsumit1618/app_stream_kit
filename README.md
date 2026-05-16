<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

A small Flutter toolkit that makes it easier to build UI from Streams, with convenient builders and lifecycle-aware listeners.

## Features

- `AppStreamBuilder`: a `StreamBuilder`-like widget with customizable loading/empty/error builders.
- `AppStreamListener`: lifecycle-aware stream subscription with `onData`, `onError`, and `onDone` callbacks.
- `AppStreamConsumer`: combines listener + builder.
- `AppStreamState`: simple typed state classes (optional utility).

## Getting started

Add `app_stream_kit` to your `pubspec.yaml`:

```yaml
dependencies:
  app_stream_kit: ^0.0.1
```

## Usage

### AppStreamBuilder

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_stream_kit/app_stream_kit.dart';

class Example extends StatelessWidget {
  Example({super.key});

  final Stream<int> stream = Stream<int>.periodic(const Duration(seconds: 1), (i) => i);

  @override
  Widget build(BuildContext context) {
    return AppStreamBuilder<int>(
      stream: stream,
      initialData: 0,
      loadingBuilder: (_) => const CircularProgressIndicator(),
      emptyBuilder: (_) => const Text('No data'),
      errorBuilder: (context, error, _) => Text('Error: $error'),
      onData: (data) {
        // optional side-effect
      },
      builder: (context, data) => Text('Latest: $data'),
    );
  }
}
```

### AppStreamListener

```dart
AppStreamListener<int>(
  stream: stream,
  onData: (data) => debugPrint('data: $data'),
  onError: (e) => debugPrint('error: $e'),
  onDone: () => debugPrint('done'),
  child: const Text('Listening...'),
)
```

### AppStreamConsumer

```dart
AppStreamConsumer<int>(
  stream: stream,
  initialData: 0,
  listener: (context, data) {
    debugPrint('consumer data: $data');
  },
  loadingBuilder: (_) => const CircularProgressIndicator(),
  errorBuilder: (context, error, _) => Text('Error: $error'),
  emptyBuilder: (_) => const Text('No data'),
  builder: (context, data) => Text('Latest: $data'),
)
```

## Additional information

- GitHub: https://github.com/rsumit1618/app_stream_kit
- Issues: https://github.com/rsumit1618/app_stream_kit/issues

Pull requests welcome.

