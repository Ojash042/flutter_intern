import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/course_states.dart';
import 'package:flutter_intern/project/bloc/courses_bloc.dart';
import 'package:flutter_intern/project/bloc/instructor_bloc.dart';
import 'package:flutter_intern/project/bloc/instructor_state.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;

class CoursesDetailsPage extends StatefulWidget{
  @override
  State<CoursesDetailsPage> createState() => _CoursesDetailsPageState();
  final String courseId;
  const CoursesDetailsPage({super.key, required this.courseId});
}

class SyllabusPage extends StatelessWidget{  
  final List<TModels.Syllabus> syllabus;
  const SyllabusPage({super.key, required this.syllabus});

  @override
  Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    //alignment: Alignment.topLeft,
    child: Wrap(
      children: syllabus.map((e) => ExpansionTile(
      expandedAlignment: Alignment.topLeft,
        title: Text(e.title),
        children:[
          const SizedBox(height: 15,),
          const Align(alignment: Alignment.topLeft, child: Text("Summary", style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline
          ),),),
          const SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Align(alignment: Alignment.topLeft, child: Text(e.summary, maxLines: null,)),
          ),
          const SizedBox(height: 15,),
          Row(children: [
            const Text("Total Content: ", style: TextStyle(fontSize: 14,decoration: TextDecoration.underline, fontWeight: FontWeight.bold),),
            const SizedBox(width: 15,),
            Text(e.totalContent.toString()),
          ],),
          const SizedBox(height: 15,),
          Row(children: [
            const Text("Hours to be completed: ", style: TextStyle(fontSize: 14,decoration: TextDecoration.underline, fontWeight: FontWeight.bold),),
            const SizedBox(width: 15,),
            Text(e.hoursToBeCompleted.toString()),
          ],),
          const SizedBox(height: 30,)
          ],
        )).toList(),
    ),
  );
  }
}


class FAQPage extends StatelessWidget{
  final List<TModels.FAQ> faqs;
  const FAQPage({super.key, required this.faqs}); 
@override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Wrap(alignment: WrapAlignment.start,
        children: faqs.map((e) => ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Text(e.title), children: [
          const SizedBox(width: 30,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              const Text("Subtitle:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
              const SizedBox(width: 5,),
              Text(e.subtitle),
              ],),
          ),
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              const Text("Description:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
              const SizedBox(width: 5,),
              Text(e.description),
              ],),
          ),
          const SizedBox(height: 30,),
        ],)).toList(),),
      ),
      );
  }
} 

class DescriptionPage extends StatelessWidget{
  final String description, overview;
  final double price;
  final List<TModels.Instructor> instructors;
  final List<String> skills;
  const DescriptionPage({super.key, required this.description, required this.overview, required this.price, required this.instructors, 

  required this.skills});

  @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [  
              Row(children: [
                const Text('Price: ', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, fontSize: 18),),
                const SizedBox(width: 10,),
                Text(price.toString()),
              ],),
              const SizedBox(height: 30,),
              const Text("Instructors details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),), 
              const SizedBox(height: 10,),
              Row(children: [
                const Text("No. of instructors: "),
                Text(instructors.length.toString()),
              ],),
              const SizedBox(height: 10,),
              ListView.builder( 
                shrinkWrap: true,
                itemCount: instructors.length,
                itemBuilder: (context, index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Row(children: [
                      const Text("Instructor: ", style: TextStyle(fontStyle: FontStyle.italic),),
                      const SizedBox(width: 5,),
                      Text(instructors.elementAt(index).name),
                    ],),
                    RichText(text: TextSpan(
                      children: [
                        const WidgetSpan(child:SizedBox(width: 4,)),
                        const TextSpan(text: '-'),
                        const WidgetSpan(child: SizedBox(width: 12,),),
                       TextSpan(text:instructors.elementAt(index).summary )],
                      )),
                    Text('-\t${instructors.elementAt(index).summary}'),
                  ]);
                }),
                const SizedBox(height: 20,),
                const Text("Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                const SizedBox(height: 10,),
                Wrap(children: skills.map((e) => Card(child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(e),
                ),)).toList()),
            ],),
          ),
        ),
      );
    }
}

class ImageClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = 50.0; // adjust the radius for the rounded corners

    // top-left corner
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    // top edge
    path.lineTo(size.width - radius, 0);

    // top-right corner (stretched)
    path.lineTo(size.width, radius);
    path.lineTo(size.width, size.height - radius);

    // right edge
    path.lineTo(size.width, size.height);

    // bottom-right corner (stretched)
    path.lineTo(size.width - radius, size.height);
    path.lineTo(size.width - radius, size.height);

    // bottom edge
    path.lineTo(radius, size.height);

    // bottom-left corner

    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    // close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}

class _CoursesDetailsPageState extends State<CoursesDetailsPage> with SingleTickerProviderStateMixin{
  TModels.Courses? currentCourse;
  List<TModels.Instructor>? currentCourseInstructor = List.empty(growable: true);
  late final TabController _tabController = TabController(length: 2, vsync: this);
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
    body:
    MultiBlocListener(
        listeners: [
            BlocListener<CoursesBloc, CourseListStates>(
          listener: (context, coursesState) {
            currentCourse = (coursesState is CourseListEmpty) ? null : coursesState.courses?.firstWhereOrNull((e) => e.id == int.parse(widget.courseId)); 
          },
    
        ),
            BlocListener<InstructorBloc, InstructorState>(
                listener: (context, instructorState) {
                  if(currentCourse ==null || instructorState == InstructorEmpty()){
                    return;
                  }
                  currentCourseInstructor = (currentCourse == null || instructorState == InstructorEmpty() ) ? null :
                  instructorState.instructors?.where((e) => currentCourse!.instructors.contains(e.id)).toList();
                },
            ),
        ],
              child: BlocBuilder<CoursesBloc, CourseListStates>(
              builder: (context, coursesState) {
                return BlocBuilder<InstructorBloc, InstructorState>(
                  builder: (context, instructorState) {
                                      return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: Column(
                        children: [
                          ClipPath(clipper: ImageClipper(),
                            child: Image.network(currentCourse!.image),
                            ),
                            const SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0),
                              child: Row(
                                children: [
                                  Text(currentCourse!.title, style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                                  const Spacer(),
                                  Text('Rs. ${currentCourse!.price}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.lightGreenAccent),)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:16.0),
                              child: Text(currentCourse!.subtitle, style: const TextStyle(color: Colors.greenAccent),),
                            ),
                            const SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:16.0),
                              child: GestureDetector(
                                onTap: ()=> setState(() {
                                  showMore = !showMore;
                                }),
                                child: Text(currentCourse!.description, maxLines: showMore? 100 : 2, overflow: TextOverflow.ellipsis, 
                                style: const TextStyle(fontWeight: FontWeight.w100, color: Colors.black26),),

                                ),
                            ),
                            SizedBox(height: showMore ? 10 : 0 ),
                            showMore ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Wrap(spacing: 5, children: currentCourse!.skills.map((e) => Card(color: Colors.white,elevation: 0,child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(e),
                              ),)).toList(),),
                            ): Container(),
                            SizedBox(height: showMore ? 10 : 0),
                            showMore ? SingleChildScrollView(
                              child: Wrap(spacing: 5, children: currentCourseInstructor!.map((e) => 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                CircleAvatar(backgroundImage: NetworkImage(e.image),),  
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                  Text(e.name), 
                                  Text(e.summary)
                                  ],)],) ).toList()),
                            ) : Container(),
                        ],
                      ),),
                      SliverAppBar(
                        title:TabBar(tabs: const [
                            //Tab(text: "Description",),
                            Tab(text: "Syllabus"),
                            Tab(text: "FAQs",),
                          ],
                          controller: _tabController,),
                          pinned: true, 
                          automaticallyImplyLeading: false,
                          leading: null,
                      ),
                      SliverFillRemaining(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            SingleChildScrollView(child: SyllabusPage(syllabus: currentCourse!.syllabus,)),
                          SingleChildScrollView(child: FAQPage(faqs: currentCourse!.faqs,)),
                        ])
                      )
                    ],
                  ); 
                  },
                );
              },
            ),
    ) 
    );
  } 
}