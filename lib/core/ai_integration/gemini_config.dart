
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:user_panel/core/keystore/keystore.dart';

class GeminiConfig {
  static late final String apiKey;

  static void initialize() {
    apiKey = EnvConstants.geminiApiKey;
    if (apiKey.isEmpty) {
      throw Exception("Gemini API key is not set in the .env file");
    }

    Gemini.init(apiKey: apiKey); 
  }
}
