import 'package:flutter/material.dart';

import '../../../config/route_path.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: [
            _buildGridItem(
              context,
              'Prescription',
              Icons.medical_services,
              RoutePath.prescription,
            ),
            _buildGridItem(
              context,
              'Work Scheduling',
              Icons.schedule,
              RoutePath.workScheduling,
            ),
            _buildGridItem(
              context,
              'Recommendation',
              Icons.recommend,
              RoutePath.recommendation,
            ),
            _buildGridItem(
              context,
              'Make Payment',
              Icons.payment,
              RoutePath.makePayment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50.0),
            const SizedBox(height: 10.0),
            Text(title, style: const TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}
