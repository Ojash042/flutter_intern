import 'package:flutter/material.dart';
import 'package:flutter_intern/project/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_intern/project/models.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xffabb5ff), Color(0xfff6efe9)])
        ),
      ),
    centerTitle: true,
    title: const Text("Project"),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MyDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xffabb5ff), Color(0xfff6efe9)])),
             child:  Text("Project App")
            ),
        ListTile(title:const Row(
          children: [
            Icon(Icons.home_outlined),
            SizedBox(width: 10,),
            Text("Home"),
          ],
        ),
        onTap: (){
          if(ModalRoute.of(context)?.settings.name != "/home"){
            Navigator.of(context).pushNamed('/home');
          }
          else{Scaffold.of(context).openEndDrawer();}
        },),
        ListTile(title: const Row(
          children: [
            Icon(Icons.folder_open_outlined),
            SizedBox(width: 10,),
            Text("Courses Info"),
          ],
        ),
        onTap: (){
          if(ModalRoute.of(context)?.settings.name != '/courses'){
            Navigator.of(context).pushNamed("/courses"); 
          }
          else{
            Scaffold.of(context).openEndDrawer();
          }
          },),
          ListTile(title: const Row(
            children: [
              Icon(Icons.account_circle_outlined),
              SizedBox(width: 10,),
              Text("Login"),
            ],
          ),
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

class BackgroundWaveClipper extends CustomClipper<Path>{
  double heightFactor;
  double widthFactor;
  double secondHeightFactor;
  BackgroundWaveClipper({this.heightFactor = 0.75, this.widthFactor = 0.5, this.secondHeightFactor = 0.5});
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double p0 = size.height * heightFactor;
    path.lineTo(0.0, p0); 
    final controlPoint = Offset(size.width * widthFactor, size.height);
    final endPoint = Offset(size.width, size.height * secondHeightFactor);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    //path.lineTo(0.0, size.height);
    //path.lineTo(size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper != this;
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(gradient:LinearGradient(colors: [Color(0xffabb5ff), Color(0xfff6efe9)])),
            child: Text("Project App")
            ),
        ListTile(title:const Row(
          children: [
            Icon(Icons.folder_open_outlined),
            SizedBox(width: 10,),
            Text("Courses Info"),
          ],
        ),
        onTap: (){
          if(ModalRoute.of(context)?.settings.name != '/courses'){
            Navigator.of(context).pushNamed("/courses"); 
          }
          else{
            Scaffold.of(context).openEndDrawer();
          }
          },),
          ListTile(title: const Row(
            children: [
              Icon(Icons.account_circle_outlined),
              SizedBox(width: 10,),
              Text("Profile Info"),
            ],
          ),
          onTap: (){ 
          Navigator.of(context).pushNamed('/profileInfo/${loggedInUser!.id}');
          },
          ),
          ListTile(title: const Row(
            children: [
              Icon(Icons.group_outlined),
              SizedBox(width: 10,),
              Text("Friends"),
            ],
          ),
          onTap: (){
            if(ModalRoute.of(context)?.settings.name!='/friendLists'){
              Navigator.of(context).pushNamed('/friendLists');
            }
            else{
              Scaffold.of(context).openEndDrawer();
            }
          },
          ),
          ListTile(title:const Row(
            children: [
              Icon(Icons.bookmarks_outlined),
              SizedBox(width: 10,),
              Text("My Posts"),
            ],
          ),
          onTap: (){
            if(ModalRoute.of(context)?.settings.name!='/myPosts'){
              Navigator.of(context).pushNamed('/myPosts');
            }
            else {
              Scaffold.of(context).openEndDrawer();
            }
          },
          ),
          ListTile(title: const Row(
            children: [
              Icon(Icons.group_add_outlined),
              SizedBox(width: 10,),
              Text("Friend Requests"),
            ],
          ),
          onTap: (){
            if(ModalRoute.of(context)?.settings.name != '/friendRequests'){
              Navigator.of(context).pushNamed("/friendRequests");
            }
            else{
              Scaffold.of(context).openEndDrawer();
            }
          }
          ),

          ListTile(title: const Row(children: [
            Icon(Icons.check_box_outlined),
            SizedBox(width: 10,),
            Text("ToDos")
            ],),
            onTap: (){
              if(ModalRoute.of(context)?.settings.name != '/todos'){
                Navigator.of(context).pushNamed('/todos');
              }
              else{
                Scaffold.of(context).openEndDrawer();
              }
            },
            ),
          // ListTile(title: const Text("Change Password"),
          // onTap: (){
          //   Navigator.pushNamed(context, '/changePassword');
          // },),

          ListTile(title: const Row(
            children: [
              Icon(Icons.search_outlined),
              SizedBox(width: 10,),
              Text("Search"),
            ],
          ),
            onTap: (){
              Navigator.of(context).pushNamed("/search");
            },
          ),
          ListTile(title:const Row(
            children: [
              Icon(Icons.exit_to_app_outlined),
              SizedBox(width: 10,),
              Text("Log out"),
            ],
          ),
          onTap: (){
            Provider.of<AuthProvider>(context, listen: false).logout(); 
            Navigator.of(context).pushNamedAndRemoveUntil( "/",(Route<dynamic> route) => false);
          },
          ),
          ],
        ),
    );
  }
}

