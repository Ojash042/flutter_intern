import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_intern/bloc_project/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_events.dart';
part 'authentication_states.dart';

class LoginObserver extends BlocObserver{
  const LoginObserver();
  
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }
}

class AuthenticationBloc extends Bloc<AuthenticationEvents, AuthenticationStates>{
  AuthenticationBloc():super(const UnknownState()){
    on<AuthenticationUnknownEvent>((event, emit) => unknown(event, emit));
    on<AuthenticationAutoLogin>((event, emit) => autoLogin(event, emit),);
    on<AuthenticationRequestLogin>(((event, emit) => loginEvent(event, emit)));
    on<AuthenticationRequestLogout>((event, emit) => logoutEvent(event, emit),);
    on<AuthenticationUnauthenticatedEvent>((event,emit) => unauthenticatedEvent);
  }

  Future<void> unknown(AuthenticationEvents event, Emitter<AuthenticationStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? loggedInEmail =  sharedPreferences.getString("loggedInEmail");
    if(loggedInEmail!=null){
        String? userJson = sharedPreferences.getString("bloc_user");
        Iterable userJsonDecoder = jsonDecode(userJson!);
        List<User> userList = userJsonDecoder.map((e) => User.fromJson(e)).toList();
        User loggedInUser = userList.firstWhere((element) => element.userEmail == loggedInEmail);
        add(AuthenticationAutoLogin(userEmail: loggedInEmail, userPassword: loggedInUser.userPassword!));
    }
    else{
      add(AuthenticationUnauthenticatedEvent());
      emit(const UnauthenticatedState());
    }
  }

  void autoLogin(AuthenticationAutoLogin event, Emitter<AuthenticationStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? loggedInEmail = sharedPreferences.getString("loggedInEmail");
    String? userJson = sharedPreferences.getString("bloc_user");
    Iterable userJsonDecoder = jsonDecode(userJson!);
    List<User> userList = userJsonDecoder.map((e) => User.fromJson(e)).toList();
    User loggedInUser = userList.firstWhere((element) => element.userEmail == loggedInEmail);

    emit(LoggedInState(isLoggedIn: true, loggedInEmail: loggedInEmail!, user: loggedInUser));
  }

  void loginEvent(AuthenticationRequestLogin event, Emitter<AuthenticationStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userJson = sharedPreferences.getString("bloc_user");
    if(userJson == null){
      emit(const UnauthenticatedState(logInError: true));
      return;
    }

    Iterable userJsonDecoder = jsonDecode(userJson);

    List<User> userList = userJsonDecoder.map((e) => User.fromJson(e)).toList();
    User? user = userList.firstWhereOrNull((element) => element.userEmail == event.userEmail && element.userPassword == event.password);
    if(user!=null){
      sharedPreferences.setString("loggedInEmail", user.userEmail!);
      emit(LoggedInState(isLoggedIn: true, loggedInEmail: event.userEmail, user: user));
      return;
    }
    else{
      emit(const UnauthenticatedState(logInError: true));
      return;
    }
  }
  
  void logoutEvent(AuthenticationRequestLogout event, Emitter<AuthenticationStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("loggedInEmail");
    emit(const UnauthenticatedState(logInError: false));
  }
  
  void unauthenticatedEvent(AuthenticationUnauthenticatedEvent event, Emitter<UnauthenticatedState> emit) async{
    emit(const UnauthenticatedState(logInError: false));
  }
}