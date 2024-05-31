import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/models.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatefulWidget{
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController reNewPasswordController = TextEditingController();

  void changePassword() async{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      if(newPasswordController.text != reNewPasswordController.text){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The two new passwords do not match")));
        return;
      }

      UserData? userData;
      String? loggedInEmail = sharedPreferences.getString("loggedInEmail");
      String? userDataJson = sharedPreferences.getString("user_data");

      Iterable decodedUserData = jsonDecode(userDataJson!);
      var userDataList = decodedUserData.map((e) => UserData.fromJson(e)).toList();
      userData = userDataList.firstWhereOrNull((element) => element.email == loggedInEmail);

      if(userData == null){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong!")));
        return;
      }
      if(userData.password != oldPasswordController.text){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Old password does not match")));
        return;
      }
      userData.password = newPasswordController.text;
      var jsonUserData  = jsonEncode(userDataList.map((e) => e.toJson()).toList());
      sharedPreferences.setString("user_data", jsonUserData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully changed password")));
      oldPasswordController.text = "";
      newPasswordController.text = "";
      reNewPasswordController.text = "";
      Navigator.pop(context);
    }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: const CommonAppBar(),
    //drawer: LoggedInDrawer(),
    body: SingleChildScrollView(
      child: Form(
      key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(child: Column(
            children: [
              TextFormField(controller: oldPasswordController, decoration: const InputDecoration(hintText: "Enter Old Password."), obscureText: true,),
              const SizedBox(height: 30,),
              TextFormField(controller: newPasswordController, decoration: const InputDecoration(hintText: "Enter new Password."), obscureText: true,),
              const SizedBox(height: 30,),
              TextFormField(controller: reNewPasswordController, decoration: const InputDecoration(hintText: "Enter new Password (again)."), obscureText: true,),
              const SizedBox(height: 30,),
              ElevatedButton(onPressed: (){changePassword();}, child: const Text("Change Password"))
            ],
          )),
        ),
      ),
    ),
  );
  }
}