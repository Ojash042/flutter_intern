import 'package:flutter/material.dart';
import 'package:flutter_intern/day_1.dart';

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent)),
      title: "Day 7",      
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
 State<MyHomePage> createState() => _MyHomePageState(); 
}

class _MyHomePageState extends State<MyHomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Assessment"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: const FormData(),
    );
  }
}


class User{
  User({required this.id, required this.name, required this.gender, required this.dob, required this.interestAreas, required this.skills, required this.url,
  required this.isMarried, required this.isStudent});
  final int id; 
  final String name;
  final String gender;
  final DateTime dob;
  final List<String> interestAreas;
  final List<String> skills;
  final String url;
  final bool isStudent;
  final bool isMarried;
}

class Skill{
  Skill({required this.id, required this.skillName});
  int id;
  String skillName; 
}

class WorkExperience{
  WorkExperience({required this.id, required this.jobTitle, required this.summary, required this.organizationName, required this.startDate, required this.endDate});
  final int id;
  final String jobTitle;
  final String summary;
  final String organizationName;
  final DateTime startDate;
  final DateTime endDate;
}

class Achievements{
  Achievements({required this.id, required this.title, required this.summary, required this.achievedDate});
  final int id;
  final String title;
  final String summary;
  final DateTime achievedDate;
}

class EducationLevel{
  EducationLevel({required this.id, required this.organizationName, required this.level, required this.startDate, required this.endDate, required this.achievements});
  final int id;
  final String organizationName;
  final String level;
  final DateTime startDate;
  final DateTime endDate;
  final List<Achievements> achievements;
}

class CVModel{
  CVModel({required this.firstName, required this.middleName, required this.lastName, required this.age, required this.gender, required this.skills, required this.workExperiences});
  final String firstName;
  final String middleName;
  final String lastName; 
  final int age;
  final String gender;
  final List<Skill> skills;
  final List<WorkExperience> workExperiences;
}

class FormData extends StatefulWidget{
const FormData({super.key});
@override
State<FormData> createState() => _FormDataState();
}
class _FormDataState extends State<FormData>{

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
              Text("Sign Up", style: Theme.of(context).textTheme.displayMedium,),
              const SizedBox(height: 30,),
              Text("")
          ]
        ),
      ),
    );
  }
}
