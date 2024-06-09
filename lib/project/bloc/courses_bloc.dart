import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/course_events.dart';
import 'package:flutter_intern/project/bloc/course_states.dart';
import 'package:flutter_intern/project/technical_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursesBloc extends Bloc<CourseListEvents, CourseListStates>{
  CoursesBloc():super(const CourseListEmpty()){
    on<CourseListInitialize>((event, emit) => _fetchCourses(event, emit));
  }
  
  void _fetchCourses(CourseListEvents event, Emitter<CourseListStates> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String coursesJson = sharedPreferences.getString("courses")!;
    try{
      Iterable decoderCourse = jsonDecode(coursesJson)["courses"];
      List<Courses> courses =  decoderCourse.map((e) => Courses.fromJson(e)).where((e) => e.id > 0).toList();

      String courseByCategoriesJson = sharedPreferences.getString("course_by_categories")!;
      Iterable decoderCourseByCategories = jsonDecode(courseByCategoriesJson)["courses_by_categories"];
      List<CourseByCategories> courseByCategories =  decoderCourseByCategories.map((e) => CourseByCategories.fromJson(e)).where((e) => e.categoriesId > 0).toList();

      String courseCategories  = sharedPreferences.getString('course_categories')!;
      Iterable decoderCourseCategories = jsonDecode(courseCategories)["course_categories"];
      List<CourseCategories> courseCategoriesList =  decoderCourseCategories.map((e) => CourseCategories.fromJson(e)).where((e) => e.id>0).toList();

      emit(CourseListStates(courses: courses, courseByCategories: courseByCategories, courseCategories: courseCategoriesList));

    }
    catch(e){
      print(e);
    }
      }
}