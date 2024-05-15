import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPage extends StatefulWidget{
  const UserInfoPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserInfoPageState();
  }

}

class _UserInfoPageState extends State<UserInfoPage>{

  UserData? currentUser;
  UserDetails? currentUserDetails;

  Future<void> getDataFromSharedPrefs() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userDataString =  sharedPreferences.getString("user_data");
    String? userDetailsString = sharedPreferences.getString("user_details");
    String? loggedInEmail = sharedPreferences.getString("loggedInEmail");

    Iterable userDataDecoder = jsonDecode(userDataString!);
    Iterable userDetalsDecoder = jsonDecode(userDetailsString!);

    currentUser = userDataDecoder.map((e) => UserData.fromJson(e)).toList()
    .firstWhereOrNull((element) => element.id == loggedInEmail);
    
    currentUserDetails = userDetalsDecoder.map((e) => UserDetails.fromJson(e)).toList()
    .firstWhereOrNull((element) => element.id == currentUser?.id);
  }

  @override
  void initState() {
    super.initState();
    getDataFromSharedPrefs().then((value) => setState(() { 
    }));   
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(onPressed: (){Navigator.pushNamed(context, "/changePassword");}, icon: const Icon(Icons.settings))
        ],
      ),
      drawer: LoggedInDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Card(
              elevation: 5.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(alignment: Alignment.bottomLeft,
                    clipBehavior: Clip.antiAlias,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width - 40, height: 210, child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Image.file(File(currentUserDetails!.basicInfo.coverImage.imagePath)),
                        ),),
                       Padding(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                       child: Container(decoration: const BoxDecoration(border:  Border(
                        top: BorderSide(color: Colors.transparent, width: 1.5),
                        bottom: BorderSide(color: Colors.transparent, width: 1.5),
                        left: BorderSide(color: Colors.transparent, width: 1.5),
                        right: BorderSide(color: Colors.transparent, width: 1.5),
                       ),),
                       height: 120, width: 120, child: CircleAvatar(radius: 60, backgroundImage: FileImage(File(currentUserDetails!.basicInfo.profileImage.imagePath)),),
                       ),
                       )
                    ],),
                  ),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(currentUser!.name, style:const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),), 
              ),
              const SizedBox(height: 24,),
                ],
              ),
            ),
            const SizedBox(height: 20), 
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                children: [
                  const Text("About Me", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                  const SizedBox(height: 15,),
                  Text(currentUserDetails!.basicInfo.summary),
                  Row(
                    children: [const Text("Gender: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),), const SizedBox(width: 10,), Text(currentUserDetails!.basicInfo.gender)],
                    ),
                const SizedBox(height: 15,),
                Row(children: [const Text("Born On: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),), const SizedBox(width: 10,), Text(currentUserDetails!.basicInfo.dob)],),
                const SizedBox(height: 15,),
                ],),
              ),),
              const SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: [
                    Card(child: Padding(padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      const Text("Skills", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                      const SizedBox(height: 15,),
                      Wrap(children: currentUserDetails!.skills.map((e) => Card(child: Padding(padding: const EdgeInsets.all(8), child: Text(e.title),),)).toList(),),
                    ],),),),
                  Card(child: Padding(padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  const Text("Hobbies", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                  const SizedBox(height: 15,),
                  Wrap(children: currentUserDetails!.hobbies.map((e) => Card(child: Padding(padding: const EdgeInsets.all(8), child: Text(e.title),),)).toList(),),
                ],),),),
                Card(child: Padding(padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                  const Text("Languages", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                  const SizedBox(height: 15,),
                  Wrap(children: currentUserDetails!.languages.map((e) => Card(child: Padding(padding: const EdgeInsets.all(8), child: Text(e.title),),)).toList(),),
                ],),),)
                  ],
                ),
              ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Card(child: Padding(padding: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const Text("Education", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                    const SizedBox(height: 15,),
                    Column(
                    children: currentUserDetails!.educations.map((e) => Column(children: [
                      Text(e.organizationName), 
                      Text(e.level, style: const TextStyle(fontWeight: FontWeight.w100),), 
                      Text('${DateFormat("yMMM").format(e.startDate!)} - ${DateFormat("yMMM").format(e.endDate!)}')],)).toList()
                    )
                  ],),
                ),
                ),),
              ),
            ),
            Padding(padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Card(child: Padding(padding: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Workplace History", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),), 
                      const SizedBox(height: 15,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: currentUserDetails!.workExperiences.map((e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text(e.jobTitle),
                          Text(e.organizationName, maxLines: null,),
                          const SizedBox(height: 5,),
                          Text('Worked On: - ${e.summary}'),
                          const SizedBox(height: 5,),
                          Text('${DateFormat("yMMM").format(e.startDate!)} - ${DateFormat("yMMM").format(e.endDate!)}'),
                      ],)).toList(),),
                    ],
                  ),
                )
              ),),
              ),
            ),
            Padding(padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Card(child: Padding(padding: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  const Text("Contact Info", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                  const SizedBox(height: 15,),
                   Row(children: [const Text("Mobile No.", style: TextStyle(fontWeight: FontWeight.bold),), const  SizedBox(width: 5,),Text(currentUserDetails!.contactInfo.mobileNo)],),
                  const SizedBox(height: 5,),
                  Column(children: currentUserDetails!.contactInfo.socialMedias.map((e) =>
                   Row(
                     children: [
                       Image.network('https://logo.clearbit.com/${e.type}', height: 32, width: 32,),
                       const SizedBox(width: 10,),
                       Column(children: [
                        Text(e.title),
                        Text(e.url.split('/').last),
                        const SizedBox(height: 15,),           
                        ]),
                     ],
                   )).toList())
                ],),
              ),),),
            ),)
            ],),
        ),
      ),
    );
  }
}
