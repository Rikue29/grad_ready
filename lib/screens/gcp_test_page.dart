import 'package:flutter/material.dart';
import '../services/presentation_analysis_service.dart';

class GcpTestPage extends StatefulWidget {
  const GcpTestPage({super.key});

  @override
  State<GcpTestPage> createState() => _GcpTestPageState();
}

class _GcpTestPageState extends State<GcpTestPage> {
  final _service = PresentationAnalysisService();
  String _status = 'Not initialized';
  bool _isLoading = false;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Initializing...';
    });

    try {
      await _service.initialize();
      setState(() {
        _status = 'Initialized. Testing connection...';
      });

      final success = await _service.testConnection();
      setState(() {
        _status = success ? '✅ Connection successful!' : '❌ Connection failed';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2632),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2632),
        iconTheme: const IconThemeData(
          color: Color(0xFFFF6B00), // Orange color to match the button
        ),
        title: const Text(
          "GCP Connection Test",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2632),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const CircularProgressIndicator(
                      color: Color(0xFFFF6B00),
                    )
                  else
                    ElevatedButton(
                      onPressed: _testConnection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B00),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'Test Connection',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
