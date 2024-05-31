// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/auth_bloc.dart';
import 'package:flutter_intern/project/auth_events.dart';
import 'package:flutter_intern/project/auth_states.dart';
import 'package:flutter_intern/project/misc.dart';
class LoginForm extends StatefulWidget{
  const LoginForm({super.key});

  @override
  State<LoginForm> createState()=> _LoginFormState();
}



class _LoginFormState extends State<LoginForm>{

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  double heightFactor = 0.75;
  double originalHeightFactor = 0.75;
  double widthFactor = 0.5;
  double originaWidthFactor = 0.5;
  double secondHeightFactor = 0.5;
  double originaSecondHeightFactor = 0.5;

  bool passwordObscure = true; 
  @override
  void initState(){
    super.initState(); 
    _emailFocusNode.addListener(() {_onLostFocus();});
    _passwordFocusNode.addListener(() {_onLostFocus();});
  } 
  
  void _onTapChangeClipPath(){
    setState(() {
      heightFactor = 0.4;
      widthFactor = 0.25;
      secondHeightFactor = -0.35;
    });
    return;
  }
 
  void _onLostFocus(){
    if(! _emailFocusNode.hasFocus && !_passwordFocusNode.hasFocus){
      setState(() {
       heightFactor = originalHeightFactor; 
       widthFactor = originaWidthFactor;
       secondHeightFactor = originaSecondHeightFactor;
      }); 
    }
    if(_emailFocusNode.hasFocus || _passwordFocusNode.hasFocus){
        setState(() {
          heightFactor = 0.1;
          widthFactor = -2.0;
          secondHeightFactor = 0.1;
        });
      }
    return;
  }
  
  @override
  Widget build(BuildContext context) { 
    return BlocListener<AuthBloc, AuthStates>(
      listener: (BuildContext context, state) { 
        if(state is AuthorizedAuthState){
          Navigator.of(context).popAndPushNamed('/');
        }
       },
      child: BlocBuilder<AuthBloc, AuthStates>(
        builder: (BuildContext context, state)  => Scaffold(
          // appBar: AppBar(title: const Text("Project"), centerTitle: true, backgroundColor: Colors.blueAccent,),
          drawer: MyDrawer(),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: ClipPath(
                clipper: BackgroundWaveClipper(heightFactor: heightFactor, widthFactor: widthFactor, secondHeightFactor: heightFactor),
                child: Container(width: MediaQuery.of(context).size.width,
                height: 280, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xffabb5ff), Color(0xfff6efe9)])),
                      ),
                    ),
                  ),
              Center(
                child: Form(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [ 
                        Text("Login", style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 40,),
                        SizedBox(width: MediaQuery.of(context).size.width - 100, child: TextFormField(decoration: const InputDecoration(hintText: "Enter Email"),
                        focusNode: _emailFocusNode,controller: _emailController,),),
                        const SizedBox(height: 30,),
                        SizedBox(width: MediaQuery.of(context).size.width -100 , child: TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          onTap:() => _onTapChangeClipPath,
                          obscureText: passwordObscure, decoration: InputDecoration(
                          suffixIcon: IconButton(onPressed:() =>
                           setState(() {
                            passwordObscure = !passwordObscure; 
                           }),
                          icon: Icon(passwordObscure ? Icons.visibility_off : Icons.visibility)),
                          hintText: "Enter password"),),),
                        const SizedBox(height: 30,), 
                        SizedBox(child: OutlinedButton(onPressed:  () => 
                        context.read<AuthBloc>().add(RequestLogInEvent(email: _emailController.text, password: _passwordController.text)),
                        //BlocProvider.of<AuthBloc>(context).add(RequestLogInEvent(email: _emailController.text, password: _passwordController.text)),
                        child: const Text("Login"),)),
                        const SizedBox(height: 40,),
                        SizedBox(child: TextButton(onPressed: (){Navigator.pushNamed(context, '/forgotPassword');}, child: const Text("Forgot Password"),),),
                        const SizedBox(height: 30,),
                        SizedBox(child: TextButton(onPressed: (){Navigator.pushNamed(context, "/signup");}, child: const Text("Sign Up"),),)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } 
}