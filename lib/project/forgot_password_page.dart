import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordPage extends StatefulWidget{
  const ForgotPasswordPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordPageState();
  }
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>{

  bool emailError = false;
  bool passwordError = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController reNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void changePassword() async{
    setState(() {
      emailError = false;
      passwordError = false;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(newPasswordController.text!= reNewPasswordController.text){
      setState(() {
        passwordError = true;
      }); 
      return;
    }

    String? userDataJson = sharedPreferences.getString("user_data");
    Iterable decoder = jsonDecode(userDataJson!);
    List<UserData> userDataList = decoder.map((e) => UserData.fromJson(e)).toList();
    UserData? userData = userDataList.firstWhereOrNull((element) => element.email == emailController.text);
    if(userData == null){
      setState(() {
        emailError = true;
      });
      return;
    }
    setState(() {
      userData.password = newPasswordController.text;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password Changed Successfully")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: const Text("Project"),centerTitle: true, 
    backgroundColor: Colors.lightBlueAccent,),
    //drawer: MyDrawer(),
    body: SingleChildScrollView(child: Center(child: Column(children: [
      TextFormField(controller: emailController, decoration: InputDecoration(hintText: "Enter email address", error: emailError ? const Text("Invalid Email") : null),),
      const SizedBox(height: 30,),
      TextFormField(controller: newPasswordController, decoration: InputDecoration(hintText: "Enter New Password", error: passwordError ? const Text("Passwords do not match"): null),),
      const SizedBox(height: 30,),
      TextFormField(controller: reNewPasswordController, decoration: InputDecoration(hintText: "Enter New Password (again)", error: passwordError ? const Text("Passwords do not match"): null),),
      ElevatedButton(onPressed: (){changePassword();}, child: const Text("Submit"))
    ],),),),
    );
  }  
}