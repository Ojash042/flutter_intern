import 'dart:io';
import 'package:collection/collection.dart';
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
import 'package:humanizer/humanizer.dart';

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
  List<String> creationDates = List.empty(growable: true);

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
          locator<UserFriendBloc>().add(UserAddFriendEvent(friendId: id, userId: userId));
        };
        break;

      case fService.FriendState.friend:
        friendStateString = "Remove Friend";
        ico = Icons.group_off_outlined;
        onPressed = (){
          int userId = context.read<AuthBloc>().state.userData!.id;
          locator<UserFriendBloc>().add(UserFriendRemoveEvent(friendId: id, userId: userId));
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
          locator<UserFriendBloc>().add(UserFriendAcceptRequestEvent(friendId: id, userId: userId));
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
              }, label: const Text("Remove Friend"), icon: const Icon(Icons.delete_forever_outlined),),
           ),
          
        );
      }, icon: const Icon(Icons.more_horiz));
    }
    return OutlinedButton(
      style:const ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(), borderRadius: BorderRadius.all(Radius.circular(0)))),
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
    if(locator<UserFriendBloc>().state is UserFriendEmpty){
      locator<UserFriendBloc>().add(UserFriendInitialize());
    }
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
              return Scaffold(
              key: _scaffoldKey,
                appBar: const CommonAppBar(),
                body: SingleChildScrollView(
                  child: userDataList.length < minUser ? Text(userDataList.length.toString()): Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 30,),
                        BlocBuilder<UserFriendBloc, UserFriendStates>(
                          builder:(context,userFriendState) {
                            if(userFriendState is UserFriendEmpty){
                              return const Scaffold(appBar: CommonAppBar(), body: Center(child: CircularProgressIndicator(),));
                              }
                              var filteredFriendList =  locator<UserFriendBloc>().state.userFriends!.where((element) => 
                              (element.friendId == state.userData!.id || element.userId == state.userData!.id) && (element.hasNewRequestAccepted == false) &&
                              element.requestedBy != state.userData!.id && element.userListId>0).toList(); 
                              requestedByUserDetails = List.empty(growable: true);
                              requestedByUsers = List.empty(growable: true);
                              for(var item in filteredFriendList){
                                var user = locator<UserListBloc>().state.userDataList!.firstWhere((element) => element.id == item.requestedBy); 
                                var userDetails = locator<UserListBloc>().state.userDetailsList!.firstWhere((element) => element.id == user.id); 
                                requestedByUsers.add(user);
                                requestedByUserDetails.add(userDetails);
                                creationDates.add(item.createdAt);
                              }
                        
                            return Column(
                              children: requestedByUserDetails.mapIndexed((index,element) => GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushNamed('/profileInfo/${requestedByUsers.elementAt(index).id}');
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        minRadius: 40,
                                        backgroundImage: FileImage(File(requestedByUserDetails.elementAt(index).basicInfo.profileImage.imagePath)),),
                                      const SizedBox(width: 5,),
                                      Flexible(
                                      flex: 5,
                                        fit: FlexFit.loose,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                          Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(requestedByUsers.elementAt(index).name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                  maxLines: 1,
                                                  const ApproximateTimeTransformation(granularity: Granularity.primaryUnit, round: true, isRelativeToNow: true)
                                                  .transform(Duration(microseconds: DateTime.parse(creationDates.elementAt(index)).microsecondsSinceEpoch - DateTime.now().microsecondsSinceEpoch), 'en')
                                                  ),
                                              )],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              FutureBuilder(future: getFriendStateWidget(requestedByUserDetails.elementAt(index).id!, state.userData!), builder: (context, AsyncSnapshot<Widget> snapshot){
                                                if(snapshot.connectionState == ConnectionState.waiting){
                                                  return const CircularProgressIndicator();
                                                }
                                                else if(snapshot.hasError){
                                                  return Text('${snapshot.error}');
                                                }
                                                return snapshot.data ?? Container();
                                                }),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: FilledButton(
                                                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.grey[400]), shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)))),
                                                  onPressed: (){
                                                    int friendId = requestedByUserDetails.elementAt(index).id!;
                                                    int userId = context.read<AuthBloc>().state.userData!.id;
                                                    locator<UserFriendBloc>().add(UserFriendRejectRequestEvent(friendId: friendId, userId: userId));
                                                  }, child: const Text("Remove")),
                                              ),
                                            ],
                                          )
                                          ], ),
                                      ),
                                      ],),
                                          const SizedBox(height: 30,),
                                            ],
                                          ),
                                        )).toList());
                            return ListView.builder(
                            shrinkWrap: true,
                            itemCount: requestedByUsers.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushNamed('/profileInfo/${requestedByUsers.elementAt(index).id}');
                                },
                                child: Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(backgroundImage: FileImage(File(requestedByUserDetails.elementAt(index).basicInfo.profileImage.imagePath)),),
                                        const SizedBox(width: 20,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.35),
                                                child: Text(requestedByUsers.elementAt(index).name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                                              Text(
                                                const ApproximateTimeTransformation(granularity: Granularity.primaryUnit, round: true, isRelativeToNow: true)
                                                .transform(Duration(microseconds: DateTime.parse(creationDates.elementAt(index)).microsecondsSinceEpoch - DateTime.now().microsecondsSinceEpoch), 'en')
                                                )],
                                          ),
                                          FutureBuilder(future: getFriendStateWidget(requestedByUserDetails.elementAt(index).id!, state.userData!), builder: (context, AsyncSnapshot<Widget> snapshot){
                                            if(snapshot.connectionState == ConnectionState.waiting){
                                              return const CircularProgressIndicator();
                                            }
                                            else if(snapshot.hasError){
                                              return Text('${snapshot.error}');
                                            }
                                            return snapshot.data ?? Container();
                                            })
                                          ], ),
                                        const Spacer(),
                                        ],),
                                            const SizedBox(height: 30,),
                                              ],
                                            ),
                                ),
                                        ));
                          },
                        ),
                                ],
                              ),
                  ),
                          ),
                          );
            },
          );
          },
        );
      } 
  }