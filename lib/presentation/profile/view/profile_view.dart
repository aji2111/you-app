import 'package:flutter/material.dart';

import 'package:you_app/presentation/profile/view/componen/about_container.dart';
import 'package:you_app/presentation/profile/view/componen/interest_section.dart';
import 'package:you_app/presentation/profile/view/componen/top_container.dart';

import 'package:get/get.dart';
import 'package:you_app/presentation/profile/controller/profile_controller.dart';
import 'package:you_app/ui_kit/common_widget/common_appbar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller with dependency injection
    final ProfileController profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0E141B),
      appBar: CustomAppBar(title: '', backgroundColor: Colors.transparent,),
      body: SafeArea(child: Body()),
    );
  }
}

class Body extends StatelessWidget {
  final ScrollController scrollController = ScrollController();

  Body({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    return Obx(() {
      if (profileController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }

      return SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== TOP CONTAINER ======
            TopContainer(),
            // ====== ABOUT SECTION ======
            AboutContainer(),

            // ====== INTERESTS SECTION ======
            InterestSection(),
          ],
        ),
      );
    });
  }
}
