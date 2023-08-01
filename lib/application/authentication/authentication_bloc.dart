import '../../domain/authentication/user.dart' as auth;
import '../../domain/utils/logger.dart';
import '../../data/localDb/local_db.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/utils/event.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  bool isSignedIn = false;
  bool initDone = false;
  AuthenticationBloc(AuthenticationState authenticationInitial)
      : super(authenticationInitial) {
    on<AuthenticationAppStartEvent>((event, emit) async {
      emit(AuthenticationLoadingState());
      try {
        if (!initDone) {
          initDone = true;
          final remoteConfig = FirebaseRemoteConfig.instance;
          await remoteConfig.setConfigSettings(RemoteConfigSettings(
            fetchTimeout: const Duration(minutes: 1),
            minimumFetchInterval: const Duration(hours: 1),
          ));
          await remoteConfig.fetchAndActivate();
        }
      } catch (e) {
        logger.e(e);
      }
      try {
        await FirebaseAuth.instance.currentUser?.reload();
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          isSignedIn = true;
        } else {
          isSignedIn = false;
        }
        emit(AuthenticationAppStartedState());
      } catch (e) {
        emit(AuthenticationAppStartErrorState(error: e.toString()));
      }
    });
    on<AuthenticationSignInEvent>((event, emit) async {
      emit(AuthenticationSignInLoadingState());
      try {
        GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();
        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          final userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          String? token = await userCredential.user?.getIdToken();
          if (token != null) {
            await LocalDb.saveUserDetails(auth.User(
                email: userCredential.user?.email ?? "",
                image: userCredential.user?.photoURL ?? "",
                name: userCredential.user?.displayName ?? ""));
            emit(AuthenticationSignedInState());
          } else {
            emit(const AuthenticationSignInErrorState(
                error: "Failed to sign in with google"));
          }
          googleSignIn.signOut();
        } else {
          emit(const AuthenticationSignInErrorState(
              error: "Please select an account to continue"));
        }
      } catch (e) {
        if (e.toString() == "popup_closed") {
          emit(const AuthenticationSignInErrorState(
              error: "Please select an account to continue"));
        } else {
          emit(AuthenticationSignInErrorState(error: e.toString()));
        }
      }
    });
    on<AuthenticationLogoutEvent>((event, emit) async {
      emit(AuthenticationLoadingState());
      try {
        await FirebaseAuth.instance.signOut();
        await LocalDb.clearUserData();
        add(AuthenticationAppStartEvent());
      } catch (e) {
        emit(AuthenticationAppStartErrorState(error: e.toString()));
      }
    });
  }
}
