// ignore_for_file: depend_on_referenced_packages

import 'package:bossshopadmin/Features/AllUsers.dart/AllUsersScreen.dart';
import 'package:bossshopadmin/Features/Productsmanager/categoryViewer/mainbloc/Repository/repository.dart';
import 'package:bossshopadmin/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (context) => Repository())],
      child: const MaterialApp(
        home: AllUsersScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
