import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/user_post_event.dart';
import 'package:flutter_intern/project/bloc/user_post_states.dart';
import 'package:flutter_intern/project/technical_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPostBloc extends Bloc<UserPostEvent, UserPostStates>{
  UserPostBloc():super(const UserPostEmpty()){
    on<UserPostInitialize>((event,emit) => _fetchUserPosts(event, emit));
    on<UserPostAddPostEvent>((event,emit) => _addUserPost(event, emit));
    on<UserPostLikePostEvent>((event, emit) => _pressLikePost(event, emit));
  }

  void _fetchUserPosts(UserPostEvent event, Emitter<UserPostStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userPostJson = sharedPreferences.getString("user_post")!;
    Iterable decoderUserPost = jsonDecode(userPostJson);
    List<UserPost> userPosts = decoderUserPost.map((e) => UserPost.fromJson(e)).toList();
    emit(UserPostStates(userPosts: userPosts));
    return;
  }

  void _addUserPost(UserPostAddPostEvent event, Emitter<UserPostStates> emit) async{
    SharedPreferences sharedPreferences =  await SharedPreferences.getInstance();
    if(state is! UserPostEmpty){
      state.userPosts!.add(event.userPost);
      String encodedData = jsonEncode(state.userPosts!.map((e) => e.toJson()).toList());  
      sharedPreferences.setString("user_post", encodedData);
      emit(UserPostStates(userPosts: state.userPosts));
    }
  }
  
  void _pressLikePost(UserPostLikePostEvent event, Emitter<UserPostStates> emit) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  List<UserPost> userPosts = state.userPosts!;
  List<PostLikedBy> postLikedBys =  userPosts.firstWhere((e) => e.postId == event.postId).postLikedBys;
  bool userLikedPost = postLikedBys.firstWhereOrNull((e) => e.userId == event.userId) == null;
  if(userLikedPost){
    PostLikedBy postLikedBy = PostLikedBy();
    postLikedBy.dateTime = DateTime.now().toIso8601String();
    postLikedBy.userId = event.userId;
    if(userPosts.firstWhere((e) => e.postId == event.postId).postLikedBys == []){
      userPosts.firstWhere((e) => e.postId == event.postId).postLikedBys = List.empty(growable: true);
    }
    userPosts.firstWhere((e) => e.postId == event.postId).postLikedBys.add(postLikedBy);
  }
  else{
    postLikedBys.remove(postLikedBys.firstWhere((e) => e.userId == event.userId));
  }

  String editedJson = jsonEncode(userPosts.map((e) => e.toJson()).toList());
  sharedPreferences.setString("user_post", editedJson);
  var userState = UserPostStates(userPosts: userPosts);
  emit(userState);
  }
}