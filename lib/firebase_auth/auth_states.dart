import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationStates extends Equatable{
  final User? user;
  final bool isLoggedIn;
  final String? loggedInEmail;
  const AuthenticationStates({required this.user, required this.isLoggedIn, required this.loggedInEmail});
  @override
  List<Object?> get props => throw UnimplementedError();
}

class UnknownState extends AuthenticationStates{
  const UnknownState(): super(isLoggedIn: false, user: null, loggedInEmail: null);
}

class LoggedInState extends AuthenticationStates{
  final bool isLoggedIn;
  final String loggedInEmail;
  final User user;

  const LoggedInState({required this.isLoggedIn, required this.loggedInEmail, required this.user}):

  super(isLoggedIn: isLoggedIn, loggedInEmail: loggedInEmail, user: user);
}

class UnauthenticatedState extends AuthenticationStates{
  const UnauthenticatedState():super(isLoggedIn: false, loggedInEmail: null, user: null);
}

