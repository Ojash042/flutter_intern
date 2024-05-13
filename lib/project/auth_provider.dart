import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier{
  UserData? _userData;
  UserData? get userData => _userData;

  void login(BuildContext context, String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userDataJson = sharedPreferences.getString("user_data");
    if(userDataJson == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Not Found")));
      return;
    }
    Iterable decoder = jsonDecode(userDataJson);
    UserData? user = decoder.map((e) => UserData.fromJson(e)).toList().firstWhereOrNull((element) => element.email == email && element.password == password );
    if(user==null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Not Found")));
      return;
    }
    _userData = user;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Logged In")));
    sharedPreferences.setString("loggedInEmail", email);
    notifyListeners();
  }

  void logout(){
    _userData = null;
    notifyListeners();
  }

  Future<bool> isLoggedIn() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? loggedInEmail = sharedPreferences.getString("loggedInEmail");
    return loggedInEmail!=null;
  }
}