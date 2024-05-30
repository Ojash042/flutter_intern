import 'package:equatable/equatable.dart';

class AuthEvents extends Equatable{
  @override
  List<Object?> get props => throw UnimplementedError();
}

class UnknownAuthEvent extends AuthEvents{
}

class AuthorizedAuthEvent extends AuthEvents{

}

class UnauthorizedAuthEvent extends AuthEvents{

}

class RequestLogInEvent extends AuthEvents{
  String email;
  String password;
  RequestLogInEvent({required this.email, required this.password});
}

class RequestLogoutEvent extends AuthEvents{

}