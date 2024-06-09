import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/instructor_event.dart';
import 'package:flutter_intern/project/bloc/instructor_state.dart';
import 'package:flutter_intern/project/technical_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstructorBloc extends Bloc<InstructorEvent, InstructorState>{
  InstructorBloc():super(InstructorEmpty()){
    on<InstructorInitialize>((event, emit) => _fetchInstructors(event, emit));
    on<InstructorFetched>((event, emit) => {});
  }
  
  void _fetchInstructors(InstructorEvent event, Emitter<InstructorState> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String instructorJson = sharedPreferences.getString("instructor")!;
    Iterable decoderInstructor = jsonDecode(instructorJson)["instructor"];
    List<Instructor> instructors = decoderInstructor.map((e) => Instructor.fromJson(e)).toList();
    emit(InstructorState(instructors: instructors));
    return;
  }

}