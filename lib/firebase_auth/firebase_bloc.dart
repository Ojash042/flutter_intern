import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/firebase_auth/auth_events.dart';
import 'package:flutter_intern/firebase_auth/auth_states.dart';

class UserObserver extends BlocObserver{
  const UserObserver();

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }
  
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }
}

class AuthenticationBloc extends Bloc<AuthenticationEvents, AuthenticationStates>{
  AuthenticationBloc():super(const UnknownState()){
  on<AuthenticationUnknownEvent>((event, emit) => unknown(event, emit),);
  on<AuthenticationRequestLogin>((event, emit) => loginOperation(event, emit),);
  on<AuthenticationRequestSignUp>((event, emit) => signUpOperation(event, emit),);
  }

  void unknown(AuthenticationEvents event, Emitter<AuthenticationStates> emit){
    FirebaseAuth.instance.currentUser;
    if(FirebaseAuth.instance.currentUser != null){
      emit(LoggedInState(isLoggedIn: true, loggedInEmail: FirebaseAuth.instance.currentUser!.email!, user: FirebaseAuth.instance.currentUser!));
    }
    else{
      emit(const UnauthenticatedState());
    }
  }
  
  void loginOperation(AuthenticationRequestLogin event, Emitter<AuthenticationStates> emit){
    if(FirebaseAuth.instance.currentUser == null){
    FirebaseAuth.instance.signInWithEmailAndPassword(email: event.email, password: event.password).then((value) =>
     value.user != null ? emit(LoggedInState(
      isLoggedIn: true, loggedInEmail: value.user!.email!, user: value.user!)): null);
    } 
  }

  void signUpOperation(AuthenticationEvents event, Emitter<AuthenticationStates> emit){ 
    if(FirebaseAuth.instance.currentUser==null){
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: "", password: "");
    }
  }

}