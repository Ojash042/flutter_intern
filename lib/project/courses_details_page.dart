import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;
import 'package:shared_preferences/shared_preferences.dart';

class CoursesDetailsPage extends StatefulWidget{
  @override
  State<CoursesDetailsPage> createState() => _CoursesDetailsPageState();
  final String courseId;
  const CoursesDetailsPage({super.key, required this.courseId});
}

class SyllabusPage extends StatelessWidget{  
  final List<TModels.Syllabus> syllabus;
  const SyllabusPage({super.key, required this.syllabus});

  @override
  Widget build(BuildContext context) {

  return Container(
    padding: const EdgeInsets.all(8.0),
    alignment: Alignment.topLeft,
    child: SingleChildScrollView(child: 
    Wrap(
      children: syllabus.map((e) => ExpansionTile(
      expandedAlignment: Alignment.topLeft,
        title: Text(e.title),
        children:[
          const SizedBox(height: 15,),
          const Align(alignment: Alignment.topLeft, child: Text("Summary", style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline
          ),),),
          const SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Align(alignment: Alignment.topLeft, child: Text(e.summary, maxLines: null,)),
          ),
          const SizedBox(height: 15,),
          Row(children: [
            const Text("Total Content: ", style: TextStyle(fontSize: 14,decoration: TextDecoration.underline, fontWeight: FontWeight.bold),),
            const SizedBox(width: 15,),
            Text(e.totalContent.toString()),
          ],),
          const SizedBox(height: 15,),
          Row(children: [
            const Text("Hours to be completed: ", style: TextStyle(fontSize: 14,decoration: TextDecoration.underline, fontWeight: FontWeight.bold),),
            const SizedBox(width: 15,),
            Text(e.hoursToBeCompleted.toString()),
          ],),
          const SizedBox(height: 30,)
          ],
        )).toList(),
    ),),
  );
  }
}


class FAQPage extends StatelessWidget{
  final List<TModels.FAQ> faqs;
  const FAQPage({super.key, required this.faqs}); 
@override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Wrap(alignment: WrapAlignment.start,
        children: faqs.map((e) => ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Text(e.title), children: [
          const SizedBox(width: 30,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              const Text("Subtitle:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
              const SizedBox(width: 5,),
              Text(e.subtitle),
              ],),
          ),
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              const Text("Description:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
              const SizedBox(width: 5,),
              Text(e.description),
              ],),
          ),
          const SizedBox(height: 30,),
        ],)).toList(),),
      ),
      );
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
      return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
              const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(description),
              ), 
              const SizedBox(height: 30,),
              Row(children: [
                const Text('Price: ', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, fontSize: 18),),
                const SizedBox(width: 10,),
                Text(price.toString()),
              ],),
              const SizedBox(height: 30,),
              const Text("Instructors details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),), 
              const SizedBox(height: 10,),
              Row(children: [
                const Text("No. of instructors: "),
                Text(instructors.length.toString()),
              ],),
              const SizedBox(height: 10,),
              ListView.builder( 
                shrinkWrap: true,
                itemCount: instructors.length,
                itemBuilder: (context, index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Row(children: [
                      const Text("Instructor: ", style: TextStyle(fontStyle: FontStyle.italic),),
                      const SizedBox(width: 5,),
                      Text(instructors.elementAt(index).name),
                    ],),
                    RichText(text: TextSpan(
                      children: [
                        const WidgetSpan(child:SizedBox(width: 4,)),
                        const TextSpan(text: '-'),
                        const WidgetSpan(child: SizedBox(width: 12,),),
                       TextSpan(text:instructors.elementAt(index).summary )],
                      )),
                    Text('-\t${instructors.elementAt(index).summary}'),
                  ]);
                }),
                const SizedBox(height: 20,),
                const Text("Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                const SizedBox(height: 10,),
                Wrap(children: skills.map((e) => Card(child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(e),
                ),)).toList()),
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

Future<void> getDataFromSharedPrefs() async{
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? coursesJson = sharedPreferences.getString("courses"); 
      String? instructorJson = sharedPreferences.getString("instructor");
    List<dynamic> decoderCourse = jsonDecode(coursesJson!)["courses"];
    List<dynamic> decoderInstructor = jsonDecode(instructorJson!)["instructor"];
    courses = decoderCourse.map((e) => TModels.Courses.fromJson(e)).toList(); 
    instructors = decoderInstructor.map((e) => TModels.Instructor.fromJson(e)).toList(); 
    currentCourse = courses.firstWhere((element) => element.id == int.parse(widget.courseId));
    for(int item in currentCourse!.instructors){
      currentCourseInstructor.add(instructors.firstWhere((element) =>element.id ==  item));
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
              Image.network(currentCourse!.image, height: 196,width: 196,),
              const SizedBox(width: 10,),
              Column(
                children: [
                  Text(currentCourse!.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  Text(currentCourse!.subtitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w100), maxLines: null,),
                ],
              ),
          ],),

        const SizedBox(height: 30,),
        const Divider(),
        TabBar(tabs: const [
          Tab(text: "Description",),
          Tab(text: "Syllabus"),
          Tab(text: "FAQs",),
        ],
        controller: _tabController,),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
            DescriptionPage(description: currentCourse!.description, overview: currentCourse!.overview, price: currentCourse!.price,
              instructors: currentCourseInstructor, skills: currentCourse!.skills,
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