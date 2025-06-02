import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calendar_event.dart';

final scheduleProvider = StateNotifierProvider<ScheduleNotifier, ScheduleState>((ref) {
  return ScheduleNotifier();
});

class ScheduleState {
  final Map<DateTime, List<CalendarEvent>> events;
  final bool isLoading;

  ScheduleState({required this.events, this.isLoading = false});
}

class ScheduleNotifier extends StateNotifier<ScheduleState> {
  ScheduleNotifier() : super(ScheduleState(events: {}));

  void addEvent(DateTime date, CalendarEvent event) {
    final events = Map<DateTime, List<CalendarEvent>>.from(state.events);
    events[date] = [...(events[date] ?? []), event];
    state = ScheduleState(events: events, isLoading: state.isLoading);
  }

  void deleteEvent(DateTime date, CalendarEvent event) {
    final events = Map<DateTime, List<CalendarEvent>>.from(state.events);
    events[date] = (events[date] ?? []).where((e) => e != event).toList();
    state = ScheduleState(events: events, isLoading: state.isLoading);
  }

  void setLoading(bool loading) {
    state = ScheduleState(events: state.events, isLoading: loading);
  }
}
