import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/api_project/bloc_provider.dart';
import 'package:flutter_intern/api_project/events.dart';
import 'package:flutter_intern/api_project/misc.dart';
import 'package:flutter_intern/api_project/states.dart';

class LoginPage extends StatelessWidget{
  LoginPage({super.key});
  bool logginError = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController =TextEditingController();
    return BlocConsumer<AuthorizationProvider, AuthorizedUserState>(listener: (context, state) => {
      if(state is LoggedInState){
        Navigator.of(context).popAndPushNamed('/')
      }
    },
    buildWhen: (previous, current) => (previous.hashCode != current.hashCode),
    builder: (context, state) =>
   Scaffold(
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(child: 
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              logginError? Container(
                padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                "Error! Could not log in",
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ],
                ),
              ) : Container(),
              Text("Login", style: Theme.of(context).textTheme.headlineSmall,),
              TextFormField(controller: usernameController, decoration: const InputDecoration(hintText: "Enter username"),),
              TextFormField(controller: passwordController, decoration: const InputDecoration(hintText: "Enter password"),),
              OutlinedButton(onPressed: (){
              BlocProvider.of<AuthorizationProvider>(context).add(AuthorizedUserLogin(username: usernameController.text, password: passwordController.text, loginError: true));
              if(state is LoggedInState){
                Navigator.of(context).popAndPushNamed('/');
              }
              else{
                logginError = true;
              }
          
              }, child: const Text("Login")),
          ],),
        )
      ,),
    )  ,
    );
  }
}
