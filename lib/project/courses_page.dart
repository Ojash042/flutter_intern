import 'package:flutter/material.dart';
import 'package:flutter_intern/project/auth_provider.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_intern/project/technical_models.dart' as TModels;

class CoursesPage extends StatefulWidget{
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState()=> _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage>{ 

  List<TModels.CourseCategories> courseCategories = List.empty(growable: true);
  List<TModels.CourseByCategories> courseByCategories = List.empty(growable: true);
  List<TModels.Courses> courses = List.empty(growable: true);
  List<TModels.Instructor> instructors = List.empty(growable: true);
  List<TModels.Courses> popularCourse = List.empty(growable: true);
  List<TModels.Courses> recentlyViewedCourse = List.empty(growable: true);
  List<List<dynamic>> coursesGroupedByCategories = [];

  Map<String, List<TModels.Courses>> groupedData = {}; 
  bool isLoggedIn = false;
  bool checkLoggedIn(){
    Provider.of<AuthProvider>(context, listen: false).isLoggedIn().then((value){
    setState(() {  
      isLoggedIn = value;
    });});
    return isLoggedIn;
  }
  
  Future<void> getDataFromSharedPrefs() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();  
    String? courseByCategoriesJson = sharedPreferences.getString("course_by_categories");
    String? coursesJson = sharedPreferences.getString("courses");
    String? courseCategoriesJson = sharedPreferences.getString("course_categories");
    String? instructorJson = sharedPreferences.getString("instructor");
    List<dynamic> decoderCourseCategories = jsonDecode(courseCategoriesJson!)["course_categories"];
    List<dynamic> decoderCourseByCategories = jsonDecode(courseByCategoriesJson!)["courses_by_categories"];
    List<dynamic> decoderCourses = jsonDecode(coursesJson!)["courses"];
    List<dynamic> decoderInstructor = jsonDecode(instructorJson!)["instructor"];
    
    courseCategories = decoderCourseCategories.map((e) => TModels.CourseCategories.fromJson(e)).toList();
    courseByCategories = decoderCourseByCategories.map((e) => TModels.CourseByCategories.fromJson(e)).toList(); 
    courses = decoderCourses.map((e) => TModels.Courses.fromJson(e)).toList();
    instructors = decoderInstructor.map((e) => TModels.Instructor.fromJson(e)).toList();  
   
    popularCourse = courses.where((element) => element.isTopCourse == true).toList();
    recentlyViewedCourse = courses.where((element) => element.isRecentlyViewedCourse == true).toList();


    for(var item in courseByCategories){
      print(item.createdAt);
    }
    for(var item in courseByCategories){
      var category = courseCategories.firstWhere((element) => element.id== item.categoriesId);
      var course = courses.firstWhere((element) => element.id == item.courseId);
      
      if(!groupedData.containsKey(category.title)){
        groupedData[category.title] = [];
      }
      groupedData[category.title]!.add(course);
    }
    
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
      appBar: CommonAppBar(),
      bottomNavigationBar: CommonNavigationBar(),
      drawer: checkLoggedIn() ? const LoggedInDrawer(): MyDrawer(),
      body: SingleChildScrollView(
        child: Column(children: [
          Text("Courses", style: Theme.of(context).textTheme.headlineMedium,),
          const SizedBox(height: 20,),
          Text("Popular Courses", style: Theme.of(context).textTheme.headlineSmall,),
          const SizedBox(height: 10,),
          Column(
            children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: 
                popularCourse.map((e) => 
                GestureDetector(
                onTap: ()=> {Navigator.of(context).pushNamed('/courses/${e.id}')},
                  child: Column(children: [
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(e.image,height: 124, width: 124,),
                    ),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(e.title),
                    ),
                    const SizedBox(height: 5,),
                    ],
                    ),
                )).toList()
              )
            ),
            const SizedBox(height: 20,),
            Text("Recently Viewed Courses", style: Theme.of(context).textTheme.headlineSmall,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal ,
              child: Row(children: recentlyViewedCourse.map((e) => 
              GestureDetector(
                onTap: ()=> {Navigator.of(context).pushNamed('/courses/${e.id}')},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    const SizedBox(height: 5,),
                    Image.network(e.image, height: 124, width: 124,),
                    const SizedBox(height: 5,),
                    Text(e.title),
                    const SizedBox(height: 5,),
                  ]
                    ),
                ),
              ),
              ).toList()
              ),
            ),
            ListView.builder(
              itemCount: groupedData.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                var categoryTitle = groupedData.keys.elementAt(index);
                var courseList = groupedData[categoryTitle];
                return ExpansionTile(
                  title: Text(categoryTitle),
                  children: [
                    SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                      child: Row(children: courseList!.map((e) => 
                      GestureDetector(
                        onTap: ()=> {Navigator.pushNamed(context, '/courses/${e.id}')},
                        child: Column(children: [
                          const SizedBox(height: 5,),
                          Text(e.title),
                          const SizedBox(height: 5,),
                          Image.network(e.image, height: 248, width: 248,),
                          const SizedBox(height: 5,),
                        ],),
                      )).toList(),),
                    )
                  ],
                  );
              })
            // ListView.builder(
            //   shrinkWrap: true,
            //   itemCount: courseCategories.length,
            //   itemBuilder: (context, index)=>
            // Container(
            //   child: Text(courseCategories.elementAt(index).title),
            //   
            // ),
            // ),
            //   ListView.builder(
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) =>
            //     Row(
            //       children: [
            //       Text(popularCourse.elementAt(index).title), 
            //   ],
            //  )
            // )
            ],
          ),
          
        ]
        ),
      ),
    );
  } 
}