import 'package:equatable/equatable.dart';
import 'package:flutter_intern/project/models.dart';

class AuthStates extends Equatable{
  final bool loggedInState;
  final UserData? userData; 
  final UserDetails? userDetails;
  const AuthStates({this.loggedInState = false, this.userData, this.userDetails});
  @override
  List<Object?> get props => [];
}

class UnknownAuthState extends AuthStates{
  const UnknownAuthState():super();
}

class AuthorizedAuthState extends AuthStates{
  final UserData? userData;
  final UserDetails? userDetails;
  const AuthorizedAuthState({required this.userData, required this.userDetails}): super(loggedInState: true, userData: userData, userDetails: userDetails);
}

class UnauthorizedAuthState extends AuthStates{
  const UnauthorizedAuthState():super();
}