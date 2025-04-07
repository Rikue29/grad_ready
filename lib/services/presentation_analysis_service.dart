import 'package:googleapis/aiplatform/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'env_config_service.dart';

class PresentationAnalysisService {
  late ProjectsResource _aiPlatform;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      print('Getting GCP credentials from environment...');
      final credentialsData = EnvConfigService.gcpCredentials;

      final credentials = ServiceAccountCredentials(
        credentialsData['client_email'],
        ClientId(
            credentialsData['client_id'], credentialsData['private_key_id']),
        credentialsData['private_key'],
      );

      print('Authenticating with Google Cloud...');
      final scopes = ['https://www.googleapis.com/auth/cloud-platform'];
      final client = await clientViaServiceAccount(credentials, scopes);
      _aiPlatform = AiplatformApi(client).projects;
      _isInitialized = true;
      print('Authentication successful');
    } catch (e) {
      print('Initialization error: $e');
      throw Exception('Failed to initialize analysis service: $e');
    }
  }

  Future<bool> testConnection() async {
    if (!_isInitialized) {
      throw Exception('Analysis service not initialized');
    }

    try {
      print('Testing connection to Google Cloud...');
      final projectId = EnvConfigService.gcpCredentials['project_id'];
      print('Listing locations for project $projectId...');
      await _aiPlatform.locations.list('projects/$projectId');
      print('Connection test successful');
      return true;
    } catch (e) {
      print('Connection test failed: $e');
      throw Exception('Failed to test connection: $e');
    }
  }
}
