import 'package:equatable/equatable.dart';
import 'package:flutter_intern/project/models.dart';

class AuthStates extends Equatable{
  final bool loggedInState;
  final UserData? userData; 
  final UserDetails? userDetails;
  final bool isLoginError;
  const AuthStates({this.loggedInState = false, this.userData, this.userDetails, this.isLoginError = false});
  @override
  List<Object?> get props => [loggedInState, userData, userDetails, isLoginError];
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
  final bool isLoginError;
  const UnauthorizedAuthState({required this.isLoginError}):super(isLoginError: isLoginError);
}