import 'package:flutter/material.dart';

class GCPTestPage extends StatelessWidget {
  const GCPTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GCP Test'),
      ),
      body: const Center(
        child: Text('GCP Test Page'),
      ),
    );
  }
}
