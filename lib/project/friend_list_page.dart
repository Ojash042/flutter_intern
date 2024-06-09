import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_states.dart';
import 'package:flutter_intern/project/bloc/user_friend_bloc.dart';
import 'package:flutter_intern/project/bloc/user_friend_events.dart';
import 'package:flutter_intern/project/bloc/user_friend_states.dart';
import 'package:flutter_intern/project/bloc/user_list_bloc.dart';
import 'package:flutter_intern/project/bloc/user_list_states.dart';
import 'package:flutter_intern/project/locator.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart' as bsIcons;
import 'package:flutter_intern/project/technical_models.dart' as TModels;
import 'package:flutter_intern/project/friend_service_provider.dart' as fService;

class FriendListPage extends StatefulWidget{
  const FriendListPage({super.key});

  @override
  State<FriendListPage> createState() {
    return _FriendListPageState();
  }
}

class _FriendListPageState extends State<FriendListPage>{

  List<TModels.UserFriend> usersFriends = List.empty(growable: true);
  List<UserData>? userDataList = List.empty(growable: true);
  List<UserDetails>? userDetailsList = List.empty(growable: true);

  List<TModels.UserFriend> userFriends = List.empty(growable: true);
  List<UserData> userFriendData = List.empty(growable: true);
  List<UserDetails> userFriendDetails = List.empty(growable: true);
  
  List<Widget> action = List.empty(growable: true);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<Widget> getFriendStateWidget(ScaffoldState scaffoldKey,int id, UserData userData) async{
    String friendStateString;
    fService.FriendServiceProvider fserve = fService.FriendServiceProvider();
    fService.FriendState friendState = await fserve.getFriendState(id, userData);
    IconData ico;
    VoidCallback onPressed;
    switch(friendState){
      case fService.FriendState.notFriend:
        friendStateString = "Add Friend";
        ico = Icons.group_add;
        onPressed = (){
           int userId = context.read<AuthBloc>().state.userData!.id;
           context.read<UserFriendBloc>().add(UserAddFriendEvent(friendId: id, userId: userId));
          };
        break;

      case fService.FriendState.friend:
        friendStateString = "Remove Friend";
        ico = Icons.group_off_outlined;
        onPressed = (){
          int userId = context.read<AuthBloc>().state.userData!.id;
          context.read<UserFriendBloc>().add(UserFriendRemoveEvent(friendId: id, userId: userId));
        };
        break;

      case fService.FriendState.pending:
        friendStateString = "Pending";
        ico = Icons.access_time;
        onPressed= (){};
        break;

      case fService.FriendState.requested:
        friendStateString = "Requested";
        ico = Icons.group;
        onPressed = () { 
          int userId = context.read<AuthBloc>().state.userData!.id;
          context.read<UserFriendBloc>().add(UserFriendAcceptRequestEvent(friendId: id, userId: userId));
        // fserve.acceptRequest(id, userData);
        //  setState(() { 
        // });          
        };
        break;

      case fService.FriendState.isUser:
        return Container();
    }

    if(friendState == fService.FriendState.friend){
      return IconButton(onPressed: (){
        _scaffoldKey.currentState!.showBottomSheet(
          enableDrag: true,
        showDragHandle: true,
        (builder) => 
           SizedBox(
           width: MediaQuery.of(context).size.width,
             child: TextButton.icon(onPressed: (){
                onPressed();
                Navigator.pop(context);
                setState(() {});
              }, label: const Text("Remove Friend"), icon: const Icon(Icons.delete_forever_outlined),),
           ),
          
        );
      }, icon: const Icon(Icons.more_horiz));
    }
    return OutlinedButton(
      style:const ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(), borderRadius: BorderRadius.all(Radius.circular(12)))),
        backgroundColor: WidgetStatePropertyAll(Colors.blue),side: WidgetStatePropertyAll(BorderSide(
          strokeAlign: BorderSide.strokeAlignOutside,
          width: 2, color: Colors.white, style: BorderStyle.solid))),
      onPressed: (){
      onPressed(); setState(() { 
    });},child: Row(children: [Icon(ico, color: Colors.white,), Text(friendStateString, style: const TextStyle(color: Colors.white),),], ));
  } 
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
      }
  
  @override
  void didUpdateWidget(covariant FriendListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    }
  
  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    //BlocProvider.of<UserListBloc>(context).add(UserListInitialize());
    BlocProvider.of<UserFriendBloc>(context).add(UserFriendInitialize());
    IconButton searchButton = IconButton(onPressed: (){
    Navigator.of(context).pushNamed('/search');
    }, icon: const Icon(Icons.search));
    action = [searchButton];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
      builder: (builder, state) {
        UserData? loggedInUser = state.userData;
        return 
        BlocBuilder<UserListBloc, UserListStates>(builder: (context, userListState){
           userDataList = userListState.userDataList;
           userDetailsList = userListState.userDetailsList;
        return BlocBuilder<UserFriendBloc, UserFriendStates >(
          builder: (context, userFriendState) {
             if(userFriendState is UserFriendEmpty){
              return(
                const Scaffold(
                appBar: CommonAppBar(),
                body: Center(child: CircularProgressIndicator(),),
              ));
             }
             usersFriends = userFriendState.userFriends!.where((element) => (element.userListId>0) &&
             (element.userId == loggedInUser!.id || element.friendId == loggedInUser.id ) && (element.hasNewRequest == false) && (!element.hasRemoved)).toList();

            for(var item in usersFriends){
              int friendId;
              if(item.userId == loggedInUser!.id){
                  friendId = item.friendId;
              }
              else{
                friendId = item.userId;
              }
 
              var userData = userDataList!.firstWhere((element) => element.id == friendId);
              var userDetails = userDetailsList!.firstWhere((element) => element.id == friendId);
              if(userFriendData.firstWhereOrNull((e) => e.id == userData.id) == null){
                userFriendData.add(userData);
                userFriendDetails.add(userDetails); 
              }
              }

            return Scaffold (
                key: _scaffoldKey,
                appBar: CommonAppBar(actions: action,),
                bottomNavigationBar: const CommonNavigationBar(),
                body: (userFriendState is UserFriendEmpty) ? const Center(child: CircularProgressIndicator(),):  SingleChildScrollView(
                  child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                    child: Column(
                      children: [
                      Align(alignment: Alignment.topLeft, child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            child:  const Padding(
                              padding: EdgeInsets.symmetric(horizontal:25, vertical:  12.0),
                              child: Text("Requests", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              ), onTap: (){
                            Navigator.of(context).pushNamed("/friendRequests");
                          },),
                        ),
                      ),),
                      const SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('${userFriendData.length} friends', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: userFriendData.length,
                        itemBuilder: (context, index)=> Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: GestureDetector(onTap: (){
                            Navigator.of(context).pushNamed('/profileInfo/${userFriendState.userFriends!.elementAt(index).userId}');},
                          child: Row(
                            children: [
                              CircleAvatar(backgroundImage: FileImage(File(userFriendDetails.elementAt(index).basicInfo.profileImage.imagePath)),),
                              const SizedBox(width: 20,),
                              Column(children: [
                                Text(userFriendData.elementAt(index).name),
                                ],),
                              const Spacer(),
                              Card(
                                elevation: 0,
                                child: IconButton(onPressed: (){}, icon: const Icon(bsIcons.BootstrapIcons.chat_dots_fill, color: Colors.black,))),
                              Card(
                              elevation: 0,
                                color: Colors.transparent,
                                child: FutureBuilder(future: getFriendStateWidget(_scaffoldKey.currentState!,userFriendDetails.elementAt(index).id!, loggedInUser!), builder: (context, AsyncSnapshot<Widget> snapshot){
                                  if(snapshot.connectionState == ConnectionState.waiting){
                                    return const CircularProgressIndicator();
                                  }
                                  else if(snapshot.hasError){
                                    return Text('${snapshot.error}');
                                  }
                                  return snapshot.data ?? Container();
                                }),
                              )
                            ],
                          ), 
                          ),
                        ))
                      ]
                    ),
                  ),),);
          },
        );}, 
        );
      },
    );
  }
}