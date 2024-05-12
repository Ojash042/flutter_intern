import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;
import 'package:shared_preferences/shared_preferences.dart';

class CoursesDetailsPage extends StatefulWidget{
  State<CoursesDetailsPage> createState() => _CoursesDetailsPageState();
  final String courseId;
  const CoursesDetailsPage({super.key, required this.courseId});
}

class SyllabusPage extends StatelessWidget{  
  List<TModels.Syllabus> syllabus;
  SyllabusPage({super.key, required this.syllabus});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class FAQPage extends StatelessWidget{
  List<TModels.FAQ> faqs;
  FAQPage({super.key, required this.faqs}); 
@override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
} 

class DescriptionPage extends StatelessWidget{
  final String description, overview;
  final double price;
  final List<TModels.Instructor> instructors;
  final List<String> skills;
  const DescriptionPage({super.key, required this.description, required this.overview, required this.price, required this.instructors, 
  required this.skills});

  @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(description),
              ), 
              const SizedBox(height: 30,),
              Text('Price: $price'),
              const SizedBox(height: 10,),
              const Text("Instructors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),), 
              Text(instructors.length.toString()),
              ListView.builder(
                shrinkWrap: true,
                itemCount: instructors.length,
                itemBuilder: (context, index){
                  return Column(children: [
                   Text(instructors.elementAt(index).name),
                  Text('-\t${instructors.elementAt(index).summary}')
                  ]);
                })
            ],),

          ),
        ),
      );
    }
}

class _CoursesDetailsPageState extends State<CoursesDetailsPage> with SingleTickerProviderStateMixin{
List<TModels.Courses> courses = List.empty(growable: true);
List<TModels.Instructor> instructors = List.empty(growable: true);
TModels.Courses? currentCourse;
List<TModels.Instructor> currentCourseInstructor = List.empty(growable: true);
late TabController _tabController;

static const List<Tab> courseDetailsTab = [
  Tab(text: "Description",),
  Tab(text: "Syllabus"),
  Tab(text: "FAQs",),
];



Future<void> getDataFromSharedPrefs() async{
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      print(sharedPreferences.getString("courses"));
      String? coursesJson = sharedPreferences.getString("courses"); 
      String? instructorJson = sharedPreferences.getString("instructor");
    List<dynamic> decoderCourse = jsonDecode(coursesJson!)["courses"];
    List<dynamic> decoderInstructor = jsonDecode(instructorJson!)["instructor"];
    courses = decoderCourse.map((e) => TModels.Courses.fromJson(e)).toList(); 
    instructors = decoderInstructor.map((e) => TModels.Instructor.fromJson(e)).toList(); 
    for (var element in instructors) {
      print(element.id);
    }
    currentCourse = courses.firstWhere((element) => element.id == int.parse(widget.courseId));
    for(int item in currentCourse!.instructors){
      currentCourseInstructor.add(instructors.firstWhere((element) =>element.id ==  item));
      print(currentCourseInstructor);
    }

    }
    catch(e){
      print(e);
    }
    // sharedPreferences = await SharedPreferences.getInstance();
        }

  @override
    void initState(){
      super.initState();
      _tabController = TabController(length: 3, vsync: this);
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
      ),
    drawer: MyDrawer(),
    body:
    // Center(child: Text(int.parse(widget.courseId).toString()),)
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(children: [
              Image.network(currentCourse!.image, height: 124,width: 124,),
              const SizedBox(width: 10,),
              Text(currentCourse!.title, style: Theme.of(context).textTheme.displayMedium,),
          ],),
        const SizedBox(height: 30,),
        const Divider(),
        TabBar(tabs: const [
        Tab(text: "Description",),
        Tab(text: "Syllabus"),
        Tab(text: "FAQs",),
],controller: _tabController,),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
            Align(
            alignment: Alignment.topLeft,
              child: DescriptionPage(description: currentCourse!.description, overview: currentCourse!.overview, price: currentCourse!.price,
                instructors: currentCourseInstructor, skills: currentCourse!.skills,
              ),
            ),
            SyllabusPage(syllabus: currentCourse!.syllabus,),
            FAQPage(faqs: currentCourse!.faqs,),
          ]),
        ),
        ],),
    ) 
    );
  } 
}