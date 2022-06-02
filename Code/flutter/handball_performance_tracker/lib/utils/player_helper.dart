import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:get/get.dart';

List<int> getOnFieldIndex() {
  final GlobalController globalController = Get.find<GlobalController>();
  List<int> ind = [];
  for (int i = 0; i < globalController.playersOnField.length; i++) {
    if (globalController.playersOnField[i] == true) {
      ind.add(i);
    }
  }
  return ind;
}

List<int> getNotOnFieldIndex() {
  final GlobalController globalController = Get.find<GlobalController>();
  List<int> ind = [];
  for (int i = 0; i < globalController.playersOnField.length; i++) {
    if (globalController.playersOnField[i] == false) {
      ind.add(i);
    }
  }
  return ind;
}
