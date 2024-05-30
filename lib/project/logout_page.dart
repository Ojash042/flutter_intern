import 'package:flutter/material.dart';
import 'package:flutter_intern/project/auth_provider.dart';
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
    return Scaffold(
      appBar: const CommonAppBar(),
      bottomNavigationBar: CommonNavigationBar(),
      body: Center(
        child: OutlinedButton.icon(onPressed: (){
          Provider.of<AuthProvider>(context, listen: false).logout();
          Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        }, label: const Text("Logout"), icon: const Icon(Icons.exit_to_app_outlined),),
      ),
    );
  }
}