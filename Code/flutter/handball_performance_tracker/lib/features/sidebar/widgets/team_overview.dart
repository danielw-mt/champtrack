// Build List of ListTiles with all alvailable teams.
// List<Widget> buildTeamChildren(BuildContext context) {
//   final PersistentController persController = Get.find<PersistentController>();
//   List<Team> allTeams = persController.getAvailableTeams();
//   List<Widget> teamChildren = [Divider()];
//   for (Team team in allTeams) {
//     teamChildren.add(SimpleListEntry(
//       text: " " * 5 + team.name,
//       screen: TeamSettingsScreen(),
//       teamId: team.id,
//     ));
//   }
//   return teamChildren;
// }