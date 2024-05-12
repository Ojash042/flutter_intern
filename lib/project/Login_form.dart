import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginForm extends StatefulWidget{
  const LoginForm({super.key});

  @override
  State<LoginForm> createState()=> _LoginFormState();

}

class _LoginFormState extends State<LoginForm>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userDataJson = sharedPreferences.getString("user_data");
    if(userDataJson == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not available")));
      return;
    }
    Iterable decoder = jsonDecode(userDataJson);
    List<UserData> retrievedUserData = decoder.map((e) => UserData.fromJson(e)).toList(); 
    if(retrievedUserData.isEmpty || (retrievedUserData.firstWhereOrNull((element) => element.email == _emailController.text) ==null)){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not available")));
    }
    sharedPreferences.setBool("loggedIn", true);
    sharedPreferences.setString("loggedInEmail", _emailController.text);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Successfully Logged In") ,));
    return;     
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login", style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 30,),
              SizedBox(width: MediaQuery.of(context).size.width - 100, child: TextFormField(decoration: const InputDecoration(hintText: "Enter Email"), controller: _emailController,),),
              const SizedBox(height: 30,),
              SizedBox(width: MediaQuery.of(context).size.width -100 , child: TextFormField(obscureText: true, decoration: const InputDecoration(hintText: "Enter password"),controller: _passwordController,),),
              const SizedBox(height: 30,), 
              SizedBox(child: OutlinedButton(child: const Text("Login"), onPressed: loginUser,)),
              const SizedBox(height: 60,),
              SizedBox(child: TextButton(onPressed: (){Navigator.pushNamed(context, "/signup");}, child: const Text("Sign Up"),),)
            ],
          ),
        ),
      ),
    );    
  } 
}