import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:http/http.dart' as http;

class ToDoModel{
  ToDoModel({this.id = -1, this.todo, this.completed = false, this.userId = -1});
  int id;
  String? todo;
  bool completed = false;
  int userId;

  factory ToDoModel.fromJson(Map<String,dynamic> json){
    return ToDoModel(id:json["id"], todo: json["todo"], completed: json["completed"], userId: json["userId"]);
  }
}

class ToDoPage extends StatefulWidget{
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() {
    return _ToDoPage();
  }

}

class _ToDoPage extends State<ToDoPage>{
  List<ToDoModel> todos = [];
  Widget showAddTodoDialog(){
    TextEditingController todoController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(onPressed: (){Navigator.of(context).pop();}, icon: const Icon(Icons.cancel_outlined))),
              const SizedBox(height: 30,),
              TextFormField(decoration: const InputDecoration(hintText: "Add a todo"), controller: todoController,),
              const SizedBox(height: 30,),
              OutlinedButton(onPressed: (){
                setState(() { 
                  todos.add(ToDoModel(id: Random().nextInt(100)+10, completed: false, todo: todoController.text, userId: 1), );
                });
                Navigator.of(context).pop();
              }, child: const Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }
  void postRequest(int todoId) async{
    ToDoModel todo = todos.firstWhere((element) => element.id == todoId);
    await http.put(
      Uri.parse('https://dummyjson.com/todos/$todoId'),
      headers: {"Content-Type": 'application/json'},
      body: 
      jsonEncode({
        "completed": todo..completed,
      }));
  } 

  void fetchToDos() async{
    http.Response response = await http.get(Uri.parse("https://dummyjson.com/todos"));
    if(response.statusCode == 200){
      Iterable responseJson = json.decode(response.body)["todos"];
      setState(() { 
        todos = responseJson.map((e) => ToDoModel.fromJson(e)).toList();
      });
    }
    return;
  }

  void deleteTodo(int todoId) async{
    await http.delete(Uri.parse("https://dummyjson.com/todos/$todoId"));
  }
  @override
  void initState() {
    super.initState();
    fetchToDos();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      //drawer: const LoggedInDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OutlinedButton.icon(onPressed: (){showDialog(context: context, builder: (context) => showAddTodoDialog());}, icon: const Icon(Icons.add_outlined), label: const Text("Add More")),
            Column(
              children: todos!.map((e) => ListTile(leading: Icon(e.completed ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined),
               title: Text(e.todo!, style: TextStyle(decoration: e.completed ? TextDecoration.lineThrough : null),),
               trailing: IconButton(icon: const Icon(Icons.delete_outline), color:Theme.of(context).colorScheme.error, onPressed: (){
                setState(() {
                  todos.removeWhere((element) => element.id ==e.id);
                });             
               },),
               onTap: (){
                setState(() {
                  e.completed = !e.completed;
                  postRequest(e.id);
                });
               },
               )).toList()
            ),
          ],
        ),
      ), 
    );
  }
}