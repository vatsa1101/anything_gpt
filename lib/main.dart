import 'dart:io';
import 'package:dio/dio.dart';
import 'package:url_strategy/url_strategy.dart';
import './bloc/chatbot_bloc.dart';
import './domain/bloc_observer.dart';
import './presentation/chatbot.dart';
import './infrastructure/local_db_hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as gt;

String baseUrl = "";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  HttpOverrides.global = MyHttpOverrides();
  await LocalDb.init();
  final Response response = await Dio()
      .get("https://api.github.com/gists/a9720d65c39b79b259d00f3e8da65f46");
  baseUrl = response.data['files']['BASE_URL']['content'];
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return gt.GetMaterialApp(
      title: 'AnythingGPT',
      home: BlocProvider(
        create: (context) =>
            ChatbotBloc(ChatbotInitialState())..add(FetchUserChatsEvent()),
        child: const ChatbotScreen(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
