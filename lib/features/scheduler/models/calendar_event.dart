import 'package:flutter/material.dart';

class CalendarEvent {
  final String title;
  final String description;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final DateTime date;
  final Color color;
  final String reason;

  CalendarEvent({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.reason,
    this.color = Colors.blue,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json, DateTime date) {
    return CalendarEvent(
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: _parseTime(json['start_time'] as String),
      endTime: _parseTime(json['end_time'] as String),
      date: date,
      reason: json['reason'] as String,
      color: Colors.blue, // Optionally adjust or parse a color value
    );
  }

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
