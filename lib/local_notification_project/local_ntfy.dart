import 'package:flutter/material.dart';
import 'package:flutter_intern/local_notification_project/firebase_options.dart';
import 'package:flutter_intern/local_notification_project/local_ntfy.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_intern/local_notification_project/notification_service.dart';
import 'package:rxdart/rxdart.dart';


 final _messageStreamController = BehaviorSubject<RemoteMessage>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 await Firebase.initializeApp();

 if (kDebugMode) {
   print("Handling a background message: ${message.messageId}");
   print('Message data: ${message.data}');
   print('Message notification: ${message.notification?.title}');
   print('Message notification: ${message.notification?.body}');
 }
}


Future<void> main(List<String> args) async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final FirebaseMessaging messaging =  FirebaseMessaging.instance;
  
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  final settings =  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );

  String? token = await messaging.getToken();
  if(kDebugMode == true){
    print('token = $token');
  }

 
 
 FirebaseMessaging.onMessage.listen((RemoteMessage message){
  _messageStreamController.sink.add(message);
 });
 await NotificationService().initiailizeNotification();
 runApp(App()); 
}

class App extends StatefulWidget{
  @override
  State<App> createState() {
    return _AppState();
  }
}

class _AppState extends State<App>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent)),
    home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>{
  NotificationService ntfyService = NotificationService();
  String? _lastMessage = "";

  _HomePageState(){
    _messageStreamController.listen((msg) {
      setState(() {
        if(msg.notification != null){
          _lastMessage =  'Received a notification message: \nTitle=${msg.notification?.title},\nBody=${msg.notification?.body},\nData=${msg.data}';
        }
        else{
          _lastMessage = 'Received a data message: ${msg.data}';
        }
      });
     });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ntfy Project"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body:  Center(
        child: Column(
          children: [
            const Text('Last Message From Firebase'),
            const SizedBox(height: 30,),
            Text(_lastMessage!),
            const SizedBox(height: 30,),
            const SizedBox(height: 30,),
            OutlinedButton(onPressed: (){
              ntfyService.showNotification();
            }, child: const Text("Notify")),
          ],
        ),
      ),
    );
  }
}