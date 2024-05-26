import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_intern/project/auth_provider.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:provider/provider.dart';
class LoginForm extends StatefulWidget{
  const LoginForm({super.key});

  @override
  State<LoginForm> createState()=> _LoginFormState();
}



class _LoginFormState extends State<LoginForm>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordObscure = true;

  void checkLoggedIn() async{
  if(await Provider.of<AuthProvider>(context, listen: false).isLoggedIn()){
      Navigator.of(context).popAndPushNamed("/home");
    }
  }
  @override
  void initState(){
    super.initState(); 
    checkLoggedIn();
  }

  void loginUser() async {
    Provider.of<AuthProvider>(context, listen: false).login(context, _emailController.text, _passwordController.text);
    if(await Provider.of<AuthProvider>(context, listen: false).isLoggedIn()){
      Navigator.of(context).popAndPushNamed("/home");
    }
  }
  

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      // appBar: AppBar(title: const Text("Project"), centerTitle: true, backgroundColor: Colors.blueAccent,),
      drawer: MyDrawer(),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ClipPath(
            clipper: BackgroundWaveClipper(),
            child: Container(width: MediaQuery.of(context).size.width,
            height: 280, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xffabb5ff), Color(0xfff6efe9)])),
                  ),
                ),
              ),
          Center(
            child: Form(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                  Text("Login", style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 240,),
                  SizedBox(width: MediaQuery.of(context).size.width - 100, child: TextFormField(decoration: const InputDecoration(hintText: "Enter Email"), controller: _emailController,),),
                  const SizedBox(height: 30,),
                  SizedBox(width: MediaQuery.of(context).size.width -100 , child: TextFormField(obscureText: passwordObscure, decoration: InputDecoration(
                    suffixIcon: IconButton(onPressed:() =>
                     setState(() {
                      passwordObscure = !passwordObscure; 
                     }),
                    icon: Icon(passwordObscure ? Icons.visibility_off : Icons.visibility)),
                    hintText: "Enter password"),controller: _passwordController,),),
                  const SizedBox(height: 30,), 
                  SizedBox(child: OutlinedButton(onPressed: loginUser,child: const Text("Login"),)),
                  const SizedBox(height: 40,),
                  SizedBox(child: TextButton(onPressed: (){Navigator.pushNamed(context, '/forgotPassword');}, child: const Text("Forgot Password"),),),
                  const SizedBox(height: 30,),
                  SizedBox(child: TextButton(onPressed: (){Navigator.pushNamed(context, "/signup");}, child: const Text("Sign Up"),),)
                ],
              ),
            ),
          ),
        ],
      ),
    );    
  } 
}