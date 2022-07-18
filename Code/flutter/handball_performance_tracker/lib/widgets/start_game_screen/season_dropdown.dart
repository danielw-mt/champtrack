import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import '../../controllers/tempController.dart';
import 'package:get/get.dart';

// dropdown that shows all available teams belonging to the selected team type
class SeasonDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return // build the dropdown button
        GetBuilder<TempController>(
      id: "season-dropdown",
      builder: (TempController tempController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: buttonDarkBlueColor,
          ),
          child: DropdownButton(
              isExpanded: true,
              focusColor: Colors.transparent,
              value: tempController.getSelectedSeason(),
              icon: const Icon(Icons.arrow_drop_down_circle_outlined),
              iconEnabledColor: Colors.white, 
              //elevation: 16,
              style: const TextStyle(color: Colors.white),
              dropdownColor: buttonDarkBlueColor,
              underline: Container(), // remove underline
              onChanged: (String? newSeason) {
                tempController.setSelectedSeason(newSeason!);
              },
              // build dropdown item widgets
              // TODO don't hardcode
              items: <String>[
                'Saison 2021/22',
                'Saison 2020/21',
                'Saison 2019/20'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                      child: Text(value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                );
              }).toList()),
        );
      },
    );
  }
}
