// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_events.dart';
import 'package:flutter_intern/project/bloc/auth_states.dart';
import 'package:flutter_intern/project/bloc/course_events.dart';
import 'package:flutter_intern/project/bloc/courses_bloc.dart';
import 'package:flutter_intern/project/bloc/instructor_bloc.dart';
import 'package:flutter_intern/project/bloc/instructor_event.dart';
import 'package:flutter_intern/project/bloc/user_friend_bloc.dart';
import 'package:flutter_intern/project/bloc/user_friend_events.dart';
import 'package:flutter_intern/project/bloc/user_list_bloc.dart';
import 'package:flutter_intern/project/bloc/user_list_events.dart';
import 'package:flutter_intern/project/bloc/user_post_bloc.dart';
import 'package:flutter_intern/project/bloc/user_post_event.dart';
import 'package:flutter_intern/project/categories_details_page.dart';
import 'package:flutter_intern/project/change_password_page.dart';
import 'package:flutter_intern/project/courses_details_page.dart';
import 'package:flutter_intern/project/courses_page.dart';
import 'package:flutter_intern/project/forgot_password_page.dart';
import 'package:flutter_intern/project/friend_list_page.dart';
import 'package:flutter_intern/project/friend_requests.dart';
import 'package:flutter_intern/project/landing_page.dart';
import 'package:flutter_intern/project/locator.dart';
import 'package:flutter_intern/project/logout_page.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/my_posts_page.dart';
import 'package:flutter_intern/project/profile_details.dart';
import 'package:flutter_intern/project/profile_info_page.dart';
import 'package:flutter_intern/project/search_page.dart';
import 'package:flutter_intern/project/todo.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_intern/project/Login_form.dart';
import 'package:google_fonts/google_fonts.dart';



void main(List<String> args) {
  setupLocator();
  runApp(const MyApp());
  }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<UserData> userDataList;
  late int currentUserId;

  Future<void> loadAssets() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var courseCategoriesJson =
        await rootBundle.loadString('assets/course_categories.json');
    var courseByCategoriesJson =
        await rootBundle.loadString('assets/courses_by_categories.json');
    var coursesJson = await rootBundle.loadString('assets/courses.json');
    var instructorJson = await rootBundle.loadString('assets/instructor.json');
    var userPost = await rootBundle.loadString('assets/user_post.json');

    var userFriendJson =
        await rootBundle.loadString('assets/user_friend_list.json');

    sharedPreferences.getString("course_categories") == null ? sharedPreferences.setString("course_categories", courseCategoriesJson) : null;
    sharedPreferences.getString("course_by_categories") == null ? sharedPreferences.setString( "course_by_categories", courseByCategoriesJson): null;
    sharedPreferences.getString("courses") == null ? sharedPreferences.setString("courses", coursesJson) : null;
    sharedPreferences.getString("instructor") == null ? sharedPreferences.setString("instructor", instructorJson) : null;
    sharedPreferences.getString("user_post") == null ? sharedPreferences.setString("user_post", jsonEncode(jsonDecode(userPost)["user_post"])): null;
    sharedPreferences.getString("user_friend") == null? sharedPreferences.setString("user_friend",jsonEncode(jsonDecode(userFriendJson)["user_friend_list"])) : null;
  }

  @override
  void dispose() {
    super.dispose();
    closeUserPostLocator();
  }

  @override
  void initState() {
    super.initState();
    loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(UnknownAuthEvent())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: GoogleFonts.quicksandTextTheme(),
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
            )),
        initialRoute: "/",
        routes: {
          "/": (context) => const MyHomePage(child: LoginForm()),
          "/login": (context) => const LoginForm(),
          "/signup": (context) => const SignUpForm(),
          "/courses": (context) => BlocProvider(
              create: (_) => CoursesBloc()..add(CourseListInitialize()),
              child: const CoursesPage()),
          "/home": (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        UserPostBloc()..add(UserPostInitialize()),
                  ),
                  BlocProvider.value(value: locator<UserListBloc>()),
                ],
                child: const LandingPage(),
              ),
          "/changePassword": (context) => const ChangePasswordPage(),
          "/profileInfo": (context) => ProfileInfoPage(
                id: currentUserId.toString(),
              ),
          "/settings": (context) => const LogoutPage(),
          "/editDetails": (context) => BlocProvider.value(
              value: locator<UserListBloc>(),
              child: ProfileDetails()),
          "/search": (context) => MultiBlocProvider(providers: [
                BlocProvider(create:(context) => UserListBloc()..add(UserListInitialize()),),
                BlocProvider(
                    create: (_) =>
                        UserFriendBloc()..add(UserFriendInitialize())),
              ], child: const SearchPage()),
          "/friendRequests": (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        UserFriendBloc()..add(UserFriendInitialize()),
                  ),
                  BlocProvider(create: (context) => UserListBloc()..add(UserListInitialize()),)
                ],
                child: const FriendRequests(),
              ),
          "/friendLists": (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        UserFriendBloc()..add(UserFriendInitialize()),
                  ),
                  BlocProvider(create: (context) => UserListBloc()..add(UserListInitialize())) ,
                ],
                child: const FriendListPage(),
              ),
          "/forgotPassword": (context) => const ForgotPasswordPage(),
          "/myPosts": (context) => MultiBlocProvider(providers: [
                BlocProvider(
                    create: (_) => UserPostBloc()..add(UserPostInitialize())),
                BlocProvider.value(value: locator<UserListBloc>()) 
              ], child: const MyPostsPage()),
          "/todos": (context) => const ToDoPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name!.startsWith('/courses/')) {
            var courseId = settings.name!.split('/').last;
            return MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              CoursesBloc()..add(CourseListInitialize()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              InstructorBloc()..add(InstructorInitialize()),
                        ),
                      ],
                      child: CoursesDetailsPage(courseId: courseId),
                    ));
          }
          if (settings.name!.startsWith('/profileInfo/')) {
            var profileId = settings.name!.split('/').last;
            return MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => GetIt.I<UserListBloc>(),
                        ),
                        BlocProvider(create: (context) => UserPostBloc()..add(UserPostInitialize())),
                      ],
                      child: ProfileInfoPage(id: profileId),
                    ));
          }
          if(settings.name!.startsWith('/category/')){
            var categoryId = int.parse(settings.name!.split('/').last);
            return MaterialPageRoute(
              builder: (context) => BlocProvider(create: (_) => CoursesBloc()..add(CourseListInitialize()), child: CategoriesDetailsPage(categoryId: categoryId,),));
          }
          return null;
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Widget child;
  const MyHomePage({super.key, required this.child});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void redirectPage() {
    context.read<AuthBloc>().state.loggedInState
        ? Navigator.of(context).popAndPushNamed('/home')
        : Navigator.of(context).popAndPushNamed('/login');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // redirectPage();
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    //redirectPage();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => redirectPage());
    //redirectPage();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: UnauthorizedNavigationBar(),
      appBar: CommonAppBar(),
      body: BodyContainer(),
    );
  }
}

class BodyContainer extends StatefulWidget {
  const BodyContainer({super.key});

  @override
  State<BodyContainer> createState() => _BodyContainerState();
}

class _BodyContainerState extends State<BodyContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthStates>(
        listener: (BuildContext context, state) =>
            Future.delayed(Duration.zero, () {
              (state is AuthorizedAuthState)
                  ? Navigator.of(context).popAndPushNamed('/home')
                  : Navigator.of(context).popAndPushNamed('/login');
            }),
        child: BlocBuilder<AuthBloc, AuthStates>(
          builder: (context, state) =>
              const Center(child: CircularProgressIndicator()),
        ));
  }
}

class BasicDetails extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  UserData userData;
  final VoidCallback incrementPhase;
  final FocusNode fullNameFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode rePasswordFocusNode;
  final VoidCallback onChangeFocus;

  BasicDetails({
    super.key,
    required this.formKey,
    required this.userData,
    required this.incrementPhase,
    required this.fullNameFocusNode,
    required this.passwordFocusNode,
    required this.emailFocusNode,
    required this.rePasswordFocusNode,
    required this.onChangeFocus,
  });

  @override
  State<BasicDetails> createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails> {
  final RegExp _fullNameRegex = RegExp(r'[A-Za-z]+');
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  void addData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Completer<void> dialogCompleter = Completer<void>();

    String? userDataSharedPrefs = sharedPreferences.getString("user_data");
    List<UserData> retrievedUserData = List.empty();
    if (userDataSharedPrefs != null) {
      Iterable decoded = jsonDecode(userDataSharedPrefs);
      retrievedUserData = decoded.map((e) => UserData.fromJson(e)).toList();
    }
    var scaffoldContext = context;

    // var ret = retrievedUserData.firstWhereOrNull((element) => element.email == emailController.text);

    if (retrievedUserData.isNotEmpty &&
        (retrievedUserData.firstWhereOrNull((element) => element.email == emailController.text) != null)) {
      mounted ? showDialog(context: context, builder: (BuildContext context) {
        context = scaffoldContext;
        return AlertDialog(
          title: const Text("User Already exists"),
          content: const Text("Redirecting to loging page"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(scaffoldContext);
                dialogCompleter.complete();
                }, child: const Text("Ok!")),
            ],);}): null;
      return;
    }

    widget.userData.name = fullNameController.text;
    widget.userData.password = passwordController.text;
    widget.userData.email = emailController.text;
    if (widget.formKey.currentState!.validate()) {
      widget.incrementPhase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Center(
          child: Column(
            children: [
              Text(
                "Basic Details",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 60,
              ),
              TextFormField(
                controller: fullNameController,
                focusNode: widget.fullNameFocusNode,
                decoration: const InputDecoration(hintText: "Enter Full Name "),
                validator: (value) => (!_fullNameRegex.hasMatch(value!))
                    ? null /*"Invalid Name Format"*/: null,
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: emailController,
                  focusNode: widget.emailFocusNode,
                  decoration: const InputDecoration(
                      hintText: "Enter your email address"),
                  validator: (value) => (!_emailRegex.hasMatch(value!)
                      ? null /*"Invalid Email Fomrat"*/
                      : null)),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: passwordController,
                  focusNode: widget.passwordFocusNode,
                  decoration: const InputDecoration(
                    hintText: "Enter password",
                  ),
                  obscureText: true,
                  validator: (value) => (value == null || value.isEmpty)
                      ? "Password cannot be empty"
                      : null),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: rePasswordController,
                focusNode: widget.rePasswordFocusNode,
                decoration: const InputDecoration(hintText: "Reenter Password"),
                obscureText: true,
                validator: (value) => (value == null ||
                        value.isEmpty ||
                        passwordController.text != value)
                    ? null /*"Passwords do not match"*/
                    : null,
              ),
              const SizedBox(
                height: 60,
              ),
              //SizedBox(height: MediaQuery.of(context).size.width - 100.0 ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          addData();
                        },
                        icon: const Icon(Icons.arrow_forward)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalDetails extends StatefulWidget {
  GlobalKey<FormState> formKey;
  final VoidCallback incrementPhase;
  BasicInfo basicInfo = BasicInfo();
  PersonalDetails(
      {super.key,
      required this.formKey,
      required this.incrementPhase,
      required this.basicInfo});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  Gender? _gender = Gender.Male;
  MaritalStatus? _maritalStatus = MaritalStatus.single;
  TextEditingController birthDateController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  File? coverImage;
  File? profileImage;
  bool isDoBEmpty = false;

  Future<void> pickImage(bool isProfileImage) async {
    ImagePicker _imagePicker = ImagePicker();
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    var directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    if (pickedImage != null) {
      setState(() {
        if (isProfileImage) {
          profileImage = File(pickedImage.path);
          widget.basicInfo.profileImage = ImageModel();
        } else {
          coverImage = File(pickedImage.path);
          widget.basicInfo.coverImage = ImageModel();
        }
      });

      if (profileImage != null) {
        String profileImagePath =
            '$path/profile_image-${Random().nextInt(100)}.png';
        await profileImage?.copy(profileImagePath);
        setState(() {
          widget.basicInfo.profileImage.isNetworkUrl = false;
          widget.basicInfo.profileImage.imagePath = profileImagePath;
        });
      }

      if (coverImage != null) {
        String coverImagePath = '$path/cover_image${Random().nextInt(100)}.png';
        await coverImage?.copy(coverImagePath);
        widget.basicInfo.coverImage.isNetworkUrl = false;
        widget.basicInfo.coverImage.imagePath = coverImagePath;
      }
    }
  }

  void addData() {
    widget.basicInfo.summary = summaryController.text;

    widget.basicInfo.gender = (_gender == Gender.Male) ? "Male" : "Female";
    widget.basicInfo.maritalStatus =
        (_maritalStatus == MaritalStatus.married) ? "Married" : "Single";
    if (profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Image cannot be empty!")));
      return;
    }
    if (coverImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cover Image cannot be empty!")));
      return;
    }

    if (birthDateController.text.isEmpty) {
      setState(() {
        isDoBEmpty = true;
      });
      return;
    }

    if (widget.formKey.currentState!.validate()) {
      widget.incrementPhase();
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    widget.basicInfo.id = Random().nextInt(10000) + 1000;
    widget.basicInfo.dob = "";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                alignment: Alignment.bottomLeft,
                clipBehavior: Clip.antiAlias,
                children: [
                  coverImage == null
                      ? InkWell(
                          onTap: () => pickImage(false),
                          child: Container(
                            color: Colors.blueGrey,
                            width: MediaQuery.of(context).size.width - 40,
                            height: 210,
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: Text("Upload cover image")),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () => pickImage(false),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 210,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Image.file(coverImage!),
                            ),
                          ),
                        ),
                  profileImage == null
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: InkWell(
                            onTap: () => pickImage(true),
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.white, width: 1.5),
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.5),
                                  left: BorderSide(
                                      color: Colors.white, width: 1.5),
                                  right: BorderSide(
                                      color: Colors.white, width: 1.5),
                                ),
                                color: Colors.blueGrey,
                                shape: BoxShape.circle,
                              ),
                              width: 120,
                              height: 120,
                              child: const Center(
                                  child: Text("Upload profile image")),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12),
                          child: InkWell(
                            onTap: () => pickImage(true),
                            child: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.white, width: 1.5),
                                      bottom: BorderSide(
                                          color: Colors.white, width: 1.5),
                                      left: BorderSide(
                                          color: Colors.white, width: 1.5),
                                      right: BorderSide(
                                          color: Colors.white, width: 1.5),
                                    )),
                                height: 120,
                                width: 120,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(profileImage!),
                                )
                                //child: Image.file(profileImage!),
                                ),
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              maxLines: null,
              controller: summaryController,
              decoration:
                  const InputDecoration(hintText: "Describe yourself..."),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
              child: Text(
                "Gender",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.start,
              ),
            ),
            RadioListTile(
                value: Gender.Male,
                groupValue: _gender,
                title: const Text("Male"),
                onChanged: (Gender? value) {
                  setState(() {
                    _gender = value;
                  });
                }),
            RadioListTile(
                value: Gender.Female,
                title: const Text("Female"),
                groupValue: _gender,
                onChanged: (Gender? value) {
                  setState(() {
                    _gender = value;
                  });
                }),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: Text(
                "Marital Status",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            RadioListTile(
                value: MaritalStatus.married,
                title: const Text("Married"),
                groupValue: _maritalStatus,
                onChanged: (MaritalStatus? value) {
                  setState(() {
                    _maritalStatus = value;
                  });
                }),
            RadioListTile(
                value: MaritalStatus.single,
                title: const Text("Single"),
                groupValue: _maritalStatus,
                onChanged: (MaritalStatus? value) {
                  setState(() {
                    _maritalStatus = value;
                  });
                }),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: Text(
                "Date of Birth",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                // validator: (value) => (value == null || value.isEmpty)? "Date of Birth cannot be empty": null,
                controller: birthDateController,
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.calendar_month,
                  ),
                  error: isDoBEmpty
                      ? Text(
                          "Date of birth cant be empty",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        )
                      : null,
                  label: Text(((widget.basicInfo.dob == "")
                      ? "Enter Date of Birth"
                      : widget.basicInfo.dob)),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1970),
                      lastDate: DateTime(DateTime.now().year - 17),
                      initialDate: DateTime(DateTime.now().year - 18));
                  setState(() {
                    if (pickedDate != null) {
                      widget.basicInfo.dob =
                          DateFormat("yyyy-MM-dd").format(pickedDate);
                      birthDateController.text = widget.basicInfo.dob;
                    }
                  });
                }),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                  onPressed: () {
                    addData();
                  },
                  icon: const Icon(Icons.arrow_forward))
            ]),
          ]),
        ));
  }
}

class WorkPlaceDetails extends StatefulWidget {
  VoidCallback incrementPhase;
  GlobalKey<FormState> formKey;

  int workplaceCount = 0;
  DateTime? startDate;
  DateTime? endDate;

  List<WorkExperiences> workplaceData;
  WorkPlaceDetails(
      {super.key,
      required this.incrementPhase,
      required this.formKey,
      required this.workplaceData});

  @override
  State<WorkPlaceDetails> createState() => _WorkPlaceDetailsState();
}

class _WorkPlaceDetailsState extends State<WorkPlaceDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            Text(
              "Workplace history",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ListView.builder(
              itemCount: widget.workplaceCount,
              shrinkWrap: true,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) => {
                        setState(() {
                          widget.workplaceData.elementAt(index).jobTitle =
                              value;
                        })
                      },
                      decoration: const InputDecoration(hintText: "Job Title"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (value) => {
                        setState(() {
                          widget.workplaceData
                              .elementAt(index)
                              .organizationName = value;
                        })
                      },
                      decoration: const InputDecoration(
                          hintText: "The name of the organization"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      onChanged: (value) => {
                        setState(() {
                          widget.workplaceData.elementAt(index).summary = value;
                        })
                      },
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: "Features worked on the organization"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              icon: const Icon(Icons.calendar_month),
                              label: Text(
                                (widget.workplaceData
                                            .elementAt(index)
                                            .startDate ==
                                        null)
                                    ? "Enter the starting date here"
                                    : DateFormat("yyyy-MM-dd").format(widget
                                        .workplaceData
                                        .elementAt(index)
                                        .startDate!),
                              )),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickeDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1970),
                                lastDate: DateTime(2030));
                            setState(() {
                              if (pickeDate != null) {
                                widget.workplaceData
                                    .elementAt(index)
                                    .startDate = pickeDate;
                              }
                            });

                            FocusScope.of(context).unfocus();
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                              icon: const Icon(Icons.calendar_month),
                              label: Text(
                                (widget.workplaceData
                                            .elementAt(index)
                                            .endDate ==
                                        null)
                                    ? "Enter the ending date here"
                                    : DateFormat("yyyy-MM-dd").format(widget
                                        .workplaceData
                                        .elementAt(index)
                                        .endDate!),
                              )),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickeDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1970),
                                lastDate: DateTime(2030));
                            setState(() {
                              if (pickeDate != null) {
                                widget.workplaceData.elementAt(index).endDate =
                                    pickeDate;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    DateTime? dt;
                    widget.workplaceCount++;
                    WorkExperiences workExperiences = WorkExperiences();
                    workExperiences.id = Random().nextInt(10000) + 1000;
                    workExperiences.startDate = dt;
                    workExperiences.endDate = dt;
                    widget.workplaceData.add(workExperiences);
                  });
                },
                child: const Text("Add more +")),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: widget.incrementPhase,
                    icon: const Icon(Icons.arrow_forward))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EducationForm extends StatefulWidget {
  GlobalKey<FormState> formKey;
  VoidCallback incrementPhase;

  EducationForm(
      {super.key,
      required this.formKey,
      required this.incrementPhase,
      required this.educations});

  int educationCount = 0;
  int achivementCount = 0;

  List<Education> educations;
  List<TextEditingController> organizationController =
      List.empty(growable: true);
  List<TextEditingController> levelController = List.empty(growable: true);
  List<TextEditingController> summaryController = List.empty(growable: true);

  @override
  State<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        child: Column(
          children: [
            Text(
              "Education History",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            ListView.builder(
                itemCount: widget.educationCount,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Organization name"),
                          onChanged: (value) => {
                            setState(() {
                              widget.educations
                                  .elementAt(index)
                                  .organizationName = value;
                            })
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(hintText: "Level"),
                          onChanged: (value) => {
                            setState(() {
                              widget.educations.elementAt(index).level = value;
                            })
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          maxLines: null,
                          decoration:
                              const InputDecoration(hintText: "Summary"),
                          onChanged: (value) => {
                            setState(() {
                              widget.educations.elementAt(index).summary =
                                  value;
                            })
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  icon: const Icon(Icons.calendar_month),
                                  label: Text(
                                      (widget.educations.length < index ||
                                              widget.educations
                                                      .elementAt(index)
                                                      .startDate ==
                                                  null)
                                          ? "Enter joined Date"
                                          : DateFormat("yyyy-MM-dd").format(
                                              widget.educations
                                                  .elementAt(index)
                                                  .startDate!))),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1970),
                                    lastDate: DateTime(2030));
                                setState(() {
                                  if (pickedDate != null) {
                                    widget.educations
                                        .elementAt(index)
                                        .startDate = pickedDate;
                                  }
                                });
                              },
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  icon: const Icon(Icons.calendar_month),
                                  label: Text(
                                      (widget.educations.length < index ||
                                              widget.educations
                                                      .elementAt(index)
                                                      .endDate ==
                                                  null)
                                          ? "Enter Ended Date"
                                          : DateFormat("yyyy-MM-dd").format(
                                              widget.educations
                                                  .elementAt(index)
                                                  .endDate!))),
                              onTap: () async {
                                DateTime? dt = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1970),
                                    lastDate: DateTime(2030));
                                setState(() {
                                  if (dt != null) {
                                    widget.educations.elementAt(index).endDate =
                                        dt;
                                  }
                                });
                              },
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Text("Achievements",
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            // ListView.builder(
                            //   shrinkWrap: true,
                            //   itemCount: widget.achivementCount+1, itemBuilder: (innerContext, innerIndex) => Text(innerIndex.toString()) )
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.educations
                                    .elementAt(index)
                                    .accomplishments
                                    .length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (innerContext, innerIndex) =>
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Achievement #${innerIndex + 1}',
                                        ),
                                        SizedBox(
                                            width: 220,
                                            child: TextFormField(
                                              onChanged: (value) {
                                                setState(() {
                                                  widget.educations
                                                      .elementAt(index)
                                                      .accomplishments
                                                      .elementAt(innerIndex)
                                                      .title = value;
                                                });
                                              },
                                              decoration: const InputDecoration(
                                                  hintText: "Achivement Title"),
                                            )),
                                        SizedBox(
                                          width: 220,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              setState(() {
                                                widget.educations
                                                    .elementAt(index)
                                                    .accomplishments
                                                    .elementAt(innerIndex)
                                                    .description = value;
                                              });
                                            },
                                            maxLines: null,
                                            decoration: const InputDecoration(
                                                hintText: "Descriptions"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 220,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              icon: const Icon(
                                                  Icons.calendar_month),
                                              hintText: (widget.educations
                                                          .elementAt(index)
                                                          .accomplishments
                                                          .elementAt(innerIndex)
                                                          .dateTime ==
                                                      null)
                                                  ? "Enter accomplished date"
                                                  : DateFormat("yyyy-MM-dd")
                                                      .format(widget.educations
                                                          .elementAt(index)
                                                          .accomplishments
                                                          .elementAt(innerIndex)
                                                          .dateTime!),
                                            ),
                                            readOnly: true,
                                            onTap: () async {
                                              DateTime? dt =
                                                  await showDatePicker(
                                                      context: context,
                                                      firstDate: DateTime(1970),
                                                      lastDate: DateTime(2030));
                                              setState(() {
                                                if (dt != null) {
                                                  widget.educations
                                                      .elementAt(index)
                                                      .accomplishments
                                                      .elementAt(innerIndex)
                                                      .dateTime = dt;
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    )),

                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    Education education = widget.educations.elementAt(index);
                                    Accomplishment accomplishment = Accomplishment();
                                    accomplishment.description = "";
                                    accomplishment.id = Random().nextInt(10000) + 1000;
                                    accomplishment.title = "";
                                    accomplishment.dateTime = null;
                                    // ignore: unnecessary_null_comparison
                                    List<Accomplishment> accomplishments = (widget.educations.elementAt(index).accomplishments ==null) ? List.empty(growable: true)
                                    : widget.educations.elementAt(index).accomplishments;
                                    accomplishments.add(accomplishment);
                                    education.accomplishments = accomplishments;
                                    widget.achivementCount++;
                                  });
                                },
                                child: const Text("Add Achievement"))
                          ],
                        )
                      ],
                    )),
            TextButton(
                onPressed: () {
                  setState(() {
                    widget.educationCount++;
                    Education education = Education();
                    education.id = Random().nextInt(10000) + 1000;
                    education.startDate = null;
                    education.endDate = null;
                    education.accomplishments = List.empty(growable: true);
                    widget.educations.add(education);
                  });
                },
                child: const Text("Add more +")),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                  onPressed: widget.incrementPhase,
                  icon: const Icon(Icons.arrow_forward)),
            ])
          ],
        ),
      ),
    );
  }
}

class ContactDetailsPage extends StatefulWidget {
  GlobalKey<FormState> formKey;
  VoidCallback incrementPhase;
  ContactDetailsPage(
      {super.key,
      required this.formKey,
      required this.incrementPhase,
      required this.contactInfo});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsState();
  int socialMediaCounter = 0;
  ContactInfo contactInfo;
  TextEditingController phoneController = TextEditingController();
  List<TextEditingController> titleController = List.empty(growable: true);
  List<TextEditingController> urlController = List.empty(growable: true);
  List<TextEditingController> typeController = List.empty(growable: true);
}

class _ContactDetailsState extends State<ContactDetailsPage> {
  RegExp phoneNoRegex = RegExp(r'^98\d{8}$');
  TextEditingController mobilNoController = TextEditingController();
  bool _mobileNoError = false;

  @override
  void initState() {
    super.initState();
  }

  void validate() {
    if (widget.contactInfo.mobileNo != "" ||
        phoneNoRegex.hasMatch(widget.contactInfo.mobileNo!)) {
      widget.incrementPhase();
    } else {
      setState(() {
        _mobileNoError = true;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            Text(
              "Contact Details:",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              onChanged: (value) => {
                setState(() {
                  widget.contactInfo.copyWith(value, null);
                })
              },
              decoration: InputDecoration(
                  errorText: _mobileNoError ? "Enter a valid mobile no." : null,
                  hintText: "Enter mobile no:"),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Social Media Links: ",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(
              height: 30,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.socialMediaCounter,
                itemBuilder: (context, index) => Column(
                      children: [
                        TextFormField(
                          onChanged: (value) => {
                            setState(() {
                              widget.contactInfo.socialMedias
                                  .elementAt(index)
                                  .title = value;
                            })
                          },
                          decoration: const InputDecoration(
                            hintText: "Title",
                          ),
                          controller: widget.titleController.elementAt(index),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          onChanged: (value) => {
                            setState(() {
                              widget.contactInfo.socialMedias
                                  .elementAt(index)
                                  .url = value;
                            })
                          },
                          decoration: const InputDecoration(hintText: "Url"),
                          controller: widget.urlController.elementAt(index),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          onChanged: (value) => {
                            setState(() {
                              widget.contactInfo.socialMedias
                                  .elementAt(index)
                                  .type = value;
                            })
                          },
                          decoration: const InputDecoration(hintText: "Type"),
                          controller: widget.typeController.elementAt(index),
                        ),
                      ],
                    )),
            TextButton(
                onPressed: () {
                  setState(() {
                    SocialMedia socialMedia = SocialMedia();
                    socialMedia.id = Random().nextInt(10000) + 1000;
                    widget.socialMediaCounter++;
                    widget.contactInfo.socialMedias.add(socialMedia);
                    widget.titleController.add(TextEditingController());
                    widget.urlController.add(TextEditingController());
                    widget.typeController.add(TextEditingController());
                  });
                },
                child: const Text("Add More +")),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () => {validate()},
                    icon: const Icon(Icons.arrow_forward)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MiscelleneousPage extends StatefulWidget {
  GlobalKey<FormState> formKey;
  final VoidCallback incrementPhase;

  MiscelleneousPage(
      {super.key,
      required this.formKey,
      required this.incrementPhase,
      required this.skills,
      required this.hobbies,
      required this.languages});

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

  TextEditingController skillController = TextEditingController();
  TextEditingController hobbiesController = TextEditingController();
  TextEditingController languageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: widget.key,
        child: Column(
          children: [
            Wrap(
              direction: Axis.horizontal,
              children: [
                Container(
                  width: 120,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.skillCounter,
                      itemBuilder: (context, index) => Card(
                            elevation: 3,
                            child: Text(
                              widget.skills.elementAt(index).title!,
                              textAlign: TextAlign.center,
                            ),
                          )),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Enter skills to be added"),
                  focusNode: skillFocusNode,
                  controller: skillController,
                  onFieldSubmitted: (value) {
                    Skills skill = Skills();
                    setState(() {
                      widget.skillCounter++;
                      skill.id = Random().nextInt(90000) + 10000;
                      skill.title = value;
                      widget.skills.add(skill);
                      skillController.clear();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Wrap(
              direction: Axis.horizontal,
              children: [
                Container(
                  width: 120,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.hobbiesCounter,
                      itemBuilder: (context, index) => Card(
                            //width: MediaQuery.of(context).size.width * 0.333,
                            child: Text(
                              widget.hobbies.elementAt(index).title,
                              textAlign: TextAlign.center,
                            ),
                          )),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Enter hobbies to be added"),
                  focusNode: hobbiesFocusNode,
                  controller: hobbiesController,
                  onFieldSubmitted: (value) {
                    Hobbies hobbies = Hobbies();
                    setState(() {
                      widget.hobbiesCounter++;
                      hobbies.id = Random().nextInt(90000) + 10000;
                      hobbies.title = value;
                      widget.hobbies.add(hobbies);
                      hobbiesController.clear();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Wrap(
              direction: Axis.horizontal,
              children: [
                Container(
                  width: 120,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.languageCounter,
                      itemBuilder: (context, index) => Card(
                            //width: 120,
                            child: Text(
                              widget.languages.elementAt(index).title,
                              textAlign: TextAlign.center,
                            ),
                          )),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Enter languages to be added"),
                  focusNode: languageFocusNode,
                  controller: languageController,
                  onFieldSubmitted: (value) {
                    Languages languages = Languages();
                    setState(() {
                      widget.languageCounter++;
                      languages.id = Random().nextInt(90000) + 10000;
                      languages.title = value;
                      widget.languages.add(languages);
                      languageController.clear();
                    });
                  },
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                  onPressed: widget.incrementPhase,
                  icon: const Icon(Icons.arrow_forward)),
            ])
          ],
        ),
      ),
    );
  }
}

class FinishedSignupPage extends StatefulWidget {
  @override
  State<FinishedSignupPage> createState() => _FinishedSignupPageState();
}

class _FinishedSignupPageState extends State<FinishedSignupPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Text(
          "Finished Signup",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
          child: const Text("Go back to Login"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ));
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController mobileNoController = TextEditingController();
  List<GlobalKey<FormState>> formStateList =
      List.generate(6, (index) => GlobalKey<FormState>());
  UserData userData = UserData();
  RegExp phoneRegex = RegExp(r'[0-9]{10}');
  RegExp emailRegex = RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$');
  File? image;
  File? cvFile;
  String cvText = "";
  int currentIndex = 0;
  late List<Widget> formPhases;

  List<Education> educationFields = List.empty(growable: true);
  List<Accomplishment> accomplishmentFields = List.empty(growable: true);
  List<SocialMedia> socialMedias = List.empty(growable: true);
  ContactInfo contactInfo = ContactInfo();

  BasicInfo basicInfo = BasicInfo();
  List<Skills> skills = List.empty(growable: true);
  List<Hobbies> hobbies = List.empty(growable: true);
  List<Languages> languages = List.empty(growable: true);
  List<WorkExperiences> workExperiences = List.empty(growable: true);

  FocusNode fullNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode rePasswordFocusNode = FocusNode();

  void _onFocusChangedBasic() {
    if (fullNameFocusNode.hasFocus ||
        emailFocusNode.hasFocus ||
        passwordFocusNode.hasFocus ||
        rePasswordFocusNode.hasFocus) {
      setState(() {
        heightFactor = 0.3;
        widthFactor = -1.0;
        secondHeightFactor = -0.1;
      });
    }
    if (!fullNameFocusNode.hasFocus &&
        !emailFocusNode.hasFocus &&
        !passwordFocusNode.hasFocus &&
        !rePasswordFocusNode.hasFocus) {
      heightFactor = originalHeightFactor;
      widthFactor = originaWidthFactor;
      secondHeightFactor = originaSecondHeightFactor;
    }
    return;
  }

  Future<int> getNextId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var userJson = sharedPreferences.getString("user_data");

    if (userJson == null) {
      return 1;
    }

    List<UserData> userDataList = List.empty(growable: true);
    Iterable decoded = jsonDecode(userJson);
    userDataList = decoded.map((e) => UserData.fromJson(e)).toList();
    return userDataList.length + 1;
  }

  Future<void> storeUserDatatoPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userData.id = await getNextId();
    UserDetails userDetails = UserDetails(basicInfo: basicInfo);
    userDetails.id = await getNextId();
    userDetails.workExperiences = workExperiences;
    userDetails.skills = skills;
    userDetails.hobbies = hobbies;
    userDetails.educations = educationFields;
    userDetails.contactInfo = contactInfo;
    userDetails.languages = languages;
    String? userDataSharedPrefs = sharedPreferences.getString("user_data");
    String? userDetailsSharedPrefs =
        sharedPreferences.getString("user_details");

    List<UserDetails> retrievedUserDetails = List.empty(growable: true);
    List<UserData> retrievedUserData = List.empty(growable: true);

    if (userDataSharedPrefs != null) {
      Iterable decoded = jsonDecode(userDataSharedPrefs);
      retrievedUserData = decoded.map((e) => UserData.fromJson(e)).toList();
    }
    if (userDetailsSharedPrefs != null) {
      Iterable decoded = jsonDecode(userDetailsSharedPrefs);
      retrievedUserDetails =
          decoded.map((e) => UserDetails.fromJson(e)).toList();
    }

    retrievedUserDetails.add(userDetails);
    retrievedUserData.add(userData);
    String jsonUserDetails =
        jsonEncode(retrievedUserDetails.map((e) => e.toJson()).toList());
    String jsonUserData =
        jsonEncode(retrievedUserData.map((e) => e.toJson()).toList());

    sharedPreferences.setString("user_details", jsonUserDetails);
    sharedPreferences.setString("user_data", jsonUserData);
    _incrementPhase();
  }

  void _incrementPhase() {
    setState(() {
      currentIndex = min(++currentIndex, formPhases.length - 1);
    });
  }

  ScrollController scrollController = ScrollController();
  double heightFactor = 0.60;
  double originalHeightFactor = 0.60;
  double widthFactor = 0.7;
  double originaWidthFactor = 0.7;
  double secondHeightFactor = 0.45;
  double originaSecondHeightFactor = 0.45;

  void _onscrollReducePath() {
    setState(() {
      heightFactor = min(
          0.45,
          max(
              originalHeightFactor -
                  (scrollController.position.pixels * (0.0625 / 4)),
              -1.0));
      widthFactor = min(
          0.7,
          max(0.7 - (scrollController.position.pixels * (0.00625 / 4)),
              -0.25)); //0.5
      //widthFactor = min(widthFactor,max(widthFactor - scrollController.position.pixels/40, 0.05));
      secondHeightFactor = min(0.45,
          max(0.45 - (scrollController.position.pixels * (0.0625 / 4)), -1.0));

      //widthFactor = (heightFactor+secondHeightFactor) *0.5;
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onscrollReducePath);
    fullNameFocusNode.addListener(_onFocusChangedBasic);
    emailFocusNode.addListener(_onFocusChangedBasic);
    passwordFocusNode.addListener(_onFocusChangedBasic);
    rePasswordFocusNode.addListener(_onFocusChangedBasic);

    formPhases = [
      BasicDetails(
        formKey: formStateList.first,
        userData: userData,
        incrementPhase: _incrementPhase,
        fullNameFocusNode: fullNameFocusNode,
        emailFocusNode: emailFocusNode,
        passwordFocusNode: passwordFocusNode,
        rePasswordFocusNode: rePasswordFocusNode,
        onChangeFocus: _onFocusChangedBasic,
      ),
      PersonalDetails(
        formKey: formStateList.elementAt(1),
        basicInfo: basicInfo,
        incrementPhase: storeUserDatatoPreferences,
      ),
      FinishedSignupPage(),
      WorkPlaceDetails(
        formKey: formStateList.elementAt(2),
        incrementPhase: _incrementPhase,
        workplaceData: workExperiences,
      ),
      EducationForm(
        formKey: formStateList.elementAt(3),
        incrementPhase: _incrementPhase,
        educations: educationFields,
      ),
      ContactDetailsPage(
        formKey: formStateList.elementAt(4),
        incrementPhase: _incrementPhase,
        contactInfo: contactInfo,
      ),
      MiscelleneousPage(
        formKey: formStateList.elementAt(5),
        incrementPhase: storeUserDatatoPreferences,
        skills: skills,
        languages: languages,
        hobbies: hobbies,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ClipPath(
              clipper: BackgroundWaveClipper(
                  heightFactor: heightFactor,
                  widthFactor: widthFactor,
                  secondHeightFactor: secondHeightFactor),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 280,
                color: Colors.blueAccent,
                //decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xffabb5ff), Color(0xfff6efe9)])),
              ),
            ),
          ),
          Center(
              child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    "Sign Up",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                formPhases.elementAt(currentIndex),
              ],
            ),
          )),
        ],
      ),
    ));
  }
}
