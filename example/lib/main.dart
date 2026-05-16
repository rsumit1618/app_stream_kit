import 'dart:async';

import 'package:app_stream_kit/app_stream_kit.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Stream Kit Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const StreamExamplePage(),
    );
  }
}

class StreamExamplePage extends StatefulWidget {
  const StreamExamplePage({super.key});

  @override
  State<StreamExamplePage> createState() => _StreamExamplePageState();
}

class _StreamExamplePageState extends State<StreamExamplePage> {
  late final StreamController<int> _counterController;

  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _counterController = StreamController<int>.broadcast();
  }

  void _incrementCounter() {
    if (_counterController.isClosed) return;

    _counter++;
    _counterController.add(_counter);
  }

  void _addError() {
    if (_counterController.isClosed) return;

    _counterController.addError('Something went wrong');
  }

  void _completeStream() {
    if (_counterController.isClosed) return;

    _counterController.close();
  }

  void _resetStream() {
    if (!_counterController.isClosed) return;

    setState(() {
      _counter = 0;
      _counterController = StreamController<int>.broadcast();
    });
  }

  @override
  void dispose() {
    if (!_counterController.isClosed) {
      _counterController.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final counterStream = _counterController.stream;

    return Scaffold(
      appBar: AppBar(title: const Text('App Stream Kit Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AppStreamConsumer<int>(
          stream: counterStream,
          initialData: 0,
          listener: (context, value) {
            if (value == 5) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Counter reached 5')),
              );
            }
          },
          onError: (error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $error')));
          },
          onDone: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Stream completed')));
          },
          loadingBuilder: (_) {
            return const Center(child: CircularProgressIndicator());
          },
          emptyBuilder: (_) {
            return const Center(child: Text('No data yet'));
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
            );
          },
          builder: (context, value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Counter value from stream:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Text(
                  '${value ?? 0}',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _counterController.isClosed
                      ? null
                      : _incrementCounter,
                  child: const Text('Add Data'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _counterController.isClosed ? null : _addError,
                  child: const Text('Add Error'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _counterController.isClosed
                      ? null
                      : _completeStream,
                  child: const Text('Complete Stream'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _counterController.isClosed ? _resetStream : null,
                  child: const Text('Reset Stream'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
