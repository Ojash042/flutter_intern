
import 'package:flutter_intern/project/bloc/user_list_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<UserListBloc>(UserListBloc());
}

void resetLocator() async{
  await locator.reset(dispose: false);
}