import 'package:get/get.dart';
import 'package:you_app/services/net_utils.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // --- Core Services ---
    // These are singletons that will live for the entire app lifecycle.
    // We use Get.put() because we want them created immediately and only once.

    // Mock implementations (replace with your actual ones if they exist)
    Get.put<HttpInspector>(HttpInspector());
    Get.put<LocalService>(LocalService());

    // --- Network Layer ---
    // HttpUtil depends on the core services above.
    Get.put<HttpUtil>(
      HttpUtilImpl(
        inspect: Get.find<HttpInspector>(),
        local: Get.find<LocalService>(),
      ),
    );
  }
}