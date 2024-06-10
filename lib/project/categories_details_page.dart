import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/course_states.dart';
import 'package:flutter_intern/project/bloc/courses_bloc.dart';
import 'package:flutter_intern/project/technical_models.dart' as t_models;
import 'package:flutter_intern/project/misc.dart';

class CategoriesDetailsPage extends StatefulWidget{
  
  final int categoryId;
  const CategoriesDetailsPage({super.key, required this.categoryId});

  @override
  State<CategoriesDetailsPage> createState() {
    return _CategoriesDetailsPageState();
  }
}


class _CategoriesDetailsPageState extends State<CategoriesDetailsPage>{

  List<t_models.Courses> courses = List.empty(growable: true);  
  void getCourseById(){

  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CourseListStates>(
      builder: (context, state) {

        if(state is! CourseListEmpty){
          List<t_models.CourseByCategories> courseByCategories = BlocProvider.of<CoursesBloc>(context).state.courseByCategories!.where((e) => 
          e.categoriesId == widget.categoryId).toList(); 
          List<t_models.Courses> courses = BlocProvider.of<CoursesBloc>(context).state.courses!.where((e) => courseByCategories.map((cbc) => cbc.courseId).contains(e.id)).toList();
          return Scaffold(
            appBar:const CommonAppBar(),
            body: ListView.builder(
              itemCount: courses.length, 
              itemBuilder: (context, index) => Container( 
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(border: Border.symmetric(horizontal: BorderSide(width: 0.45))),
              child: InkWell(
              onTap: ()=> Navigator.of(context).pushNamed("/courses/${courses.elementAt(index).id}"),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(courses.elementAt(index).title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                          Text(courses.elementAt(index).subtitle, style: const TextStyle(fontSize: 14,),),
                          Text("Rs. ${courses.elementAt(index).price}", style: const TextStyle(fontSize: 12, color: Colors.greenAccent)),
                        ],
                      ),
                    ),
                  const Spacer(),
                    Center(child: SizedBox(height: 128, width: 108, child: Image.network(fit: BoxFit.contain, courses.elementAt(index).image,))),
                  ],),
              ),
              )),
        );

        } 
        return const Scaffold(appBar: CommonAppBar(), body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}