import 'package:equatable/equatable.dart';
import 'package:flutter_intern/project/models.dart';

class UserListEvents extends Equatable{
  @override
  List<Object?> get props => [];

}

class UserListInitialize extends UserListEvents{}

class UserListFetched extends UserListEvents{
  
}

class EditUserEvent extends UserListEvents{
  final List<UserDetails> userDetails;
  EditUserEvent({required this.userDetails});
}