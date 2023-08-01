import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import './app.dart';
import './firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'domain/utils/bloc_observer.dart';
import 'data/localDb/local_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalDb.init();
  Bloc.observer = SimpleBlocObserver();
  runApp(const App());
}
