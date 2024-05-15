import 'package:flutter/material.dart';
import 'package:flutter_intern/project/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_intern/project/models.dart';

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
        ListTile(title: const Text("Home"),
        onTap: (){
          if(ModalRoute.of(context)?.settings.name != "/home"){
            Navigator.of(context).pushNamed('/home');
          }
          else{Scaffold.of(context).openEndDrawer();}
        },),
        ListTile(title: const Text("Courses Info"),
        onTap: (){
          if(ModalRoute.of(context)?.settings.name != '/courses'){
            Navigator.of(context).pushNamed("/courses"); 
          }
          else{
            Scaffold.of(context).openEndDrawer();
          }
          },),
          ListTile(title: const Text("Login"),
          onTap: (){
            if(ModalRoute.of(context)?.settings.name != "/login"){
              Navigator.of(context).pushNamed("/login");
            }
            else{
              Scaffold.of(context).openEndDrawer();
            }
          },
          ),
          
          ],
        ),
    );
  }
}

class LoggedInDrawer extends StatefulWidget{
  const LoggedInDrawer({super.key});

  @override 
  State<LoggedInDrawer> createState() => _LoggedInDrawerState();

}

class _LoggedInDrawerState extends State<LoggedInDrawer>{   

  UserData? loggedInUser;
  Future<void> getLoggedInUser() async{
    UserData? userData =  await Provider.of<AuthProvider>(context).getLoggedInUser();
    setState(() {
     loggedInUser = userData; 
    }); 

  }

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getLoggedInUser();
  }

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
          Navigator.of(context).pushNamed('/profileInfo/${loggedInUser!.id}');
          },
          ),
          ListTile(title: const Text("Friend Requests"),
          onTap: (){
            if(ModalRoute.of(context)?.settings.name != '/friendRequests'){
              Navigator.of(context).pushNamed("/friendRequests");
            }
            else{
              Scaffold.of(context).openEndDrawer();
            }
          }
          ),
          // ListTile(title: const Text("Change Password"),
          // onTap: (){
          //   Navigator.pushNamed(context, '/changePassword');
          // },),

          ListTile(title: const Text("Search"),
            onTap: (){
              Navigator.of(context).pushNamed("/search");
            },
          ),
          ListTile(title: const Text("Log out"),
          onTap: (){
            Provider.of<AuthProvider>(context, listen: false).logout(); 
            Navigator.of(context).popAndPushNamed("/");
          },
          ),
          ],
        ),
    );
  }
}