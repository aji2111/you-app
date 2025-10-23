import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_app/presentation/profile/controller/profile_controller.dart';

class EditInterestPage extends StatelessWidget {
  EditInterestPage({super.key});

  final profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              profileController.saveProfile();
              Get.back(); // simpan otomatis saat kembali
            },
            child: const Text("Save", style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tell everyone about yourself',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "What interest you?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: profileController.interestController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add, color: Colors.amber),
                    onPressed: () {
                      profileController.addInterest(
                        profileController.interestController.text,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: profileController.interests
                    .map(
                      (i) => Chip(
                        label: Text(i),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => profileController.removeInterest(i),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
