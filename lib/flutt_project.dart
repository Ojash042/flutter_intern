import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main(List<String> args) {
  runApp(const MyApp());
}


enum Gender {Male, Female}
enum MaritalStatus{married, single}

class UserData{
  // UserData({required this.id, required this.name, required this.email, required this.password });
  late int id;
  late String name;
  late String email;
  late String password;
}
class ImageModel{
  // ImageModel({required this.isNetworkUrl, required this.imagePath});
  late bool isNetworkUrl;
  late bool imagePath;
}

class Skills{
  // Skills({required this.id, required this.title});
  late int id;
  late String title;
}

class WorkExperiences{
  // WorkExperiences({required this.id, required this.jobTitle, required this.summary, 
  // required this.organizationName, required this.startDate, required this.endDate});
  late int id;
  late String jobTitle;
  late String summary;
  late String organizationName;
  late DateTime startDate;
  late DateTime endDate;
}

class Hobbies{
  // Hobbies({required this.id, required this.title});
  late int id;
  late String title;
}

class Accomplishment{
  // Accomplishment({required this.id, required this.title, required this.description, required this.dateTime});
  late int id;  
  late String title;
  late String description;
  late DateTime dateTime;
}

class Education{
  // Education({required this.id, required this.level, required this.summary, required this.organizationName, required this.startDate, 
  // required this.endDate, required this.accomplishments});
  late int id;
  late String level;
  late String summary;
  late String organizationName;
  late DateTime startDate;
  late DateTime endDate;
  late List<Accomplishment> accomplishments;
}


class SocialMedia{
  // SocialMedia({required this.id, required this.title, required this.url, required this.type});
  late int id;  
  late String title;
  late String url;
  late String type;
}

class ContactInfo{
  // ContactInfo({required this.mobileNo, required this.socialMedias});
  late String mobileNo;  
  late List <SocialMedia> socialMedias;
}

class Languages{
  // Languages({required this.id, required this.title, required this.status});
  late int id;
  late String title;
  late String status;
}

class BasicInfo{
  //BasicInfo({required this.id, required this.profileImage, required this.coverImage, 
  // required this.summary, required this.gender, required this.dob, required this.maritalStatus});
  late int id;
  late ImageModel profileImage;
  late ImageModel coverImage;
  late String summary;
  late String gender;
  late String dob;
  late String maritalStatus;
}

class UserDetails{
  //UserDetails({required this.id, required this.basicInfo, required this.workExperiences, required this.skills, required this.hobbies, required this.languages, 
   //required this.educations, required this.contactInfo});
  late int id;
  late BasicInfo basicInfo;
  late List<WorkExperiences> workExperiences ;
  late List<Skills> skills;
  late List<Hobbies> hobbies;
  late List<Languages> languages;
  late List<Education> educations;
  late List<ContactInfo> contactInfo;
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue,)),
      // theme: ThemeData.from(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue,)),
      initialRoute: "/",
      routes: {
        "/": (context)=>const MyHomePage(child: LoginForm()),
        "/login": (context) => const LoginForm(),
        "/signup": (context) => const SignUpForm(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget{
  final Widget child;
  const MyHomePage({super.key, required this.child });

  @override
  State<MyHomePage> createState()=> _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Project"),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      ),
      body: widget.child ,
    );
  }
}

class BodyContainer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class BasicDetails extends StatefulWidget{
  GlobalKey<FormState> formKey;
  UserData userData;
  final VoidCallback incrementPhase;
  BasicDetails({super.key, required this.formKey, required this.userData, required this.incrementPhase});
  @override
  State<BasicDetails> createState()=> _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails>{
  RegExp _fullNameRegex = RegExp(r'[A-Za-z]+');
  RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController(); 
  TextEditingController emailController =  TextEditingController();

  void addData(){
    widget.userData.name = fullNameController.text;
    widget.userData.password =passwordController.text;
    widget.userData.email = emailController.text;
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: 
          Column(
            children: [
              const Text("Basic Details"),
              const SizedBox(height: 30,),
              TextFormField(controller: fullNameController, decoration: const InputDecoration(hintText: "Enter Full Name "), validator: (value) => (!_fullNameRegex.hasMatch(value!))? "Invalid Name Format": null,),
              const SizedBox(height: 30,),
              TextFormField(controller: emailController, decoration: const InputDecoration(hintText: "Enter your email address"), validator: (value) => (!_emailRegex.hasMatch(value!)? "Invalid Email Fomrat": null)),
              const SizedBox(height: 30,),
              TextFormField(controller: passwordController, decoration: const InputDecoration(hintText: "Enter password",), obscureText: true,),
              const SizedBox(height: 30,),
              SizedBox(height: MediaQuery.of(context).size.width - 100.0 ),
              Row(
              mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: (){addData();widget.incrementPhase();}, icon: const Icon(Icons.arrow_forward)),
                ],
              ),
            ],
          ), 
        ),
      ),
    );
  }
}

class PersonalDetails extends StatefulWidget{
  GlobalKey<FormState> formKey;
  final VoidCallback incrementPhase;
  PersonalDetails({super.key, required this.formKey, required this.incrementPhase,});
  State<PersonalDetails> createState() => _PersonalDetailsState(); 
}

class _PersonalDetailsState extends State<PersonalDetails>{
  Gender? _gender = Gender.Male;
  MaritalStatus? _maritalStatus = MaritalStatus.single;
  File? coverImage;
  File? profileImage;

  Future<void> pickImage(bool isProfileImage) async{
    ImagePicker _imagePicker = ImagePicker();
    final XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

    if(pickedImage!= null){
      setState((){
        if(isProfileImage){
          profileImage = File(pickedImage.path);
        }
        else{
          coverImage = File(pickedImage.path);
        } 
    });
  } 
  }
  void addData(){   
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
      padding: const EdgeInsets.all(9),
        child: Column(children: [
          Stack(
          alignment: Alignment.bottomLeft,
          clipBehavior:Clip.antiAlias,
            children: [
            coverImage == null?
              InkWell(
                onTap: () => pickImage(false),
                child: Container(color: Colors.blueGrey, width: MediaQuery.of(context).size.width - 40, height: 210, child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Text("Upload cover image")),
                ),),
              ):
              InkWell(
                onTap: () => pickImage(false),
                child: SizedBox(width: MediaQuery.of(context).size.width - 40, height: 210, child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.file(coverImage!),
                ),),
              ),

              profileImage == null?
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                onTap: () => pickImage(true),
                  child: Container(decoration: const BoxDecoration( border: Border(
                    top: BorderSide(color: Colors.white, width: 1.5),
                    bottom: BorderSide(color: Colors.white, width: 1.5),
                    left: BorderSide(color: Colors.white, width: 1.5),
                    right: BorderSide(color: Colors.white, width: 1.5),
                  ),
                  color: Colors.blueGrey,
                  shape: BoxShape.circle,),
                   width: 120, height: 120, child: const Center(child: Text("Upload profile image")),),
                ),
              ):
              Padding(
                padding: const EdgeInsets.all(12),
                child: InkWell(
                  onTap: () => pickImage(true),
                  child: Container(decoration:const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border(
                    top: BorderSide(color: Colors.white, width: 1.5),
                    bottom: BorderSide(color: Colors.white, width: 1.5),
                    left: BorderSide(color: Colors.white, width: 1.5),
                    right: BorderSide(color: Colors.white, width: 1.5),
                  )),
                  height: 120,width: 120,
                  child: CircleAvatar(radius: 60, backgroundImage: FileImage(profileImage!),)
                  //child: Image.file(profileImage!),
                  ),
                ), 
              ),
              

            ],
          ),
          const SizedBox(height: 30,),
          TextFormField(maxLines: null,decoration: const InputDecoration(hintText: "Describe yourself..."),),
          const SizedBox(height: 30,),
          Text("Gender", style: Theme.of(context).textTheme.headlineSmall,),
          RadioListTile(value: Gender.Male, groupValue: _gender, title: const Text("Male"), onChanged: (Gender? value) {
            _gender = value;
          }),
          RadioListTile(value: Gender.Female, title: const Text("Female"), groupValue: _gender, onChanged: (Gender? value){
          _gender = value;
          }),
        
          const SizedBox(height: 30,),
          Text("Marital Status", style: Theme.of(context).textTheme.headlineLarge,),
          RadioListTile(value: MaritalStatus.married, title: const Text("Married"), groupValue: _maritalStatus, onChanged: (MaritalStatus? value){
            setState(() {
              _maritalStatus = value;
            });
          }),
          RadioListTile(value: MaritalStatus.single, title: const Text("Single"), groupValue: _maritalStatus, onChanged: (MaritalStatus? value){
            setState(() {
              _maritalStatus = value;
            });
          }), 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
          IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back)),
          IconButton(onPressed:(){ addData(); widget.incrementPhase();} , icon: const Icon(Icons.arrow_forward))
          ]),
        ]),
      ));
  }
}

class WorkPlaceDetails extends StatefulWidget{
  VoidCallback incrementPhase;
  GlobalKey<FormState> formKey;

  int workplaceCount = 0;
  DateTime? startDate;
  DateTime? endDate;
  
  Map<String, List<dynamic>> workplaceData = {
    "job_title": List.empty(growable: true),
    "summary": List.empty(growable: true),
    "organization_name": List.empty(growable: true),
    "starting_date": List.empty(growable: true),
    "end_date": List.empty(growable: true),
  };


  WorkPlaceDetails({super.key, required this.incrementPhase, required this.formKey});
  @override
  State<WorkPlaceDetails> createState()=> _WorkPlaceDetailsState();
}

class _WorkPlaceDetailsState extends State<WorkPlaceDetails>{

  Future<void> pickDate() async{
  
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          ListView.builder(itemCount: widget.workplaceCount,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Column(
            children: [
              Container(child: TextFormField(decoration: const InputDecoration(hintText: "Job Title"),),),
              Container(child: TextFormField(decoration: const InputDecoration(hintText: "The name of the organization"),),),
              Container(child: TextFormField(decoration: const InputDecoration(hintText: "Features worked on the organization"),),),
              Column(
                children: [
                  TextField(decoration:  InputDecoration(icon: Icon(Icons.calendar_month), label: Text((widget.workplaceData["starting_date"]!.length < index || widget.workplaceData["starting_date"]![index] == null)? 
                  widget.workplaceData["starting_date"]![0] : "Enter the starting date here", )),
                  readOnly: true,
                  onTap: () async{
                    DateTime? pickeDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1970), lastDate: DateTime(2030));
                    if(widget.workplaceData["ending_date"]!.length < index){
                      widget.workplaceData["starting_date"]!.add(pickeDate);
                    }
                    else{
                      widget.workplaceData["starting_date"]![index] = pickeDate;
                    }
                  },
                  ),
                  TextField(decoration: InputDecoration(icon: const Icon(Icons.calendar_month), label: Text((widget.workplaceData["end_date"]!.length < index || widget.workplaceData["end_date"]![0] == null)? 
                  widget.workplaceData["end_date"]![0] : "Enter the starting date here", )),
                  readOnly: true,
                  onTap: () async{
                    DateTime? pickeDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1970), lastDate: DateTime(2030));
                    if(widget.workplaceData["end_date"]!.length < index){
                      widget.workplaceData["end_date"]!.add(pickeDate);
                    }
                    else{
                      widget.workplaceData["end_date"]![index] = pickeDate;
                    }
                  },),
                                 ],)
            ],
            );
          }),
            TextButton(onPressed: (){setState(() {
                  DateTime? dt; 
                  widget.workplaceData["starting_date"]!.add(dt);
                  widget.workplaceCount++; 
                 });}, child: Text("Add more +")) 

        ],
      ),
    );
  }
}

class SignUpForm extends StatefulWidget{
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState()=> _SignUpFormState(); 
}

class _SignUpFormState extends State<SignUpForm>{
  TextEditingController mobileNoController = TextEditingController();
  List<GlobalKey<FormState>> formStateList =  List.generate(3, (index) => GlobalKey<FormState>());
  UserData userData = UserData();
  Gender? _selectedGender = Gender.Male;
  RegExp phoneRegex = RegExp(r'[0-9]{10}');
  RegExp emailRegex = RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$');
  File? image;
  final ImagePicker _imagePicker = ImagePicker();
  File? cvFile;
  String cvText = "";
  final _formKey = GlobalKey<FormState>();
  int currentIndex  = 0;
  late List<Widget> formPhases;
  
  void _incrementPhase(){
    print('Incrementing $currentIndex to ${currentIndex+1}');
    setState(() {
      currentIndex = min(++currentIndex, formPhases.length-1);
    });
    // if(formStateList.elementAt(currentIndex).currentState!.validate()){
    //   // formPhases.elementAt(currentIndex).addData()
    //   setState(() {
    //     currentIndex++;
    //   });
    // };
  }

  @override
  void initState() {
    super.initState();
    formPhases = [
      BasicDetails(formKey: formStateList.first, userData: userData, incrementPhase: _incrementPhase,),
      PersonalDetails(formKey: formStateList.elementAt(1), incrementPhase: _incrementPhase,),
      WorkPlaceDetails(formKey: formStateList.elementAt(2), incrementPhase: _incrementPhase,)
      ];
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
    appBar: AppBar(centerTitle: true, title: const Text("Flutter Project"), backgroundColor: Colors.blueAccent,),
        body: 
        Center(
          child: SingleChildScrollView(
            child: 
            Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Sign Up form", style: Theme.of(context).textTheme.headlineLarge,), 
              ),
              formPhases.elementAt(currentIndex),
            ],
                    ),
          )),
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(children: [
      //     if( currentIndex > 0)
      //       IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back)),
      //     if(currentIndex < formPhases.length - 1)
      //       IconButton(onPressed: _incrementPhase, icon: const Icon(Icons.arrow_forward)) ,
      //   ],),
      // ),
      )
    );
  }
}

class LoginForm extends StatefulWidget{
  const LoginForm({super.key});

  @override
  State<LoginForm> createState()=> _LoginFormState();
}
class _LoginFormState extends State<LoginForm>{
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login", style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 30,),
              SizedBox(width: MediaQuery.of(context).size.width - 100, child: TextFormField(decoration: const InputDecoration(hintText: "Enter Email"), controller: _emailController,),),
              const SizedBox(height: 30,),
              SizedBox(width: MediaQuery.of(context).size.width -100 , child: TextFormField(obscureText: true, decoration: const InputDecoration(hintText: "Enter password"),controller: _passwordController,),),
              const SizedBox(height: 30,), 
              SizedBox(child: OutlinedButton(child: const Text("Login"), onPressed: (){},)),
              const SizedBox(height: 60,),
              SizedBox(child: TextButton(onPressed: (){Navigator.pushNamed(context, "/signup");}, child: const Text("Sign Up"),),)
            ],
          ),
        ),
      ),
    );    
  } 
}

class UserProfileScreen extends StatefulWidget{
  @override
  State<UserProfileScreen> createState()=> _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>{
  @override
  Widget build(BuildContext context) {
    return  const Text("User Profile");
  }
}
