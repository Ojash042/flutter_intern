import 'package:equatable/equatable.dart';
import 'package:flutter_intern/project/technical_models.dart';

class UserPostStates extends Equatable{
  
  final List<UserPost>? userPosts;
    
  const UserPostStates({this.userPosts});

  @override
  List<Object?> get props => [userPosts];

  @override
  int get hashCode => userPosts.hashCode ^ userPosts!.map((e) => e.hashCode).reduce((a,b) => a ^ b);
  
  @override
  bool operator ==(Object other) {
    return (identical(this, other));
  }

  @override
  bool? get stringify => true;
}

class UserPostEmpty extends UserPostStates{
  const UserPostEmpty():super(userPosts: null);
}