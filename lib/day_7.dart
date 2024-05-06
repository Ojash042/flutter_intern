import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum Gender {Male, Female}
void main(List<String> args) {
 runApp(const MyApp()); 
}

class DefaultAppBar extends StatelessWidget{
  const DefaultAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text("Day 7"),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
    );
  }
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent)),
      title: "Day 7",
      initialRoute: '/',
      routes: {
        "/": (context) => const MyHomePage(),
        "/userDetails": (context) => const UserDetailsDisplay(),
        "/formPage": (context) =>const FormPage(), 
      },
    );
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key}); 
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  bool? isLoggedIn;
  String? loggedInEmail;  
  Future<void> getLoggedInState(context) async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
    isLoggedIn =  sharedPreferences.getBool("isLoggedIn"); 
    loggedInEmail =sharedPreferences.getString("loggedInEmail"); 
        print('Line 50: isLoggedIn $loggedInEmail');
      if(loggedInEmail == null){ 
        print(loggedInEmail);
        print("Testing on line 60");
        Navigator.popAndPushNamed(context, "/formPage");
      }
      else{
        Navigator.popAndPushNamed(context, "/userDetails");
      }
    });
      
    
  }

  @override
  void initState(){
      super.initState();
      getLoggedInState(context); 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Day 7"),),
      body: const Center(child: Text("Loading!"),),
    );    
  } 
}

class UserDetailsDisplay extends StatefulWidget{
  const UserDetailsDisplay({super.key});

  @override
  State<UserDetailsDisplay> createState() => _UserDetailsDisplayState();
}

class _UserDetailsDisplayState extends State<UserDetailsDisplay>{
  String? _loggedInEmail;
  UserData? userData;
  late SharedPreferences sharedPreferences;


  Future<void> getUserData() async{
    sharedPreferences = await SharedPreferences.getInstance();    
    setState(() {
      _loggedInEmail =  sharedPreferences.getString("loggedInEmail");
      String? userDetails =  sharedPreferences.getString(_loggedInEmail!);
      Map<String, dynamic> user = jsonDecode(userDetails!);
      userData = UserData.fromJson(jsonDecode(userDetails)); 
    });

      if(userData == null){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong")));
      }
  }

  void _logoutUser(){
    setState(() { 
    sharedPreferences.setBool("isLoggedIn", false); 
    sharedPreferences.remove("loggedInEmail");
    Navigator.popAndPushNamed(context, '/formPage');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }



  @override
  Widget build(BuildContext context) {
    if(userData != null){
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Day 7"), backgroundColor: Colors.blueAccent,),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Full Name:", style: Theme.of(context).textTheme.headlineMedium,),
                Text(userData!.fullName, style: Theme.of(context).textTheme.bodyLarge,),
                const SizedBox(height: 30,),
                Text("E-mail: ", style: Theme.of(context).textTheme.headlineMedium,),
                Text(userData!.email, style: Theme.of(context).textTheme.bodyLarge,),
                const SizedBox(height: 30,),
                Text("Mobile No:", style: Theme.of(context).textTheme.headlineMedium,),
                Text(userData!.mobileNo, style: Theme.of(context).textTheme.bodyLarge,),
                const SizedBox(height: 40,),
                ElevatedButton(onPressed: _logoutUser, child: const Text("Logout")),
            ],),
        ),
      ),
    );
    }
    else{
      return const Text("Loading");
    }
  }
}


class FormPage extends StatefulWidget{
  const FormPage({super.key});
  @override
  State<FormPage> createState() => _FormPageState();

}

class _FormPageState extends State<FormPage>{
  int _currentIndex = 0;
  final List<Widget> _forms = <Widget>[
    const SignUpForm(),
    const LoginForm(),
  ];


  void _changeIndex(int index){
    setState(() {   
    _currentIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Day 7"),
      ),
      body: Center(child:_forms.elementAt(_currentIndex),
       ), 
       bottomNavigationBar: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.report), label: "SignUp"),
        BottomNavigationBarItem(icon: Icon(Icons.person_pin_circle), label: "Login"),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Colors.blueAccent,
      onTap: _changeIndex,
    ));
  }
}

class LoginForm extends StatefulWidget{
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>{
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
 
  Future<void> setLoggedInState(BuildContext context) async{
  print("Setting LoggedIn State");
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLoggedIn", true);
    sharedPreferences.setString("loggedInEmail", _emailController.text);
    Navigator.popAndPushNamed(context, '/userDetails'); 
      }


  Future<bool> validateSharedPrefs() async{
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    var json = _sharedPrefs.getString(_emailController.text); 
    Map<String, dynamic> map = jsonDecode(json!);
    UserData data = UserData.fromJson(map);
    return data.password == this._passwordController.text;
    // UserData data = UserData.fromJson(json);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            Text("Login", style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 30,),
            SizedBox(width: MediaQuery.of(context).size.width - 100, child: TextFormField(decoration: const InputDecoration(hintText: "Enter Email"), controller: _emailController,),),
            const SizedBox(height: 30,),
            SizedBox(width: MediaQuery.of(context).size.width -100 , child: TextFormField(obscureText: true, decoration: const InputDecoration(hintText: "Enter password"),controller: _passwordController,),),
            const SizedBox(height: 30,), 
            SizedBox(child: ElevatedButton(child: const Text("Login"), onPressed: () async{
                bool result = await validateSharedPrefs(); 
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result? "Logged In": "Invalid Credentials"))); 
                setLoggedInState(context);
            },)),
          ],
        ),
      ),
    );    
  }
}


class SignUpForm extends StatefulWidget{
  const SignUpForm({super.key});

 @override 
 State<SignUpForm> createState() => _SignUpFormData(); 
}

class UserData{
  UserData({required this.fullName, required this.gender, required this.mobileNo, required this.email, required this.password});
  final String fullName;
  final String gender;
  final String email;
  final String mobileNo;
  final String password;

  Map<String, dynamic> toJson()=>{'fullName': fullName, 'gender': gender, 'email': this.email, 'mobileNo': mobileNo , 'password': password};
  
  factory UserData.fromJson(Map<String, dynamic> json){
    return UserData(fullName: json["fullName"], gender: json["gender"], mobileNo: json["mobileNo"], email: json["email"], password: json["password"]);
  }
}

class _SignUpFormData extends State<SignUpForm>{
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController emailController =  TextEditingController();
  Gender? _selectedGender = Gender.Male;
  RegExp phoneRegex = RegExp(r'[0-9]{10}');
  RegExp emailRegex = RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$');
  File? image;
  final ImagePicker _imagePicker = ImagePicker();
  File? cvFile;
  String cvText = "";
  final _formKey = GlobalKey<FormState>();

Future<void> _pickFiles() async{
 FilePickerResult? _filePicker = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
  if(_filePicker != null){
    setState(() {  
      cvFile = File(_filePicker.files.single.path!);
    });
    cvText = cvFile!.path;
  }
}

  Future<void> _pickFromCamera() async{
    final XFile? pickedImage =   await _imagePicker.pickImage(source: ImageSource.camera);
    if(pickedImage != null){
      setState(() {
       image = File(pickedImage.path); 
      });
    }
  }

  Future<void> _pickFromGallery() async{   
    final XFile? pickedImage =   await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      setState(() {
       image = File(pickedImage.path);
      });
    }
  }
 
  Future<void> storeDataToSharedPrefS() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String genderValue = _selectedGender == Gender.Male ? "Male": "Female";   
    UserData data = UserData(fullName: fullNameController.text, gender: genderValue, mobileNo: mobileNoController.text, 
    email: emailController.text, password: passwordController.text);

    String jsonData =jsonEncode(data.toJson());

    print('jsonData: $jsonData');
    sharedPreferences.setString(emailController.text, jsonData);
    print('DataData ${sharedPreferences.getString(emailController.text)}');
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(children: [
          Text("Sign Up", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 30, width: 30,),
          image != null ? Image.file(image!, width: 240, height: 240,) : Container(),
          const Text("image"),
          const SizedBox(height: 30, ),
          Padding(padding: const EdgeInsets.all(8.0),
          child: SizedBox(child: TextFormField(decoration: const InputDecoration(hintText: "Enter your full name: "),controller: fullNameController,),),
          ),
          const SizedBox(height: 30,),
          Text("Gender", style: Theme.of(context).textTheme.headlineMedium),
          RadioListTile(value: Gender.Female, groupValue: _selectedGender, title: const Text("Female"), onChanged: (Gender? value){
            setState(() { 
            _selectedGender = value;
            });}),
          RadioListTile(value: Gender.Male, groupValue: _selectedGender,title: const Text("Male"), onChanged: (Gender? value){
            setState(() {
              _selectedGender = value;
            }); }),

          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(child: TextFormField(decoration: const InputDecoration(hintText: "Enter your Mobile No.: "),controller: mobileNoController,  validator: (value) {return (value == null || value.isEmpty) ? "Number is required" : !phoneRegex.hasMatch(value)? "Invalid number": null;},),),
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(child: TextFormField(decoration: const InputDecoration(hintText: "Enter your email: "),controller: emailController, validator: (value) {return (value == null || value.isEmpty) ? "Email is required" : !emailRegex.hasMatch(value)? "Invalid email": null;},),),
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(child: TextFormField(obscureText: true,decoration: const InputDecoration(hintText: "Enter your password: "), controller: passwordController),),
          ),
          const SizedBox(height: 30,),
          Row(children: [
            SizedBox(child: ElevatedButton(onPressed: _pickFromCamera, child: const Text("Pick an image from camera", textAlign: TextAlign.center,maxLines: 3,overflow: TextOverflow.ellipsis, softWrap: true,))),
            SizedBox(width: 150, child: ElevatedButton(onPressed: _pickFromGallery, child: const Text("Pick an image from gallery", textAlign: TextAlign.center,maxLines: 3, overflow: TextOverflow.ellipsis,softWrap: true,))),
          ],),
          const SizedBox(height: 30,),
          Text(cvFile != null ? cvFile!.path.split("/").last:"Upload CV" ),
          ElevatedButton(onPressed: _pickFiles, child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.file_upload), Text("UploadFile")],)),
          const SizedBox(height: 30,),
          ElevatedButton(onPressed: (){
            if(_formKey.currentState!.validate()){
              
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Form Submitted")));
              storeDataToSharedPrefS();
            }},
             child:const Text("Submit")),
        ],),
      ),
    );
  }
}