import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiConfig {
  static late final String apiKey;

  static void initialize() {
    apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception("Gemini API key is not set in the .env file");
    }

    Gemini.init(apiKey: apiKey); 
  }
}
