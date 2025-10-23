import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_app/presentation/profile/controller/profile_controller.dart';

class TopContainer extends StatelessWidget {
  const TopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return Obx(() {
    
     
     
      final age = profileController.calculateAge();

      return Container(
        height: 289, // sesuai contoh resolusi 165x289
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: profileController.profileImagePath.value.isNotEmpty
              ? DecorationImage(
                  image: FileImage(
                    File(profileController.profileImagePath.value),
                  ),
                  fit: BoxFit.cover,
                )
              : null,
          color: profileController.profileImagePath.value.isNotEmpty
              ? null
              : Colors.white.withOpacity(0.08),
        ),
        child: Stack(
          children: [
            // Overlay gelap agar teks terlihat
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Konten di bagian bawah
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username & umur
                    Row(
                      children: [
                        Text(
                          profileController.username.value.isNotEmpty
                              ? profileController.username.value
                              : '@johndoe',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (age > 0) ...[
                          const SizedBox(width: 4),
                          Text(
                            ', $age',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Gender
                    if (profileController.gender.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          profileController.gender.value,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),

                    const SizedBox(height: 8),

                    // Zodiac dan Chinese zodiac
                    Row(
                      children: [
                        if (profileController.zodiacSign.text.isNotEmpty)
                          _buildZodiacChip(Icons.auto_awesome, profileController.zodiacSign.text),
                        if (profileController.chineseZodiac.text.isNotEmpty)
                          _buildZodiacChip(Icons.pets, profileController.chineseZodiac.text),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildZodiacChip(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}
