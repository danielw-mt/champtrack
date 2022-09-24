import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/controllers/persistent_controller.dart';
import 'package:handball_performance_tracker/controllers/temp_controller.dart';
import 'statistic_card_elements.dart';
import '../../data/player.dart';
import '../../data/game.dart';
import '../../controllers/temp_controller.dart';
import 'package:get/get.dart';


class PlayerStatistics extends StatefulWidget {
  const PlayerStatistics({Key? key}) : super(key: key);

  @override
  State<PlayerStatistics> createState() => _PlayerStatisticsState();
}

class _PlayerStatisticsState extends State<PlayerStatistics> {
  TempController tempController = Get.put(TempController());
  PersistentController
  List<Player> players = [];
  Player selectedPlayer = Player();
  Game selectedGame = Game();

  @override
  void initState() {
    players = tempController.getPlayersFromSelectedTeam();
    selectedPlayer = players[0];
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex: 2,
            child: Column(children: [
              // Name & Quotes
              Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: buildPlayerSelectionCard(selectedPlayer)                      
                        ),
                      Flexible(
                        flex: 2,
                        child: QuotesPosition(ring_form: true,),
                      )
                    ],
                  )),
              // ef-score & actions
              Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: PerformanceCard(),
                      ),
                      Expanded(
                        child: ActionsCard(),
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
                Expanded(
                  flex: 1,
                  child: CardsInfoCard(),
                ),
                Expanded(
                  flex: 4,
                  child: Card(
                    child: Center(child: Text("Game field coming soon")),
                  ),
                )
              ],
            )),
      ],
    ));
  }

  Card buildPlayerSelectionCard(Player selectedPlayer){
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: DropdownButton<Player>(
      value: selectedPlayer,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (Player? newPlayer) {
        // This is called when the user selects an item.
        setState(() {
            selectedPlayer = newPlayer!;
        });
      },
      items: players.map<DropdownMenuItem<Player>>((Player player) {
        return DropdownMenuItem<Player>(
            value: player,
            child: Text(player.firstName+" "+player.lastName),
        );
      }).toList(),
    ),
          )
        ],
      ),
    );
  }

  Card buildGameSelectionCard(Player selectedPlayer){
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: DropdownButton<Player>(
      value: selectedPlayer,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (Player? newPlayer) {
        // This is called when the user selects an item.
        setState(() {
            selectedPlayer = newPlayer!;
        });
      },
      items: players.map<DropdownMenuItem<Player>>((Player player) {
        return DropdownMenuItem<Player>(
            value: player,
            child: Text(player.firstName+" "+player.lastName),
        );
      }).toList(),
    ),
          )
        ],
      ),
    );
  }
}



/*class QuotesCard extends StatefulWidget {
  const QuotesCard({Key? key}) : super(key: key);
  @override
  _QuotesCardState createState() => _QuotesCardState();
}

class _QuotesCardState extends State<QuotesCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  flex: 1,
                  child: Text("Wurfqoute"),
                ),
                Flexible(
                  flex: 2,
                  child: PieChartQuotesWidget(),
                ),
                Flexible(
                  flex: 2,
                  child: Text("20 Wuerfe"),
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  flex: 1,
                  child: Text("Quote Postition"),
                ),
                Flexible(
                  flex: 2,
                  child: PieChartQuotesWidget(),
                ),
                Flexible(
                  flex: 2,
                  child: Text("15 Wuerfe"),
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  flex: 1,
                  child: Text("7m Quote"),
                ),
                Flexible(
                  flex: 2,
                  child: PieChartQuotesWidget(),
                ),
                Flexible(
                  flex: 2,
                  child: Text("7 Wuerfe"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/

