import 'package:equatable/equatable.dart';
import 'package:flutter_intern/project/technical_models.dart';

class UserPostEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class UserPostInitialize extends UserPostEvent{}

class UserPostAddPostEvent extends UserPostEvent{
  final UserPost userPost;
  
  UserPostAddPostEvent({required this.userPost});
}

class UserPostLikePostEvent extends UserPostEvent{
  final int postId;
  final int userId;
  UserPostLikePostEvent({required this.postId, required this.userId});

}