import 'package:equatable/equatable.dart';

class AuthenticationEvents extends Equatable{
  @override
  List<Object?> get props => throw UnimplementedError();
}

class AuthenticationRequestLogin extends AuthenticationEvents{
  AuthenticationRequestLogin({required this.email, required this.password}):super();
  String email;
  String password;
}

class AuthenticationRequestLogout extends AuthenticationEvents{

}

class AuthenticationUnknownEvent extends AuthenticationEvents{

}

class AuthenticationUnauthenticatedEvent extends AuthenticationEvents{

}

class AuthenticationRequestSignUp extends AuthenticationEvents{

}