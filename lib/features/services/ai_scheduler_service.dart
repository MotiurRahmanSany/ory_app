import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ory/core/common/constants/app_secret.dart';
import 'package:ory/core/utils/utils.dart';
import '../schedule/models/calendar_event.dart';
import '../schedule/models/schedule_suggestion.dart';

class AISchedulerService {
  static const String _apiKey = AppSecret.geminiApiKey;
  final GenerativeModel _model;

  AISchedulerService()
      : _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);

  Future<ScheduleSuggestion> getScheduleSuggestion({
    required String userPrompt,
    required List<CalendarEvent> existingEvents,
  }) async {
    final prompt = '''
You are a professional scheduling assistant. The user has these existing events:
${_formatEvents(existingEvents)}
The user wants to: $userPrompt
Suggest the best time slot considering:
- 1 hour minimum gap between events
- Typical working hours (9 AM - 6 PM)
- Balanced daily schedule
Return in JSON format(no comments is allowed or anything else in the response except the core json with resonse
the format for date, startTime, endTime is given, give a valid time for each of them don't just give any invalid string 
that cant be parsed as datetime!
):
{
  "title": "Event title",
  "description": "Detailed description",
  "date": "YYYY-MM-DD", 
  "startTime": "HH:MM",
  "endTime": "HH:MM",
  "reason": "Explanation of choice"
}
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    if (response.text == null) {
      throw Exception('No response from AI');
    }

    // Clean the AI response to remove markdown formatting (e.g., ```json)
    final cleanedResponse = _cleanResponse(response.text!);
    printLog.w('finding promblem in this code');
    return ScheduleSuggestion.fromJson(cleanedResponse);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatEvents(List<CalendarEvent> events) {
    return events.map((e) {
      final dateStr = e.date.toIso8601String();
      final start = _formatTime(e.startTime);
      final end = _formatTime(e.endTime);
      return '$dateStr $start-$end: ${e.title}';
    }).join('\n');
  }

  String _cleanResponse(String response) {
    // Remove markdown code block markers and optional language specifiers (like 'json')
    final cleaned = response
        .replaceAll(RegExp(r'```(\w+)?'), '')
        .replaceAll('```', '')
        .trim();
    return cleaned;
  }
}
