import 'package:get/get.dart';

class MainScreenController extends GetxController {
  final count = 0.obs;
  increment() => count.value++;
}