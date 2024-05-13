import 'package:flutter/material.dart';
import 'package:flutter_intern/project/misc.dart';

class LandingPage extends StatefulWidget{
  State<LandingPage> createState()=> _LandingPageState();
}

class _LandingPageState extends State<LandingPage>{
 @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.blueAccent,
      centerTitle: true,
      title: const Text("Project"),
      ),
      drawer: LoggedInDrawer(),
      body:Container(),
      );
  } 
}