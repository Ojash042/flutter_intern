import 'dart:math';

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

class _CoursesPageState extends State<CoursesPage>{ 

  Map<String, List<TModels.Courses>> groupedData = {}; 
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
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: (courseState is CourseListEmpty) ? const Center(child: CircularProgressIndicator(),) :Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text("Courses", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                  const SizedBox(height: 5,),
                  const Text("Topics", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10,),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: courseState.courseCategories!.map((e) => 
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        shape: const LinearBorder(),
                        color: HSLColor.fromAHSL(1, Random().nextDouble() * 360.0, max(0.65, Random().nextDouble()), min(0.89, Random().nextDouble() + 0.69)).toColor(),
                        child: InkWell(child: Padding(padding:const EdgeInsets.all(12), child: Text(e.title)), onTap: (){
                          Navigator.of(context).pushNamed("/category/${e.id}");
                        },),
                      ),
                    ),
                    ).toList())), 
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        const Text("Top Courses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        const Spacer(),
                        TextButton(onPressed: (){
                          showDialog(context: context, builder: (build){
                            //courseState.courses.map(toElement)
                            return Scaffold(appBar:const ModalAppBar(title: "Top Courses"),
                            body: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: SingleChildScrollView(
                                child: Column(children: courseState.courses!.take(4).map( (e) => VerticalCourseItem(course: e,),).toList(),   
                                                     ),
                              ),
                            ),);
                          });
                        }, child: const Text("See More"))
                      ],
                    ), 
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: courseState.courses!.where((e) => e.isTopCourse ).map((e)=> HorizontalCourseItem(course:  e)).toList(),),
                    ),
                
                    const SizedBox(height: 20,), 
                    Row(
                      children: [
                        const Text("Recently Viewed", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        const Spacer(),
                        TextButton(onPressed: (){
                          showDialog(context: context, builder: (builder){
                            return  Scaffold(appBar: const ModalAppBar(title: "Recently Viewed",),
                            body: Padding(padding:const EdgeInsets.all(14), child: SingleChildScrollView(child: Column(children: 
                            courseState.courses!.where((e) => e.isRecentlyViewedCourse).map((e) => VerticalCourseItem(course: e)).toList(),
                            ),),),
                            );
                          });
                        }, child: const Text("See More")),
                      ],
                    ), 
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: courseState.courses!.where((e) => e.isRecentlyViewedCourse ).map((e)=> HorizontalCourseItem(course: e)).toList(),),
                    ),
 
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        const Text("Get Started With These Courses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        const Spacer(),
                        TextButton(onPressed: (){
                          showDialog(context: context, builder: (build){
                            return Scaffold(appBar:const ModalAppBar(title: "Get Started",),
                            body: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: SingleChildScrollView(child: Column(children: courseState.courses!.map((e) => VerticalCourseItem(course: e)).toList(),),),
                            ),
                            );
                          });
                        }, child: const Text("See More")),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child:  Column(
                        children: courseState.courses!.take(4).map( (e) => GestureDetector(
                          onTap: (){},
                          child: Row(children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text(e.title, maxLines: null, style: const TextStyle(fontSize: 16),),
                                  const SizedBox(height: 4,),
                                  Text(e.overview, maxLines: 2, overflow: TextOverflow.clip, style: TextStyle(color: Colors.grey[500],fontSize: 12, fontWeight: FontWeight.w200),),
                                  const SizedBox(height: 4,),
                                  Text('रू ${e.price.toString()}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w200, color: Colors.black),)
                                ],),
                              ),
                              const Spacer(),
                              SizedBox(
                              height: 96,
                              width: 96
                              ,
                              child: AspectRatio(aspectRatio: 4/3, child: Image.network(e.image),),
                              )
                            ],),
                        ),).toList(),   
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        const Text("Others", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        const Spacer(),
                        TextButton(onPressed: () { 
                        showDialog(context: context, builder: (build) {
                          return Scaffold(appBar: const ModalAppBar(title: "Other Courses",),
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(child: Column(children: courseState.courses!.where((e) => !e.isRecentlyViewedCourse && !e.isTopCourse)
                            .map((e) => VerticalCourseItem(course: e)).toList(),),),
                          ),
                          );
                        });
                        }, child: const Text("See More"),),
                      ],
                    ), 
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: courseState.courses!.where((e) => !e.isRecentlyViewedCourse && !e.isTopCourse).map((e)=> HorizontalCourseItem(course: e)).toList(),),
                    ), 
                  const SizedBox(height: 10,),
                  const SizedBox(height: 10,),
                  // Wrap(
                  //   children: groupedData.entries.mapIndexed((index, e) {
                  //     return InkWell(
                  //     onTap: (){
                  //       showModalBottomSheet(context: context, builder: (builder){
                  //         return BottomSheet(
                  //         showDragHandle: true,
                  //         dragHandleColor: Colors.grey,
                  //         onClosing: (){},
                  //           builder: (context) {
                  //             return Container(
                  //               padding: const EdgeInsets.all(14),
                  //               width: MediaQuery.of(context).size.width,
                  //               child: SingleChildScrollView(
                  //                 child: Center(
                  //                   child: Wrap(children: e.value.map((e) => 
                  //                   GestureDetector(
                  //                       onTap: ()=> {Navigator.pushNamed(context, '/courses/${e.id}')},
                  //                       child: Column(children: [
                  //                         Text(e.title),
                  //                         const SizedBox(height: 5,),
                  //                         Image.network(e.image, height: 126, width: 126,),
                  //                         const SizedBox(height: 5,),
                  //                       ],),
                  //                     )
                  //                   ).toList(),),
                  //                 ),
                  //               ),
                  //               );
                  //           }
                  //         ) ;
                  //       });
                  //     },
                  //     child: Card(
                  //       elevation: 0,
                  //       color: Colors.white,
                  //       child: Column(children: [
                  //         Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Image(image: NetworkImage(categoryImages.elementAt(index)), height: 128, width: 128,),
                  //         ),
                  //         Text(e.key),
                  //       ],),
                  //     ),
                  //   );
                  //   }).toList(),
                  // ),           
                ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  } 
}

class HorizontalCourseItem extends StatelessWidget {
  final TModels.Courses course;
  const HorizontalCourseItem({
    super.key,
    required this.course
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/courses/${course.id}'),
        child: SizedBox(
        width: 128,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(
              height: 128,
              width: 164,
              child: AspectRatio(aspectRatio: 16/9, child: Image.network(course.image, fit: BoxFit.cover,),),
            ),
            const SizedBox(height: 10,),
            Text(course.title, style: const TextStyle(fontSize: 16),),
            const SizedBox(height: 10,),
            Text(course.overview, maxLines: 2, style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 12, color: Colors.grey[500], ),),
            const SizedBox(height: 10,),
            Text(' रू ${course.price}', style: const TextStyle(fontSize: 12, color: Colors.black),),
          ],),
        ),
      ),
    );
  }
}

class VerticalCourseItem extends StatelessWidget {
  final TModels.Courses course;
  const VerticalCourseItem({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).popAndPushNamed('/courses/${course.id}');
      },child: Row(children: [
    SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(course.title, maxLines: null, style: const TextStyle(fontSize: 16),),
        const SizedBox(height: 4,),
        Text(course.overview, maxLines: 2, overflow: TextOverflow.clip, style: TextStyle(color: Colors.grey[500],fontSize: 12, fontWeight: FontWeight.w200),),
        const SizedBox(height: 4,),
        Text('रू ${course.price.toString()}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200, color: Colors.grey[500]),)
      ],),
    ),
    const Spacer(),
    SizedBox(
    height: 96,
    width: 96
    ,
    child: AspectRatio(aspectRatio: 4/3, child: Image.network(course.image),),
    )],),);
  }
}