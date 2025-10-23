import 'package:get/get.dart';
import 'package:you_app/presentation/login/controller/login_controller.dart';
import 'package:you_app/presentation/login/service/login_service.dart';

import 'package:you_app/services/net_utils.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Assuming HttpUtil is a singleton or has its own binding setup elsewhere
    // If not, you would lazyPut it here like in the RegisterBinding example
    // Get.lazyPut<HttpUtil>(() => HttpUtilImpl(...));

    Get.lazyPut(() => LoginService(Get.find<HttpUtil>()));
    Get.lazyPut(() => LoginController(Get.find<LoginService>()));
  }
}