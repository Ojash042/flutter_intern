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
        onTap: (){
          if(ModalRoute.of(context)?.settings.name != '/courses'){
            print('Route: ${ModalRoute.of(context)?.settings.name}');
            Navigator.of(context).pushNamed("/courses"); 
          }
          else{
            Scaffold.of(context).openEndDrawer();
          }
          },),],
        ),
    );
  }
}

class LoggedInDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Project App")
            ),
        ListTile(title: const Text("Courses Info"),
        onTap: (){
          if(ModalRoute.of(context)?.settings.name != '/courses'){
            Navigator.of(context).pushNamed("/courses"); 
          }
          else{
            Scaffold.of(context).openEndDrawer();
          }
          },),
          ListTile(title: const Text("Profile Info"),
          onTap: (){ 
          Navigator.of(context).pushNamed("/profileInfo");
          },
          ),
          ListTile(title: const Text("Change Password"),
          onTap: (){
            Navigator.pushNamed(context, '/changePassword');
          },),
          ],
        ),

    );
  }
}