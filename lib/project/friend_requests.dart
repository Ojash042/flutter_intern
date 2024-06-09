import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_states.dart';
import 'package:flutter_intern/project/bloc/user_friend_bloc.dart';
import 'package:flutter_intern/project/bloc/user_friend_events.dart';
import 'package:flutter_intern/project/bloc/user_friend_states.dart';
import 'package:flutter_intern/project/bloc/user_list_bloc.dart';
import 'package:flutter_intern/project/bloc/user_list_states.dart';
import 'package:flutter_intern/project/friend_service_provider.dart' as fService;
import 'package:flutter_intern/project/locator.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;

class FriendRequests extends StatefulWidget{
  const FriendRequests({super.key});

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests>{

  List<UserData>?  userDatatList;
  List<UserDetails>? userDetailsList;
  List<UserData> requestedByUsers = List.empty(growable: true);
  List<UserDetails> requestedByUserDetails = List.empty(growable: true);
  List<UserData> userDataList =List.empty(growable: true);

  final GlobalKey<ScaffoldState> _scaffoldKey  = GlobalKey();

  int minUser = 3;

  Future<Widget> getFriendStateWidget(int id, UserData userData) async{
    String friendStateString;
    fService.FriendServiceProvider fServe = fService.FriendServiceProvider();
    fService.FriendState friendState = await fServe.getFriendState(id, userData);
    IconData ico;
    VoidCallback onPressed;

    switch(friendState) {
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
          width: 2, color: Colors.white, style: BorderStyle.solid))),
      onPressed: (){onPressed(); setState(() {
      
    });},child: Row(children: [Icon(ico, color: Colors.white,), Text(friendStateString, style:const TextStyle(color: Colors.white),)],));
  } 

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
      builder:(builder, state) { 
        return BlocBuilder<UserListBloc, UserListStates>(
          builder: (context, userListState) {
            userDataList = userListState.userDataList!;
            userDetailsList = userListState.userDetailsList;
            return BlocBuilder<UserFriendBloc, UserFriendStates>(
            builder: (context, userFriendState) {
              if(userFriendState is UserFriendEmpty){
                return const Scaffold(appBar: CommonAppBar(), body: Center(child: CircularProgressIndicator(),));
              }
              var filteredFriendList =  userFriendState.userFriends!.where((element) => 
              (element.friendId == state.userData!.id || element.userId == state.userData!.id) && (element.hasNewRequestAccepted == false) &&
              element.requestedBy != state.userData!.id && element.userListId>0).toList(); 
              for(var item in filteredFriendList){
                var user = locator.get<UserListBloc>().state.userDataList!.firstWhere((element) => element.id == item.requestedBy); 
                var userDetails = locator.get<UserListBloc>().state.userDetailsList!.firstWhere((element) => element.id == user.id); 
                requestedByUsers.add(user);
                requestedByUserDetails.add(userDetails);
                }
              return Scaffold(
              key: _scaffoldKey,
                appBar: const CommonAppBar(),
                body: SingleChildScrollView(
                  child: userDataList.length < minUser ? Text(userDataList.length.toString()):Column(
                    children: [
                      const SizedBox(height: 30,),
                      Center(child: Text("Requests", style: Theme.of(context).textTheme.headlineSmall,)),
                      const SizedBox(height: 30,),
                      Padding(padding: const EdgeInsets.all(12),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: requestedByUsers.length,
                        itemBuilder: (context, index) => Container(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushNamed('/profileInfo/${requestedByUsers.elementAt(index).id}');
                              },
                              child: Column(children: [
                                Row(
                                  children: [
                                    CircleAvatar(backgroundImage: FileImage(File(requestedByUserDetails.elementAt(index).basicInfo.profileImage.imagePath)),),
                                    const SizedBox(width: 20,),
                                    Column(children: [Text(requestedByUsers.elementAt(index).name),],),
                                    const Spacer(),
                                    FutureBuilder(future: getFriendStateWidget(requestedByUserDetails.elementAt(index).id!, state.userData!), builder: (context, AsyncSnapshot<Widget> snapshot){
                                      if(snapshot.connectionState == ConnectionState.waiting){
                                        return const CircularProgressIndicator();
                                        }
                                        else if(snapshot.hasError){
                                          return Text('${snapshot.error}');
                                        }
                                        return snapshot.data ?? Container();
                                        })
                                        ],),
                                        const SizedBox(height: 30,),
                                          ],
                                        ),
                                      ))),
                                ),
                              ],
                            ),
                          ),
                          );
            },
          );
          },
        );
      },
    );
  }
}