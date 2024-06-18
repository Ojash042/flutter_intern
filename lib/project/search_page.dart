import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_states.dart';
import 'package:flutter_intern/project/bloc/user_friend_bloc.dart';
import 'package:flutter_intern/project/bloc/user_friend_events.dart';
import 'package:flutter_intern/project/bloc/user_friend_states.dart';
import 'package:flutter_intern/project/bloc/user_list_bloc.dart';
import 'package:flutter_intern/project/bloc/user_list_events.dart';
import 'package:flutter_intern/project/bloc/user_list_states.dart';
import 'package:flutter_intern/project/friend_service_provider.dart' as fService;
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;

class SearchPage extends StatefulWidget{
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  late List<UserData> userDataList;
  late List<UserDetails> userDetails;
  List<TModels.UserFriend> usersFriends = List.empty(growable: true);

  List<UserData> searchedData = List.empty(growable: true);
  List<UserDetails> searchedDataDetails = List.empty(growable: true);
  List<UserData> userFriendData = List.empty(growable: true);
  List<UserDetails> userFriendDetails = List.empty(growable: true);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  UserData? loggedInUser;

  SearchController searchController = SearchController();

  Future<Widget> getFriendStateWidget(int id, UserData? userData) async{
    String friendStateString;
    fService.FriendServiceProvider fServe = fService.FriendServiceProvider();
    fService.FriendState friendState = await fServe.getFriendState(id, userData);
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
        onPressed= (){
          int userId = context.read<AuthBloc>().state.userData!.id;
          context.read<UserFriendBloc>().add(UserAddFriendEvent(friendId: id, userId: userId));
        };
        break;
      case fService.FriendState.requested:
        friendStateString = "Requested";
        ico = Icons.group;
        onPressed = (){
          int userId = context.read<AuthBloc>().state.userData!.id;
          context.read<UserFriendBloc>().add(UserAddFriendEvent(friendId: id, userId: userId));
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
        backgroundColor: WidgetStatePropertyAll(Colors.blue),side: WidgetStatePropertyAll(BorderSide(width: 4, color: Colors.white, style: BorderStyle.solid))),
      onPressed: (){onPressed();setState(() { 

    });},child: Row(children: [Icon(ico, color: Colors.white,), Text(friendStateString, style: const TextStyle(color: Colors.white),)],));
  }

  @override
  void dispose(){
    super.dispose();
  }

  Future<void> searchData(String value, UserData? userData) async{
    setState(() { 
      searchedData = List.empty(growable: true);
      searchedDataDetails = List.empty(growable: true);
      searchedData = userDataList.where((element) => element.name == value).toList();
      for(var item in searchedData){
        var userDetail = userDetails.firstWhere((element) => element.id == item.id);
        searchedDataDetails.add(userDetail);
      }
     });
    fService.FriendServiceProvider fServe =  fService.FriendServiceProvider();
    List<fService.FriendState> friendStates = List.empty(growable: true);
    for(var item in searchedData){
      fService.FriendState friendState = await  fServe.getFriendState(item.id, userData);
      friendStates.add(friendState);
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserListBloc>(context).add(UserListInitialize());
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
      builder: (builder, state) {
        loggedInUser = state.userData;
        return BlocBuilder<UserListBloc, UserListStates>(
        builder: (context, userListState){
          userDataList = userListState.userDataList!;
          userDetails = userListState.userDetailsList!; 
          return BlocBuilder<UserFriendBloc, UserFriendStates>(
          builder: (context, userFriendState) {
            if(userFriendState is UserFriendEmpty){
              return const Scaffold(appBar: CommonAppBar(), body: Center(child: CircularProgressIndicator(),),);
            }
          usersFriends = userFriendState.userFriends!.where((element) => (element.userListId>0) &&
             (element.userId == loggedInUser!.id || element.friendId == loggedInUser!.id ) && (element.hasNewRequest == false) && (!element.hasRemoved)).toList();
      
            for(var item in usersFriends){
              int friendId;
              if(item.userId == loggedInUser!.id){
                  friendId = item.friendId;
              }
              else{
                friendId = item.userId;
              }
       
              var userData = userDataList.firstWhere((element) => element.id == friendId);
              var userDetail = userDetails.firstWhere((element) => element.id == friendId);
              userFriendData.add(userData);
              userFriendDetails.add(userDetail);
            }
            return Scaffold(
                  key: _scaffoldKey,
                  appBar: const CommonAppBar() ,
                  // drawer: (loggedInEmail == null) ? MyDrawer() : const LoggedInDrawer(),
                  body:SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(children: [
                        TextFormField(decoration: const InputDecoration(hintText: "Search..."), onFieldSubmitted: (value){
                          searchData(value, loggedInUser);
                        },),
                 
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: searchedData.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => SizedBox(
                              height: 64,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, '/profileInfo/${searchedData.elementAt(index).id}');
                                    },
                                      child: Row(children: [
                                        CircleAvatar(backgroundImage: FileImage(File(searchedDataDetails.elementAt(index).basicInfo.profileImage.imagePath), ),),
                                        const SizedBox(width: 12,),
                                        Text(searchedData.elementAt(index).name),
                                        const SizedBox(height: 12,),
                                        const Spacer(),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: FutureBuilder(
                                            future: getFriendStateWidget(searchedDataDetails.elementAt(index).id!, loggedInUser),
                                            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                                              if(snapshot.connectionState == ConnectionState.waiting){
                                                return const CircularProgressIndicator();
                                              }
                                              else if(snapshot.hasError){
                                                return Text('${snapshot.error}');
                                              }
                                              return snapshot.data ?? Container();
                                            }
                                          ))
                                      ],),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        // TextFormField(controller: searchController, decoration: InputDecoration(hintText: ), )
                      ],),
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