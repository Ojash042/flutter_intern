import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_intern/api_project/misc.dart';
import 'package:flutter_intern/api_project/models.dart';
import 'package:http/http.dart' as http;

class UserDetailsPage extends StatefulWidget{

  final String id;
  const UserDetailsPage({super.key, required this.id});

  @override
  State<UserDetailsPage> createState() {
    return _UserDetailsPageState();
  }
}

class _UserDetailsPageState extends State<UserDetailsPage>{
  late Users user = Users();
  bool contentLoaded = false;

  void fetchUserProfile() async{
    http.Response response = await http.get(Uri.parse("https://dummyjson.com/users/${widget.id}"));
    if(response.statusCode == 200){
      Map<String, dynamic> userJson = json.decode(response.body);
      setState(() { 
        user = Users.fromJson(userJson);
        contentLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: 
       !contentLoaded ? const Center(child: CircularProgressIndicator()) :
       SingleChildScrollView(
        child: Column(children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(backgroundImage: NetworkImage(user.image ?? 
                    "https://www.kindpng.com/picc/m/451-4517876_default-profile-hd-png-download.png"),),
                  ),
                  const SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${user.firstName} ${user.lastName} ${user.maidenName}'),
                  ),
                  const SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${user.gender}' ,style: Theme.of(context).textTheme.titleSmall,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${user.age}', style: Theme.of(context).textTheme.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Contact At: ${user.email}'),
                  ),
                ],),
              ),
            ),
          )
        ],)
      ),
    );
  }
}