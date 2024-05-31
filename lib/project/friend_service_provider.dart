import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_intern/project/auth_provider.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;
import 'package:provider/provider.dart';
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
    .firstWhereOrNull((element) => element.userListId > 0 && (element.friendId == friendId || element.userId == friendId) && (userData!.id == element.userId || element.userId == friendId));


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

  void addFriend(int friendId, UserData userData) async {
    String? userFriendJson = sharedPreferences.getString("user_friend");
    Iterable decoder = jsonDecode(userFriendJson!);
    List<TModels.UserFriend> userFriendList = decoder.map((e) => TModels.UserFriend.fromJson(e)).toList();
    TModels.UserFriend userFriend = TModels.UserFriend();
    userFriend.userListId = userFriendList.length +1;
    userFriend.createdAt = DateTime.now().toIso8601String();
    userFriend.friendId = friendId;
    userFriend.requestedBy = userData!.id;
    userFriend.userId = userData.id;
    userFriend.hasNewRequest = true;
    userFriend.hasNewRequestAccepted = false;
    userFriend.hasRemoved = false;
    userFriendList.add(userFriend);

    String editedJson = jsonEncode(userFriendList.map((e) => e.toJson()).toList());
    sharedPreferences.setString("user_friend", editedJson);
  }

  void removeFriend(int id, UserData userData) async{
    String? userFriendJson = sharedPreferences.getString("user_friend");
    Iterable decoder = jsonDecode(userFriendJson!);
    List<TModels.UserFriend> userFriendList = decoder.map((e) => TModels.UserFriend.fromJson(e)).toList();
    var userFriend  = userFriendList.firstWhere((element) => element.userListId> 0 && (element.friendId == id || element.userId == id) &&
    (element.friendId == userData!.id || element.userId == userData!.id) && (element.hasNewRequestAccepted));

    userFriend.hasRemoved = true;

    String editedJson = jsonEncode(userFriendList.map((e) => e.toJson()).toList());

    sharedPreferences.setString("user_friend", editedJson);
  }
  
  void acceptRequest(int id, UserData userData) async{
    String? userFriendJson = sharedPreferences.getString("user_friend");
    Iterable decoder = jsonDecode(userFriendJson!);
    List<TModels.UserFriend> userFriendList = decoder.map((e) => TModels.UserFriend.fromJson(e)).toList();

    var userFriend = userFriendList.firstWhere((element) => element.userListId>0 && 
    (element.friendId == id || element.userId == id) && (element.friendId == userData!.id || element.userId == userData.id ) && (element.hasNewRequest == true));
    
    userFriend.hasNewRequest = false;
    userFriend.hasNewRequestAccepted = true;
  
    String editedJson = jsonEncode(userFriendList.map((e) => e.toJson()).toList());
    sharedPreferences.setString("user_friend", editedJson);
  }

}