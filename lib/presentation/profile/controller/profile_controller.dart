import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:you_app/presentation/profile/constant/profile_constant.dart';

import 'package:you_app/presentation/profile/service/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService;
  final ProfileConstants _constants = ProfileConstants();
  final ImagePicker _picker = ImagePicker();
  final _storage = GetStorage();

  ProfileController(this._profileService);

  // --- STATE ---
  var isLoading = true.obs;
  var isSaving = false.obs;
  var errorMessage = ''.obs;
  var isEditingAbout = false.obs;
  var username = ''.obs;
  var profileData;

  // --- FORM DATA ---
  var interests = <String>[].obs;
  final interestController = TextEditingController();
  final zodiacSign = TextEditingController();
  final chineseZodiac = TextEditingController();
  final List<String> genderList = ['Male', 'Female', 'Other'];
  var gender = ''.obs;

  // interest
  var isEditingInterest = false.obs;

  // --- IMAGE DATA ---
  var profileImagePath = ''.obs;

  // --- TEXT CONTROLLERS ---
  TextEditingController get nameController => _constants.nameText;
  TextEditingController get birthdayController => _constants.birthdayText;
  TextEditingController get heightController => _constants.heightText;
  TextEditingController get weightController => _constants.weightText;

  @override
  void onInit() {
    super.onInit();
    _loadLocalData();
    fetchProfile();
  }

  // --- LOAD LOCAL DATA ---
  void _loadLocalData() {
    profileImagePath.value = _storage.read('profileImagePath') ?? '';
  }

  // --- FETCH PROFILE FROM API ---
  Future<void> fetchProfile() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _profileService.getProfile();

    result.fold((error) => errorMessage.value = error, (data) {
      if (data['message'] == "Profile has been found successfully") {
        profileData = data['data'];
        username.value = profileData['email'] ?? '';

        nameController.text = profileData['name'] ?? '';
        birthdayController.text = profileData['birthday'] ?? '';
        heightController.text = profileData['height']?.toString() ?? '';
        weightController.text = profileData['weight']?.toString() ?? '';
        zodiacSign.text = profileData['horoscope']?.toString() ?? '';
        chineseZodiac.text = profileData['zodiac']?.toString() ?? '';

        interests.assignAll(profileData['interests']?.cast<String>() ?? []);
      }
    });

    isLoading.value = false;
  }

  // --- PICK IMAGE ---
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        profileImagePath.value = image.path;
      }
    } catch (e) {
      errorMessage.value = 'Failed to pick image: $e';
    }
  }

  // --- ADD / REMOVE INTERESTS ---
  void addInterest(String interest) {
    if (interest.trim().isNotEmpty && !interests.contains(interest)) {
      interests.add(interest.trim());
      interestController.clear();
    }
  }

  void removeInterest(String interest) {
    interests.remove(interest);
  }

  // --- UPDATE ZODIAC SIGNS ---
  void updateZodiacSigns() {
    if (birthdayController.text.isEmpty) {
      zodiacSign.text = '';
      chineseZodiac.text = '';
      return;
    }

    try {
      // Coba format "dd MMM yyyy" misal: 23 Oct 1995
      final birthday = DateFormat('dd MMM yyyy').parse(birthdayController.text);
      zodiacSign.text = _getWesternZodiac(birthday);
      chineseZodiac.text = _getChineseZodiac(birthday);
    } catch (e1) {
      try {
        // Fallback: coba "yyyy-MM-dd"
        final birthday = DateFormat(
          'yyyy-MM-dd',
        ).parse(birthdayController.text);
        zodiacSign.text = _getWesternZodiac(birthday);
        chineseZodiac.text = _getChineseZodiac(birthday);
      } catch (e2) {
        zodiacSign.text = '';
        chineseZodiac.text = '';
        debugPrint('⚠️ Failed to parse birthday: $e1 / $e2');
      }
    }
  }

  // --- SAVE PROFILE ---
  Future<void> saveProfile() async {
    if (!_validateForm()) return;
    isSaving.value = true;
    errorMessage.value = '';

    await _storage.write('profileImagePath', profileImagePath.value);

    final result = profileData != null
        ? await _profileService.updateProfile(
            name: nameController.text.trim(),
            birthday: birthdayController.text.trim(),
            height: int.parse(heightController.text.trim()),
            weight: int.parse(weightController.text.trim()),
            interests: interests.toList(),
          )
        : await _profileService.createProfile(
            name: nameController.text.trim(),
            birthday: birthdayController.text.trim(),
            height: int.parse(heightController.text.trim()),
            weight: int.parse(weightController.text.trim()),
            interests: interests.toList(),
          );

    result.fold((error) => errorMessage.value = error, (response) {
      Get.snackbar('Success', 'Profile saved successfully!');
      fetchProfile();
      isEditingAbout.value = false; // ⬅️ keluar dari edit mode
    });

    isSaving.value = false; // pastikan balik ke false
  }

  // --- CALCULATE AGE ---
  int calculateAge() {
    if (birthdayController.text.isEmpty) return 0;
    try {
      final birthDate = DateFormat(
        'dd MMM yyyy',
      ).parse(birthdayController.text);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }

  // --- VALIDATE FORM ---
  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      errorMessage.value = 'Name cannot be empty';
      return false;
    }
    if (birthdayController.text.trim().isEmpty) {
      errorMessage.value = 'Birthday cannot be empty';
      return false;
    }
    if (heightController.text.trim().isEmpty ||
        int.tryParse(heightController.text) == null) {
      errorMessage.value = 'Enter a valid height';
      return false;
    }
    if (weightController.text.trim().isEmpty ||
        int.tryParse(weightController.text) == null) {
      errorMessage.value = 'Enter a valid weight';
      return false;
    }
    return true;
  }

  // --- HELPER: WESTERN ZODIAC ---
  String _getWesternZodiac(DateTime date) {
    final month = date.month;
    final day = date.day;
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'Aries';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'Taurus';
    if ((month == 5 && day >= 21) || (month == 6 && day <= 21)) return 'Gemini';
    if ((month == 6 && day >= 22) || (month == 7 && day <= 22)) return 'Cancer';
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Leo';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'Virgo';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 23)) return 'Libra';
    if ((month == 10 && day >= 24) || (month == 11 && day <= 21))
      return 'Scorpio';
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21))
      return 'Sagittarius';
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19))
      return 'Capricorn';
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18))
      return 'Aquarius';
    return 'Pisces';
  }

  // --- HELPER: CHINESE ZODIAC ---
  String _getChineseZodiac(DateTime date) {
    final year = date.year;
    const zodiacs = [
      'Rat',
      'Ox',
      'Tiger',
      'Rabbit',
      'Dragon',
      'Snake',
      'Horse',
      'Goat',
      'Monkey',
      'Rooster',
      'Dog',
      'Pig',
    ];
    return zodiacs[(year - 2020) % 12];
  }

  @override
  void onClose() {
    _constants.dispose();
    interestController.dispose();
    super.onClose();
  }
}
