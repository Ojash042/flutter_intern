import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  static final NotificationService _notificationService = NotificationService();
   
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  Future<void> initiailizeNotification() async{
    WidgetsFlutterBinding.ensureInitialized();
    var initializationSettingsAndroid = const AndroidInitializationSettings('icon');
    var initializationSettingsIoS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings( android: initializationSettingsAndroid, iOS: initializationSettingsIoS);
  
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  
  Future<void> showNotification() async{
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails('defaultChannelId', 'defaultChannelName', importance: Importance.max, priority: Priority.max, ticker: 'ticker');
    var iosPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, "Title", "Body", platformSpecifics, payload: 'itemX');
  }
  
    
}