import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_intern/firebase_auth/misc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main(List<String> args) async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseAuth.instance
  // .authStateChanges().listen((User? user) {
  //   if(user == null){
  //
  //   }
  //   else{
  //     
  //   }
  //  });
  runApp(const App());
}

class App extends StatefulWidget{
  const App({super.key});
  @override
  State<App> createState() {
    return _AppState();
  }
}

class _AppState extends State<App>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.quicksandTextTheme(),useMaterial3: true,colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime)),
      routes:{
        "/init": (context)=> const InitPage(), 
        "/": (context) => HomePage(), 
        "/login": (context) => LoginPage(),
        "/signUp": (context) => const DefaultSignUpPage(),
        "/gSignUp": (context) => const GoogleSignUpPage(),
      },
      initialRoute: "/init",
      
    );
  }
}

class InitPage extends StatefulWidget{
  const InitPage({super.key});
  @override
  State<InitPage> createState() {
    return _InitPageState();
  }
}

class _InitPageState extends State<InitPage>{

  void rerouteToPage(){
    print("SJFkSDJhfahfakjfhasjkfhsjlk.hskfjhashfkajslfhlkj");
    print('${FirebaseAuth.instance.currentUser !=null}') ;
    (FirebaseAuth.instance.currentUser != null) ? 
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false, arguments: {'user':FirebaseAuth.instance.currentUser}):
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route)=> false); 
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){rerouteToPage();});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CommonAppBar(),
    body: Container(),);
  }
}

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  } 
}

class _LoginPageState extends State<LoginPage>{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  UserCredential? userCredentials;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: SingleChildScrollView(child: 
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(children: [
          const SizedBox(height: 30,),
          Text("Login", style: Theme.of(context).textTheme.headlineSmall,),
          const SizedBox(height: 30,),
          TextFormField(decoration: const InputDecoration(hintText: "Email: "), controller: emailController,),
          const SizedBox(height: 30,),
          TextFormField(decoration: InputDecoration(hintText: "Password: ", suffixIcon: IconButton(onPressed: (){
            setState(() {
              passwordVisible =! passwordVisible; 
            });
          }, icon: Icon(passwordVisible? Icons.visibility_off_outlined: Icons.visibility_outlined),)),obscureText: passwordVisible, controller: passwordController,),
          const SizedBox(height: 50,),
          OutlinedButton.icon(onPressed: () async{
            try{
              userCredentials = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
              Navigator.of(context).popAndPushNamed('/', arguments: {'user': userCredentials!.user});
            }
            on FirebaseAuthException catch(e){
              showDialog(context: context, builder: (builder)=> 
                AlertDialog(
                  title: const Text("Error"),
                  content: Text(e.message!),
                  actions: [TextButton.icon(onPressed: (){Navigator.of(context).pop();}, icon: const Icon(Icons.close_outlined), label: const Text("Close"))],
                ));
              }
            } , icon: const Icon(Icons.login), label: const Text("Login")),
          TextButton.icon(onPressed: (){
            Navigator.of(context).pushNamed('/signUp');
          }, label: const Text("Sign Up With E-Mail"), icon: const Icon(Icons.email_outlined),),
          OutlinedButton(onPressed: () async{
            final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
            final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
            final credentials =GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken,
            );
            try{
              UserCredential userCredentials = await FirebaseAuth.instance.signInWithCredential(credentials);
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false, arguments: {'user': userCredentials.user});
            }
            on FirebaseAuthException catch(e){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: const Text("Alert"),
                  content: Text(e.message!),
                  actions: [TextButton.icon(onPressed: (){}, label: const Text(""))],);
              });
            }
          }, child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Row(children: [
                Image.network('https://logo.clearbit.com/www.google.com', width: 12, height: 12,), 
                const SizedBox(width: 10,),
                const Text("Sign Up With Google")],),
            ),
          ))
        ],),
      ),),
    );
  }
}

class DefaultSignUpPage extends StatefulWidget{
  const DefaultSignUpPage({super.key});

  @override
  State<DefaultSignUpPage> createState() {
    return _DefaultSignUpageState();
  }
}

class _DefaultSignUpageState extends State<DefaultSignUpPage>{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: SingleChildScrollView(child: 
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text("Sign Up"),
            const SizedBox(height: 30,),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Email"), 
                    controller: emailController,
                    validator: (value) => ( value != null && value.isNotEmpty && !emailRegex.hasMatch(value))?"Invalid Email Format":null ,
                    ),
                  const SizedBox(height: 30,),
                  TextFormField(decoration: const InputDecoration(hintText: "Password"), controller: passwordController,
                  validator: (value)=>(value!=null && value.isEmpty)? "Password is invalid": null ,
                  ),
                  const SizedBox(height: 30,),
                  TextFormField(decoration: const InputDecoration(hintText: "Confirm Password"),
                   controller: confirmPasswordController,
                   validator: (value)=>(value!=null && value.isNotEmpty && value != passwordController.text)? "Passwords do not match": null ,
                   ),
                  const SizedBox(height: 30,),
                  OutlinedButton.icon(icon: const Icon(Icons.person_add_outlined),onPressed: (){
                    if(!formKey.currentState!.validate()){
                      return;
                    }
                    try{
                      FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
                    .then((value) => Navigator.popAndPushNamed(context, '/',arguments: {'user': value.user}) );
                    }
                    catch(e){
                      if(e is FirebaseAuthException ){
                        showDialog(context: context, builder: (context){
                          return Scaffold(
                            body: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton.outlined(onPressed: (){
                                    Navigator.pop(context);
                                  }, icon: const Icon(Icons.cancel_outlined)),
                                ),
                                Text(e.message ?? ""),
                              ],
                            ),
                          );
                        } );
                      }
                    }
                  }, label: const Text("Sign Up"),),
                ],
              ),
            )
          ],
        ),
      ),),
    );
    
  }
} 

class GoogleSignUpPage extends StatefulWidget{
  const GoogleSignUpPage({super.key});

  @override
  State<GoogleSignUpPage> createState() {
    return _GoogleSignUpPageState();
  }
}

class _GoogleSignUpPageState extends State<GoogleSignUpPage>{
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class HomePage extends StatefulWidget{
  User? user;   

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage>{
    Map<dynamic,dynamic> arguements = {};
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    arguements = (ModalRoute.of(context)!.settings.arguments ??  <String, dynamic>{}) as Map;
    widget.user = arguements["user"];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: SingleChildScrollView(child: SizedBox(
      height: MediaQuery.of(context).size.height/2,
        child: Center(child: 
        widget.user != null? Column(
          children: [
            Text('Logged In As: ${widget.user!.email}'),
            const SizedBox(height: 30,),
            OutlinedButton.icon(onPressed: () async{
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route)=> false);
            }, label: const Text("Logout"), icon:const Icon(Icons.exit_to_app_outlined),),
          ],
        ): Container()),
      ),),
    );
  } 
}