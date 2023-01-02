import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_demo/provider/movie_provider.dart';
import 'package:provider_demo/screens/home_screen.dart';

import 'constants/app_constants.dart';

void main() {
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
            create: (_)=>MovieProvider(),
            child: const HomeScreen()),
        
      ],
      child: MaterialApp(
        title: AppConstants.appTitleString,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
       // home: user != null || isLinkedInLoggedIn == true || isFacebookLoggedIn == true ? const HomeScreen(): const LoginScreen(),
        
         home: const HomeScreen(),
      
        //builder: EasyLoading.init(),
      ),
    );
    
    
    
    // ChangeNotifierProvider(
    //   create: (context) {
    //     MovieProvider();
    //   },
    //   builder: (context, child) {
    //     return MaterialApp(
    //     title: 'Provider Demo',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     home: const HomeScreen(),
    //   );
    //   },
    //   child: MaterialApp(
    //     title: 'Provider Demo',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     home: const HomeScreen(),
    //   ),
    // );
  }
}