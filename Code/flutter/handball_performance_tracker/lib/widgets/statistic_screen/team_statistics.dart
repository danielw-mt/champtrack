import 'package:flutter/material.dart';
import 'charts.dart';



class TeamStatistics extends StatelessWidget {
  const TeamStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
              flex: 2,
              child: Column(children: [
                // Name & Quotes
                Flexible(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      const Flexible(
                        flex: 1,
                        child: Text("Team Statistics"),
                      ),
                      Flexible(
                        flex: 2,
                        child: Card(),
                      )
                    ])),// ef-score & actions
              Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Card(child: LineChartWidget()),
                      ),
                      Expanded(
                        child: LineChartWidget(),
                      )
                    ],
                  ))
            ])),
        // cards & field
          Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Card(child: LineChartWidget()),
                  ),
                  Expanded(
                    child: LineChartWidget(),
                  )
                ],
              )),
        ],
      ),
    );
  }
}