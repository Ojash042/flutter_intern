import 'package:equatable/equatable.dart';
import 'package:flutter_intern/project/technical_models.dart';

class CourseListStates extends Equatable{
  const CourseListStates({this.courses, this.courseByCategories, this.courseCategories});

  final List<Courses>? courses;
  final List<CourseByCategories>? courseByCategories;
  final List<CourseCategories>? courseCategories;
  
  @override
  List<Object?> get props => [courses];
}

class CourseListEmpty extends CourseListStates{
  const CourseListEmpty():super(courses: null);
}