import 'package:flutter/material.dart';
import 'package:ory/core/common/widgets/animated_ai_logo.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/constants.dart';

class ShimmerLoader extends StatelessWidget {
  final String loadingText;
  const ShimmerLoader({super.key, required this.loadingText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CenteredLogoWithText(
          isLoading: true,
          loadingText: loadingText,
          logoSize: Constants.requestLoadingBodyAnimationLogoSize,
        ),
        const SizedBox(height: 40),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ListView(
                padding: EdgeInsets.zero,
                children: List.generate(
                  5,
                  (index) => Container(
                    height: 20 + (index * 24.0),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
