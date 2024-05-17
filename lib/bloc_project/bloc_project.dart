import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/bloc_project/login_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_intern/bloc_project/models.dart';

void main(){
  Bloc.observer = const LoginObserver();
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthenticationBloc()..add(AuthenticationUnknownEvent())), 
      ],
      child: const App(),
    ),
    );
}

class App extends StatelessWidget{

  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      routes: {
        "/":(context) => const HomePage(), 
        "/login":(context) => LoginPage(),
        "/signup":(context) => const SignUpPage(),
      },
      initialRoute: "/",
    );
  }}


class HomePage extends StatelessWidget{

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.primary,),
    body: const InitialContainer(),
    );
  }
}

class InitialContainer extends StatelessWidget{ 

  const InitialContainer({super.key});

  @override
  Widget build(BuildContext context) {
   return BlocListener<AuthenticationBloc, AuthenticationStates>(listener: (BuildContext context, state){
    print(state);
    if(state is UnauthenticatedState || state is UnknownState){
      Navigator.popAndPushNamed(context, "/login");
    } 
   },
    child: BlocBuilder<AuthenticationBloc, AuthenticationStates>(builder: (context, state) => 
      (state is LoggedInState)?
      Center(
        child: Column(children: [
          Text('Logged In as User ${state.user.userFullName}'),
          OutlinedButton(onPressed: (){context.read<AuthenticationBloc>().add(AuthenticationRequestLogout());}, child: const Text("Log Out"))
        ],),
      ): Container()
    ,), 
   ); 
  }
}

class LoginPage extends StatelessWidget{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationStates>(listener: (BuildContext context, state){
      if(state is LoggedInState){
        Navigator.popAndPushNamed(context, '/'); 
      }
    },
    child: BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      buildWhen: (previous, current) => previous.runtimeType != current.runtimeType || (previous is UnauthenticatedState && current is UnauthenticatedState && previous.logInError != current.logInError),
      builder: (context, state) => 
      Scaffold(
          appBar: AppBar(centerTitle: true, title: const Text("Bloc Project"), backgroundColor: Theme.of(context).colorScheme.primary,),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(child: Column(children: [
                Text("Login", style: Theme.of(context).textTheme.headlineMedium,),
                const SizedBox(height: 30,),
                (state is UnauthenticatedState && state.logInError)?
                Container(width: MediaQuery.of(context).size.width - 40, color: Colors.redAccent,
                child: const Text("Login Failed"),
                ):
                Container(),
                const SizedBox(height: 60,), 
                TextFormField(decoration: const InputDecoration(hintText: "Enter Email"), controller: emailController,),
                const SizedBox(height: 60,),
                TextFormField(decoration: const InputDecoration(hintText: "Enter password"), controller: passwordController, obscureText: true,),
                const SizedBox(height: 60,),
                OutlinedButton(onPressed: (){
                  context.read<AuthenticationBloc>().add(AuthenticationRequestLogin(userEmail: emailController.text, password: passwordController.text));
                  },
                  child: const Text("Login")),
                const SizedBox(height: 60,),
                TextButton(onPressed: (){Navigator.of(context).pushNamed('/signup');}, child: const Text("Not Signed Up?")),
              ],),),
            ),
          ),
        )
    ),
    );
    }}

class SignUpPage extends StatefulWidget{

  const SignUpPage({super.key});
  
  @override
  State<SignUpPage> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage>{
  void saveData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<User> userList = List.empty(growable: true);
    setState(() {
      String? userJson =  sharedPreferences.getString("bloc_user");
      if(userJson!=null){
        Iterable decoderUser = jsonDecode(userJson); 
        userList =  decoderUser.map((e) => User.fromJson(e)).toList();
      } 

      String uuid = const Uuid().v7();
      User user =User(id:uuid, userEmail: userEmailController.text, userFullName: userFullNameController.text, userPassword: userPasswordController.text);
      userList.add(user); 
      String editedJson = jsonEncode(userList.map((e) => e.toJson()).toList());
      sharedPreferences.setString("bloc_user", editedJson); 
    });
} 

  TextEditingController userFullNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bloc Project"), centerTitle: true, backgroundColor: Theme.of(context).colorScheme.primary,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(children: [
              Text("Sign Up", style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: 30,),
              TextFormField(decoration: const InputDecoration(hintText: "Enter Full Name"), controller: userFullNameController,),
              const SizedBox(height: 30,),
              TextFormField(decoration: const InputDecoration(hintText: "Enter Email"), controller: userEmailController,),
              const SizedBox(height: 30,),
              TextFormField(decoration: const InputDecoration(hintText: "Enter Password"), obscureText:true, controller: userPasswordController,),
              const SizedBox(height: 30,),
              OutlinedButton(onPressed: (){
                saveData();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [
                  const Text("Submitted Form"),
                 TextButton(onPressed: (){Navigator.of(context).pop();}, 
                 child: const Text("Go back to Login Page"))],)));
              }, child: const Text("Submit"))
            ],),
          ),
        ),
      ),
    );
  }
}