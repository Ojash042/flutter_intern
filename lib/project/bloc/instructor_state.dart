import 'package:equatable/equatable.dart';
import 'package:flutter_intern/project/technical_models.dart';

class InstructorState extends Equatable{
  final List<Instructor>? instructors;
  const InstructorState({this.instructors});
  
  @override
  List<Object?> get props => [instructors];
}

class InstructorEmpty extends InstructorState{
  InstructorEmpty():super(instructors: []);
}