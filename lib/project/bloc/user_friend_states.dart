import 'package:equatable/equatable.dart';
import 'package:flutter_intern/project/technical_models.dart';

class UserFriendStates extends Equatable{
  final List<UserFriend>? userFriends; 
  const UserFriendStates({this.userFriends});
  
  @override
  List<Object?> get props => [userFriends];   
  
  
}

class UserFriendEmpty extends UserFriendStates{
  const UserFriendEmpty():super(userFriends: null);
}
