import 'package:equatable/equatable.dart';
import 'package:flutter_intern/project/technical_models.dart';

class UserFriendEvents extends Equatable{
  final List<UserFriend>? userFriends;

  const UserFriendEvents({this.userFriends});

  @override
  List<Object?> get props => [userFriends];

}

class UserFriendInitialize extends UserFriendEvents{}

class UserAddFriendEvent extends UserFriendEvents{
  final int friendId;
  final int userId;

  const UserAddFriendEvent({required this.friendId, required this.userId});
}

class UserFriendRemoveEvent extends UserFriendEvents{
  final int friendId;
  final int userId;
  
  const UserFriendRemoveEvent({required this.friendId, required this.userId});
}

class UserFriendAcceptRequestEvent extends UserFriendEvents{
  final int friendId;
  final int userId;
  
  const UserFriendAcceptRequestEvent({required this.friendId, required this.userId});
}