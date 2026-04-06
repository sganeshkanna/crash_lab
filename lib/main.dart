import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crash Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const CrashLabHome(),
    );
  }
}

class CrashLabHome extends StatelessWidget {
  const CrashLabHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crash Lab')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Feature 1
            ElevatedButton(
              onPressed: () {
                var config = [];
                // This will trigger RangeError (index): Invalid value: Valid value range is empty: 0
                debugPrint(config[0]['title']);
              },
              child: const Text('Fetch Config'),
            ),
            const SizedBox(height: 16),
            // Feature 2
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AsyncContextScreen()),
                );
              },
              child: const Text('Go to Async Context Ghost'),
            ),
            const SizedBox(height: 16),
            // Feature 3
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const OtpCountdownScreen()),
                );
              },
              child: const Text('Go to OTP Countdown'),
            ),
            const SizedBox(height: 16),
            // Feature 4
            ElevatedButton(
              onPressed: () async {
                const channel = MethodChannel('crash_lab');
                await channel.invokeMethod('forceUnwrap');
              },
              child: const Text('Call Native Plugin'),
            ),
            const SizedBox(height: 16),
            // Test Button for Crashlytics
            ElevatedButton(
              onPressed: () {
                FirebaseCrashlytics.instance.crash();
              },
              child: const Text('Test Firebase Crashlytics'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class AsyncContextScreen extends StatelessWidget {
  const AsyncContextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Async Context Ghost')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await Future.delayed(const Duration(seconds: 3));
            // Triggers "Looked up a deactivated widget's ancestor" if user navigates back manually before timer ends
            Navigator.of(context).pop();
          },
          child: const Text('Delayed Navigate'),
        ),
      ),
    );
  }
}

class OtpCountdownScreen extends StatefulWidget {
  const OtpCountdownScreen({super.key});

  @override
  State<OtpCountdownScreen> createState() => _OtpCountdownScreenState();
}

class _OtpCountdownScreenState extends State<OtpCountdownScreen> {
  int _counter = 10;
  
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      // This will trigger an error if the widget is disposed
      setState(() {
        _counter--;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Countdown')),
      body: Center(
        child: Text('$_counter', style: const TextStyle(fontSize: 48)),
      ),
    );
  }
}
