import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_intern/project/auth_provider.dart';
import 'package:flutter_intern/project/friend_service_provider.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendRequests extends StatefulWidget{
  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests>{

  List<UserData> requestedByUsers = List.empty(growable: true);
  List<UserDetails> requestedByUserDetails = List.empty(growable: true);

  Future<Widget> getFriendStateWidget(int id) async{
    String friendStateString;
    FriendState friendState = await Provider.of<FriendServiceProvider>(context,listen: false).getFriendState(id);
    IconData ico;
    VoidCallback onPressed;
    switch(friendState){
      case FriendState.notFriend:
        friendStateString = "Add Friend";
        ico = Icons.group_add;
        onPressed = () => Provider.of<FriendServiceProvider>(context,listen: false).addFriend(id);
        break;

      case FriendState.friend:
        friendStateString = "Remove Friend";
        ico = Icons.group_off_outlined;
        onPressed = ()=> Provider.of<FriendServiceProvider>(context, listen: false).removeFriend(id);
        break;

      case FriendState.pending:
        friendStateString = "Pending";
        ico = Icons.access_time;
        onPressed= (){};
        break;
      case FriendState.requested:
        friendStateString = "Requested";
        ico = Icons.group;
        onPressed = () => {Provider.of<FriendServiceProvider>(context, listen: false).acceptRequest(id)};
        break;
      case FriendState.isUser:
        return Container();
    }
    return OutlinedButton(onPressed: (){onPressed(); setState(() {
      
    });},child: Row(children: [Icon(ico), Text(friendStateString)],));
  }

  Future<void> getDataFromSharedPrefs() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userDataJson = sharedPreferences.getString("user_data");
    String? userDetailsJson = sharedPreferences.getString("user_details");
    String? userFriendJson = sharedPreferences.getString("user_friend");
    UserData? userData = await Provider.of<AuthProvider>(context, listen: false).getLoggedInUser();
    
    Iterable decoderUserFriend = jsonDecode(userFriendJson!); 
    Iterable decoderUserData = jsonDecode(userDataJson!);
    Iterable decoderUserDetails = jsonDecode(userDetailsJson!);

    List<TModels.UserFriend> userFriendsList = decoderUserFriend.map((e) => TModels.UserFriend.fromJson(e)).toList();
    List<UserData> userDataList = decoderUserData.map((e) => UserData.fromJson(e)).toList();
    List<UserDetails> userDetailsList = decoderUserDetails.map((e) => UserDetails.fromJson(e)).toList();


    List<TModels.UserFriend> filteredFriendList =  userFriendsList.where((element) => 
    (element.friendId == userData!.id || element.userId == userData.id) && (element.hasNewRequestAccepted == false) &&
    element.requestedBy != userData.id && element.userListId>0).toList();


    for(var item in filteredFriendList){
      var user = userDataList.firstWhere((element) => element.id == item.requestedBy); 
      var userDetails = userDetailsList.firstWhere((element) => element.id == user.id);
      setState(() { 
        requestedByUsers.add(user);
        requestedByUserDetails.add(userDetails);
      });
    }
  }


  @override
  void initState() {
    super.initState();
    getDataFromSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Project"), backgroundColor: Colors.blueAccent, ),
      drawer: const LoggedInDrawer(),
      body: SingleChildScrollView(
        child: Column(
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(backgroundImage: FileImage(File(requestedByUserDetails.elementAt(index).basicInfo.profileImage.imagePath)),),
                            const SizedBox(width: 20,),
                            Column(
                              children: [
                                Text(requestedByUsers.elementAt(index).name),
                              ],
                            ),
                            Spacer(),
                          FutureBuilder(future: getFriendStateWidget(requestedByUserDetails.elementAt(index).id), builder: (context, AsyncSnapshot<Widget> snapshot){
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
  }
}