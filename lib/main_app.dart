import 'application/authentication/authentication_bloc.dart';
import 'presentation/home/home_page.dart';
import 'presentation/utils/color_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late SpeechToTextProvider speechProvider;

  @override
  void initState() {
    super.initState();
    speechProvider = SpeechToTextProvider(SpeechToText());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SpeechToTextProvider>.value(
      value: speechProvider,
      child: BlocProvider(
        create: (context) => AuthenticationBloc(AuthenticationInitialState())
          ..add(AuthenticationAppStartEvent()),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          buildWhen: (previous, current) {
            if (current is AuthenticationAppStartedState ||
                current is AuthenticationLoadingState ||
                current is AuthenticationAppStartErrorState) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            if (state is AuthenticationAppStartedState) {
              return const HomePage();
            }
            return const Scaffold(
              backgroundColor: bgColor,
              body: Center(
                child: CircularProgressIndicator(
                  color: primaryColor2,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
