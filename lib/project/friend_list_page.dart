import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/auth_bloc.dart';
import 'package:flutter_intern/project/auth_states.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  List<UserData> userFriendData = List.empty(growable: true);
  List<UserDetails> userFriendDetails = List.empty(growable: true);

  List<Widget> action = List.empty(growable: true);

  Future<Widget> getFriendStateWidget(int id, UserData userData) async{
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
           fserve.addFriend(id, userData);
           setState(() {             
           });
           };
        break;

      case fService.FriendState.friend:
        friendStateString = "Remove Friend";
        ico = Icons.group_off_outlined;
        onPressed = ()=>  fserve.removeFriend(id, userData);
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
        {
        fserve.acceptRequest(id, userData);
         setState(() { 
        }); 
        }          
        };
        break;
      case fService.FriendState.isUser:
        return Container();
    }

    return OutlinedButton(onPressed: (){
      onPressed(); setState(() { 
    });},child: Row(children: [Icon(ico), Text(friendStateString)],));
  }

  Future<void> getDataFromSharedPrefs(UserData? loggedInUser) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    
    String? userFriendJson = sharedPreferences.getString("user_friend");
    String? userDataJson = sharedPreferences.getString("user_data");
    String? userDetailsJson = sharedPreferences.getString("user_details");

    Iterable decoderUserFriend = jsonDecode(userFriendJson!);
    Iterable decoderUserData = jsonDecode(userDataJson!);
    Iterable decoderUserDetails = jsonDecode(userDetailsJson!);

    List<TModels.UserFriend> userFriendList = decoderUserFriend.map((e) => TModels.UserFriend.fromJson(e)).toList();
    List<UserData> userDataList = decoderUserData.map((e) => UserData.fromJson(e)).toList();
    List<UserDetails> userDetailsList = decoderUserDetails.map((e) => UserDetails.fromJson(e)).toList();

    setState(() {
      usersFriends = userFriendList.where((element) => (element.userListId>0) &&
      (element.userId == loggedInUser!.id || element.friendId == loggedInUser.id ) && (element.hasNewRequest == false) && (!element.hasRemoved)).toList();
    });

    for(var item in usersFriends){
      int friendId;
      if(item.userId == loggedInUser!.id){
        friendId = item.friendId;
      }
      else{
        friendId = item.userId;
      }
      var userData = userDataList.firstWhere((element) => element.id == friendId);
      var userDetails = userDetailsList.firstWhere((element) => element.id == friendId);
      setState(() {
        userFriendData.add(userData);
        userFriendDetails.add(userDetails);
      });
    }
    
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    UserData? loggedInUser;
    AuthBloc authBloc = context.read<AuthBloc>();
    print("oooo ${authBloc.state.userData!.email}");
    setState(() { 
      loggedInUser = authBloc.state.userData;
    });
    // authBloc.stream.listen((state) {
    //   setState(() {
    //     loggedInUser = state.userData;
    //     print(state.userData!.email);
    //   });
    // });
    getDataFromSharedPrefs(loggedInUser);
  }
  
  @override
  void didUpdateWidget(covariant FriendListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    UserData? loggedInUser;
    AuthBloc authBloc = context.read<AuthBloc>();
    setState(() { 
      loggedInUser = authBloc.state.userData;
    });
    print(' ooooooojaifkf ${loggedInUser == null}');
    // authBloc.stream.listen((state) {
    //   setState(() {
    //     loggedInUser = state.userData;
    //   });
    // });
    getDataFromSharedPrefs(loggedInUser);
  }
  
  @override
  void initState() {
    super.initState();
    UserData? loggedInUser;
    AuthBloc authBloc = context.read<AuthBloc>();
    setState(() {
      loggedInUser = authBloc.state.userData;
    });
    authBloc.stream.listen((state) {
      setState(() {
        loggedInUser = state.userData;
        print(state.userData!.email);
      });
    });
    getDataFromSharedPrefs(loggedInUser);
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
        return Scaffold(
        appBar: CommonAppBar(actions: action,),
        bottomNavigationBar: CommonNavigationBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
            Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.group_add_outlined), onPressed: (){
              Navigator.of(context).pushNamed("/friendRequests");
            },),),
            const SizedBox(height: 30,),
            Text("Friend List", style: Theme.of(context).textTheme.headlineSmall,),
            ListView.builder(
              shrinkWrap: true,
              itemCount: usersFriends.length,
              itemBuilder: (context, index)=> Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(onTap: (){
                  Navigator.of(context).pushNamed('/profileInfo/${usersFriends.elementAt(index).userId}');},
                child: Row(
                  children: [
                    CircleAvatar(backgroundImage: FileImage(File(userFriendDetails.elementAt(index).basicInfo.profileImage.imagePath)),),
                    const SizedBox(width: 20,),
                    Column(children: [
                      Text(userFriendData.elementAt(index).name),
                      ],),
                    const Spacer(),
                    FutureBuilder(future: getFriendStateWidget(userFriendDetails.elementAt(index).id!, loggedInUser!), builder: (context, AsyncSnapshot<Widget> snapshot){
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return const CircularProgressIndicator();
                                }
                                else if(snapshot.hasError){
                                  return Text('${snapshot.error}');
                                }
                                return snapshot.data ?? Container();
                              })
                  ],
                ), 
                ),
              ))
            ]
          ),),);
      },
    );
  }
}