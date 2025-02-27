import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:ory/core/utils/utils.dart';
import 'package:ory/features/schedule/presentation/schedule_controller.dart';
import 'package:ory/features/schedule/presentation/event_details_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/services/ai_scheduler_service.dart';
import '../models/calendar_event.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController _taskController = TextEditingController();
  Future<void> _generateSchedule() async {
    if (_selectedDay == null) return;

    ref.read(scheduleProvider.notifier).setLoading(true);
    try {
      // Get existing events for the selected day
      final existingEvents =
          ref.read(scheduleProvider).events[_selectedDay!] ?? [];

      // Use the AI Scheduler Service to get a suggestion
      final aiService = AISchedulerService();
      printLog.w('Generating schedule for ${_taskController.text}');
      final suggestion = await aiService.getScheduleSuggestion(
        userPrompt: _taskController.text,
        existingEvents: existingEvents,
      );
      printLog.i('Generated suggestion: $suggestion');
      // Convert the suggestion into a CalendarEvent
      final event = CalendarEvent(
        title: suggestion.title,
        description: suggestion.description,
        startTime: suggestion.startTime,
        endTime: suggestion.endTime,
        date: suggestion.date,
        reason: suggestion.reason,
        color: Colors.blue, // or adjust based on suggestion if needed
      );
      ref.read(scheduleProvider.notifier).addEvent(_selectedDay!, event);
    } catch (e) {
      Logger().e('Failed to generate schedule: ${e.toString()}');
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to generate schedule: ${e.toString()}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } finally {
      ref.read(scheduleProvider.notifier).setLoading(false);
      _taskController.clear();
    }
  }

  void _deleteEvent(CalendarEvent event) {
    if (_selectedDay == null) return;
    ref.read(scheduleProvider.notifier).deleteEvent(_selectedDay!, event);
  }

  void _showScheduleTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Schedule Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(
                  labelText: 'Describe your task',
                  hintText: 'e.g. "Need 2 hours for project meeting tomorrow"',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _selectedDay != null
                      ? DateFormat('MMM dd, yyyy').format(_selectedDay!)
                      : 'Select a date from calendar',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedDay != null && _taskController.text.isNotEmpty) {
                  Navigator.pop(context);
                  _generateSchedule();
                }
              },
              child: const Text('Generate Schedule'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleState = ref.watch(scheduleProvider);
    final selectedDateEvents =
        _selectedDay != null ? scheduleState.events[_selectedDay!] ?? [] : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Me'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body:
          scheduleState.isLoading
              ? _buildShimmerLoading(context)
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calendar Section
                    Text(
                      'let AI organize your tasks',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(const Duration(days: 365)),
                        focusedDay: _focusedDay,
                        selectedDayPredicate:
                            (day) => isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Scheduled Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (selectedDateEvents.isEmpty)
                      _buildEmptyState()
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: selectedDateEvents.length,
                        itemBuilder: (context, index) {
                          final event = selectedDateEvents[index];
                          return _ScheduleEventItem(
                            event: event,
                            onDelete: () => _deleteEvent(event),
                          );
                        },
                      ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showScheduleTaskDialog,
        icon: const Icon(Icons.add, size: 28),
        label: const Text('Schedule Task'),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

Widget _buildShimmerLoading(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Stack(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar Shimmer
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 32),
              // Scheduled Tasks Header Shimmer
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.02,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              // Event List Shimmer
              Column(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // a centered text saying Generating Schedule with AI...
        Positioned(
          top: MediaQuery.of(context).size.height * 0.5,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Generating Schedule with AI...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildEmptyState() {
  return Container(
    padding: const EdgeInsets.all(24),
    margin: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Icon(Icons.schedule, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'No tasks scheduled',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    ),
  );
}

class _ScheduleEventItem extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback onDelete;

  const _ScheduleEventItem({required this.event, required this.onDelete});

  String _formatTime(TimeOfDay time, BuildContext context) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return TimeOfDay.fromDateTime(dateTime).format(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Container(width: 4, height: 40, color: event.color),
        title: Text(event.title),
        subtitle: Text(
          '${_formatTime(event.startTime, context)} - ${_formatTime(event.endTime, context)}',
        ),
        trailing: PopupMenuButton(
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
          onSelected: (_) => onDelete(),
        ),
        onTap: () {
          EventDetailsScreen.route(context, event);
        },
      ),
    );
  }
}
