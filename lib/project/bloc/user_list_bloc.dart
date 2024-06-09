import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/user_list_events.dart';
import 'package:flutter_intern/project/bloc/user_list_states.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserListBloc extends Bloc<UserListEvents, UserListStates>{

  UserListBloc():super(UserListEmpty()){
    on<UserListInitialize>((event, emit) => _fetchUserList(event, emit));
    on<UserListFetched>((event, emit) => (event, emit) => {});
    on<EditUserEvent>((event, emit) => _editUserDetails(event, emit));
  }

  void _fetchUserList(UserListEvents event, Emitter<UserListStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userDataJson = sharedPreferences.getString('user_data')!;
    String userDetailsJson = sharedPreferences.getString('user_details')!;
    Iterable decoderUserData = jsonDecode(userDataJson); 
    Iterable decoderUserDetails = jsonDecode(userDetailsJson);
    List<UserData> userData = decoderUserData.map((e) => UserData.fromJson(e)).toList();
    List<UserDetails> userDetails = decoderUserDetails.map((e) => UserDetails.fromJson(e)).toList();
    emit(UserListStates(userDataList: userData, userDetailsList: userDetails));
  }

  void _editUserDetails(EditUserEvent event, Emitter<UserListStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     
      String? encodedString = jsonEncode(event.userDetails.map((e) => e.toJson()).toList()); 
      sharedPreferences.setString("user_details", encodedString);
      emit(UserListStates(userDataList: state.userDataList, userDetailsList: event.userDetails));
  }
}