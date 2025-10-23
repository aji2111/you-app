import 'package:get/get.dart';
import 'package:you_app/presentation/profile/controller/profile_controller.dart';
import 'package:you_app/presentation/profile/service/profile_service.dart';
import 'package:you_app/services/net_utils.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Register the ProfileService first
    Get.lazyPut<ProfileService>(() => ProfileService(Get.find<HttpUtil>()));
    
    // Then register the ProfileController with the service
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find<ProfileService>()),
    );
  }
}