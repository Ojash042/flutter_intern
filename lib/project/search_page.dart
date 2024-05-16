import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_intern/project/friend_service_provider.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_intern/project/models.dart';

class SearchPage extends StatefulWidget{

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  String? loggedInEmail;
  late List<UserData> userDataList;
  late List<UserDetails> userDetails;

  List<UserData> searchedData = List.empty(growable: true);
  List<UserDetails> searchedDataDetails = List.empty(growable: true);

  SearchController searchController = SearchController();

  Future<void> getDataFromSharedPrefs() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userDataJson = sharedPreferences.getString("user_data");
    String? userDetailsJson = sharedPreferences.getString("user_details");
    Iterable userDataDecoder = jsonDecode(userDataJson!); 
    Iterable userDetailsDecoder = jsonDecode(userDetailsJson!);

    setState(() {
      userDataList = userDataDecoder.map((e) => UserData.fromJson(e)).toList();
      userDetails =  userDetailsDecoder.map((e) => UserDetails.fromJson(e)).toList(); 
    });
  }

  Future<Widget> getFriendStateWidget(int id) async{
    String friendStateString;
    FriendState friendState = await Provider.of<FriendServiceProvider>(context,listen: false).getFriendState(id);
    IconData ico;
    VoidCallback onPressed;
    switch(friendState){
      case FriendState.notFriend:
        friendStateString = "Add Friend";
        ico = Icons.group_add;
        onPressed = () => Provider.of<FriendServiceProvider>(context,listen: false).addFriend(id);
        break;

      case FriendState.friend:
        friendStateString = "Remove Friend";
        ico = Icons.group_off_outlined;
        onPressed = () => Provider.of<FriendServiceProvider>(context, listen: false).removeFriend(id);
        break;

      case FriendState.pending:
        friendStateString = "Pending";
        ico = Icons.access_time;
        onPressed= (){};
        break;
      case FriendState.requested:
        friendStateString = "Requested";
        ico = Icons.group;
        onPressed = () => Provider.of<FriendServiceProvider>(context).acceptRequest(id);
        break;
      case FriendState.isUser:
        return Container();
    }
    return OutlinedButton(onPressed: (){onPressed();setState(() {
      
    });},child: Row(children: [Icon(ico), Text(friendStateString)],));
  }

  Future<void> searchData(String value) async{
    setState(() { 
      searchedData = List.empty(growable: true);
      searchedDataDetails = List.empty(growable: true);
      searchedData = userDataList.where((element) => element.name == value).toList();
      for(var item in searchedData){
        var userDetail = userDetails.firstWhere((element) => element.id == item.id);
        searchedDataDetails.add(userDetail);
      }
     });

    List<FriendState> friendStates = List.empty(growable: true);
    for(var item in searchedData){
      FriendState friendState = await Provider.of<FriendServiceProvider>(context, listen: false).getFriendState(item.id);
      friendStates.add(friendState);
    }
  }

  Future<void> getLoggedInState() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() { 
      loggedInEmail = sharedPreferences.getString("loggedInEmail");
    });
  }

  @override
  void initState() {
    super.initState();
    getLoggedInState();
    getDataFromSharedPrefs();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Project"), centerTitle: true, backgroundColor: Colors.lightBlueAccent,),
      drawer: (loggedInEmail == null) ? MyDrawer() : const LoggedInDrawer(),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(children: [
            TextFormField(decoration: const InputDecoration(hintText: "Search..."), onFieldSubmitted: (value){
              searchData(value);
            },),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: searchedData.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => SizedBox(
                  height: 64,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/profileInfo/${searchedData.elementAt(index).id}');
                        },
                          child: Row(children: [
                            CircleAvatar(backgroundImage: FileImage(File(searchedDataDetails.elementAt(index).basicInfo.profileImage.imagePath), ),),
                            const SizedBox(width: 12,),
                            Text(searchedData.elementAt(index).name),
                            const SizedBox(height: 12,),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FutureBuilder(
                                future: getFriendStateWidget(searchedDataDetails.elementAt(index).id),
                                builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                                  if(snapshot.connectionState == ConnectionState.waiting){
                                    return const CircularProgressIndicator();
                                  }
                                  else if(snapshot.hasError){
                                    return Text('${snapshot.error}');
                                  }
                                  return snapshot.data ?? Container();
                                }
                              ))
                          ],),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
            // TextFormField(controller: searchController, decoration: InputDecoration(hintText: ), )
          ],),
        ),
      ),
    );
  }
}