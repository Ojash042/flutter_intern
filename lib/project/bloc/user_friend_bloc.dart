import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/user_friend_events.dart';
import 'package:flutter_intern/project/bloc/user_friend_states.dart';
import 'package:flutter_intern/project/technical_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserFriendBloc extends Bloc<UserFriendEvents, UserFriendStates>{
  UserFriendBloc():super(const UserFriendEmpty()){
    on<UserFriendInitialize>((event, emit) => _fetchUserFriend(event, emit));
    on<UserAddFriendEvent>((event,emit) => _addUserFriend(event,emit));
    on<UserFriendRemoveEvent>((event, emit) => _removeUserFriend(event, emit));
    on<UserFriendAcceptRequestEvent>((event, emit) => _acceptRequest(event, emit));
    on<UserFriendRejectRequestEvent>((event, emit) => _rejectRequest(event, emit),);
  }
  
  void _fetchUserFriend(UserFriendEvents event, Emitter<UserFriendStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userFriendJson = sharedPreferences.getString("user_friend")!;
    Iterable decoderUserFriend = jsonDecode(userFriendJson);
    List<UserFriend> userFriend = decoderUserFriend.map((e) => UserFriend.fromJson(e)).toList();
    emit(UserFriendStates(userFriends: userFriend));
    return;
  }

  void _addUserFriend(UserAddFriendEvent event, Emitter<UserFriendStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userFriendJson = sharedPreferences.getString("user_friend");
    Iterable decoder = jsonDecode(userFriendJson!);
    List<UserFriend> userFriendList = decoder.map((e) => UserFriend.fromJson(e)).toList();
    UserFriend? userFriendItem = userFriendList.singleWhereOrNull((e) => 
      (e.friendId == event.friendId && e.userId == event.userId  || e.friendId == event.userId && e.userId == event.friendId));
    if(userFriendItem!= null){
      userFriendItem.createdAt = DateTime.now().toIso8601String();
      userFriendItem.requestedBy = event.userId;
      userFriendItem.hasNewRequest = true;
      userFriendItem.hasNewRequestAccepted = false;
      userFriendItem.hasRemoved = false;
    }
    else{
      UserFriend userFriend = UserFriend();
      userFriend.userListId = userFriendList.length +1;
      userFriend.createdAt = DateTime.now().toIso8601String();
      userFriend.friendId = event.friendId;
      userFriend.requestedBy = event.userId;
      userFriend.userId = event.userId;
      userFriend.hasNewRequest = true;
      userFriend.hasNewRequestAccepted = false;
      userFriend.hasRemoved = false;
      userFriendList.add(userFriend); 
    }
    String editedJson = jsonEncode(userFriendList.map((e) => e.toJson()).toList());
    sharedPreferences.setString("user_friend", editedJson);
    emit(UserFriendStates(userFriends: userFriendList));
  }
  
  void _removeUserFriend(UserFriendRemoveEvent event, Emitter<UserFriendStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userFriendJson = sharedPreferences.getString("user_friend");
    Iterable decoder = jsonDecode(userFriendJson!);
    List<UserFriend> userFriendList = decoder.map((e) => UserFriend.fromJson(e)).toList();
    var userFriend  = userFriendList.firstWhere((element) => element.userListId> 0 && (element.friendId == event.userId || element.userId == event.userId) &&
    (element.friendId == event.friendId || element.userId == event.friendId) && (element.hasNewRequestAccepted));

    userFriend.hasRemoved = true;

    String editedJson = jsonEncode(userFriendList.map((e) => e.toJson()).toList());

    sharedPreferences.setString("user_friend", editedJson);
    emit(UserFriendStates(userFriends: userFriendList));
  }
  
  void _acceptRequest(UserFriendAcceptRequestEvent event, Emitter<UserFriendStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userFriendJson = sharedPreferences.getString("user_friend");
    Iterable decoder = jsonDecode(userFriendJson!);
    List<UserFriend> userFriendList = decoder.map((e) => UserFriend.fromJson(e)).toList();
    var userFriend = userFriendList.firstWhere((element) => element.userListId>0 && 
    (element.friendId == event.friendId || element.userId == event.friendId) 
    && (element.friendId == event.userId || element.userId == event.userId ) && (element.hasNewRequest == true));
    
    userFriend.hasNewRequest = false;
    userFriend.hasNewRequestAccepted = true; 

    String editedJson = jsonEncode(userFriendList.map((e) => e.toJson()).toList());
    sharedPreferences.setString("user_friend", editedJson);
    emit(UserFriendStates(userFriends: userFriendList));
  }
  
  void _rejectRequest(UserFriendRejectRequestEvent event, Emitter<UserFriendStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userFriendJson = sharedPreferences.getString("user_friend");
    Iterable decoder = jsonDecode(userFriendJson!);
    List<UserFriend> userFriendList = decoder.map((e) => UserFriend.fromJson(e)).toList();
    var userFriend = userFriendList.firstWhere((element) => element.userListId>0 && 
    (element.friendId == event.friendId || element.userId == event.friendId) 
    && (element.friendId == event.userId || element.userId == event.userId ) && (element.hasNewRequest == true));
        
    userFriend.hasNewRequest = false;
    userFriend.hasNewRequestAccepted = true;
    userFriend.userId = -1;
    userFriend.friendId = -1;

    String editedJson = jsonEncode(userFriendList.map((e) => e.toJson()).toList());
    sharedPreferences.setString("user_friend", editedJson);
    emit(UserFriendStates(userFriends: userFriendList));
  }
}