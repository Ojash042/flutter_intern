import 'package:equatable/equatable.dart';

class AuthEvents extends Equatable{
  const AuthEvents();
  @override
  List<Object?> get props => [];
}

class UnknownAuthEvent extends AuthEvents{
}

class AuthorizedAuthEvent extends AuthEvents{

}

class UnauthorizedAuthEvent extends AuthEvents{

}

class RequestLogInEvent extends AuthEvents{
  final String email;
  final String password;
  const RequestLogInEvent({required this.email, required this.password});
}

class RequestLogoutEvent extends AuthEvents{
}