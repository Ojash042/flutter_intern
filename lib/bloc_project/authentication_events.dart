part of 'login_bloc.dart';

class AuthenticationEvents{
  const AuthenticationEvents();
}

  final class AuthenticationRequestLogin extends AuthenticationEvents{
    final String userEmail;
    final String password;
    AuthenticationRequestLogin({required this.userEmail, required this.password});
  }

  final class AuthenticationRequestLogout extends AuthenticationEvents{
    AuthenticationRequestLogout();
    
  }

  final class AuthenticationAutoLogin extends AuthenticationEvents{
    final String userEmail;
    final String userPassword;
    AuthenticationAutoLogin({required this.userEmail, required this.userPassword});
  }
  
  final class AuthenticationUnknownEvent extends AuthenticationEvents{
    AuthenticationUnknownEvent();
  }
  
  final class AuthenticationUnauthenticatedEvent extends AuthenticationEvents{
    AuthenticationUnauthenticatedEvent();
  }