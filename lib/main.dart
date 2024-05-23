import 'package:automated_texbook_system/firebase_options.dart';
import 'package:automated_texbook_system/utill/routes.dart';
import 'package:automated_texbook_system/utill/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoom_widget/zoom_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
          // options: DefaultFirebaseOptions.currentPlatform,
          options: const FirebaseOptions(
        apiKey: 'AIzaSyDDv-XfymCvpHOgzg9SKixeUwEdJqVIqwM',
        appId: '1:299319567459:web:665b2c9a6a2918a609c456',
        messagingSenderId: '299319567459',
        projectId: 'automated-textbook-system',
        authDomain: 'automated-textbook-system.firebaseapp.com',
        storageBucket: 'automated-textbook-system.appspot.com',
      ));
    } else {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    }
  } catch (e) {
    rethrow;
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.theme(),
      routerConfig: routes,
    );
  }
}
