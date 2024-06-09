import 'package:equatable/equatable.dart';

class CourseListEvents extends Equatable{
  @override
  List<Object?> get props => [];

}

class CourseListInitialize extends CourseListEvents{}

class CourseListFetched extends CourseListEvents{}