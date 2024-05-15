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
     print(searchedData);
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
      drawer: (loggedInEmail == null) ? MyDrawer() : LoggedInDrawer(),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(children: [
            TextFormField(decoration: const InputDecoration(hintText: "Search..."), onFieldSubmitted: (value){
              searchData(value);
            },),

            // SearchAnchor(
            //   viewOnSubmitted: (value){
            //     searchData(value);
            //   },
            //   builder: ((BuildContext context, SearchController searchController )=>  
            // 
            // SearchBar(controller: searchController,
            // onTap: (){searchController.openView();}, )
            // ), 
            // suggestionsBuilder: (context, controller) => List<ListTile>.generate(searchedData.length, 
            // (int index){
            //   return ListTile(
            //     leading: Image.network(searchedDataDetails.elementAt(index).basicInfo.profileImage.imagePath),
            //     title: Text(searchedData.elementAt(index).name),);
            //   })),

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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: OutlinedButton(onPressed: (){}, child: const Text("Add Friend")))
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