import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart' as cupertino show CupertinoIcons ;
import 'package:flutter_intern/project/bloc/auth_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_events.dart';
import 'package:flutter_intern/project/bloc/auth_states.dart';
import 'package:flutter_intern/project/misc.dart';

class LogoutPage extends StatefulWidget{
  const LogoutPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LogoutPageState();
  }
}

class _LogoutPageState extends State<LogoutPage>{
  @override
  void initState() {
    super.initState();
    setState(() {
      
    });
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
        
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    const double cardPadding = 12;
    return BlocBuilder<AuthBloc, AuthStates>(
      builder: (builder, state) => Scaffold(
        appBar: const CommonAppBar(),
        bottomNavigationBar: const CommonNavigationBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: 
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
            child: Column(
              children: [
                Row(children: [const Text("Menu", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),), const Spacer(), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(onPressed: (){}, icon: const Icon(cupertino.CupertinoIcons.gear_alt_fill)),
                ),
                IconButton(onPressed: (){}, icon: const Icon(cupertino.CupertinoIcons.search)),
                ],),
                SizedBox(height: constraints.maxWidth * 0.05,),
                SizedBox(width : MediaQuery.of(context).size.width, child: Card(color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                    CircleAvatar(backgroundImage: FileImage(File(BlocProvider.of<AuthBloc>(context).state.userDetails!.basicInfo.profileImage.imagePath),)), 
                    const SizedBox(width: 10,),
                    Text(BlocProvider.of<AuthBloc>(context).state.userData!.name), 
                    const Spacer(),
                    IconButton(onPressed: (){}, icon: Icon(cupertino.CupertinoIcons.chevron_down_circle_fill, color: Colors.grey[400],)),
                    //CircleAvatar(backgroundColor: Colors.grey, child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_downward_rounded)))
                    ],),
                ),
                )),
                SizedBox(height: constraints.maxHeight * 0.05,),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: (1/0.6),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Card(
                      color: Colors.white, child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShaderMask(
                            blendMode: ui.BlendMode.srcIn,
                            shaderCallback: (Rect bounds){
                              return ui.Gradient.linear(const Offset(12.0, 24),const Offset(24, 4), [Colors.blue, Colors.white]);
                            },
                            child: const Icon(Icons.history, size: 35,),),
                            const Text("Memories"),
                          ],
                        ),
                      ),),
                    Card(color: Colors.white, child: Padding(
                      padding: const EdgeInsets.all(cardPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(blendMode: ui.BlendMode.srcIn,
                          shaderCallback: (bounds) {
                            return ui.Gradient.linear(const Offset(32, 12), const Offset(0,32), [Colors.deepPurple[500]!, Colors.blue[500]!]);
                          },
                          child: const Icon(Icons.bookmark, size: 35,),
                          ),
                        const Text("Saved"),
                        ],
                      ),
                    ),),
                    Card(color: Colors.white, child: Padding(
                      padding: const EdgeInsets.all(cardPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(blendMode: ui.BlendMode.srcIn,shaderCallback: (bounds) => ui.Gradient.linear(const Offset(32, 12), const Offset(0, 32), [Colors.blue[700]!, Colors.blueAccent]), 
                          child: const Icon(Icons.shop, size: 35,),
                          ),
                          const Text("Marketplace")
                      ],),
                    ),),
                    Card(color: Colors.white, 
                      child: Padding(
                        padding: const EdgeInsets.all(cardPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          ShaderMask(blendMode: ui.BlendMode.srcIn, shaderCallback: (bounds) => ui.Gradient.linear(const Offset(32, 12), const Offset(0, 32), [Colors.blueAccent, Colors.white]),
                          child: const Icon(Icons.group, size: 30,),
                          ),
                          const Text("Groups"),
                        ],),
                      ),
                    ), //group
                   Card(color: Colors.white, 
                   child: Padding(
                        padding: const EdgeInsets.all(cardPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          ShaderMask(blendMode: ui.BlendMode.srcIn, shaderCallback: (bounds) => ui.Gradient.linear(const Offset(20, 53), const Offset(53, 20), [Colors.red[900]!, Colors.red[200]!]),
                          child: const Icon(Icons.slideshow, size: 30,),
                          ),
                          const Text("Videos"),
                        ],),
                      ) ), //videos
                   Card(color: Colors.white,
                   child: Padding(
                        padding: const EdgeInsets.all(cardPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          ShaderMask(blendMode: ui.BlendMode.srcIn, shaderCallback: (bounds) => ui.Gradient.linear(const Offset(32, 12), const Offset(0, 32), [Colors.greenAccent, Colors.white]),
                          child: const Icon(Icons.style, size: 30,),
                          ),
                          const Text("Finds"),
                        ],),
                      ) ), //finds
                  ],
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05,),
                SizedBox(
                  width: constraints.maxWidth,
                  child: OutlinedButton(
                    style: blueFilledButtonStyle.copyWith(
                    side: const WidgetStatePropertyAll(BorderSide(color: Colors.transparent)),
                    backgroundColor: WidgetStatePropertyAll(Colors.grey[300])),
                    onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(RequestLogoutEvent());
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                    }, child: const Text("Logout", style: TextStyle(color: Colors.black),),),
                ),
                //   OutlinedButton.icon(onPressed: (){
                //   BlocProvider.of<AuthBloc>(context).add(RequestLogoutEvent());
                //   Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                // }, label: const Text("Logout"), icon: const Icon(Icons.exit_to_app_outlined),),
              ],
            ),
          );
          },
        ),
        )
      ),
    );
  }
}