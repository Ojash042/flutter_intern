import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_states.dart';
import 'package:flutter_intern/project/bloc/user_list_bloc.dart';
import 'package:flutter_intern/project/bloc/user_list_states.dart';
import 'package:flutter_intern/project/bloc/user_post_bloc.dart';
import 'package:flutter_intern/project/bloc/user_post_event.dart';
import 'package:flutter_intern/project/bloc/user_post_states.dart';
import 'package:flutter_intern/project/locator.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;
import 'package:humanizer/humanizer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomThumbUpIcon extends StatelessWidget{
  const CustomThumbUpIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
      child: const Center(child: Icon(cupertino.CupertinoIcons.hand_thumbsup_fill, color: Colors.white, size: 14,),),
    );
  }  
}


class ProfileInfoPage extends StatefulWidget{
  final String id;
  ProfileInfoPage({super.key, required this.id});
  final GlobalKey<_ProfileInfoPageState> profileInfoKey = GlobalKey<_ProfileInfoPageState>();

@override
  State<StatefulWidget> createState() {
    return _ProfileInfoPageState(profileInfoKey);
  }
}
enum UserGender{male, female}

class PhotoGrid extends StatefulWidget {
  final int maxImages;
  final List<TModels.Image> images;
  final Function(int) onImageClicked;
  final Function onExpandClicked;

  PhotoGrid({required this.images, required this.onImageClicked, required this.onExpandClicked,
      this.maxImages = 4, super.key});

  @override
  createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  @override
  Widget build(BuildContext context) {
    var images = buildImages();

    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      children: images,
    );
  }

  List<Widget> buildImages() {
    int numImages = widget.images.length;
    return List<Widget>.generate(min(numImages, widget.maxImages), (index) {
      String imageUrl = widget.images[index].url;

      // If its the last image
      if (index == widget.maxImages - 1) {
        // Check how many more images are left
        int remaining = numImages - widget.maxImages;

        // If no more are remaining return a simple image widget
        if (remaining == 0) {

          return GestureDetector(
            child:  widget.images.elementAt(index).isNetworkUrl ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ):
            Image.file(File(imageUrl), fit: BoxFit.cover,),
            onTap: () => widget.onImageClicked(index),
          );
        } else {
          // Create the facebook like effect for the last image with number of remaining  images
          return GestureDetector(
            onTap: () => widget.onExpandClicked(),
            child: Stack(
              fit: StackFit.expand,
              children: [
                widget.images.elementAt(index).isNetworkUrl ? Image.network(imageUrl, fit: BoxFit.cover) : Image.file(File(imageUrl), fit: BoxFit.cover,),
                Positioned.fill(child: Container(alignment: Alignment.center, color: Colors.black54, child: 
                Text('+$remaining',style: const TextStyle(fontSize: 32),),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        return GestureDetector(
          child: widget.images.elementAt(index).isNetworkUrl ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ) : Image.file(File(imageUrl), fit: BoxFit.cover,),
          onTap: () => widget.onImageClicked(index),
        );
      }
    });
  }
}

class _ProfileInfoPageState extends State<ProfileInfoPage>{

  GlobalKey<_ProfileInfoPageState> profileInfoKey = GlobalKey<_ProfileInfoPageState>();
  _ProfileInfoPageState(profileInfoKey);
  UserData? currentUser;
  UserDetails? currentUserDetails;
  late List<UserData> userDataList;
  late List<UserDetails> userDetailsList;
  bool isEditMode = false;
  List<TModels.UserPost> userPosts = List.empty(growable: true);
  List<Widget> action = [];
  void saveData(List<UserDetails> userDetailsList) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() { 
      String? encodedString = jsonEncode(userDetailsList.map((e) => e.toJson()).toList()); 
      sharedPreferences.setString("user_details", encodedString);
    });
    
  }

  String getPrefixText(List<TModels.PostLikedBy> postLikedBy){
    return postLikedBy.isEmpty ?  "No one liked this" : postLikedBy.length==1 ? "1 person liked this." : '${postLikedBy.length} people liked this.';
  } 


  Widget showEditBasicInfoModal(List<UserDetails> userDetailsList, int currentUserId){
    var currentUserDetails = userDetailsList.firstWhere((element) => element.id == currentUserId);
    TextEditingController summaryController = TextEditingController();
    summaryController.text = currentUserDetails.basicInfo.summary;
    UserGender? _gender = UserGender.male;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StatefulBuilder(
          builder: (context, StateSetter setState) {
            return SingleChildScrollView(
              child: Center(
                child: Form(child: 
                    Column(children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.cancel))),
                        const SizedBox(height: 30,),
                        Text("Edit Basic Info", style: Theme.of(context).textTheme.headlineMedium,),
                        const SizedBox(height: 30,),
                        TextFormField(
                        controller: summaryController,
                        decoration: InputDecoration(labelText: currentUserDetails.basicInfo.summary,hintText: "Enter summary"),
                        //initialValue: currentUserDetails.basicInfo.summary,
                        ),
                        const SizedBox(height: 30,),
                        Text("Gender", style: Theme.of(context).textTheme.headlineSmall,),
                        RadioListTile(value: UserGender.male, groupValue: _gender, title: const Text("Male"), onChanged: (UserGender? value) {
                    setState((){
                      currentUserDetails.basicInfo.gender = "Male";
                      _gender = value; 
                    });
                    }),
                  RadioListTile(value: UserGender.female, title: const Text("Female"), groupValue: _gender, onChanged: (UserGender? value){
                  setState((){
                    currentUserDetails.basicInfo.gender = "Female";
                    _gender = value; 
                    });
                  }), 
                  const SizedBox(height: 30,),
                  OutlinedButton(onPressed: (){
                    currentUserDetails.basicInfo.summary = summaryController.text;
                    saveData(userDetailsList);
                    Navigator.of(context).pop();
                    }, child: const Text("Submit"))
                    ],)
                ,),
              ),
            );
          }
        ),
      )
    );
  }

  Widget showEditSkillsModal(List<UserDetails> userDetailsList, int currentUserId){
    var currentUserDetails = userDetailsList.firstWhere((element) => element.id == currentUserId);
    TextEditingController skillController = TextEditingController();
    return Scaffold(
      body: StatefulBuilder(
        builder: (context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Center(child: 
              Form(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.cancel))),
                  const SizedBox(height: 30,),
                  Text("Skills", style: Theme.of(context).textTheme.headlineMedium,),
                  Wrap(children: currentUserDetails.skills.map((e) => Card(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e.title!),
                  ),)).toList(),),
                  const SizedBox(height: 30,),
                  TextFormField(
                    controller: skillController,
                    decoration: const InputDecoration(hintText: "Enter skills"), onFieldSubmitted: (value){
                      setState(() {
                       Skills skills = Skills();
                      skills.id = Random().nextInt(10000) + 1000;
                      skills.title = value;
                      currentUserDetails.skills.add(skills);
                      skillController.clear();
                      });
                                  },),
                  const SizedBox(height: 30,),
                  OutlinedButton(onPressed: (){
                    saveData(userDetailsList);
                    Navigator.of(context).pop();
                  }, child: const Text("Submit")),
                ],
              ),)),
            ),
          );
        }
      ),
    );
  }

  Widget showEditHobbiesModal(List<UserDetails> userDetailsList, int currentUserId){
    var currentUserDetails = userDetailsList.firstWhere((element) => element.id == currentUserId);
    TextEditingController hobbiesController = TextEditingController();
    return Scaffold(
      body: StatefulBuilder(
        builder: (context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Center(child: 
              Form(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.cancel))),
                  const SizedBox(height: 30,),
                  Text("Hobbies", style: Theme.of(context).textTheme.headlineMedium,),
                  Wrap(children: currentUserDetails.hobbies.map((e) => Card(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e.title),
                  ),)).toList(),),
                  const SizedBox(height: 30,),
                  TextFormField(
                    controller: hobbiesController,
                    decoration: const InputDecoration(hintText: "Enter hobbies"), onFieldSubmitted: (value){
                      setState(() {
                       Hobbies hobbies = Hobbies();
                      hobbies.id = Random().nextInt(10000) + 1000;
                      hobbies.title = value;
                      currentUserDetails.hobbies.add(hobbies);
                      hobbiesController.clear();
                      });},),
                  const SizedBox(height: 30,),
                  OutlinedButton(onPressed: (){
                    saveData(userDetailsList);
                  Navigator.of(context).pop();
                  }, child: const Text("Submit")),
                ],
              ),)),
            ),
          );
        }
      ),
    );
  }

  Widget showEditLanguagesModal(List<UserDetails> userDetailsList, int currentUserId){
    var currentUserDetails = userDetailsList.firstWhere((element) => element.id == currentUserId);
    TextEditingController languageController = TextEditingController();
    return Scaffold(
      body: StatefulBuilder(
        builder: (context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Center(child: 
              Form(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.cancel))),
                  const SizedBox(height: 30,),
                  Text("Languages", style: Theme.of(context).textTheme.headlineMedium,),
                  Wrap(children: currentUserDetails.languages.map((e) => Card(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e.title),
                  ),)).toList(),),
                  const SizedBox(height: 30,),
                  TextFormField(
                    controller: languageController,
                    decoration: const InputDecoration(hintText: "Enter languages"), onFieldSubmitted: (value){
                      setState(() {
                        Languages language = Languages();
                        language.id = Random().nextInt(10000) + 1000;
                        language.title = value;
                        currentUserDetails.languages.add(language);
                        languageController.clear();
                      });},),
                  const SizedBox(height: 30,),
                  OutlinedButton(onPressed: (){
                    saveData(userDetailsList);
                  Navigator.of(context).pop();
                  }, child: const Text("Submit")),
                ],
              ),)),
            ),
          );
        }
      ),
    );
  }

  Widget showEditEducationModal(List<UserDetails> userDetailsList, int currentUserId){
    UserDetails currentUser = userDetailsList.firstWhere((element) => element.id == currentUserId);

    List<TextEditingController> levelControllers = List.generate(currentUser.educations.length, (index) => TextEditingController());
    List<TextEditingController> summaryControllers = List.generate(currentUser.educations.length, (index) => TextEditingController());
    List<TextEditingController> organizationNameControllers = List.generate(currentUser.educations.length, (index) => TextEditingController());

    List<List<TextEditingController>> achievementTitleControllerMatrix = List.generate(currentUser.educations.length, (index) => List.generate(currentUser.educations.elementAt(index).accomplishments.length, (i) => TextEditingController()));
    List<List<TextEditingController>> achievementDescriptionControllerMatrix = List.generate(currentUser.educations.length, (index) => List.generate(currentUser.educations.elementAt(index).accomplishments.length, (i) => TextEditingController()));


    for(int i=0; i<currentUser.educations.length; i++){
      levelControllers.elementAt(i).text = currentUserDetails!.educations.elementAt(i).level;
      summaryControllers.elementAt(i).text = currentUserDetails!.educations.elementAt(i).summary;
      organizationNameControllers.elementAt(i).text = currentUserDetails!.educations.elementAt(i).organizationName ?? "";

      for(int j=0; j<currentUser.educations.elementAt(i).accomplishments.length; j++){
        achievementTitleControllerMatrix.elementAt(i).elementAt(j).text = currentUser.educations.elementAt(i).accomplishments.elementAt(j).title;
        achievementDescriptionControllerMatrix.elementAt(i).elementAt(j).text = currentUser.educations.elementAt(i).accomplishments.elementAt(j).description;
      }  
    }

    return Scaffold(
      body: StatefulBuilder(builder: (context, setState) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(child: Form(child: Column(
            children: [
              const SizedBox(height: 30,),
              Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.cancel), onPressed: (){Navigator.pop(context);},),),
              const SizedBox(height: 60,),
              Text("Educational History", style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: 30,),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: levelControllers.length,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                 Column(
                  children: [
                    const SizedBox(height: 30,),
                    TextFormField(decoration: const InputDecoration(hintText: "Enter level",), controller: levelControllers.elementAt(index),),
                    const SizedBox(height: 30,),
                    TextFormField(decoration: const InputDecoration(hintText: "Enter summary",), controller: summaryControllers.elementAt(index),),
                    const SizedBox(height: 30,),
                    TextFormField(decoration: const InputDecoration(hintText: "Enter organization name"), controller: organizationNameControllers.elementAt(index),),
                    const SizedBox(height: 30,),
                    TextFormField(decoration: InputDecoration(icon: const Icon(Icons.calendar_month), label: Text((currentUserDetails!.educations.elementAt(index).startDate == null)? "Enter the starting date here":
                    DateFormat("yyyy-MM-dd").format(currentUserDetails!.educations.elementAt(index).startDate!)
                    ),),
                    readOnly: true,
                    onTap: () async{
                      DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2030), initialDate: DateTime.now());
                      setState((){
                        if(pickedDate != null){
                          currentUserDetails!.educations.elementAt(index).startDate = pickedDate;
                        }
                      });
                    },),
                    TextFormField(decoration: InputDecoration(icon: const Icon(Icons.calendar_month), label: Text((currentUserDetails!.educations.elementAt(index).endDate == null)? "Enter the end date here":
                    DateFormat("yyyy-MM-dd").format(currentUserDetails!.educations.elementAt(index).endDate!)
                    ),),
                    readOnly: true,
                    onTap: () async{
                      DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2030), initialDate: DateTime.now());
                      setState((){
                        if(pickedDate != null){
                          currentUserDetails!.educations.elementAt(index).endDate = pickedDate;
                        }
                      });
                    },),

                    const SizedBox(height: 10,),
                    Text("Achievement", style: Theme.of(context).textTheme.headlineSmall,), 
                    const SizedBox(height: 10,),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: achievementTitleControllerMatrix.elementAt(index).length,
                      itemBuilder: (context, indexJ) => Column(children: [
                        const SizedBox(height: 10,),
                        TextFormField(decoration: const InputDecoration(hintText: "Achievement Title"), controller: achievementTitleControllerMatrix.elementAt(index).elementAt(indexJ),),
                        const SizedBox(height: 10,),
                        TextFormField(decoration: const InputDecoration(hintText: "Achievement Description"),controller: achievementDescriptionControllerMatrix.elementAt(index).elementAt(indexJ),),
                        const SizedBox(height: 10,),
                        TextFormField(decoration: InputDecoration(icon: const Icon(Icons.calendar_month), label: Text((currentUserDetails!.educations.elementAt(index).accomplishments.elementAt(indexJ).dateTime == null)? "Enter the starting date here":
                          DateFormat("yyyy-MM-dd").format(currentUserDetails!.educations.elementAt(index).accomplishments.elementAt(indexJ).dateTime!)
                          ),),
                          readOnly: true,
                          onTap: () async{
                              DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2030), initialDate: DateTime.now());
                              setState((){
                              if(pickedDate != null){
                                  currentUserDetails!.educations.elementAt(index).accomplishments.elementAt(indexJ).dateTime = pickedDate;
                          }
                      });
                    },),
                  ],)),
                        TextButton(onPressed: () => 
                          setState((){
                            TextEditingController achievementTitleController = TextEditingController();
                            TextEditingController achievementDescriptionController = TextEditingController();
                            achievementTitleControllerMatrix.elementAt(index).add(achievementTitleController);
                            achievementDescriptionControllerMatrix.elementAt(index).add(achievementDescriptionController);
                            Accomplishment accomplishment = Accomplishment();
                            accomplishment.dateTime = null;
                            accomplishment.id = Random().nextInt(10000) +1000;
                            currentUserDetails!.educations.elementAt(index).accomplishments.add(accomplishment);
                          }), child: const Text("Add achievements")),
                  ],
                 )),
                TextButton(
                 child: const Text("Add more education"),
                  onPressed: () =>
                  setState((){
                    TextEditingController levelController = TextEditingController();
                    TextEditingController summaryController = TextEditingController();
                    TextEditingController organizationController = TextEditingController();
                    
                    levelControllers.add(levelController);
                    summaryControllers.add(summaryController);
                    organizationNameControllers.add(organizationController);
                    
                    Education education = Education();
                    education.id = Random().nextInt(10000)+1000;

                    education.endDate =null;
                    education.startDate = null;
                    education.organizationName = "";
                    education.level = "";
                    education.summary ="";
                    List<Accomplishment> accomplishment = List.empty(growable: true);
                    education.accomplishments = accomplishment;
                    achievementTitleControllerMatrix.add([]);
                    achievementDescriptionControllerMatrix.add([]);
                    currentUserDetails!.educations.add(education);

                    WidgetsBinding.instance.addPostFrameCallback((_) => setState((){}));
                  })
                ,),
              const SizedBox(height: 30,),
              OutlinedButton(onPressed: (){
                setState((){
                  for(int i=0; i<currentUser.educations.length; i++){
                    currentUser.educations.elementAt(i).level = levelControllers.elementAt(i).text;
                    currentUser.educations.elementAt(i).organizationName = organizationNameControllers.elementAt(i).text;
                    currentUser.educations.elementAt(i).summary = summaryControllers.elementAt(i).text;
                    for(int j=0; j<currentUser.educations.elementAt(i).accomplishments.length; j++){
                      currentUser.educations.elementAt(i).accomplishments.elementAt(j).title = achievementTitleControllerMatrix.elementAt(i).elementAt(j).text;
                      currentUser.educations.elementAt(i).accomplishments.elementAt(j).description = achievementDescriptionControllerMatrix.elementAt(i).elementAt(j).text;
                    }
                  }
                });
                saveData(userDetailsList);
                Navigator.of(context).pop();
              }, child: const Text("Submit")),
            ],
          ),),),
        ),
      )),);
  }

  Widget showEditWorkPlaceHistory(List<UserDetails> userDetailsList, int currentUserId){
    UserDetails currentUserDetails = userDetailsList.firstWhere((element) => element.id == currentUserId,);
    List<TextEditingController> jobTitleController = List.generate(growable: true, currentUserDetails.workExperiences.length, (index) => TextEditingController());
    List<TextEditingController> summaryController = List.generate(growable: true, currentUserDetails.workExperiences.length, (index) => TextEditingController());
    List<TextEditingController> organizationController = List.generate(growable: true, currentUserDetails.workExperiences.length, (index) => TextEditingController());
    List<TextEditingController> startDateController = List.generate(growable: true, currentUserDetails.workExperiences.length, (index) => TextEditingController());
    List<TextEditingController> endDateController = List.generate(growable: true, currentUserDetails.workExperiences.length, (index) => TextEditingController());

    for(int index=0; index< currentUserDetails.workExperiences.length; index++){
      jobTitleController.elementAt(index).text = currentUserDetails.workExperiences.elementAt(index).jobTitle;
      summaryController.elementAt(index).text = currentUserDetails.workExperiences.elementAt(index).summary;
      organizationController.elementAt(index).text = currentUserDetails.workExperiences.elementAt(index).organizationName; 
   }
    
    return Scaffold(
      body: StatefulBuilder(builder: (context, setState) => 
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(child: Form(child: Column(
            children: [
              const SizedBox(height: 30,),
              Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.cancel), onPressed: () => Navigator.of(context).pop(),),),
              const SizedBox(height: 30,),
              Text("Workplace History", style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: 30,),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: jobTitleController.length,
                itemBuilder: (context, index) => 
                Column(children: [
                  TextFormField(decoration: const InputDecoration(hintText: "Enter job Title"), controller: jobTitleController.elementAt(index),),
                  const SizedBox(height: 30,),
                  TextFormField(decoration: const InputDecoration(hintText: "Enter Features worked on"), controller: summaryController.elementAt(index),),
                  const SizedBox(height: 30,),
                  TextFormField(decoration: const InputDecoration(hintText: "Enter Organization Name"), controller: organizationController.elementAt(index),),
                  const SizedBox(height: 30,),
                  TextFormField(decoration: InputDecoration(icon: const Icon(Icons.calendar_month), label: Text((currentUserDetails.workExperiences.elementAt(index).startDate == null)? "Enter the starting date here":
                  DateFormat("yyyy-MM-dd").format(currentUserDetails.workExperiences.elementAt(index).startDate!)
                  ),),
                  readOnly: true,
                  onTap: () async{
                    DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2030), initialDate: DateTime.now());
                    setState((){
                      if(pickedDate != null){
                        currentUserDetails.workExperiences.elementAt(index).startDate = pickedDate;
                      }
                    });
                  },),
                  TextFormField(decoration: InputDecoration(icon: const Icon(Icons.calendar_month), label: Text((currentUserDetails.workExperiences.elementAt(index).endDate == null)? "Enter the end date here":
                  DateFormat("yyyy-MM-dd").format(currentUserDetails.workExperiences.elementAt(index).endDate!)
                  ),),
                  readOnly: true,
                  onTap: () async{
                    DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2030), initialDate: DateTime.now());
                    setState((){
                      if(pickedDate != null){
                        currentUserDetails.workExperiences.elementAt(index).endDate = pickedDate;
                      }
                    });
                  },),
                  const SizedBox(height: 30,)
                  ],)
                ,),
                TextButton(onPressed: (){
                  setState((){
                    TextEditingController jobTitleControls = TextEditingController();
                    TextEditingController summaryControls = TextEditingController();
                    TextEditingController organizationContols = TextEditingController();
          
                    jobTitleController.add(jobTitleControls);
                    summaryController.add(summaryControls);
                    organizationController.add(organizationContols);
                    
                    WorkExperiences workExperience = WorkExperiences();
                    workExperience.startDate = null;
                    workExperience.endDate = null;
                    workExperience.id = Random().nextInt(10000) + 1000;
                    currentUserDetails.workExperiences.add(workExperience);
                  });  
                }, child: const Text("Add More")),
              const SizedBox(height: 60,),
              OutlinedButton(onPressed: (){
                for(int index = 0; index < currentUserDetails.workExperiences.length; index++){
                  currentUserDetails.workExperiences.elementAt(index).jobTitle = jobTitleController.elementAt(index).text;
                  currentUserDetails.workExperiences.elementAt(index).summary = summaryController.elementAt(index).text;
                  currentUserDetails.workExperiences.elementAt(index).organizationName = organizationController.elementAt(index).text;
                } 
                saveData(userDetailsList); 
                Navigator.of(context).pop();
              }, child: const Text("Submit")),
            ],
          ),),),
        ),),),
    );
  }

  Widget showEditContactInfoModal(List<UserDetails> userDetailsList, int currentUserId){
    var currentUserDetails = userDetailsList.firstWhere((e)=>e.id == currentUserId);
    RegExp phoneNoRegex = RegExp(r'^98\d{8}$');
    TextEditingController mobileNoController = TextEditingController();
    List<TextEditingController> socialMediaTypeController = List.generate(growable: true, currentUserDetails.contactInfo.socialMedias.length, (index) => TextEditingController());
    List<TextEditingController> socialMediaUrlController = List.generate(growable: true, currentUserDetails.contactInfo.socialMedias.length, (index) => TextEditingController());
    List<TextEditingController> socialMediaTitleController = List.generate(growable: true, currentUserDetails.contactInfo.socialMedias.length, (index) => TextEditingController());
    mobileNoController.text = currentUserDetails.contactInfo.mobileNo!;

    for(int i=0; i< currentUserDetails.contactInfo.socialMedias.length; i++){
      socialMediaTitleController.elementAt(i).text = currentUserDetails.contactInfo.socialMedias.elementAt(i).title;      
      socialMediaUrlController.elementAt(i).text = currentUserDetails.contactInfo.socialMedias.elementAt(i).url;
      socialMediaTypeController.elementAt(i).text = currentUserDetails.contactInfo.socialMedias.elementAt(i).type;
    }

    return Scaffold(
      body: StatefulBuilder(builder: (context, StateSetter setState) => 
      SingleChildScrollView(child: 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child:
           Form(child:Column(
            children: [
              const SizedBox(height: 30,),
              Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.cancel), onPressed: (){Navigator.pop(context);},),),
              const SizedBox(height: 30,),
              Text("Contact Info", style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: 60,),
              TextFormField(decoration: const InputDecoration(
                hintText: "Enter mobile no."), controller: mobileNoController, 
                validator: (value)=> phoneNoRegex.hasMatch(value!)? null :"Invalid Phone No." ,),
              const SizedBox(height: 30,),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: socialMediaTitleController.length,
                itemBuilder: (context, index) => 
                Column(children: [
                  TextFormField(decoration: const InputDecoration(hintText: "Enter Social Media Title"), controller: socialMediaTitleController.elementAt(index),),
                  const SizedBox(height: 10,),
                  TextFormField(decoration: const InputDecoration(hintText: "Enter Social Media Url"), controller: socialMediaUrlController.elementAt(index),),
                  const SizedBox(height: 10,),
                  TextFormField(decoration: const InputDecoration(hintText:"Enter Social Media Type" ), controller: socialMediaTypeController.elementAt(index),),
                  const SizedBox(height: 20,),
                ],)
                ),
              TextButton(onPressed: (){
                setState((){
                  TextEditingController titleController = TextEditingController();
                  TextEditingController urlController = TextEditingController();
                  TextEditingController typeController = TextEditingController();
                  socialMediaTitleController.add(titleController);
                  socialMediaUrlController.add(urlController);
                  socialMediaTypeController.add(typeController); 
                });                 
              }, child: const Text("Add More")),
              const SizedBox(height: 30,),
              OutlinedButton(onPressed: (){
              currentUserDetails.contactInfo = currentUserDetails.contactInfo.copyWith(mobileNoController.text, null);
                for(int i=0; i< socialMediaTitleController.length - currentUserDetails.contactInfo.socialMedias.length; i++){
                  SocialMedia sm = SocialMedia();
                  sm.id = Random().nextInt(10000) + 1000;
                  sm.title = "";
                  sm.type = "";
                  sm.url = "";
                  currentUserDetails.contactInfo.socialMedias.add(sm);
                }
                for (int i=0; i<currentUserDetails.contactInfo.socialMedias.length; i++){
                  currentUserDetails.contactInfo.socialMedias.elementAt(i).title = socialMediaTitleController.elementAt(i).text;
                  currentUserDetails.contactInfo.socialMedias.elementAt(i).url = socialMediaUrlController.elementAt(i).text;
                  currentUserDetails.contactInfo.socialMedias.elementAt(i).type = socialMediaTypeController.elementAt(i).text;
                }
                saveData(userDetailsList);
                setState((){});
                Navigator.of(context).pop();
                }, child: const Text("Submit")),
            ],
           ),),),
      ),
      ),),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //getDataFromSharedPrefs().then((value) => setState(() { }));
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() { 
      });
    });
  }

  @override
  void didUpdateWidget(covariant ProfileInfoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    //getDataFromSharedPrefs().then((value) => setState(() { }));
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
        
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
    setState(() {});
      //getDataFromSharedPrefs().then((value) => setState(() {  }));
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
      IconButton  todoButton = IconButton(onPressed: (){Navigator.of(context).pushNamed('/todos');}, icon: const Icon(Icons.check_box_outlined));
      action.add(todoButton);
      });
    });
    }); 
  }
  Future<void> pressedLikeOperation(int postId) async{
      int userId  = context.read<AuthBloc>().state.userData!.id;
      context.read<UserPostBloc>().add(UserPostLikePostEvent(postId: postId, userId: userId));
    }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
        builder: (context, authState) {
          return BlocBuilder<UserPostBloc, UserPostStates>(
            builder: (context, userPostState) {
              int userId  = context.read<AuthBloc>().state.userData!.id;
              userPosts = mounted ? context.read<UserPostBloc>().state.userPosts!.where((element) => element.userId == userId).toList() : List.empty(growable: true); 
              return (BlocBuilder<UserListBloc, UserListStates>(
                builder: (context, state) {
                  currentUser = state.userDataList!.firstWhere((e) => e.id == BlocProvider.of<AuthBloc>(context).state.userData!.id);
                  currentUserDetails = state.userDetailsList!.firstWhere((e) => e.id == BlocProvider.of<AuthBloc>(context).state.userDetails!.id);
                  bool isCurrentUserLoggedInUser = BlocProvider.of<AuthBloc>(context).state.userData!.id == int.parse(widget.id);
                  return Scaffold(
                    appBar: CommonAppBar(actions: action,),
                              bottomNavigationBar: const CommonNavigationBar(),
                              // drawer: const LoggedInDrawer(),
                              body: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Card(
                                      shape: const LinearBorder(),
                                        color:  Colors.white,
                                        elevation: 0,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Stack(alignment: Alignment.bottomLeft,
                                              clipBehavior: Clip.antiAlias,
                                              children: [
                                                SizedBox(width: MediaQuery.of(context).size.width - 40, height: 210, child: Padding(
                                                  padding: const EdgeInsets.all(16),
                                                  child: Image.file(File(currentUserDetails!.basicInfo.coverImage.imagePath), fit: BoxFit.fill,),
                                                  ),),
                                                 Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                                                 child: Center(
                                                   child: Container(decoration: const BoxDecoration(border:  Border(
                                                    top: BorderSide(color: Colors.transparent, width: 1.5),
                                                    bottom: BorderSide(color: Colors.transparent, width: 1.5),
                                                    left: BorderSide(color: Colors.transparent, width: 1.5),
                                                    right: BorderSide(color: Colors.transparent, width: 1.5),
                                                   ),),
                                                   height: 120, width: 120, 
                                                   child: CircleAvatar(backgroundColor: Colors.white, radius: 0,child: CircleAvatar(radius: 55, backgroundImage: FileImage(File(currentUserDetails!.basicInfo.profileImage.imagePath)))),
                                                   ),
                                                 ),
                                                 )
                                              ],),
                                            ),
                                          const SizedBox(height: 10,),
                                          Padding( padding: const EdgeInsets.symmetric(horizontal: 32),
                                          child: Center(child: Text(currentUser!.name, style:const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),)), 
                                        ),
                                        const SizedBox(height: 10,),
                                        Center(child: Text(currentUserDetails!.basicInfo.summary)),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(children: [currentUserDetails!.basicInfo.gender == "Male"? const Icon(Icons.male_outlined) : const Icon(Icons.female_outlined), const SizedBox(width: 10,), Text(currentUserDetails!.basicInfo.gender)],),
                                        ),
                                        const SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(children: [const Icon(Icons.cake_outlined), const SizedBox(width: 10,), Text(currentUserDetails!.basicInfo.dob)],),
                                        ),
                                        const SizedBox(height: 24,),
                                        Center(child: isCurrentUserLoggedInUser? FilledButton(onPressed: (){
                                          Navigator.of(context).pushNamed('/editDetails');
                                        }, 
                                        style: ButtonStyle(
                                        fixedSize: WidgetStatePropertyAll(Size.fromWidth(MediaQuery.of(context).size.width * 0.35)),
                                        shape: const WidgetStatePropertyAll(LinearBorder()),
                                          iconColor: WidgetStatePropertyAll(isEditMode ? Colors.blueAccent: Colors.white),
                                          backgroundColor:  WidgetStatePropertyAll(isEditMode ? Colors.grey[100] :Colors.blueAccent) ),
                                        child: Row(
                                          children: [
                                            Icon(isEditMode? Icons.check_outlined: Icons.edit_outlined),
                                            SizedBox(width: MediaQuery.of(context).size.width * 0.07,),
                                            Text(isEditMode ? "Done": "Edit", style: TextStyle(color: isEditMode ? Colors.blueAccent: Colors.white ,)),
                                          ],
                                        ),) : 
                                        Container(),
                                        ),
                                          const SizedBox(height: 20,),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: userPosts.length,
                                            itemBuilder: (context, index){
                              var e = userPosts.elementAt(index);
                              return SizedBox(width: MediaQuery.of(context).size.width,
                              child: Card(
                                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                color: Colors.white,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 14.0, top: 5.0),
                                                      child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const SizedBox(height: 10,),
                                                          GestureDetector(
                                                            onTap: ()=> Navigator.pushNamed(context, '/profileInfo/${e.userId}'),
                                                            child: Row(
                                                              children: [
                                                                CircleAvatar(backgroundImage: FileImage(File(authState.userDetails!.basicInfo.profileImage.imagePath)),),
                                                                const SizedBox(width: 10,),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(authState.userData!.name, 
                                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: /* Color(0xffabb5ff) */ Colors.black),),
                                                                    Text(
                                                                      const ApproximateTimeTransformation(granularity: Granularity.primaryUnit, round: true, isRelativeToNow: true)
                                                                      .transform(Duration(microseconds: DateTime.parse(e.createdAt).microsecondsSinceEpoch - DateTime.now().microsecondsSinceEpoch), 'en')
                                                                    )
                                                                  ],
                                                                ), 
                                                              ],
                                                            )),
                                                          //Center(child: SizedBox(width: MediaQuery.of(context).size.width * 0.7 ,child: const Divider())),
                                                          const SizedBox(height: 10,),
                                                          Text(e.title, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
                                                          const SizedBox(height: 5,),
                                                          SizedBox(
                                                            height: 300 * min(4, e.images.length.toDouble()) / 3,
                                                            width: MediaQuery.of(context).size.height - 40,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: PhotoGrid(images: e.images, onImageClicked: (idx){}, onExpandClicked: (){},),
                                                            )),
                                                            const SizedBox(height: 10,),
                                                            Row(children: [
                                                              Stack(children: [
                                                                Container(padding: const EdgeInsets.only(left: 14), child: const Icon(cupertino.CupertinoIcons.heart_circle_fill, color: Colors.pinkAccent, size: 22,)),
                                                                const CustomThumbUpIcon(),
                                                              ],),
                                                              const SizedBox(width: 10,), 
                                                              Text(getPrefixText(e.postLikedBys), style: const TextStyle(fontWeight: FontWeight.w300) ,),
                                                            ],),
                                                            const Divider(thickness: 0.5,),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                              Row(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      IconButton(onPressed: (){
                                                                      if(!authState.loggedInState){
                                                                        return;
                                                                      }
                                                                      pressedLikeOperation(e.postId);
                                                                      }, 
                                                                      icon: (authState is AuthorizedAuthState && e.postLikedBys.map((e) => e.userId).toList().contains(authState.userData!.id)) ? 
                                                                      const Icon(cupertino.CupertinoIcons.hand_thumbsup_fill, color: Colors.blueAccent,) :const Icon(cupertino.CupertinoIcons.hand_thumbsup, color: Colors.grey,),),
                                                                      const Text("Like")
                                                                    ],
                                                                  ) 
                                                                ],
                                                              ),
                                                           Row(
                                                             children: [
                                                               IconButton(onPressed: (){}, icon: const Icon(cupertino.CupertinoIcons.bubble_right, color: Colors.grey,)),
                                                               const Text("Comment"),
                                                             ],
                                                           ),
                                                           Row(
                                                             children: [
                                                               IconButton(onPressed: (){}, icon: const Icon(cupertino.CupertinoIcons.share_up, color: Colors.grey,)),
                                                               const Text("Share"),
                                                             ],
                                                           ),
                                                        ],),
                                                        const SizedBox(height: 10,)
                                                        ],),
                                                    ),
                                                  ));
                                            }),
                                    // isEditMode ? Card(
                                    //   shape: const LinearBorder(),
                                    //   elevation: 0,
                                    //   color: Colors.white,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(16.0),
                                    //     child: Column(
                                    //     children: [
                                    //       isCurrentUserLoggedInUser && isEditMode?
                                    //       Align(alignment: Alignment.topRight,
                                    //       child: IconButton(icon: const Icon(Icons.edit),onPressed: (){showDialog(context: context, builder: (context) => showEditBasicInfoModal(userDetailsList, currentUser!.id));},),):
                                    //       Container(), 
                                    //       const Text("About Me", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                                    //       const SizedBox(height: 15,),
                                    //       Text(currentUserDetails!.basicInfo.summary),
                                    //       Row(
                                    //         children: [const Text("Gender: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),), const SizedBox(width: 10,), Text(currentUserDetails!.basicInfo.gender)],
                                    //       ),
                                    //     const SizedBox(height: 15,),
                                    //     Row(children: [const Text("Born On: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),), const SizedBox(width: 10,), Text(currentUserDetails!.basicInfo.dob)],),
                                    //     const SizedBox(height: 15,),
                                    //     ],),
                                    //   ),) : Container(),
                                      // Wrap(
                                      //   children: [
                                      //     SizedBox(
                                      //     width: MediaQuery.of(context).size.width,
                                      //       child: Card(
                                      //         elevation: 0,
                                      //         shape: const LinearBorder(),
                                      //         color: Colors.white,
                                      //         child: Padding(padding: const EdgeInsets.all(16.0),
                                      //       child: Column(children: [
                                      //         isCurrentUserLoggedInUser && isEditMode?
                                      //         Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.edit), onPressed: (){showDialog(context: context, builder: (context) => showEditSkillsModal(userDetailsList, currentUser!.id));},),):
                                      //         Container(),
                                      //         const Text("Skills", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                                      //         const SizedBox(height: 15,),
                                      //         Wrap(
                                      //           children: currentUserDetails!.skills.map((e) => Card(
                                      //           shape: BeveledRectangleBorder(borderRadius:const BorderRadius.all(Radius.circular(2.0),), side: BorderSide(width: 0.4, color: Colors.grey[100]!)),
                                      //           elevation: 0,
                                      //           child: Padding(padding: const EdgeInsets.all(8), child: Text(e.title!),),)).toList(),),
                                      //       ],),),),
                                      //     ),
                                      //   SizedBox(
                                      //   width: MediaQuery.of(context).size.width,
                                      //     child: Card(
                                      //       shape: const LinearBorder(),
                                      //       elevation: 0,
                                      //       color: Colors.white,
                                      //       child: Padding(padding: const EdgeInsets.all(16.0),
                                      //                   child: Column(children: [
                                      //     isCurrentUserLoggedInUser && isEditMode?
                                      //     Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.edit), onPressed: (){showDialog(context: context, builder: (context) => showEditHobbiesModal(userDetailsList, currentUser!.id));},),):
                                      //     Container(),
                                      //     const Text("Hobbies", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                                      //     const SizedBox(height: 15,),
                                      //     Wrap(
                                      //       children: currentUserDetails!.hobbies.map((e) => Card(
                                      //       shape: BeveledRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(2.0)), side: BorderSide(width: 0.4, color: Colors.grey[100]!)),
                                      //       elevation: 0,
                                      //       child: Padding(padding: const EdgeInsets.all(8), child: Text(e.title),),)).toList(),),
                                      //                   ],),),),
                                      //   ),
                                      // SizedBox(
                                      //   width: MediaQuery.of(context).size.width,
                                      //   child: Card(
                                      //   color: Colors.white,
                                      //   elevation: 0,
                                      //   shape: const LinearBorder(),
                                      //     child: Padding(padding: const EdgeInsets.all(16.0),
                                      //     child: Column(children: [
                                      //     isCurrentUserLoggedInUser && isEditMode?
                                      //     Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.edit), onPressed: (){showDialog(context: context, builder: (context) => showEditLanguagesModal(userDetailsList, currentUser!.id));},),)
                                      //     : Container(),
                                      //     const Text("Languages", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                                      //     const SizedBox(height: 15,),
                                      //     Wrap(children: currentUserDetails!.languages.map((e) => Card(
                                      //       shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
                                      //       elevation: 0,
                                      //       child: Padding(
                                      //         padding: const EdgeInsets.all(8),
                                      //         child: Text(e.title),),)).toList(),),
                                      //   ],),),),
                                      // )
                                      //   ],
                                      // ),
                                    // const SizedBox(height: 20,),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: SizedBox(
                                    //     width: MediaQuery.of(context).size.width,
                                    //     child: Card(
                                    //       elevation: 0,
                                    //       shape: const LinearBorder(),
                                    //       color: Colors.white,
                                    //       child: Padding(padding: const EdgeInsets.all(8),
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.all(14.0),
                                    //       child: Column(
                                    //         crossAxisAlignment: CrossAxisAlignment.center,
                                    //         children: [
                                    //         isCurrentUserLoggedInUser && isEditMode?
                                    //         Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.edit), onPressed: (){showDialog(context: context, builder: (context)=> showEditEducationModal(userDetailsList, currentUser!.id));},),): Container(),
                                    //         const Text("Education", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),),
                                    //         const SizedBox(height: 15,),
                                    //         Column(
                                    //         mainAxisAlignment: MainAxisAlignment.start,
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         children: currentUserDetails!.educations.map((e) => Column(
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //           Text(e.organizationName, style: const TextStyle(fontWeight: FontWeight.w700,),), 
                                    //           Padding(
                                    //             padding: const EdgeInsets.only(left:8.0),
                                    //             child: Text('${e.level} (${e.startDate!=null? DateFormat("yMMM").format(e.startDate!) :""} - ${e.endDate!=null? DateFormat("yMMM").format(e.endDate!): ""})',
                                    //             ),
                                    //           ),
                                    //           const SizedBox(height: 5,),
                                    //           ListView.builder(
                                    //             physics: const NeverScrollableScrollPhysics(),
                                    //             shrinkWrap: true,
                                    //             itemCount: e.accomplishments.length,
                                    //             itemBuilder: (context, index) => 
                                    //             Text('${e.accomplishments.elementAt(index).title} on ${DateFormat.yMMMM().format(e.accomplishments.elementAt(index).dateTime!)}')), 
                                    //           ],)).toList()
                                    //           
                                    //         )
                                    //       ],),
                                    //     ),
                                    //     ),),
                                    //   ),
                                    // ),
                                    // Padding(padding: const EdgeInsets.all(8.0),
                                    // child: SizedBox(
                                    //   width: MediaQuery.of(context).size.width - 40,
                                    //   child: Card(
                                    //     color: Colors.white,
                                    //     elevation: 0,
                                    //     shape: const LinearBorder(),
                                    //     child: Padding(padding: const EdgeInsets.all(8),
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.all(14.0),
                                    //       child: Column(
                                    //       crossAxisAlignment: CrossAxisAlignment.start,
                                    //         children: [
                                    //           isCurrentUserLoggedInUser && isEditMode?
                                    //           Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.edit), onPressed: (){showDialog(context: context, builder: (context) => showEditWorkPlaceHistory(userDetailsList, currentUser!.id));},),)
                                    //           : Container(),
                                    //           const Center(child: Text("Workplace History", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),)), 
                                    //           const SizedBox(height: 15,),
                                    //           Column(
                                    //             crossAxisAlignment: CrossAxisAlignment.start,
                                    //             children: currentUserDetails!.workExperiences.map((e) => Column(
                                    //               crossAxisAlignment: CrossAxisAlignment.start,
                                    //               children: [
                                    //               Text(e.jobTitle),
                                    //               Text(e.organizationName, maxLines: null,),
                                    //               const SizedBox(height: 5,),
                                    //               Text('Worked On: - ${e.summary}'),
                                    //               const SizedBox(height: 5,),
                                    //               Text( '${DateFormat("yMMM").format(e.startDate!)} - ${DateFormat("yMMM").format(e.endDate!)}'),
                                    //           ],)).toList(),),
                                    //         ],
                                    //       ),
                                    //     )
                                    //   ),),
                                    //   ),
                                    // ),
                                    // Padding(padding: const EdgeInsets.all(8),
                                    // child: SizedBox(
                                    //   width: MediaQuery.of(context).size.width - 40,
                                    //   child: Card(
                                    //     elevation: 0,
                                    //     shape: const LinearBorder(),
                                    //     color: Colors.white,
                                    //     child: Padding(padding: const EdgeInsets.all(8),
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     child: Column(children: [
                                    //       isCurrentUserLoggedInUser && isEditMode?
                                    //       Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.edit), onPressed: (){showDialog(context: context, builder: (context) => showEditContactInfoModal(userDetailsList, currentUser!.id));},),): Container(),
                                    //       const Text("Contact Info", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),),
                                    //       const SizedBox(height: 15,),
                                    //        Row(children: [const Text("Mobile No.", style: TextStyle(fontWeight: FontWeight.bold),), const  SizedBox(width: 5,),Text(currentUserDetails!.contactInfo.mobileNo!)],),
                                    //       const SizedBox(height: 5,),
                                    //       Column(children: currentUserDetails!.contactInfo.socialMedias.map((e) =>
                                    //        Row(
                                    //          children: [
                                    //            Image.network('https://logo.clearbit.com/${e.type}', height: 32, width: 32,),
                                    //            const SizedBox(width: 10,),
                                    //            Column(children: [
                                    //             Text(e.title),
                                    //             Text(e.url.split('/').last),
                                    //             const SizedBox(height: 15,),      
                                    //             ]),
                                    //          ],
                                    //        )).toList())
                                    //     ],),
                                    //   ),),),
                                    // ),)
                                    ],),
                                ),
                              ),
                            );
                },
              )  
                      );
            });
        },
      );
  }
}