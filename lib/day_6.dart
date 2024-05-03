import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

void main(List<String> args) {
  runApp(const MyApp());  
}

class CVData{

CVData({required this.firstName, required this.middleName, required this.lastName, required this.gender, required this.age,
required this.skills, required this.jobTitles, required this.workplaceName, required this.joinedDates, required this.endedDates,
required this.educationOrganization, required this.board,required this.joinedDate, required this.finishedDate, this.achievements, this.projectTitle, 
this.projectStartDate, this.projectEndDate, this.projectOrganization, required this.languages, required this.interest});
String? firstName;
String? middleName;
String? lastName;
String? gender;
int age;
List<String> skills;
List<String>? jobTitles;
List<String>? workplaceName;
List<DateTime?> joinedDates;
List<DateTime?> endedDates;
String educationOrganization;
String? board;
DateTime? joinedDate;
DateTime? finishedDate;
String? achievements; 
String? projectTitle;
String? description;
DateTime? projectStartDate;
DateTime? projectEndDate;
String? projectOrganization;
List<String> languages;
List<String> interest;

}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
    ); 
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage>{
  @override
  Widget build(BuildContext context) {
    return(
      Scaffold(
        appBar: AppBar(
          title: const Text("Day 6"), 
        ),
        body: FormLayout(),
      )
    );
  }
}



enum Gender {Male, Female}
class FormLayout extends StatefulWidget{
  @override
  State<FormLayout> createState() => _FormLayoutState();
}
class _FormLayoutState extends State<FormLayout>{
SharedPreferences? preferences;

final RegExp regExp = RegExp(r'^[a-zA-Z]+$');
final RegExp ageRegEx = RegExp(r'^[0-9]{0,3}$');
List<String> selectedSKills= List.empty(growable: true);
TextEditingController _firstNameController = TextEditingController();
TextEditingController _midNameController = TextEditingController();
TextEditingController _lastNameController = TextEditingController();
TextEditingController _ageController = TextEditingController();
TextEditingController _educationalOrganizationController = TextEditingController();
final _formKey = GlobalKey<FormState>();
Gender? _gender = Gender.Male;

List<TextEditingController> jobTitleControllers = List.generate(0, growable: true, (index) => TextEditingController());
final List<TextEditingController> _workspaceController = List.generate(0, growable: true, (index) => TextEditingController());
final List<DateTime?> _joinedDates = List.empty(growable: true);
final List<DateTime?> _endedDates =  List.empty(growable: true);
List<DropdownMenuItem<String>> get _dropDownItems {
const List<DropdownMenuItem<String>> menuItems =[
   DropdownMenuItem(value: "SEE",child: Text("SEE"),),
    DropdownMenuItem(value: "+2",child: Text("+2"),),
    DropdownMenuItem(value: "Bachelor",child: Text("Bachelor"),),
    DropdownMenuItem(value: "Masters",child: Text("Masters"),),
    DropdownMenuItem(value: "PhD",child: Text("Phd"),),
  ];
  return menuItems;
}

Map<String,bool> languages = {
  "English": false,
  "Nepali": false,
  "Hindi": false,
};

Map<String, bool> interest = {
  "Interest 1": false,
  "Interest 2": false,
  "Interest 3": false,
  "Interest 4": false,
};

int _noOfWorkplaces = 0;
String? educationLevel = "SEE";
DateTime? _educationJoinedDate ;
DateTime? _educationFinishedDate;
DateTime? _projectStartDate;
DateTime? _projectEndDate;
bool hasProjects = false;

bool associatedWithOrganization = false;

Future<void> storePrefs() async{
  String genderValue = (_gender == Gender.Male) ? "Male": "Female";
  List<String> titles = List.empty(growable: true);
  List<String> workplaces = List.empty(growable: true);
  jobTitleControllers.map((e) =>  {
    titles.add(e.text)
  });

  _workspaceController.map((e) => {
    workplaces.add(e.text)
  });

  
  
  List<String> languageValues = List.empty(growable: true);
  (languages["Hindi"] == true) ? languageValues.add("Hindi"): null;
  (languages["English"] == true) ? languageValues.add("English"): null;
  (languages["Nepali"] == true)? languageValues.add("Nepali") : null;

  List<String> interestValues = List.empty(growable: true);
  (interest["Interest 1"] == true) ? interestValues.add("Interest 1") : null;
  (interest["Interest 2"] == true) ? interestValues.add("Interest 2") : null;
  (interest["Interest 3"] == true) ? interestValues.add("Interest 3") : null;
  (interest["Interest 4"] == true) ? interestValues.add("Interest 4") : null;


  CVData cvData = CVData(firstName: _firstNameController.text, lastName: _lastNameController.text, middleName: _midNameController.text, gender:genderValue,
    skills: selectedSKills, jobTitles:titles,workplaceName: workplaces,joinedDates: _joinedDates, endedDates: _endedDates,
    educationOrganization: _educationalOrganizationController.text, board: educationLevel, finishedDate: _educationFinishedDate,
    joinedDate: _educationJoinedDate, languages: languageValues, interest: interestValues, age: int.parse(_ageController.text),
  );
  String jsonValue = jsonEncode(cvData);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString(_firstNameController.text, jsonValue);
}

void _setProjectStartDate(context){
  showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2024, 12, 31), initialDate: DateTime.now()).then((value) => {
    setState((){
      if(value == null){
        return;
      }
      _projectStartDate = value;
    })
  });
}

void _setProjectEndDate(context){
  showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2024, 12, 31), initialDate: DateTime.now()).then((value) => {
    setState((){
      if(value == null){
        return;
      }
      _projectEndDate= value;
    })
  });
}

void _seteducationJoinedDate(context){
  showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2024, 12, 31), initialDate: DateTime.now()).then((value) => {
    setState((){
      if(value == null){
        return;
      }
      _educationJoinedDate = value;
    })
  });
}

void _setEducationFinishedDate(context){
  showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2024, 12, 31), initialDate: DateTime.now()).then((value) => {
    setState((){
      if(value == null){
        return;
      }
        _educationFinishedDate = value;
    })
  });
}

void _setJoinedDate(context, index){
  showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2024, 12, 31), initialDate: DateTime.now()).then((value) => {
    setState((){
      if(value == null){
        return;
      }
        _joinedDates[index] = (value);
    })
  });
}

void _setEndedDate(BuildContext context, int index){

  showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2024, 12, 31), initialDate: DateTime.now()).then((value) => {
    setState(() {
      if(value == null){
        return;
      }
      _endedDates[index] = value;

    })
  });

}

void _increaseWorkplaces(){
  setState(() {
    TextEditingController tempWorkspaceControls = TextEditingController();
    TextEditingController _jobTitleController = TextEditingController();
    DateTime? dt; 
    _workspaceController.add(tempWorkspaceControls);
    jobTitleControllers.add(_jobTitleController);
    _joinedDates.add(dt);
    _endedDates.add(dt);
    _noOfWorkplaces++;
  });
}

@override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Form(
      key: _formKey,
      child:Column(
        children: [
        const SizedBox(height: 15,),
        Text("Enter your details: ", textAlign: TextAlign.start,style: Theme.of(context).textTheme.headlineMedium,),
        Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(width: 160, child: TextFormField(decoration: const InputDecoration(hintText: "First Name",errorMaxLines: 3), controller: _firstNameController, validator: (value) {return ((value == null|| value.isEmpty)) ? "First name required" : (value.length > 10) ? "Must be less than 10 characters" :(!regExp.hasMatch(value)) ? "First name has to be only alphabets":null ;},)),
 
          ), 
          
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(width: 160, child: TextFormField(decoration: const InputDecoration(hintText: "Middle Name", errorMaxLines: 3), controller: _midNameController, validator: (value) {return ((value == null || value.isEmpty)) ? "Middle name required" : (value.length> 10) ? "Must be less than 10 characters long" : (!regExp.hasMatch(value)? "Middle name has to be only alphabets" : null);},)), 
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(width: 160, child: TextFormField(decoration: const InputDecoration(hintText: "Last Name"),controller: _lastNameController, validator: (value) {return (value == null || value.isEmpty) ? "Last name is required" : (value.length>10)? "Must be less than 10 characters long": (!regExp.hasMatch(value)) ? "Should only contain alphabets" : null;},)),
            ),
            Padding(padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: 160, child: TextFormField(decoration: const InputDecoration(hintText: "Age"), controller: _ageController, validator: (value) {return (value == null || value.isEmpty) ? "Age is required": (!ageRegEx.hasMatch(value))? "Age must be numeric": null;},),),),

          ]),

          const SizedBox(height: 10,),
          Text("Gender", style: Theme.of(context).textTheme.headlineMedium,),
          const SizedBox(height: 10,),
          Wrap(
            direction: Axis.horizontal,
            children: [
          ListTile(
            title: const Text("Male"),
            leading: Radio(value: Gender.Male, groupValue: _gender, onChanged: (Gender? value){setState(() {
              _gender = value;
            });}),
          ),
          ListTile(
            title: const Text("Female"),
            leading: Radio(value: Gender.Female, groupValue: _gender, onChanged: (Gender? value){setState(() {
              _gender = value;
            });}),
          ),]),
          Text("Skill", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10,),
         Wrap( 
          direction: Axis.horizontal,
          children: [ 
            SizedBox(
            width: (MediaQuery.of(context).size.width - 24 )/ 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChoiceChip(label: const Text("Skill 1"),
                 selected: selectedSKills.contains("Skill 1"),
                 onSelected: (value) => setState(()=> 
                  !selectedSKills.contains("Skill 1") ? selectedSKills.add("Skill 1") : selectedSKills.remove("Skill 1")
                 ),),
              ),
            ),
            SizedBox(
            width: (MediaQuery.of(context).size.width -24) / 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChoiceChip(label: const Text("Skill 2"),
                  selected: selectedSKills.contains("Skill 2"),
                  onSelected: (value) => setState(()=> 
                  !selectedSKills.contains("Skill 2") ? selectedSKills.add("Skill 2") : selectedSKills.remove("Skill 2")
                 ),),
              ),
            ), 
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChoiceChip(label: const Text("Skill 3"),
               selected: selectedSKills.contains("Skill 3"),
               onSelected: (value) => setState(()=> 
                !selectedSKills.contains("Skill 3") ? selectedSKills.add("Skill 3") : selectedSKills.remove("Skill 3")
               ),),
            ),]),
             const SizedBox(height: 40,),
             Text("Experience", style: Theme.of(context).textTheme.headlineMedium,),
             const SizedBox(height: 40,),
             SizedBox( 
                 height: _noOfWorkplaces * 320,
                 child: ListView.builder(
                 shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemCount: _noOfWorkplaces,
                   itemBuilder: (context, index)=>    
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(padding: const EdgeInsets.all(8),width: 320,child: TextFormField(decoration: const InputDecoration(hintText: "Enter Job Title", hintMaxLines: 3),)),
                        ),
                        Padding(padding: const EdgeInsets.all(8.0),
                        child: Container(padding: const EdgeInsets.all(8),width: 320, child: TextFormField(decoration: const InputDecoration(hintText: "Enter Workplace Name", hintMaxLines: 3),))
                        ),
                      //DatePickerDialog(firstDate: DateTime(2000), lastDate: DateTime(2025)),

                      ElevatedButton(onPressed: (){_setJoinedDate(context, index);}, child: Text(( _joinedDates[index] == null) ? "Set Joined Date" : 'Joined at ${_joinedDates[index]!.year.toString()}-${_joinedDates[index]!.month.toString().padLeft(2,'0')}-${_joinedDates[index]!.day.toString().padLeft(2,'0')}')),
                      ElevatedButton(onPressed: () {_setEndedDate(context, index);} , child: Text((_endedDates[index] == null) ? "Set Left Date" : 'Joined at ${_endedDates[index]!.year.toString()}-${_endedDates[index]!.month.toString().padLeft(2,'0')}-${_endedDates[index]!.day.toString().padLeft(2,'0')}')),
                      const SizedBox(height: 80),
                      Center(child: Container(width: 320, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 0.5), top: BorderSide(color: Colors.black, width: 0.5))),)),
                      const SizedBox(height: 10),
                      Center(child: Container(width: 320, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 0.5), top: BorderSide(color: Colors.black, width: 0.5))),)),
                      ],
                    ) ),
               ), 

          ElevatedButton(onPressed: (){_increaseWorkplaces(); }, child: const Text("Add More +")),
          const SizedBox(height: 40,),
          Text("Highest Education Recieved", style: Theme.of(context).textTheme.headlineMedium,),
          const SizedBox(height: 40,),
          SizedBox(
            child: Wrap(children: [
              SizedBox(width: 220,  child: TextFormField(controller: _educationalOrganizationController,decoration: const InputDecoration(hintText: "Organization Name"), validator: (value) {return (value == null || value.isEmpty) ? "Last name is required" : (value.length>10)? "Must be less than 10 characters long": (!regExp.hasMatch(value)? "Should only contain alphabets":null);},) ,),
              DropdownButton(items: _dropDownItems,value: educationLevel, onChanged: ((value) => {setState(() {
                educationLevel = value;
              })}))
            ],),
          ),
          Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: (){_seteducationJoinedDate(context);}, child: Text(_educationJoinedDate == null ? "Enter joined date":"Joined at ${_educationJoinedDate!.year.toString()}-${_educationJoinedDate!.month.toString().padLeft(2,'0')}-${_educationJoinedDate!.day.toString().padLeft(2,'0')} ")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: (){_setEducationFinishedDate(context);}, child: Text(_educationFinishedDate == null ? "Enter completed date":"Finished at ${_educationFinishedDate!.year.toString()}-${_educationFinishedDate!.month.toString().padLeft(2,'0')}-${_educationFinishedDate!.day.toString().padLeft(2,'0')} ")),
              )
            ],),
          const SizedBox(height: 30,),
          SizedBox(width: 210, 
            child: TextFormField(decoration: const InputDecoration(hintText: "Achievements (optional)",),)
          ),
          const SizedBox(height: 30,),
          const SizedBox(height: 30,),
          ListTile(
            leading: Switch(value:hasProjects, onChanged: (value) => {setState(() {
              hasProjects = !hasProjects;
            })},),
            title: Text("Projects (optional)", style: Theme.of(context).textTheme.headlineMedium,),
          ),
          hasProjects ? SizedBox(
            height: 510,
            child: Wrap(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(height:80, child: TextFormField(decoration: const InputDecoration(hintText: "Project Title"), validator: (value) {return (value == null || value.isEmpty) ? "Project Title is required" : (value.length>10)? "Must be less than 10 characters long": (!regExp.hasMatch(value)? "Should only contain alphabets":null);},) ,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(height:80,child: TextFormField(decoration: const InputDecoration(hintText: "Description"), validator: (value) {return (value == null || value.isEmpty) ? "Project Description is required" : (value.length>100)? "Must be less than 100 characters long": (!regExp.hasMatch(value)? "Should only contain alphabets":null);},) ,),
              ), 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: (){_setProjectStartDate(context);}, child: Text(_projectStartDate == null ? "Enter Project Start Date":"Joined at ${_educationJoinedDate!.year.toString()}-${_educationJoinedDate!.month.toString().padLeft(2,'0')}-${_educationJoinedDate!.day.toString().padLeft(2,'0')} ")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: (){_setProjectEndDate(context);}, child: Text(_projectEndDate == null ? "Enter Project end date":"Joined at ${_educationJoinedDate!.year.toString()}-${_educationJoinedDate!.month.toString().padLeft(2,'0')}-${_educationJoinedDate!.day.toString().padLeft(2,'0')} ")),
              ), 
              ListTile(
              leading: Radio(value: associatedWithOrganization, groupValue: !associatedWithOrganization, onChanged: (value){
              setState(() {
                associatedWithOrganization = !associatedWithOrganization;
              });
              const Text("Associated with organization?");
            })),
            associatedWithOrganization ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(decoration: InputDecoration(hintText: "Organization's Name"), validator: (value) {return (value == null || value.isEmpty) ? "Last name is required" : (value.length>10)? "Must be less than 10 characters long": (!regExp.hasMatch(value)? "Should only contain alphabets":null);},),
            ): Text("Check the radio button if there was organization involved"),

            ],),) : SizedBox(height: 10, child: Text("Optional", style: Theme.of(context).textTheme.headlineMedium,),),
                      const SizedBox(height: 30,),
          Text("Languages", style: Theme.of(context).textTheme.headlineMedium,),
          const SizedBox(height: 30,),
            Wrap(
              direction: Axis.horizontal,
              children: [
                SizedBox(
                width: ((MediaQuery.of(context).size.width) / 2) - 15.0,
                  child: ListTile(
                    leading: Checkbox(value: languages["English"], onChanged: (value){
                      setState(() {
                        languages["English"] = ! languages["English"]!;
                      });
                    }),
                  title: const Text("English"),
                  ),
                ),
                SizedBox(
                width: ((MediaQuery.of(context).size.width) / 2) -15,
                  child: ListTile(
                    leading: Checkbox(value: languages["Nepali"], onChanged: (value){
                      setState(() {
                        languages["Nepali"] = ! languages["Nepali"]!;
                      });
                    }),
                  title: const Text("Nepali")
                  ),
                ),
                SizedBox(
                width: ((MediaQuery.of(context).size.width) / 2) - 15,
                  child: ListTile(
                    leading: Checkbox(value: languages["Hindi"], onChanged: (value){
                      setState(() {
                        languages["Hindi"] = ! languages["Hindi"]!;
                      });
                    }),
                    title: const Text("Hindi"),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 30,),
          Text("Interests", style: Theme.of(context).textTheme.headlineMedium,),
          const SizedBox(height: 30,),
            Wrap(
              direction: Axis.horizontal,
              children: [
                SizedBox(
                width: (MediaQuery.of(context).size.width - 30 / 3),
                  child: ListTile(
                    leading: Checkbox(value: interest["Interest 1"], onChanged: (value){
                      setState(() {
                        interest["Interest 1"] = ! interest["Interest 1"]!;
                      });
                    }),
                  title: const Text("Interest 1"),
                  ),
                ),
                SizedBox(
                width: (MediaQuery.of(context).size.width - 30 / 3),
                  child: ListTile(
                    leading: Checkbox(value: interest["Interest 2"], onChanged: (value){
                      setState(() {
                        interest["Interest 2"] = ! interest["Interest 2"]!;
                      });
                    }),
                  title: const Text("Interest 2")
                  ),
                ),
                SizedBox(
                width: (MediaQuery.of(context).size.width - 30 / 3),
                  child: ListTile(
                    leading: Checkbox(value: interest["Interest 3"], onChanged: (value){
                      setState(() {
                        interest["Interest 3"] = !interest["Interest 3"]!;
                      });
                    }),
                    title: const Text("Interest 3"),
                  ),
                ),
                SizedBox(
                width: (MediaQuery.of(context).size.width - 30 / 3),
                  child: ListTile(
                    leading: Checkbox(value: interest["Interest 4"], onChanged: (value){
                      setState(() {
                        interest["Interest 4"] = ! interest["Interest 4"]!;
                      });
                    }),
                    title: const Text("Interest 4"),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 30,),
          ElevatedButton(onPressed: (){
            if (_formKey.currentState!.validate()){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Form Submitted")));
            }
          }, child: const Text("Submit"))
      ],
      )
      )
  );}
}