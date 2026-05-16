import 'dart:async';

import 'package:app_stream_kit/app_stream_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppStreamBuilder shows initial data', (tester) async {
    final controller = StreamController<int>();

    await tester.pumpWidget(
      MaterialApp(
        home: AppStreamBuilder<int>(
          stream: controller.stream,
          initialData: 10,
          builder: (context, data) {
            return Text('Value: $data');
          },
        ),
      ),
    );

    expect(find.text('Value: 10'), findsOneWidget);

    await controller.close();
  });

  testWidgets('AppStreamBuilder shows loading state', (tester) async {
    final controller = StreamController<int>();

    await tester.pumpWidget(
      MaterialApp(
        home: AppStreamBuilder<int>(
          stream: controller.stream,
          loadingBuilder: (_) {
            return const Text('Loading');
          },
          builder: (context, data) {
            return Text('Value: $data');
          },
        ),
      ),
    );

    expect(find.text('Loading'), findsOneWidget);

    await controller.close();
  });

  testWidgets('AppStreamBuilder shows stream data', (tester) async {
    final controller = StreamController<int>();

    await tester.pumpWidget(
      MaterialApp(
        home: AppStreamBuilder<int>(
          stream: controller.stream,
          loadingBuilder: (_) {
            return const Text('Loading');
          },
          builder: (context, data) {
            return Text('Value: $data');
          },
        ),
      ),
    );

    controller.add(20);
    await tester.pump();

    expect(find.text('Value: 20'), findsOneWidget);

    await controller.close();
  });

  testWidgets('AppStreamBuilder shows error state', (tester) async {
    final controller = StreamController<int>();

    await tester.pumpWidget(
      MaterialApp(
        home: AppStreamBuilder<int>(
          stream: controller.stream,
          builder: (context, data) {
            return Text('Value: $data');
          },
          errorBuilder: (context, error, stackTrace) {
            return Text('Error: $error');
          },
        ),
      ),
    );

    controller.addError('Test error');
    await tester.pump();

    expect(find.text('Error: Test error'), findsOneWidget);

    await controller.close();
  });

  testWidgets('AppStreamListener receives data', (tester) async {
    final controller = StreamController<int>();
    int? receivedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: AppStreamListener<int>(
          stream: controller.stream,
          onData: (value) {
            receivedValue = value;
          },
          child: const Text('Child'),
        ),
      ),
    );

    controller.add(30);
    await tester.pump();

    expect(receivedValue, 30);
    expect(find.text('Child'), findsOneWidget);

    await controller.close();
  });

  testWidgets('AppStreamConsumer builds and listens safely', (tester) async {
    final controller = StreamController<int>();
    int? listenedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: AppStreamConsumer<int>(
          stream: controller.stream,
          listener: (context, value) {
            listenedValue = value;
          },
          loadingBuilder: (_) {
            return const Text('Loading');
          },
          builder: (context, data) {
            return Text('Value: $data');
          },
        ),
      ),
    );

    controller.add(40);
    await tester.pump();

    expect(listenedValue, 40);
    expect(find.text('Value: 40'), findsOneWidget);

    await controller.close();
  });
}
