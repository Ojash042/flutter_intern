import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino show CupertinoIcons;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_events.dart';
import 'package:flutter_intern/project/bloc/auth_states.dart';
import 'package:flutter_intern/project/bloc/user_list_bloc.dart';
import 'package:flutter_intern/project/bloc/user_post_bloc.dart';
import 'package:flutter_intern/project/bloc/user_post_states.dart';
import 'package:flutter_intern/project/utils.dart';
import 'package:flutter_intern/project/locator.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:humanizer/humanizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;

final ButtonStyle blueFilledButtonStyle = FilledButton.styleFrom(backgroundColor: Colors.blueAccent, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))));

class ModalAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  
  const ModalAppBar({super.key, required this.title});
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(icon: const Icon(cupertino.CupertinoIcons.xmark), onPressed: () => Navigator.of(context).pop(),),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}

class UnauthorizedNavigationBar extends StatefulWidget{
  const UnauthorizedNavigationBar({super.key});
  
  @override
  State<UnauthorizedNavigationBar> createState() => _UnauthorizedNavigationBarState();

}

class PhotoGrid extends StatefulWidget {
  final int maxImages;
  final int postId;
  final List<TModels.Image> images;
  final Function(int) onImageClicked;
  final Function onExpandClicked;
  final void Function(int) onLikePressed;

  PhotoGrid({required this.postId,required this.images, required this.onImageClicked, required this.onExpandClicked,
      this.maxImages = 4, super.key, required this.onLikePressed});

  @override
  createState() => _PhotoGridState();
}

class PostInfoWidget extends StatelessWidget{
  final String postText;
  const PostInfoWidget({super.key, required this.postText});

  @override
  Widget build(BuildContext context) {
    return Card(
      
    );
  }

}

class _PhotoGridState extends State<PhotoGrid> {
  @override
  Widget build(BuildContext context) {
    var images = buildImages();

    return GridView(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        children: images,
      );
  }

  List<Widget> buildImages() {
    int numImages = widget.images.length;
    return List<Widget>.generate(min(numImages, widget.maxImages), (index) {
      String imageUrl = widget.images[index].url;

      // If its the last image
      if (index == widget.maxImages - 1) {
        // Check how many more images are left
        int remaining = numImages - widget.maxImages;

        // If no more are remaining return a simple image widget
        if (remaining == 0) {

          return GestureDetector(
            child:  widget.images.elementAt(index).isNetworkUrl ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ):
            Image.file(File(imageUrl), fit: BoxFit.cover,),
            onTap: () => showGroupedImages(index),
          );
        } else {
          // Create the facebook like effect for the last image with number of remaining  images
          return GestureDetector(
            onTap: () => widget.onExpandClicked(),
            child: Stack(
              fit: StackFit.expand,
              children: [
                widget.images.elementAt(index).isNetworkUrl ? Image.network(imageUrl, fit: BoxFit.scaleDown, 
                width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,) : Image.file(File(imageUrl), 
                fit: BoxFit.scaleDown, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,
                ),
                Positioned.fill(child: Container(alignment: Alignment.center, color: Colors.black54, child: 
                Text('+$remaining',style: const TextStyle(fontSize: 32),),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        return GestureDetector(
          child: widget.images.elementAt(index).isNetworkUrl ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ) : Image.file(File(imageUrl), fit: BoxFit.cover,),
          onTap: () {
            showGroupedImages(index);
          },
        );
      }
    });
  }

  bool checkPostLiked(TModels.UserPost userPost){
    var kafj = BlocProvider.of<AuthBloc>(context).state is AuthorizedAuthState && userPost.postLikedBys.map((e) => e.userId).contains(BlocProvider.of<AuthBloc>(context).state.userData!.id);
    return kafj;
  }

  Future<dynamic> showGroupedImages(startingPage) {
    PageController _imagePageController = PageController(initialPage: startingPage);  
    List<Widget> widgetPostElements = [
      
    ];
    return showDialog(
          barrierDismissible: true,
          context: context,
          builder: (build) {
            TModels.UserPost userPosts = BlocProvider.of<UserPostBloc>(context).state.userPosts!.firstWhere((e) => e.postId == widget.postId);
            return MultiBlocProvider(
                providers: [
                    BlocProvider.value(
                          value: BlocProvider.of<UserPostBloc>(context),
            
                        ),
                    BlocProvider(
                        create: (context) => locator<UserListBloc>(),
                    ),
                ],
                child: Scaffold(
                  appBar: AppBar(backgroundColor: Colors.white, actions: [IconButton(onPressed: () => {Navigator.of(context).pop()}, icon: const Icon(cupertino.CupertinoIcons.xmark, color: Colors.white,))],),
                  body: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child:
                    ListView.builder(
                    itemCount: userPosts.images.length + 1,
                      itemBuilder: (context, index){
                        if(index == 0){
                          return Card(
                          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14.0, top: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              const SizedBox(height: 20,),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/profileInfo///${userPosts.userId}'),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: FileImage(File(locator<UserListBloc>().state.userDetailsList!.firstWhereOrNull((element) => 
                                      element.id == userPosts.userId)!.basicInfo.profileImage.imagePath)),),
                                      const SizedBox(width: 10,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(locator<UserListBloc>().state.userDataList!.firstWhereOrNull((element) => element.id == userPosts.userId)!.name, 
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: /* Color(0xffabb5ff) */ Colors.black),),
                                          Text(
                                            const ApproximateTimeTransformation(granularity: Granularity.primaryUnit, round: true, isRelativeToNow: true)
                                            .transform(Duration(microseconds: DateTime.parse(userPosts.createdAt).microsecondsSinceEpoch - DateTime.now().microsecondsSinceEpoch), 'en'))
                                            ],),
                                      ],),),
                                      const SizedBox(height: 10,),
                                      Text(userPosts.title, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
                                      const SizedBox(height: 5,),
                                      Row(children: [
                                        Stack(children: [
                                          Container(padding: const EdgeInsets.only(left: 14), child: const Icon(cupertino.CupertinoIcons.heart_circle_fill, color: Colors.pinkAccent, size: 22,)),
                                          const CustomThumbUpIcon(),
                                          ],),
                                          const SizedBox(width: 10,), 
                                                Text(getPrefixText(userPosts.postLikedBys), style: const TextStyle(fontWeight: FontWeight.w300) ,),
                                              ],),
                                              const Divider(thickness: 0.5,),
                                              BlocBuilder<UserPostBloc, UserPostStates>(
                                                builder: (context, state) {
                                                  return Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              IconButton(onPressed: (){
                                                                if(!BlocProvider.of<AuthBloc>(context).state.loggedInState){
                                                                  return;
                                                                }
                                                                widget.onLikePressed(userPosts.postId);
                                                              }, 
                                                              icon: checkPostLiked(userPosts) ? 
                                                              const Icon(cupertino.CupertinoIcons.hand_thumbsup_fill, color: Colors.blueAccent,) :const Icon(cupertino.CupertinoIcons.hand_thumbsup, color: Colors.grey,),),
                                                              const Text("Like"),],) 
                                                          ],),
                                                          Row(children: [
                                                            IconButton(onPressed: (){}, icon: const Icon(cupertino.CupertinoIcons.bubble_right, color: Colors.grey,)),
                                                            const Text("Comment"),
                                                          ],),
                                                          Row(children: [
                                                            IconButton(onPressed: (){}, icon: const Icon(cupertino.CupertinoIcons.share_up, color: Colors.grey,)),
                                                            const Text("Share"),
                                                            ],),
                              ],);
                            },)
                            ],),
                            ),);
                          }
                        else{
                          TModels.Image e = userPosts.images.elementAt(index -1);
                          return Card(
                            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(0)),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            color: Colors.white,
                            child: Wrap(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.45),
                                  child: Center(child: GestureDetector(
                                    onTap: () => showIndividualImage(index -1, e.url),
                                    child: e.isNetworkUrl ? Image.network(e.url, fit: BoxFit.scaleDown,) : Image.file(File(e.url), fit: BoxFit.scaleDown,)))),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(userPosts.title, maxLines: null, style: const TextStyle(fontSize: 16,),),
                                      const SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Stack(children: [
                                            Container(padding: const EdgeInsets.only(left: 14), child: const Icon(cupertino.CupertinoIcons.heart_circle_fill, color: Colors.pinkAccent, size: 22,)),
                                            const CustomThumbUpIcon(),
                                            ],),
                                            const SizedBox(width: 10,), 
                                            Text(getPrefixText(userPosts.postLikedBys), style: const TextStyle(fontWeight: FontWeight.w300) ,),
                                            ],),
                                            const SizedBox(height: 10,),
                                            const Divider(thickness: 0.5,),
                                            const SizedBox(height: 10,),
                                            BlocBuilder<UserPostBloc, UserPostStates>(
                                              builder: (context, state) {
                                                return Row(children: [
                                                  Row(
                                                    children: [
                                                      IconButton(onPressed: (){
                                                        widget.onLikePressed(userPosts.postId);
                                                        }, icon: Icon(checkPostLiked(userPosts)? cupertino.CupertinoIcons.hand_thumbsup_fill : cupertino.CupertinoIcons.hand_thumbsup, 
                                                        color: checkPostLiked(userPosts)? Colors.blueAccent : Colors.grey,)),
                                                        const Text("Like"),
                                                        ],), 
                                                        const Spacer(),
                                                        Row(children: [
                                                          IconButton(onPressed: (){}, icon: const Icon(cupertino.CupertinoIcons.bubble_right, color: Colors.grey,)),
                                                          const Text("Comment"),
                                                          ],),
                                                          const Spacer(),
                                                          Row(children: [  
                                                            IconButton(onPressed: (){}, icon: const Icon(cupertino.CupertinoIcons.share, color: Colors.grey,)),
                                                            const Text("Share"),
                                                            ],)
                                                            ],);
                                                      },)
                                                    ],)
                                                  ],)
                                                );
                                                }}),
                                     ), 
                                  ),
            );
          }
        );
  }

  Future<dynamic> showIndividualImageNonFinalImage(int index, String imageUrl) {
    return showDialog(
          barrierDismissible: true,
          context: context, builder: (build) =>  Scaffold(
            appBar: AppBar(backgroundColor: Colors.black,actions: [IconButton(icon: const Icon(cupertino.CupertinoIcons.xmark, color: Colors.white,), onPressed: () => Navigator.of(context).pop(),)],),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.25,
                maxScale: 2,
                scaleEnabled: true,
                child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: (widget.images.elementAt(index).isNetworkUrl ? 
                  Image.network(imageUrl, fit: BoxFit.scaleDown, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.75,) 
                  : Image.file(File(imageUrl), fit: BoxFit.scaleDown, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.width * 0.75,)),
                  ),
                ],),
              ),
            ),
          ),);
  }

  Future<dynamic> showIndividualImage(int index, String imageUrl) {
    return showDialog(
            barrierDismissible: true,
            context: context, builder: (build) {
              return Scaffold(
                appBar: AppBar(backgroundColor: Colors.black, actions: [IconButton(onPressed: ()=> Navigator.of(context).pop(), icon: const Icon(cupertino.CupertinoIcons.xmark, color: Colors.white,))],),
                body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black,
                  child: InteractiveViewer(
                    minScale: 0.25,
                    maxScale: 2,
                    child: ClipRRect(
                      child: widget.images.elementAt(index).isNetworkUrl ? 
                            Image.network(imageUrl, fit: BoxFit.scaleDown,) : Image.file(File(imageUrl), fit: BoxFit.scaleDown,),
                    ),
                  ),
                ),
                );
                },);
                }
}


class _UnauthorizedNavigationBarState extends State<UnauthorizedNavigationBar>{
  List<String> routes = ["/home", "/login", "/courses"];
  int _currentIndex = 1;

  void getCurrentIndex(){
    String? route = ModalRoute.of(context)?.settings.name;
    if(route == null ||  !route.contains(route)){
      setState(() {
        _currentIndex = 1;    
      });
      return;
    } 
      setState(() { 
        Future.delayed(Duration.zero, (){
          _currentIndex = (routes.indexOf(route)).abs(); 
        });
      });
    
  }

  @override
  void didUpdateWidget(covariant UnauthorizedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, (){
      getCurrentIndex();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, (){
      getCurrentIndex();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentIndex = 1;
    });
    // Future.delayed(Duration.zero,(){      
    //   getCurrentIndex();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: "Login"),
      BottomNavigationBarItem(icon: Icon(Icons.folder_open_outlined), label: "Courses"),
    ],
    unselectedItemColor: Colors.grey,
    selectedItemColor: Colors.blueAccent,
    currentIndex: _currentIndex,
    onTap: (value) => setState(() {
      _currentIndex = value;
      Navigator.of(context).popAndPushNamed(routes[_currentIndex]);
    })); 
  }
}

class CommonNavigationBar extends StatefulWidget{
  const CommonNavigationBar({super.key});


  @override
  State<CommonNavigationBar> createState() {
    return _CommonNavigationBarState();
  }
}

class _CommonNavigationBarState extends State<CommonNavigationBar>{

  List<Widget> widgets = List.empty(growable: true);
  UserData? loggedInUser;
  List<String> routes = []; 
  int _selectedIndex = 0;

  getLoggedInUser() async{
    UserData? userData;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? loggedInEmail = sharedPreferences.getString("loggedInEmail");
    if(loggedInEmail == null ){
      return null;
    }
    String? userDataString = sharedPreferences.getString("user_data");
    Iterable decoder = jsonDecode(userDataString!);
    List<UserData> userDataList = decoder.map((e) => UserData.fromJson(e)).toList();
    userData = userDataList.firstWhere((element) => element.email == loggedInEmail);

    setState(() {
      loggedInUser = userData;
      routes = ["/home", "/friendLists", "/profileInfo/${loggedInUser!.id}", "/courses", "/settings"];
    }); 
  }

  @override
  void didUpdateWidget(covariant CommonNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, (){
      var route = ModalRoute.of(context);
      if(route!=null){
        setState(() {
          if(routes.isNotEmpty){ 
          _selectedIndex =  routes.indexOf(route.settings.name ?? '/profileInfo/${loggedInUser!.id}');
        }
      });
    }     
    }); 
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, (){
      var route = ModalRoute.of(context);
      if(route!=null){
      setState(() {
        if(routes.isNotEmpty){  
          _selectedIndex =  max(0,routes.indexOf(route.settings.name ?? '/profileInfo/${loggedInUser!.id}'));
        }
      });
    }     
    }); 
  }

  @override
    void initState(){
    super.initState(); 
      getLoggedInUser();
    }

  @override
  Widget build(BuildContext context) {

    void _onItemTapped(int value){
      setState(() {  
        _selectedIndex = value;
      }); 
      Navigator.of(context).popAndPushNamed(routes[_selectedIndex]); 
      return;
    }

    return  routes.isNotEmpty ? BottomNavigationBar(items: [
      BottomNavigationBarItem(icon: Icon(_selectedIndex == 0 ? Icons.home_filled : Icons.home_outlined), label: "Home"),
      BottomNavigationBarItem(icon: Icon(_selectedIndex == 1 ? Icons.group: Icons.group_outlined), label: "Friends"),
      BottomNavigationBarItem(icon: Icon(_selectedIndex == 2 ?  Icons.account_circle : Icons.account_circle_outlined ), label: "Profile Info"),
      BottomNavigationBarItem(icon: Icon(_selectedIndex == 3 ? Icons.folder_open_rounded: Icons.folder_open_outlined), label: "Courses"),
      BottomNavigationBarItem(icon: Icon(_selectedIndex == 4 ? Icons.settings : Icons.settings_outlined), label: "Logout"),
    ],
      onTap: (value) => _onItemTapped(value),
      currentIndex: _selectedIndex,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.blueAccent,
    ) : const BottomAppBar();
  }  
}

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget{
  final List<Widget>? actions;
  const CommonAppBar({super.key, this.actions});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      backgroundColor: Colors.white,
      // flexibleSpace: Container(
      //   decoration: const BoxDecoration(
      //     gradient: LinearGradient(colors: [Color(0xffabb5ff), Color(0xfff6efe9)])
      //   ),
      // ),
    centerTitle: false,
    title: const Text("Project", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
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

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
    builder: (context, state) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(gradient:LinearGradient(colors: [Color(0xffabb5ff), Color(0xfff6efe9)])),
              child: Center(child: Text("Project App"))
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
            Navigator.of(context).pushNamed('/profileInfo/${(state.userData)!.id}');},
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
              context.read<AuthBloc>().add(RequestLogoutEvent());
              Navigator.of(context).pushNamedAndRemoveUntil( "/",(Route<dynamic> route) => false);
            },
            ),
            ],
          ),
      ),
    );
  }
}


class CustomThumbUpIcon extends StatelessWidget{
  const CustomThumbUpIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
      child: const Center(child: Icon(cupertino.CupertinoIcons.hand_thumbsup_fill, color: Colors.white, size: 14,),),
    );
  }  
}