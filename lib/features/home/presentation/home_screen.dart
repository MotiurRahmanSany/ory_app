import 'package:flutter/material.dart';
import 'package:ory/config/route_path.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Life Assistant',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.60,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildFeatureCard(
              context,
              title: 'Smart Prescription',
              subtitle: 'AI-Powered Medicine Analysis',
              icon: Icons.medical_services,
              color: Colors.blue,
              gradient: const LinearGradient(
                colors: [Color(0xFF6F35A5), Color(0xFF9575CD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              route: RoutePath.prescription,
            ),
            _buildFeatureCard(
              context,
              title: 'Work Scheduler',
              subtitle: 'AI Time Optimization',
              icon: Icons.schedule,
              color: Colors.green,
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              route: RoutePath.workScheduling,
            ),
            _buildFeatureCard(
              context,
              title: 'AI Recommendations',
              subtitle: 'Personalized Suggestions',
              icon: Icons.recommend,
              color: Colors.orange,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9800), Color(0xFFFFC107)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              route: RoutePath.recommendation,
              isNew: true,
            ),
            _buildFeatureCard(
              context,
              title: 'Secure Payments',
              subtitle: 'Fast & Safe Transactions',
              icon: Icons.payment,
              color: Colors.purple,
              gradient: const LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFFE040FB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              route: RoutePath.makePayment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Gradient gradient,
    required String route,
    bool isNew = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, route),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: gradient,
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -30,
                  top: -30,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 28, color: Colors.white),
                      ),
                      const Spacer(),
                      Text(title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 8),
                      Text(subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          )),
                    ],
                  ),
                ),
                if (isNew)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('NEW',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}