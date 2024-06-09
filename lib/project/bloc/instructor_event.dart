import 'package:equatable/equatable.dart';

class InstructorEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InstructorInitialize extends InstructorEvent{}

class InstructorFetched extends InstructorEvent{}