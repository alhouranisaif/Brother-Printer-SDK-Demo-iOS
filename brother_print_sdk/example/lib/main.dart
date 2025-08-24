import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:brother_print_sdk/brother_print_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final BrotherPrintSdk _sdk = BrotherPrintSdk();
  final List<Map<String, dynamic>> _found = [];
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _sub = _sdk.onDiscovery().listen((event) {
      setState(() {
        _found.add(event);
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _sdk.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Running on: $_platformVersion'),
            ),
            Row(
              children: [
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async { await _sdk.startNetworkSearch(); },
                  child: const Text('Start Network Search'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async { await _sdk.cancelSearch(); },
                  child: const Text('Cancel'),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _found.length,
                itemBuilder: (context, index) {
                  final m = _found[index];
                  return ListTile(
                    title: Text(m['modelName'] ?? ''),
                    subtitle: Text(m['ipAddress'] ?? m['channelInfo'] ?? ''),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
