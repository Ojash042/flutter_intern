import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern/project/auth_provider.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FriendState {notFriend, pending, requested, friend, }
class FriendServiceProvider with ChangeNotifier{
  final BuildContext context;

  
  FriendServiceProvider(this.context);

  Future<FriendState> getFriendState(int friendId) async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? userFriendJson = sharedPreferences.getString("user_friend");
    Iterable decoder = jsonDecode(userFriendJson!);
    UserData? userData = await Provider.of<AuthProvider>(context, listen: false).getLoggedInUser(); 
    TModels.UserFriend? userFriend =  decoder.map((e) => TModels.UserFriend.fromJson(e))
    .firstWhereOrNull((element) => element.userListId > 0 && (element.friendId == friendId || element.userId == friendId));

    if(userFriend == null || userFriend.hasRemoved == true){
      return FriendState.notFriend;
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

  Future<void> addFriend() async{

  }

  Future<void> removeFriend() async{
    
  }

}