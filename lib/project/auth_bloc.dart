import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/auth_events.dart';
import 'package:flutter_intern/project/auth_states.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthObserver extends BlocObserver{
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }
  
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }
}

class AuthBloc extends Bloc<AuthEvents, AuthStates>{
  AuthBloc():super(const UnknownAuthState()){
    on<UnknownAuthEvent>((event, emit) =>_initialLoadUp(event, emit));
    on<RequestLogInEvent>((event, emit) => loginEvent(event, emit));
    on<RequestLogoutEvent>((event, emit) => logoutEvent(event, emit));
  }
  
  void logoutEvent(RequestLogoutEvent event, Emitter<AuthStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("loggedInEmail");
    emit(const UnauthorizedAuthState());
  }
  
  void loginEvent(RequestLogInEvent event, Emitter<AuthStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userDataJson = sharedPreferences.getString("userData");
    String? userDetailsJson =sharedPreferences.getString("userDetails");
    if(userDataJson == null || userDetailsJson == null){
      emit(const UnauthorizedAuthState());
      return;
    }
    
    Iterable decoderUserData = jsonDecode(userDataJson);
    Iterable decoderUserDetails = jsonDecode(userDataJson);
    
    UserData? userData =  decoderUserData.map((data) => UserData.fromJson(data)).firstWhereOrNull((element) => element.email == event.email && element.password == event.password);
    if(userData == null){
      emit(const UnauthorizedAuthState());
      return;
    }
    UserDetails userDetails = decoderUserDetails.map((details) => UserDetails.fromJson(details)).firstWhere((element) => element.id == userData.id);
    emit(AuthorizedAuthState(userData: userData, userDetails: userDetails)); 
  } 

  void _initialLoadUp(AuthEvents event, Emitter<AuthStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userDataJson = sharedPreferences.getString("user_data");
    String? userDetailsJson = sharedPreferences.getString("user_details");
    String? loggedInEmail = sharedPreferences.getString("loggedInEmail");
    if(loggedInEmail == null){
      emit(const UnauthorizedAuthState());
      return;
    }

    if(userDataJson != null && userDetailsJson != null){
      Iterable decoderUserData = jsonDecode(userDataJson); 
      Iterable decoderUserDetails = jsonDecode(userDetailsJson);
      UserData? userData = decoderUserData.map((data) => UserData.fromJson(data)).firstWhereOrNull((element) => element.email == loggedInEmail);
      if(userData == null){
        emit(const UnauthorizedAuthState());
        return;
      } 
      else{
        UserDetails userDetails = decoderUserDetails.map((details) => UserDetails.fromJson(details)).firstWhere((element) => element.id == userData.id);
        emit(AuthorizedAuthState(userData: userData, userDetails: userDetails));
        return;
      }
    }
    emit(const UnauthorizedAuthState());
  }
}