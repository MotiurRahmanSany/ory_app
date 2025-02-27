import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ory/config/route_path.dart';
import 'package:ory/features/home/presentation/widgets/feature_widget.dart';
import 'package:ory/features/home/presentation/widgets/offer_banner_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> offers = [
    {
      'title': "Smart Schedule",
      'subtitle': "Gain 10% more free time weekly",
      'icon': Icons.schedule,
      'color': Colors.blue,
      'gradient': [Color(0xFF2196F3), Color(0xFF64B5F6)],
      'progress': 0.3,
      'route': RoutePath.workScheduling,
    },
    {
      'title': "Health Pro Trial",
      'subtitle': "1 Month free premium analysis",
      'icon': Icons.health_and_safety,
      'color': Colors.green,
      'gradient': [Color(0xFF4CAF50), Color(0xFF81C784)],
      'progress': 0.15,
      'route': RoutePath.prescription,
    },
    {
      'title': "Budget Wizard",
      'subtitle': "AI-powered financial planning",
      'icon': Icons.payment,
      'color': Colors.purple,
      'gradient': [Color(0xFF9C27B0), Color(0xFFBA68C8)],
      'progress': 1.0,
      'route': RoutePath.makePayment,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Life Assistant',
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildOfferCarousel(),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.60,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 16.0,
                children: [
                  FeatureWidget(
                    title: 'Medi Mind',
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
                  FeatureWidget(
                    title: 'Sync Me',
                    subtitle: 'AI-Powered Work Scheduler',
                    icon: Icons.schedule,
                    color: Colors.green,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    route: RoutePath.workScheduling,
                  ),
                  FeatureWidget(
                    title: 'Deal Baba',
                    subtitle: 'AI-Powered Recommendations',
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
                  FeatureWidget(
                    title: 'Budget Genie',
                    subtitle: 'AI-Powered Budget Planner',
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
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCarousel() {
    return CarouselSlider.builder(
      itemCount: offers.length,
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 1.55,
        enlargeCenterPage: true,
        viewportFraction: 0.85,
        autoPlayInterval: Duration(seconds: 5),
      ),
      itemBuilder: (context, index, realIndex) {
        final offer = offers[index];
        return OfferBannerWidget(
          title: offer['title'],
          subtitle: offer['subtitle'],
          icon: offer['icon'],
          gradient: LinearGradient(
            colors: offer['gradient'],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          progress: offer['progress'],
          onTap: () => Navigator.pushNamed(context, offer['route']),
        );
      },
    );
  }
}
