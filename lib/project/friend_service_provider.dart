import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;
import 'package:shared_preferences/shared_preferences.dart';

enum FriendState {notFriend, pending, requested, friend, isUser }
class FriendServiceProvider{
  late SharedPreferences sharedPreferences;

  Future<void> getSharedPref() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }  

  Future<FriendState> getFriendState(int friendId, userData) async{
    sharedPreferences = await SharedPreferences.getInstance();
    String? userFriendJson = sharedPreferences.getString("user_friend");
    Iterable decoder = jsonDecode(userFriendJson!);
    TModels.UserFriend? userFriend =  decoder.map((e) => TModels.UserFriend.fromJson(e))
    .firstWhereOrNull((element) => element.userListId > 0 && (element.friendId == friendId || element.userId == friendId) && (userData!.id == element.userId || userData.id ==element.friendId));


    if(userFriend == null || userFriend.hasRemoved == true){
      return FriendState.notFriend;
    }

    if(friendId == userData!.id){
      return FriendState.isUser;
    }

    if(userFriend.requestedBy == userData!.id && userFriend.hasRemoved == false && userFriend.hasNewRequest == true){
      return FriendState.pending;
    }

    if(userFriend.requestedBy == friendId  && userFriend.hasRemoved ==false && userFriend.hasNewRequest == true){
      return FriendState.requested;
    }
    if(userFriend.hasNewRequest == false && userFriend.hasRemoved == false && userFriend.hasNewRequestAccepted == true){
      return FriendState.friend;
    }
    
    return FriendState.notFriend; 
  }  
}