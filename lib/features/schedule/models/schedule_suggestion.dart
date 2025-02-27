import 'dart:convert';
import 'package:flutter/material.dart';

class ScheduleSuggestion {
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String reason;

  ScheduleSuggestion({
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.reason,
  });

  factory ScheduleSuggestion.fromJson(String jsonString) {
  final dynamic decoded = jsonDecode(jsonString);
  final Map<String, dynamic> json;
  
  if (decoded is List) {
    if (decoded.isEmpty) {
      throw Exception("Received empty suggestions list from AI.");
    }
    json = decoded.first as Map<String, dynamic>;
  } else if (decoded is Map<String, dynamic>) {
    json = decoded;
  } else {
    throw Exception("Unexpected JSON format from AI.");
  }
  print('json: $json');
  return ScheduleSuggestion(
    title: json['title'] as String,
    description: json['description'] as String,
    date: DateTime.parse(json['date'] as String),
    startTime: _parseTime(json['startTime'] as String),
    endTime: _parseTime(json['endTime'] as String),
    reason: json['reason'] as String,
  );
}


  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
