import 'dart:math';

import 'package:collection/collection.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_states.dart';
import 'package:flutter_intern/project/bloc/course_states.dart';
import 'package:flutter_intern/project/bloc/courses_bloc.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;

class CoursesPage extends StatefulWidget{
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState()=> _CoursesPageState();
}

enum Filter {all, popular, recentlyViewed}

class _CoursesPageState extends State<CoursesPage>{ 

  Map<String, List<TModels.Courses>> groupedData = {}; 
  Filter? _filter = Filter.all;
  int catIndex = 0;
  List<String> categoryImages = [
    "https://cdn.dribbble.com/users/1538808/screenshots/16466417/media/5724dbe3c521a2263e376b2e1a3aa6e3.jpg?resize=768x576&vertical=center",
    "https://media.istockphoto.com/id/1288965449/vector/graphic-designer-creating-logo-design-vector-flat-isometric-illustration.webp?s=1024x1024&w=is&k=20&c=a32TLY52v2U-Yxmp3wP-rpOnuAQZsq7yn4j2Bhdf2e8=",
    "https://img.freepik.com/premium-vector/graphic-designer-illustration-concept-white-background_701961-61.jpg?w=740",
    "https://community.nasscom.in/sites/default/files/styles/960_x_600/public/media/images/Picture1_8.png?itok=4YIHRtCq",
    "https://i0.wp.com/plopdo.com/wp-content/uploads/2021/11/20211107_210902-1.jpg?w=720&ssl=1",
    "https://i0.wp.com/plopdo.com/wp-content/uploads/2021/11/20211107_210421.jpg?w=720&ssl=1",
    "https://i0.wp.com/plopdo.com/wp-content/uploads/2021/09/dm5.jpg?w=612&ssl=1",
    "https://i0.wp.com/plopdo.com/wp-content/uploads/2021/11/20211107_210622-1.jpg?w=720&ssl=1",
    "https://static.vecteezy.com/system/resources/thumbnails/008/515/303/small_2x/achievement-or-business-success-reaching-goal-or-target-challenge-and-career-growth-concept-success-businessman-climbing-growth-bar-graph-to-the-top-to-stab-down-winning-flag-vector.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQmA_orGGkUnBhbVxOb109SyCykeLDz_dI7Vk4um94u10CGa7LdjzsVKg9JeNm3rgzlUw&usqp=CAU",
    "https://static.vecteezy.com/system/resources/previews/008/089/740/non_2x/arguments-in-the-organization-arguing-to-find-a-solution-conflict-and-solution-overcome-giant-boss-hand-stopping-him-vector.jpg"
    ];

  Future<void> groupData(List<TModels.CourseCategories> courseCategories,
    List<TModels.CourseByCategories> courseByCategories,
    List<TModels.Courses> courses) async{     
    for(var item in courseByCategories){
      var category = courseCategories.firstWhere((element) => element.id== item.categoriesId);
      var course = courses.firstWhere((element) => element.id == item.courseId);
      
      if(!groupedData.containsKey(category.title)){
        groupedData[category.title] = [];
      }
      setState(() { 
        groupedData[category.title]!.add(course);
      });
    } 
  } 

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
      builder: (context, state) => BlocListener<CoursesBloc, CourseListStates>(
      listener: (context, state){
        if (state is! CourseListEmpty){
          groupData(state.courseCategories!, state.courseByCategories!, state.courses!); 
        }
      },
        child: BlocBuilder<CoursesBloc, CourseListStates>(
          builder:(context, courseState)=> Scaffold(
            appBar: const CommonAppBar(),
            bottomNavigationBar: (state is AuthorizedAuthState)? const CommonNavigationBar(): const UnauthorizedNavigationBar(),
            body: SingleChildScrollView(
              child: (courseState is CourseListEmpty) ? const Center(child: CircularProgressIndicator(),) :Column(children: [
                Text("Courses", style: Theme.of(context).textTheme.headlineMedium,),
                const SizedBox(height: 20,),
                 Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(child: const Card(
                    elevation: 0,
                    child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("All"),
                  ),), onTap: (){
                    setState(() {
                      _filter = Filter.all;
                    });
                  },),
                  InkWell(child: const Card(
                    elevation: 0,
                    child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Popular"),
                  ),), onTap: (){
                    setState(() {
                      _filter = Filter.popular;
                    });
                  },),
                  InkWell(child: const Card(
                    elevation: 0,
                    child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Recently Viewed"),
                  ),), onTap: (){
                    setState(() { 
                      _filter = Filter.recentlyViewed;
                    });
                  },),
                  ],),
                Wrap(children: courseState.courses!.where((e){
                  if(_filter == Filter.all){
                   return true; 
                  }
                  if(_filter == Filter.recentlyViewed){
                   return e.isRecentlyViewedCourse; 
                  }

                  if(_filter == Filter.popular){
                    return e.isTopCourse;
                  }
                  else{
                    return true;
                  }
                }).map((e) => 
                GestureDetector(
                      onTap: ()=> {Navigator.of(context).pushNamed('/courses/${e.id}')},
                        child: Column(children: [
                          const SizedBox(height: 5,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                            child: Image.network(e.image,height: 156, width: 156,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.title),
                          ),
                          ],
                          ),
                      )
                ).toList(),), 
                const SizedBox(height: 10,),
                Text("Categories", style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10,),
                Wrap(
                  children: groupedData.entries.mapIndexed((index, e) {
                    return InkWell(
                    onTap: (){
                      showModalBottomSheet(context: context, builder: (builder){
                        return BottomSheet(
                        showDragHandle: true,
                        dragHandleColor: Colors.grey,
                        onClosing: (){},
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.all(14),
                              width: MediaQuery.of(context).size.width,
                              child: SingleChildScrollView(
                                child: Center(
                                  child: Wrap(children: e.value.map((e) => 
                                  GestureDetector(
                                      onTap: ()=> {Navigator.pushNamed(context, '/courses/${e.id}')},
                                      child: Column(children: [
                                        Text(e.title),
                                        const SizedBox(height: 5,),
                                        Image.network(e.image, height: 126, width: 126,),
                                        const SizedBox(height: 5,),
                                      ],),
                                    )
                                  ).toList(),),
                                ),
                              ),
                              );
                          }
                        ) ;
                      });
                    },
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(image: NetworkImage(categoryImages.elementAt(index)), height: 128, width: 128,),
                        ),
                        Text(e.key),
                      ],),
                    ),
                  );
                  }).toList(),
                ),           
              ]
              ),
            ),
          ),
        ),
      ),
    );
  } 
}