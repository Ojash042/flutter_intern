part of 'login_bloc.dart';

class AuthenticationStates extends Equatable{
  final User? user;
  final bool isLoggedIn;
  final String loggedInEmail;
  
  const AuthenticationStates({required this.isLoggedIn, required this.loggedInEmail, this.user});

  @override
  List<Object> get props => [isLoggedIn, loggedInEmail, user!];
} 

class UnknownState extends AuthenticationStates{
  
  const UnknownState() : super(isLoggedIn: false, loggedInEmail: "", );
  
  @override
  List<Object> get props => [];
  
}

class LoggedInState extends AuthenticationStates{
  final bool isLoggedIn;
  final String loggedInEmail;
  final User user;
  const LoggedInState({required this.isLoggedIn, required this.loggedInEmail, required this.user}) : super(isLoggedIn: isLoggedIn, loggedInEmail: loggedInEmail, user: user);

  @override 
  List<Object> get props => [isLoggedIn, loggedInEmail];

  @override
  String toString()=> 'LoggedIn with $loggedInEmail';
}

class UnauthenticatedState extends AuthenticationStates{
  final bool logInError;
  const UnauthenticatedState({this.logInError = false}):super(isLoggedIn: false, loggedInEmail: "", user: null);

  @override
  List<Object> get props => [logInError, loggedInEmail];
}