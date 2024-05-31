import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/auth_bloc.dart';
import 'package:flutter_intern/project/auth_events.dart';
import 'package:flutter_intern/project/auth_provider.dart';
import 'package:flutter_intern/project/auth_states.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:provider/provider.dart';

class LogoutPage extends StatefulWidget{
  const LogoutPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LogoutPageState();
  }
}

class _LogoutPageState extends State<LogoutPage>{
  @override
  void initState() {
    super.initState();
    setState(() {
      
    });
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
        
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
      builder: (builder, state) => Scaffold(
        appBar: const CommonAppBar(),
        bottomNavigationBar: CommonNavigationBar(),
        body: Center(
          child: OutlinedButton.icon(onPressed: (){
            BlocProvider.of<AuthBloc>(context).add(RequestLogoutEvent());
            Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          }, label: const Text("Logout"), icon: const Icon(Icons.exit_to_app_outlined),),
        ),
      ),
    );
  }
}