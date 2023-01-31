


import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget{
  final String title;
  final IconData icon;
  final Widget screen;
  String subtitle;
  DashboardCard({required this.screen, required this.title, required this.icon, this.subtitle = ""});
  

  // build widget card with leading icon, title and subtitle
  // on pressed navigate to passed screen
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
  
}