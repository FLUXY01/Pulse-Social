import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_social/providers/user_provider.dart';
import 'package:pulse_social/responsive/mobile_screen_layout.dart';
import 'package:pulse_social/responsive/responsive_screen_layout.dart';
import 'package:pulse_social/responsive/web_screen_layout.dart';
import 'package:pulse_social/screens/login_screen_layout.dart';
import 'package:pulse_social/screens/signup_screen_layout.dart';
import 'package:pulse_social/utils/colors.dart';
import 'firebase_options.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
    ?await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,)
    :await Firebase.initializeApp();

  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCCHkxgjwbmbXUdDwo3OD1PNj4BA5qEnVE',
          appId: '1:508780810247:web:b574e32ac48f1b7afe9aa2',
          messagingSenderId: '508780810247',
          projectId: 'pulse-social-4ee66',
          authDomain: 'pulse-social-4ee66.firebaseapp.com',
          storageBucket: 'pulse-social-4ee66.appspot.com'
      ),
    );
  }else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pulse Social',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream:FirebaseAuth.instance.authStateChanges() ,
          builder:(context,snapshot){
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                return const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout(),
                );
              }else if(snapshot.hasError){
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
           return const loginScreen();
          }
        ),
      ),
    );
  }
}