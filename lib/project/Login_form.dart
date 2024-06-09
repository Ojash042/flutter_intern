// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_events.dart';
import 'package:flutter_intern/project/bloc/auth_states.dart';
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
        builder: (BuildContext context, state) {
          
          return Scaffold(

          // appBar: AppBar(title: const Text("Project"), centerTitle: true, backgroundColor: Colors.blueAccent,),
          //drawer: MyDrawer(),
          bottomNavigationBar: const UnauthorizedNavigationBar(),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: ClipPath(
                clipper: BackgroundWaveClipper(heightFactor: heightFactor, widthFactor: widthFactor, secondHeightFactor: heightFactor),
                child: Container(width: MediaQuery.of(context).size.width,
                height: 280, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.blueAccent, Colors.white])),
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
                        const SizedBox(height: 120,),
                        // (state is UnauthorizedAuthState && state.isLoginError)? SnackBar(content: const Text("Login Error"), 
                        // backgroundColor: Colors.white, elevation: 5, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        // behavior: SnackBarBehavior.floating,showCloseIcon: true,): Container(), 

                        (state is UnauthorizedAuthState && state.isLoginError ) ? Container(
                          decoration:BoxDecoration(color: Colors.red[400],
                          border: Border.all(color: Colors.grey[200]!, width: 2),
                          borderRadius:const BorderRadius.all(Radius.circular(14)),
                          //shape: BoxShape.circle
                          ),
                          child: const Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 9.0, vertical: 10),
                            child:  Text("Error! Invalid Credentials", style: TextStyle(color: Colors.white),),
                          ),) : Container(),
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
                        SizedBox(child: OutlinedButton(onPressed:  (){                        
                        context.read<AuthBloc>().add(RequestLogInEvent(email: _emailController.text, password: _passwordController.text));
                        if(true){
                          
                        }
                        },
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
        );
        },
      ),
    );
  } 
}