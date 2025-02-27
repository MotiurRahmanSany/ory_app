import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI-Powered Offers'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _OfferCard(
            title: "Smart Schedule Optimization",
            description:
                "Let AI organize your calendar with 10% more free time",
            icon: Icons.schedule,
            progress: 0.3,
            offerText: "10% Free Time Boost",
            color: Colors.blue,
          ),
          _OfferCard(
            title: "Health Analysis Pro",
            description: "Get 15% off on premium health insights package",
            icon: Icons.health_and_safety,
            progress: 0.15,
            offerText: "15% Discount",
            color: Colors.green,
          ),
          _OfferCard(
            title: "AI Meal Planner",
            description: "Unlock 20% more recipe suggestions this week",
            icon: Icons.restaurant,
            progress: 0.2,
            offerText: "20% More Recipes",
            color: Colors.orange,
          ),
          _OfferCard(
            title: "Financial AI Assistant",
            description: "Free 1-month trial for budget optimization",
            icon: Icons.attach_money,
            progress: 1.0,
            offerText: "1 Month Free",
            color: Colors.purple,
          ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final double progress;
  final String offerText;
  final Color color;

  const _OfferCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.progress,
    required this.offerText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        offerText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${(progress * 100).toInt()}% Activated",
                  style: TextStyle(color: color, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    // Handle offer claim
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text('Claimed $title offer'),
                          backgroundColor: color,
                        ),
                      );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      'Claim Offer',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // child: ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: color,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(18),
                //     ),
                //     padding: const EdgeInsets.symmetric(horizontal: 5),
                //     fixedSize: const Size(40, 40),

                //   ),
                //   onPressed: () {
                //     // Handle offer claim
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //         content: Text('Claimed $title offer'),
                //         backgroundColor: color,
                //       ),
                //     );
                //   },
                //   child: const Text(
                //     'Claim Offer',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
