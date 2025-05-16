import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppSecret {
  static final String geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? 'GEMINI_API_KEY';
}
