import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Project App")
            ),
        ListTile(title: const Text("Courses Info"),
        onTap: (){Navigator.of(context).pushNamed("/courses");},),],
        ),
    );
  }
} 

class MyAppBar extends StatelessWidget{
  MyAppBar();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Project"),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
    );
  }
}
