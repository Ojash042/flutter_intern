import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/api_project/bloc_provider.dart';
import 'package:flutter_intern/api_project/events.dart';
import 'package:flutter_intern/api_project/states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title = "Project";

  const CommonAppBar({super.key});
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Theme.of(context).colorScheme.primary,
      centerTitle: true,
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class LoggedInDrawer extends StatelessWidget{
  void logout() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance(); 
    sharedPreferences.remove("validTime");
    sharedPreferences.remove("username");
    sharedPreferences.remove("password");
    sharedPreferences.remove("token");
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: [
           DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text("Project")),
          ListTile(title: const Text("Logout"), onTap: (){
            logout();
            BlocProvider.of<AuthorizationProvider>(context).add(AuthorizedUserLogout());
            Navigator.of(context).pushNamedAndRemoveUntil('/init', (route) => false);
          },)
        ],),
    );
  }
}