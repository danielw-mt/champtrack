import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/data/ef_score.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import '../strings.dart';
import './../../controllers/globalController.dart';
import './../widgets/helper_screen/stopwatch.dart';
import '../widgets/main_screen/action_menu.dart';
import '../widgets/main_screen/playermenu.dart';
import './../widgets/helper_screen/reverse_button.dart';
import './../widgets/helper_screen/action_feed.dart';

class HelperScreen extends GetView<GlobalController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.lHelperScreenHeader),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [StopWatch(), ReverseButton(), ActionFeed()],
          ),
          EfScoreBar()
        ],
      ),
    );
  }
}
