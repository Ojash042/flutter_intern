import 'package:equatable/equatable.dart';
import 'package:flutter_intern/project/models.dart';

class UserListStates extends Equatable{
  const UserListStates({this.userDataList, this.userDetailsList});
  final List<UserData>? userDataList;
  final List<UserDetails>? userDetailsList;

  @override
  List<Object?> get props => [userDataList, userDetailsList]; 
  
  @override
  bool operator ==(Object other) {
    return identical(userDataList, userDetailsList);
  }

}

class UserListEmpty extends UserListStates{
  UserListEmpty():super(userDataList: List.empty(), userDetailsList: List.empty());
}