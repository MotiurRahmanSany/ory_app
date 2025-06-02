import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ory/features/scheduler/models/calendar_event.dart';

class EventDetailsScreen extends StatelessWidget {
  static route(context, ev) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EventDetailsScreen(event: ev)),
  );
  final CalendarEvent event;

  const EventDetailsScreen({super.key, required this.event});

  // String _formatTime(TimeOfDay time, BuildContext context) {
  //   final now = DateTime.now();
  //   final dateTime = DateTime(
  //     now.year,
  //     now.month,
  //     now.day,
  //     time.hour,
  //     time.minute,
  //   );
  //   return TimeOfDay.fromDateTime(dateTime).format(context);
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final duration = event.endTime.hour * 60 +
    //     event.endTime.minute -
    //     (event.startTime.hour * 60 + event.startTime.minute);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      event.color.withOpacity(0.3),
                      event.color.withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: event.title,
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        event.title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: event.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            pinned: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _TimeIndicatorCard(event: event),
                const SizedBox(height: 20),
                _DetailSection(
                  icon: Icons.description,
                  title: "Event Description",
                  color: event.color,
                  child: Text(
                    event.description,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,

                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _DetailSection(
                  icon: Icons.psychology_rounded,
                  title: "AI Scheduling Reason",
                  color: event.color,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.reason,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "This schedule was optimized by our AI assistant",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                              // overflow: TextOverflow.ellipsis,
                              // maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeIndicatorCard extends StatelessWidget {
  final CalendarEvent event;

  const _TimeIndicatorCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duration =
        event.endTime.hour * 60 +
        event.endTime.minute -
        (event.startTime.hour * 60 + event.startTime.minute);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: event.color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TimeBadge(
                icon: Icons.calendar_month,
                text: DateFormat('MMM dd, yyyy').format(event.date),
                color: event.color,
              ),
              _TimeBadge(
                icon: Icons.schedule,
                text: '${duration ~/ 60}h ${duration % 60}m',
                color: event.color,
              ),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: _calculateTimeProgress(event),
            backgroundColor: event.color.withOpacity(0.1),
            color: event.color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTime(event.startTime, context),
                style: theme.textTheme.bodyLarge,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: event.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "AI Suggested",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: event.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                _formatTime(event.endTime, context),
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateTimeProgress(CalendarEvent event) {
    final totalMinutes = 24 * 60;
    final startMinutes = event.startTime.hour * 60 + event.startTime.minute;
    return startMinutes / totalMinutes;
  }

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
}

class _TimeBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _TimeBadge({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DetailSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Color color;

  const _DetailSection({
    required this.icon,
    required this.title,
    required this.child,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
