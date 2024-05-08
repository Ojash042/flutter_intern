import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_intern/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(List<String> args) {
  runApp(const MyApp());
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
  final RegExp _fullNameRegex = RegExp(r'[A-Za-z]+');
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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
  BasicInfo basicInfo = BasicInfo();
  PersonalDetails({super.key, required this.formKey, required this.incrementPhase, required this.basicInfo});
  State<PersonalDetails> createState() => _PersonalDetailsState(); 
}

class _PersonalDetailsState extends State<PersonalDetails>{
  Gender? _gender = Gender.Male;
  MaritalStatus? _maritalStatus = MaritalStatus.single;
  TextEditingController summaryController = TextEditingController();
  File? coverImage;
  File? profileImage;

  Future<void> pickImage(bool isProfileImage) async{
    ImagePicker _imagePicker = ImagePicker();
    final XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    var directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    if(pickedImage!= null){
      setState((){
        if(isProfileImage){
          profileImage = File(pickedImage.path);
        }
        else{
          coverImage = File(pickedImage.path);
        } 
    });

    if(profileImage!=null){
      String profileImagePath = '$path/profile_image-${Random().nextInt(100)}.png';
      await profileImage?.copy(profileImagePath);
      widget.basicInfo.coverImage.isNetworkUrl = false;
      widget.basicInfo.coverImage.imagePath = profileImagePath;
    }

    if(coverImage!=null){
      String coverImagePath = '$path/cover_image${Random().nextInt(100)}.png';
      await coverImage?.copy(coverImagePath);
      widget.basicInfo.coverImage.isNetworkUrl = false;
      widget.basicInfo.coverImage.imagePath = coverImagePath; 
    }
  } 
}

  void addData(){   
    widget.basicInfo.summary = summaryController.text;
    widget.basicInfo.gender = (_gender == Gender.Male)? "Male": "Female";
    widget.basicInfo.maritalStatus = (_maritalStatus == MaritalStatus.married) ? "Married": "Single";
  }

  @override
  void initState() {
    super.initState();
    widget.basicInfo.id = Random().nextInt(10000) + 1000;
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
          TextFormField(maxLines: null, controller: summaryController,decoration: const InputDecoration(hintText: "Describe yourself..."),),
          const SizedBox(height: 30,),
          Text("Gender", style: Theme.of(context).textTheme.headlineSmall,),
          RadioListTile(value: Gender.Male, groupValue: _gender, title: const Text("Male"), onChanged: (Gender? value) {
            _gender = value;
          }),
          RadioListTile(value: Gender.Female, title: const Text("Female"), groupValue: _gender, onChanged: (Gender? value){
          _gender = value;
          }), 

          const SizedBox(height: 30,),
          Text("Marital Status", style: Theme.of(context).textTheme.headlineSmall,),
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
          const SizedBox(height: 30,),
          Text("Date of Birth", style: Theme.of(context).textTheme.headlineSmall,),
          const SizedBox(height: 10,),
          InputDatePickerFormField(firstDate: DateTime(1970), lastDate: DateTime(2030), initialDate: DateTime.now(),
          onDateSubmitted: (value) => {
            setState(() {
              widget.basicInfo.dob = DateFormat("yyyy-MM-dd").format(value);
            })
          },),

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
  
  List<WorkExperiences> workplaceData; 
  // Map<String, List<dynamic>> workplaceData = {
  //   "job_title": List.empty(growable: true),
  //   "summary": List.empty(growable: true),
  //   "organization_name": List.empty(growable: true),
  //   "starting_date": List.empty(growable: true),
  //   "end_date": List.empty(growable: true),
  // };
  WorkPlaceDetails({super.key, required this.incrementPhase, required this.formKey, required this.workplaceData});
  @override
  State<WorkPlaceDetails> createState()=> _WorkPlaceDetailsState();
}

class _WorkPlaceDetailsState extends State<WorkPlaceDetails>{ 

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Text("Workplace history", style: Theme.of(context).textTheme.headlineMedium,),
          ListView.builder(itemCount: widget.workplaceCount,
          shrinkWrap: true,
          itemBuilder: (context, index)=> 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column( 
              children: [
                TextFormField(
                  onChanged: (value) => {
                    setState(() {
                      widget.workplaceData.elementAt(index).jobTitle = value;
                    })
                  },
                  decoration: const InputDecoration(hintText: "Job Title"),),
                const SizedBox(height: 20,),
                TextFormField(
                  onChanged: (value) =>{
                    setState(() {
                      widget.workplaceData.elementAt(index).organizationName = value;
                    })
                  },
                  decoration: const InputDecoration(hintText: "The name of the organization"),),
                const SizedBox(height: 30,),
                TextFormField(
                  onChanged: (value)=>{
                    setState(() {
                      widget.workplaceData.elementAt(index).summary = value;
                    })
                  },
                  maxLines: null,decoration: const InputDecoration(hintText: "Features worked on the organization"),),
                const SizedBox(height: 20,),
                Column(
                  children: [
                    TextField(
                      decoration:  InputDecoration(icon: const Icon(Icons.calendar_month), 
                      label: Text((widget.workplaceData.elementAt(index).startDate == null)? 
                          "Enter the starting date here": 
                          DateFormat("yyyy-MM-dd").format(widget.workplaceData.elementAt(index).startDate!), )),
                    readOnly: true,
                    onTap: () async{
                      DateTime? pickeDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1970), lastDate: DateTime(2030));
                      setState(() { 
                        if(pickeDate!=null){                             
                          widget.workplaceData.elementAt(index).startDate = pickeDate;
                        }
                        });
                       
                      FocusScope.of(context).unfocus();
                    },
                    ),
                    TextField(decoration: InputDecoration(icon: const Icon(Icons.calendar_month), label: Text((widget.workplaceData.elementAt(index).endDate == null)? 
                    "Enter the ending date here" : DateFormat("yyyy-MM-dd").format(widget.workplaceData.elementAt(index).endDate!), )),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickeDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1970), lastDate: DateTime(2030));
                        setState(() { 
                          if(pickeDate!=null){
                            widget.workplaceData.elementAt(index).endDate = pickeDate;
                          }
                        });
                      
                      
                    },),],),
              const SizedBox(height: 30,),
              ],),
            ),
          ),
            TextButton(
              onPressed: (){setState(() { 
                DateTime? dt; 
                widget.workplaceCount++;
                WorkExperiences workExperiences = WorkExperiences(); 
                workExperiences.id = Random().nextInt(10000) + 1000;
                workExperiences.startDate = dt;
                workExperiences.endDate = dt;
                widget.workplaceData.add(workExperiences);
                 });}, 
                 child: const Text("Add more +")),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back)),
          IconButton(onPressed: widget.incrementPhase, icon: const Icon(Icons.arrow_forward))
        ],),
        ],),
    );
  }
}

class EducationForm extends StatefulWidget{
  GlobalKey<FormState> formKey;
  VoidCallback incrementPhase;

  EducationForm({super.key, required this.formKey, required this.incrementPhase, required this.educations});

  int educationCount = 0;
  int achivementCount = 0;
  
  List<Education> educations;
  List<TextEditingController> organizationController = List.empty(growable: true);
  List<TextEditingController> levelController = List.empty(growable: true);
  List<TextEditingController> summaryController = List.empty(growable: true);

  @override
  State<EducationForm> createState()=> _EducationFormState();
}

class _EducationFormState extends State<EducationForm>{

  @override
  Widget build(BuildContext context) {
  return Form(
    child: Column(
      children: [ 

      Text("Education History", style: Theme.of(context).textTheme.displayMedium,),
        ListView.builder(
          itemCount: widget.educationCount,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index)=>
          Column(children: [
            TextFormField(decoration: const InputDecoration(hintText: "Organization name"),),
            const SizedBox(height: 20,),
            TextFormField(decoration: const InputDecoration(hintText: "Level"),),
            const SizedBox(height: 30,),
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(icon: const Icon(Icons.calendar_month),
                  label: Text((widget.educations.length<index ||widget.educations.elementAt(index).startDate == null)?
                  "Enter joined Date": DateFormat("yyyy-MM-dd").format(widget.educations.elementAt(index).startDate!))),
                  onTap: () async{
                    DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2030));
                    setState((){ 
                    if(pickedDate != null){  
                      widget.educations.elementAt(index).startDate = pickedDate; 
                    }
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(icon: const Icon(Icons.calendar_month),
                  label: Text((widget.educations.length<index ||widget.educations.elementAt(index).endDate == null)?
                  "Enter Ended Date": DateFormat("yyyy-MM-dd").format(widget.educations.elementAt(index).endDate!))),
                  onTap: () async{
                    DateTime? dt = await showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2030)); 
                    setState((){
                      if(dt!= null){ 
                        widget.educations.elementAt(index).endDate  =dt;
                      } 
                    });
                  },
                ),
              const SizedBox(height: 30.0,),
              Text("Achievements", style: Theme.of(context).textTheme.headlineSmall),
              // ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: widget.achivementCount+1, itemBuilder: (innerContext, innerIndex) => Text(innerIndex.toString()) )
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.educations.elementAt(index).accomplishments.length ,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (innerContext, innerIndex)=> 
                
              Column(
                children: [ 
                  const SizedBox(height: 20,),
                  Text('Achievement #${innerIndex+1}',),
                  SizedBox(width: 220, child:TextFormField(
                    onChanged: (value){
                      setState(() {
                        widget.educations.elementAt(index).accomplishments.elementAt(innerIndex).title = value;
                      });
                    },
                    decoration: const InputDecoration(hintText: "Achivement Title"),)),
                  SizedBox(width: 220, child: TextFormField(
                    onChanged: (value){
                      setState(() {
                        widget.educations.elementAt(index).accomplishments.elementAt(innerIndex).description = value;
                      });
                    },
                    maxLines: null,decoration: const InputDecoration(hintText: "Descriptions"),),),
                  SizedBox(width: 220, child: TextFormField(
                    decoration: InputDecoration(icon: const Icon(Icons.calendar_month),
                     hintText: (widget.educations.elementAt(index).accomplishments.elementAt(innerIndex).dateTime == null)? 
                    "Enter accomplished date": 
                    DateFormat("yyyy-MM-dd").format(widget.educations.elementAt(index).accomplishments.elementAt(innerIndex).dateTime!),
                    ),
                    readOnly: true,
                    onTap: ()async{  
                      DateTime? dt = await showDatePicker(context: context, firstDate: DateTime(1970), lastDate: DateTime(2030));
                      setState(() {
                        if(dt!=null){
                          widget.educations.elementAt(index).accomplishments.elementAt(innerIndex).dateTime = dt;
                        }
                      });
                    },
                    ),),
                    const SizedBox(height: 30,),
                ],)
              ),
              
                TextButton(onPressed: (){
                  setState(() {
                  Education education = widget.educations.elementAt(index);
                  Accomplishment accomplishment = Accomplishment();
                  accomplishment.description = "";
                  accomplishment.id = Random().nextInt(10000) + 1000;
                  accomplishment.title = "";
                  accomplishment.dateTime  = null;
                  List<Accomplishment> accomplishments = (widget.educations.elementAt(index).accomplishments == null)? List.empty(growable: true) 
                  : widget.educations.elementAt(index).accomplishments; 
                  accomplishments.add(accomplishment);
                  education.accomplishments = accomplishments;
                  widget.achivementCount++;
                });
              }, 
              child: const Text("Add Achievement"))
              ],
            )
          ],)
          ),

        TextButton(onPressed: (){
          setState(() { 
            widget.educationCount++;
            Education education = Education();
            education.id = Random().nextInt(10000) + 1000;
            education.startDate = null;
            education.endDate = null;
            education.accomplishments = List.empty(growable: true);
            widget.educations.add(education);
          });
        }, child: const Text("Add more +")),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [ 
            IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back)),
            IconButton(onPressed: widget.incrementPhase, icon: const Icon(Icons.arrow_forward)),
          ]
        )
        
      ],
    ),
  );
  }
}

class ContactDetailsPage extends StatefulWidget{
  GlobalKey<FormState> formKey;
  VoidCallback incrementPhase;
  ContactDetailsPage({super.key, required this.formKey, required this.incrementPhase, required this.contactInfo});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsState();
  int socialMediaCounter = 0; 
  ContactInfo contactInfo;
  TextEditingController phoneController = TextEditingController();
  List<TextEditingController> titleController = List.empty(growable: true);
  List<TextEditingController> urlController = List.empty(growable: true);
  List<TextEditingController> typeController = List.empty(growable: true);
}

class _ContactDetailsState extends State<ContactDetailsPage>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Text("Contact Details:", style: Theme.of(context).textTheme.displayMedium,),
          const SizedBox(height: 30,),
          TextFormField(
            onChanged: (value) => {
              setState(() {
                widget.contactInfo.mobileNo = value;
              })
            },
            decoration: const InputDecoration(hintText: "Enter mobile no:"),),
          const SizedBox(height: 30,),
          Text("Social Media Links: ", style: Theme.of(context).textTheme.displaySmall,),
          const SizedBox(height: 30,),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.socialMediaCounter,
            itemBuilder: (context, index) => Column(children: [
              TextFormField(
                onChanged: (value) => {
                  setState(() {
                    widget.contactInfo.socialMedias.elementAt(index).title = value;
                  })
                },
                decoration: const InputDecoration(hintText: "Title",), controller: widget.titleController.elementAt(index),), 
              const SizedBox(height: 10,),
              TextFormField(
                onChanged: (value) => {
                  setState(() {
                    widget.contactInfo.socialMedias.elementAt(index).url = value;
                  })
                },
                decoration: const InputDecoration(hintText: "Url"), controller: widget.urlController.elementAt(index),),
              const SizedBox(height: 10,),
              TextFormField(
              onChanged: (value) =>{
                setState(() {
                  widget.contactInfo.socialMedias.elementAt(index).type = value;
                })
              },
                decoration: const InputDecoration(hintText: "Type"), controller: widget.typeController.elementAt(index),),
            ],)
            ),
            TextButton(onPressed: (){
              setState(() {
                SocialMedia socialMedia = SocialMedia();
                socialMedia.id = Random().nextInt(10000) + 1000;
                widget.socialMediaCounter++;
                widget.contactInfo.socialMedias.add(socialMedia);
                widget.titleController.add(TextEditingController());
                widget.urlController.add(TextEditingController());
                widget.typeController.add(TextEditingController());
              });
            }, child: const Text("Add More +")),

          const SizedBox(height: 30,), 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back)),
              IconButton(onPressed: widget.incrementPhase, icon: const Icon(Icons.arrow_forward)),
          ],)
        ],
      ),
    );
  }
}

class MiscelleneousPage extends StatefulWidget{
  GlobalKey<FormState> formKey;
  VoidCallback incrementPhase;

  MiscelleneousPage({super.key, required this.formKey, required this.incrementPhase, 
    required this.skills, required this.hobbies, required this.languages
  });

  int skillCounter = 0;
  int hobbiesCounter = 0;
  int languageCounter = 0;

  

  @override
  State<MiscelleneousPage> createState() => _MiscelleneousPageState();

  List<Skills> skills;
  List<Hobbies> hobbies;
  List<Languages> languages;
}

class _MiscelleneousPageState extends State<MiscelleneousPage> {


  FocusNode skillFocusNode = FocusNode();
  FocusNode hobbiesFocusNode = FocusNode();
  FocusNode languageFocusNode = FocusNode(); 

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: widget.key,
      child: Column(children:[
        Wrap(
        direction: Axis.horizontal,
          children: [
            Container(
            width: 120,
              child: ListView.builder(
              shrinkWrap: true,
                itemCount: widget.skillCounter,
                itemBuilder: (context, index)=>
                  Card(
                    //width: 120,
                    //decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.elliptical(0, 1)),border: Border.all(width: 1, style: BorderStyle.solid, strokeAlign: BorderSide.strokeAlignInside)),
                  elevation: 3,
                  child: Text(widget.skills.elementAt(index).title, textAlign: TextAlign.center,),
                  )
                ),
            ),
            const SizedBox(height: 10,),
            TextFormField(decoration: const InputDecoration(hintText: "Enter skills to be added"), focusNode: skillFocusNode, 
            onFieldSubmitted: (value){

              Skills skill = Skills();
            setState(() {
              widget.skillCounter++;
              skill.id = Random().nextInt(90000) + 10000;
              skill.title = value;
              widget.skills.add(skill);
            });
          },),
          ],
        ),
        const SizedBox(height: 30,),
        Wrap(
        direction: Axis.horizontal,
          children: [
            Container(
            width: 120,
              child: ListView.builder(
              shrinkWrap: true,
                itemCount: widget.hobbiesCounter,
                itemBuilder: (context, index)=>
                  Card(
                    //width: MediaQuery.of(context).size.width * 0.333,
                    //decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.elliptical(0, 1)),border: Border.all(width: 1, style: BorderStyle.solid, strokeAlign: BorderSide.strokeAlignInside)),
                    child: Text(widget.hobbies.elementAt(index).title, textAlign: TextAlign.center,),
                  )
                ),
            ),
            const SizedBox(height: 10,),
            TextFormField(decoration: const InputDecoration(hintText: "Enter hobbies to be added"), focusNode: hobbiesFocusNode, 
            onFieldSubmitted: (value){
              Hobbies hobbies = Hobbies();
              setState(() {
                widget.hobbiesCounter++;
                hobbies.id = Random().nextInt(90000) + 10000;
                hobbies.title = value;
                widget.hobbies.add(hobbies); 
              });},),
          ],
        ),
        const SizedBox(height: 30,),
          Wrap(
          direction: Axis.horizontal,
          children: [
            Container(
              width: 120,
              child: ListView.builder(
              shrinkWrap: true,
                itemCount: widget.languageCounter,
                itemBuilder: (context, index)=>
                  Card(
                    //width: 120,
                    // decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.elliptical(0, 1)),border: Border.all(width: 1, style: BorderStyle.solid, strokeAlign: BorderSide.strokeAlignInside)),
                  child: Text(widget.languages.elementAt(index).title, textAlign: TextAlign.center,),
                  )
                ),
            ),
            const SizedBox(height: 10,),
            TextFormField(decoration: const InputDecoration(hintText: "Enter languages to be added"), focusNode: languageFocusNode, 
            onFieldSubmitted: (value){
              Languages languages = Languages();
              setState(() {  
                widget.languageCounter++;
                languages.id = Random().nextInt(90000) + 10000;
                languages.title = value;
                widget.languages.add(languages);
              });},),
          ],
        ),
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back)),
          IconButton(onPressed: widget.incrementPhase, icon: const Icon(Icons.arrow_forward)),
        ]
      )
      ],),);
  }
}

class SignUpForm extends StatefulWidget{
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState()=> _SignUpFormState(); 
}


class _SignUpFormState extends State<SignUpForm>{
  TextEditingController mobileNoController = TextEditingController();
  List<GlobalKey<FormState>> formStateList =  List.generate(6, (index) => GlobalKey<FormState>());
  UserData userData = UserData();
  RegExp phoneRegex = RegExp(r'[0-9]{10}');
  RegExp emailRegex = RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$');
  File? image;
  File? cvFile;
  String cvText = "";
  int currentIndex  = 0;
  late List<Widget> formPhases;

  List<Education> educationFields = List.empty(growable: true);
  
  List<SocialMedia> socialMedias = List.empty(growable: true); 
  ContactInfo contactInfo = ContactInfo();

  BasicInfo basicInfo = BasicInfo();
  List<Skills> skills = List.empty(growable: true);
  List<Hobbies> hobbies = List.empty(growable: true);
  List<Languages> languages = List.empty(growable: true);
  List<WorkExperiences> workExperiences = List.empty(growable: true);

  Future<int> getMaxId() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance(); 
    var userJson = sharedPreferences.getString("user_data") as List;
    int maxIdCount = userJson.map((e) => UserData.fromJson(e)).toList().length + 1;
    return maxIdCount;
    }
  Future<void> storeUserDatatoPreferences() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userData.id = await getMaxId();
    UserDetails userDetails = UserDetails();
    userDetails.id= await getMaxId();
    userDetails.basicInfo = basicInfo;
    userDetails.workExperiences = workExperiences;
    userDetails.skills = skills;
    userDetails.hobbies = hobbies;
    userDetails.educations = educationFields;
    userDetails.contactInfo = contactInfo;
    //String jsonData = jsonEncode()
    //String jsonData = jsonEncode();
  }

  void _incrementPhase(){
    setState(() {
      currentIndex = min(++currentIndex, formPhases.length-1);

    });
    // if(formStateList.elementAt(currentIndex).currentState!.validate()){
    //   // formPhases.elementAt(currentIndex).addData()
    //   setState(() {
    //     currentIndex = min(++currentIndex, formPhases.length-1);
    //   });
    // };
  }

  @override
  void initState() {
    super.initState();
    contactInfo.socialMedias = socialMedias;
    formPhases = [
      BasicDetails(formKey: formStateList.first, userData: userData, incrementPhase: _incrementPhase,),
      PersonalDetails(formKey: formStateList.elementAt(1), basicInfo: basicInfo, incrementPhase: _incrementPhase,),
      WorkPlaceDetails(formKey: formStateList.elementAt(2), incrementPhase: _incrementPhase,workplaceData: workExperiences,),
      EducationForm(formKey: formStateList.elementAt(3), incrementPhase: _incrementPhase, educations: educationFields,),
      ContactDetailsPage(formKey: formStateList.elementAt(4), incrementPhase: _incrementPhase, contactInfo: contactInfo,),
      MiscelleneousPage(formKey: formStateList.elementAt(5), incrementPhase: _incrementPhase,
       skills: skills, languages: languages, hobbies: hobbies,
       ),
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
            ],),
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