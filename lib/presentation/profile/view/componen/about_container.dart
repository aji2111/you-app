import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_app/presentation/profile/controller/profile_controller.dart';
import 'package:you_app/ui_kit/common_widget/common_datepicker.dart';
import 'package:you_app/ui_kit/common_widget/common_dropdown.dart';
import 'package:you_app/ui_kit/common_widget/custom_textfield.dart';

class AboutContainer extends StatelessWidget {
  const AboutContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header bar
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
              Obx(
                () => profileController.isEditingAbout.value
                    ? TextButton(
                        onPressed: () {
                          profileController.saveProfile();
                          profileController.isEditingAbout.value = false;
                        },
                        child: const Text(
                          'Save & Update',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white70),
                        onPressed: () {
                          profileController.isEditingAbout.value = true;
                        },
                      ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Obx(() {
            // ✅ CASE 1: Sedang mode edit
            if (profileController.isEditingAbout.value) {
              return _buildEditForm(profileController);
            }

            if (profileController.profileData != null) {
              return _buildProfileInfo(profileController);
            }

            return Container(
              padding: const EdgeInsets.all(5),
              child: const Text(
                'Add in your info to help others know you',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(ProfileController controller) {
    final age = controller.calculateAge();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          'Birthday',
          controller.birthdayController.text.isNotEmpty
              ? '${controller.birthdayController.text} (Age $age) '
              : '--',
        ),

        _buildInfoRow(
          'Horoscope',
          controller.chineseZodiac.text.isNotEmpty
              ? controller.chineseZodiac.text
              : '--',
        ),
        _buildInfoRow(
          'Zodiac',
          controller.zodiacSign.text.isNotEmpty
              ? controller.zodiacSign.text
              : '--',
        ),
        _buildInfoRow(
          'Height',
          '${controller.heightController.text.isEmpty ? '--' : controller.heightController.text} cm',
        ),
        _buildInfoRow(
          'Weight',
          '${controller.weightController.text.isEmpty ? '--' : controller.weightController.text} kg',
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(ProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile image
        Row(
          children: [
            GestureDetector(
              onTap: () => controller.pickImage(),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: controller.profileImagePath.value.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(controller.profileImagePath.value),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.add, color: Colors.white70),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Add image',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Display name field
        CustomTextField(
          hintText: 'enter Name',
          label: 'Display Name',
          controller: controller.nameController,
        ),
        Obx(
          () => CustomDropdown(
            label: 'Gender',
            hintText: 'Select gender',
            items: controller.genderList,
            value: controller.gender.value.isEmpty
                ? null
                : controller.gender.value,
            onChanged: (value) {
              if (value != null) controller.gender.value = value;
            },
          ),
        ),
        // Pass the callback to update zodiac signs when date changes
        CustomDatePicker(
          label: 'Birth Date',
          hintText: 'Select Date',
          controller: controller.birthdayController,
          onDateChanged: () {
            controller.updateZodiacSigns();
          },
        ),

        CustomTextField(
          hintText: '--',
          label: 'Horoscope',
          controller: controller.chineseZodiac,
          enabled: false, // Make this field read-only
        ),
        CustomTextField(
          hintText: '--',
          label: 'Zodiac',
          controller: controller.zodiacSign,
          enabled: false, // Make this field read-only
        ),
        CustomTextField(
          hintText: 'Add height',
          label: 'Height',
          controller: controller.heightController,
          suffixText: 'cm',
        ),
        CustomTextField(
          hintText: 'Add Weight',
          label: 'Weight',
          controller: controller.weightController,
          suffixText: 'kg',
        ),

        // Error message
        Obx(
          () => controller.errorMessage.value.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
