import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_app/presentation/profile/controller/profile_controller.dart';
import 'edit_interest_page.dart';

class InterestSection extends StatelessWidget {
  final profileController = Get.find<ProfileController>();

  InterestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (profileController.interests.isEmpty) {
        return _buildEmptyInterest();
      } else {
        return _buildInterestTags(context);
      }
    });
  }

  Widget _buildEmptyInterest() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'About',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () => Get.to(() => EditInterestPage()),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: const Text(
              'Add in your interest to find a better match',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestTags(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Interest",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                Get.to(() => EditInterestPage());
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: profileController.interests
              .map(
                (i) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(i, style: const TextStyle(color: Colors.white)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
