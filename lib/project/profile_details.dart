import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino show CupertinoIcons;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_states.dart';
import 'package:flutter_intern/project/bloc/user_list_bloc.dart';
import 'package:flutter_intern/project/bloc/user_list_events.dart';
import 'package:flutter_intern/project/bloc/user_list_states.dart';
import 'package:flutter_intern/project/locator.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:intl/intl.dart';

class ProfileDetails extends StatefulWidget{
  @override
  State<ProfileDetails> createState() {
    return _ProfileDetailsState();
  }
}
enum UserGender{male, female}



class _ProfileDetailsState extends  State<ProfileDetails>{

List<UserDetails> userDetailsList  = List.empty();
List<UserData> userDataList = List.empty();

UserDetails? currentUserDetails;
UserData? currentUserData;

void saveData(List<UserDetails> userDetailsList) async{ 
  if(locator<UserListBloc>().state is! UserListEmpty){
    locator<UserListBloc>().add(EditUserEvent(userDetails: userDetailsList));
  }
}

@override
  void dispose() {
    super.dispose();
    closeUserPostLocator();
  }

@override
void initState(){
  super.initState();
  if(locator<UserListBloc>().state is UserListEmpty){
    locator<UserListBloc>().add(UserListInitialize());
  }
}

Widget showEditBasicInfoModal(){
    userDetailsList = locator.get<UserListBloc>().state.userDetailsList!;
    int currentUserId = BlocProvider.of<AuthBloc>(context).state.userData!.id;
    var currentUserDetails = userDetailsList.firstWhere((element) => element.id == currentUserId);
    TextEditingController summaryController = TextEditingController();

    summaryController.text = currentUserDetails.basicInfo.summary;
    UserGender? _gender = context.read<AuthBloc>().state.userDetails!.basicInfo.gender == "Male" ? UserGender.male: UserGender.female;
    return StatefulBuilder(
      builder: (context, setState) {
        return BlocBuilder<UserListBloc, UserListStates>(
            builder: (context, state) {
              return Scaffold(
                appBar: const ModalAppBar(title: "Edit Basic Info",),
                body: Padding(
                  padding: const EdgeInsets.only(left:16.0, right: 16.0, bottom: 16.0),
                  child:  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Form(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Column(children: [
                            SizedBox(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: summaryController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid)),
                                      hintText: "Enter summary",),
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
                                              _gender = value; });
                                              }), 
                                              const SizedBox(height: 30,),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Expanded(child: Container()),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FilledButton(style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blueAccent), shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))))),
                                  onPressed: (){
                                    setState((){
                                      currentUserDetails.basicInfo.summary = summaryController.text;
                                      currentUserDetails.basicInfo.gender = _gender == UserGender.male ? "Male"  : "Female";
                              });
                              saveData(userDetailsList);
                              Navigator.of(context).pop();
                              }, child: const Text("Submit")),
                                                          )
                            ],),
                        ),
                      ),
                    ),
                  )  
                )
              );
            },
          );
      }
    );
  }

  Widget showEditSkillsModal(){
    var userDetailsList = locator.get<UserListBloc>().state.userDetailsList;
    var currentUserDetails = userDetailsList!.firstWhere((element) => element.id == BlocProvider.of<AuthBloc>(context).state.userData!.id);
    TextEditingController skillController = TextEditingController();
    return Scaffold(
      appBar:const ModalAppBar(title: "Edit Skills",),
      body: StatefulBuilder(
        builder: (context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Center(child: 
            Form(child: 
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      TextFormField(
                        controller: skillController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
                          ),
                          hintText: "Enter skills"), onFieldSubmitted: (value){
                          ;},),
                      const SizedBox(height: 30,),
                      // Text("Skills", style: Theme.of(context).textTheme.headlineSmall,),
                      // const SizedBox(height: 30,),
                      // Wrap(
                      //   runSpacing: 8.0,
                      //   spacing: 8.0,
                      //   children: currentUserDetails.skills.map((e) => Card(child: Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(e.title!),
                      // ),)).toList(),),
                      // const SizedBox(height: 30,),
                      // 
                      // const SizedBox(height: 30,),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Expanded(child: Container()),
                  FilledButton(
                    style: const ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                      backgroundColor: WidgetStatePropertyAll(Colors.blueAccent)),
                    onPressed: (){
                      setState(() {
                          Skills skills = Skills();
                          skills.id = Random().nextInt(10000) + 1000;
                          skills.title = skillController.text;
                          currentUserDetails.skills.add(skills);
                          skillController.clear();
                          });
                    saveData(userDetailsList);
                    Navigator.of(context).pop();
                  }, child: const Text("Submit")),
                ],
              ),
            ),)),
          );
        }
      ),
    );
  }

  Widget showEditHobbiesModal(){
    userDetailsList = locator.get<UserListBloc>().state.userDetailsList!;
    int currentUserId = BlocProvider.of<AuthBloc>(context).state.userData!.id;
    var currentUserDetails = userDetailsList.firstWhere((element) => element.id == currentUserId);

    TextEditingController hobbiesController = TextEditingController();
    return Scaffold(
      appBar: const ModalAppBar(title: "Edit Hobbies",),
      body: StatefulBuilder(
        builder: (context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Center(child: 
              Form(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30,),
                  Text("Hobbies", style: Theme.of(context).textTheme.headlineSmall,),
                  const SizedBox(height: 20,),
                  Wrap(children: currentUserDetails.hobbies.map((e) => Card(
                    elevation: 0,
                    child: Padding(
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
                  FilledButton(
                    style: blueFilledButtonStyle, 
                    onPressed: (){
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

  Widget showEditLanguagesModal(){
    userDetailsList = locator.get<UserListBloc>().state.userDetailsList!;
    int currentUserId = BlocProvider.of<AuthBloc>(context).state.userData!.id;
    var currentUserDetails = userDetailsList.firstWhere((element) => element.id == currentUserId);

    TextEditingController languageController = TextEditingController();
    return Scaffold(
      appBar: const ModalAppBar(title: "Edit Languages",),
      body: StatefulBuilder(
        builder: (context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Center(child: 
              Form(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30,),
                  Text("Languages", style: Theme.of(context).textTheme.headlineSmall,),
                  const SizedBox(height: 30,),
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
                  FilledButton(
                    style: blueFilledButtonStyle,
                    onPressed: (){
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

  Widget showEditEducationModal(){
    userDetailsList = locator.get<UserListBloc>().state.userDetailsList!;
    int currentUserId = BlocProvider.of<AuthBloc>(context).state.userData!.id;
    var currentUserDetails = userDetailsList.firstWhere((element) => element.id == currentUserId);

    UserDetails currentUser = userDetailsList.firstWhere((element) => element.id == currentUserId);

    List<TextEditingController> levelControllers = List.generate(currentUser.educations.length, (index) => TextEditingController());
    List<TextEditingController> summaryControllers = List.generate(currentUser.educations.length, (index) => TextEditingController());
    List<TextEditingController> organizationNameControllers = List.generate(currentUser.educations.length, (index) => TextEditingController());

    List<List<TextEditingController>> achievementTitleControllerMatrix = List.generate(currentUser.educations.length, (index) => List.generate(currentUser.educations.elementAt(index).accomplishments.length, (i) => TextEditingController()));
    List<List<TextEditingController>> achievementDescriptionControllerMatrix = List.generate(currentUser.educations.length, (index) => List.generate(currentUser.educations.elementAt(index).accomplishments.length, (i) => TextEditingController()));


    for(int i=0; i<currentUser.educations.length; i++){
      levelControllers.elementAt(i).text = currentUserDetails.educations.elementAt(i).level;
      summaryControllers.elementAt(i).text = currentUserDetails.educations.elementAt(i).summary;
      organizationNameControllers.elementAt(i).text = currentUserDetails.educations.elementAt(i).organizationName;

      for(int j=0; j<currentUser.educations.elementAt(i).accomplishments.length; j++){
        achievementTitleControllerMatrix.elementAt(i).elementAt(j).text = currentUser.educations.elementAt(i).accomplishments.elementAt(j).title;
        achievementDescriptionControllerMatrix.elementAt(i).elementAt(j).text = currentUser.educations.elementAt(i).accomplishments.elementAt(j).description;
      }  
    }

    return Scaffold(
      appBar: const ModalAppBar(title: "Edit Education",),
      body: StatefulBuilder(builder: (context, setState) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(child: Form(child: Column(
            children: [
              const SizedBox(height: 30,),
              Text("Educational History", style: Theme.of(context).textTheme.headlineSmall,),
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
                    TextFormField(decoration: InputDecoration(icon: const Icon(Icons.calendar_month), label: Text((currentUserDetails.educations.elementAt(index).startDate == null)? "Enter the starting date here":
                    DateFormat("yyyy-MM-dd").format(currentUserDetails.educations.elementAt(index).startDate!)
                    ),),
                    readOnly: true,
                    onTap: () async{
                      DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2030), initialDate: DateTime.now());
                      setState((){
                        if(pickedDate != null){
                          currentUserDetails.educations.elementAt(index).startDate = pickedDate;
                        }
                      });
                    },),
                    TextFormField(decoration: InputDecoration(icon: const Icon(Icons.calendar_month), label: Text((currentUserDetails.educations.elementAt(index).endDate == null)? "Enter the end date here":
                    DateFormat("yyyy-MM-dd").format(currentUserDetails.educations.elementAt(index).endDate!)
                    ),),
                    readOnly: true,
                    onTap: () async{
                      DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2030), initialDate: DateTime.now());
                      setState((){
                        if(pickedDate != null){
                          currentUserDetails.educations.elementAt(index).endDate = pickedDate;
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
                        TextFormField(decoration: InputDecoration(icon: const Icon(Icons.calendar_month), label: Text((currentUserDetails.educations.elementAt(index).accomplishments.elementAt(indexJ).dateTime == null)? "Enter the starting date here":
                          DateFormat("yyyy-MM-dd").format(currentUserDetails.educations.elementAt(index).accomplishments.elementAt(indexJ).dateTime!)
                          ),),
                          readOnly: true,
                          onTap: () async{
                              DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2030), initialDate: DateTime.now());
                              setState((){
                              if(pickedDate != null){
                                  currentUserDetails.educations.elementAt(index).accomplishments.elementAt(indexJ).dateTime = pickedDate;
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
                            currentUserDetails.educations.elementAt(index).accomplishments.add(accomplishment);
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
                    currentUserDetails.educations.add(education);
                    WidgetsBinding.instance.addPostFrameCallback((_) => setState((){}));
                  })
                ,),
              const SizedBox(height: 30,),
              FilledButton(
                style: blueFilledButtonStyle,
                onPressed: (){
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

  Widget showEditWorkPlaceHistory(){
    userDetailsList = locator.get<UserListBloc>().state.userDetailsList!;
    int currentUserId = BlocProvider.of<AuthBloc>(context).state.userData!.id;
    var currentUserDetails = userDetailsList.firstWhere((element) => element.id == currentUserId);

    List<TextEditingController> jobTitleController = List.generate(growable: true, currentUserDetails.workExperiences.length, (index) => TextEditingController());
    List<TextEditingController> summaryController = List.generate(growable: true, currentUserDetails.workExperiences.length, (index) => TextEditingController());
    List<TextEditingController> organizationController = List.generate(growable: true, currentUserDetails.workExperiences.length, (index) => TextEditingController());

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
              Text("Workplace History", style: Theme.of(context).textTheme.headlineSmall,),
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

  Widget showEditContactInfoModal(){
    userDetailsList = locator.get<UserListBloc>().state.userDetailsList!;
    int currentUserId = BlocProvider.of<AuthBloc>(context).state.userData!.id;
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
      appBar: const ModalAppBar(title: "Edit Contact Info",),
      body: StatefulBuilder(builder: (context, StateSetter setState) => 
      SingleChildScrollView(child: 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child:
           Form(child:Column(
            children: [
              //Text("Contact Info", style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: 60,),
              TextFormField(
                decoration: const InputDecoration(
                label: Text("Enter Mobile No."),
                border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid, color: Colors.black)),
                hintText: "Enter mobile no."), controller: mobileNoController, 
                validator: (value)=> phoneNoRegex.hasMatch(value!)? null :"Invalid Phone No." ,
                ),
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
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>( 
        builder:(builder, authState) {
       if (authState is! AuthorizedAuthState){
           Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
         }
         currentUserData = locator.get<UserListBloc>().state.userDataList!.firstWhere((e) => e.id == BlocProvider.of<AuthBloc>(context).state.userData!.id);
         currentUserDetails = locator.get<UserListBloc>().state.userDetailsList!.firstWhere((e) => e.id == BlocProvider.of<AuthBloc>(context).state.userData!.id);

          return BlocBuilder<UserListBloc, UserListStates>(
         
         builder: (context, userListState) {
      
           return Scaffold(
            appBar: const CommonAppBar(),
            body: SingleChildScrollView( 
              child: 
              Container(
              color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Card(
                      shape: const LinearBorder(),
                      elevation: 0,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Text("About Me", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                            const Spacer(),
                            IconButton(icon:const Icon(Icons.edit),onPressed: (){showDialog(context: context, builder: (context) => BlocProvider.value(
                            value: locator<UserListBloc>(),
                            child: showEditBasicInfoModal(), 
                          ));},),
                          ],
                          ), 
                          const SizedBox(height: 15,),
                          Row(children: [const CustomDetailsIcon(ico: Icons.text_snippet_outlined), const SizedBox(width: 10,), Text(currentUserDetails!.basicInfo.summary)],),
                          const SizedBox(height: 15,),
                          Row(children: [const CustomDetailsIcon(ico: Icons.person),const SizedBox(width: 10,), Text(currentUserDetails!.basicInfo.gender)],),
                        const SizedBox(height: 15,),
                        Row(children: [const CustomDetailsIcon(ico: Icons.cake), const SizedBox(width: 10,), Text(currentUserDetails!.basicInfo.dob)],),
                        const SizedBox(height: 15,),
                        ],),
                      ),) ,
                      Wrap(
                        children: [
                          Divider(thickness: 0.5, indent: MediaQuery.of(context).size.width * 0.05, endIndent: MediaQuery.of(context).size.width * 0.05,),
                          SizedBox(
                          width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 0,
                              shape: const LinearBorder(),
                              color: Colors.white,
                              child: Padding(padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [ 
                              Row(
                                children: [
                                  const Text("Skills", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                                  const Spacer(),
                                  IconButton(icon: const Icon(Icons.edit), onPressed: (){showDialog(context: context, builder: (context) => showEditSkillsModal());},),
                                ],
                              ),
                              Container(),
                              const SizedBox(height: 15,),
                              Wrap(
                                direction: Axis.vertical,
                                children: currentUserDetails!.skills.map((e) => Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(padding: const EdgeInsets.all(8), child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        const CustomDetailsIcon(ico: Icons.badge,),
                                        const SizedBox(width: 10,),
                                        Center(child: Text(e.title!)),
                                      ],
                                    ),
                                  ],
                                ),),)).toList(),),
                            ],),),),
                          ),
                        Divider(thickness: 0.5, indent: MediaQuery.of(context).size.width * 0.05, endIndent: MediaQuery.of(context).size.width * 0.05,),
                        SizedBox( 
                        width: MediaQuery.of(context).size.width,
                          child: Card(
                            shape: const LinearBorder(),
                            elevation: 0,
                            color: Colors.white,
                            child: Padding(padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Hobbies", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                                      const Spacer(),
                                      Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.edit), onPressed: (){showDialog(context: context, builder: (context) => showEditHobbiesModal());},),),
                                    ],
                                  ),
                                  const SizedBox(height: 15,),
                                  Wrap(
                                    direction: Axis.vertical,
                                  children: currentUserDetails!.hobbies.map((e) => Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8), 
                                      child: Row(
                                        children: [
                                          const CustomDetailsIcon(ico: Icons.music_note),
                                          const SizedBox(width: 10,),
                                          Text(e.title),
                                        ],
                                      ),),)).toList(),),
                                    ],),),),
                        ),
                          Divider(thickness: 0.5, indent: MediaQuery.of(context).size.width * 0.05, endIndent: MediaQuery.of(context).size.width * 0.05,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: const LinearBorder(),
                          child: Padding(padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Languages", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                                  const Spacer(),
                                  Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.edit), onPressed: (){showDialog(context: context, builder: (context) => showEditLanguagesModal());},),),
                                ],
                              ),
                              const SizedBox(height: 15,),
                              Wrap(children: currentUserDetails!.languages.map((e) => Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    const CustomDetailsIcon(ico: cupertino.CupertinoIcons.chat_bubble_2_fill),
                                    const SizedBox(width: 10,),
                                    Text(e.title),
                                  ],
                                ),)).toList(),),
                        ],),),),
                      )],),
                    const SizedBox(height: 20,),
                    Divider(thickness: 0.5, indent: MediaQuery.of(context).size.width * 0.05, endIndent: MediaQuery.of(context).size.width * 0.05,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 0,
                          shape: const LinearBorder(),
                          color: Colors.white,
                          child: Padding(padding: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            Row(
                              children: [
                                const Text("Education", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),),
                                const Spacer(),
                                Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.edit), onPressed: (){showDialog(context: context, builder: (context)=> showEditEducationModal());},),),
                              ],
                            ),
                            const SizedBox(height: 15,),
                            Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: currentUserDetails!.educations.map((e) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Row(children: [const CustomDetailsIcon(ico: Icons.school), const SizedBox(width: 10,),const Text("Went To "), Text(e.organizationName, style: const TextStyle(fontWeight: FontWeight.bold),)],),
                              const SizedBox(height: 5,),
                              ],)).toList()
                              
                            )
                          ],),
                        ),
                        ),),
                      ),
                    ),
                    Divider(thickness: 0.5, endIndent: MediaQuery.of(context).size.width * 0.05, indent: MediaQuery.of(context).size.width * 0.05,),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: const LinearBorder(),
                        child: Padding(padding: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Workplace History", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),), 
                                  const Spacer(),
                                  Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.edit), onPressed: (){showDialog(context: context, builder: (context) => showEditWorkPlaceHistory());},),),
                                ],
                              ),
                              const SizedBox(height: 15,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: currentUserDetails!.workExperiences.map((e) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Row(
                                    children: [
                                      const CustomDetailsIcon(ico: Icons.work),
                                      const SizedBox(width: 10,),
                                      const Text("Worked as "),
                                      Text(e.jobTitle, style: const TextStyle(fontWeight: FontWeight.bold),),
                                      const Text("at "),
                                      Text(e.organizationName, style: const TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                              ],)).toList(),),
                            ],
                          ),
                        )
                      ),),
                      ),
                    ),
                    Divider(thickness: 0.5, indent: MediaQuery.of(context).size.width * 0.05, endIndent: MediaQuery.of(context).size.width * 0.05,),
                    Padding(padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 0,
                        shape: const LinearBorder(),
                        color: Colors.white,
                        child: Padding(padding: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        child: Column(children: [
                          Row(
                            children: [
                              const Text("Contact Info", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),),
                              const Spacer(),
                              Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.edit), onPressed: (){showDialog(context: context, builder: (context) => showEditContactInfoModal());},),),
                            ],
                          ),
                          const SizedBox(height: 15,),
                           Row(children: [const CustomDetailsIcon(ico: Icons.phone_iphone), const  SizedBox(width: 10,),Text(currentUserDetails!.contactInfo.mobileNo!)],),
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
              )                          ,
                 )   ,
              );
         });
        });}
}

class CustomDetailsIcon extends StatelessWidget {
  final IconData ico;
  const CustomDetailsIcon({
    super.key,
    required this.ico
  });

  @override
  Widget build(BuildContext context) {
    return Container(width: 30, height:30, decoration: BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle), child: Center(child: Icon(ico, color: Colors.white,)),);
  }
}