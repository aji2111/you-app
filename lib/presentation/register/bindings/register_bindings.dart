import 'package:get/get.dart';// Make sure to import your HttpUtil implementation
import 'package:you_app/presentation/register/controller/register_controller.dart';
import 'package:you_app/presentation/register/service/service_register.dart';
import 'package:you_app/services/net_utils.dart';


class RegisterBinding extends Bindings {
  @override
  void dependencies() {
   
    Get.lazyPut<HttpUtil>(() => HttpUtilImpl(
      inspect: Get.find(), 
      local: Get.find(),  
    ));

   
    Get.lazyPut<RegisterService>(() => RegisterService(Get.find<HttpUtil>()));
    
  
    Get.lazyPut(() => RegisterController(Get.find<RegisterService>()));
  }
}