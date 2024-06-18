import 'package:flutter_intern/project/bloc/user_friend_bloc.dart';
import 'package:flutter_intern/project/bloc/user_list_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<UserListBloc>(UserListBloc());
  locator.registerSingleton<UserFriendBloc>(UserFriendBloc());
}

void closeUserListLocator() async{
  await locator<UserListBloc>().close();
}

void closeUserFriendLocator() async{
  await locator<UserFriendBloc>().close();
}