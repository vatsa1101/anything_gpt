import 'dart:math';
import '../../application/authentication/authentication_bloc.dart';
import '../widgets/custom_toast.dart';
import '../utils/color_helpers.dart';
import '../utils/font_style_helpers.dart';
import '../utils/size_helpers.dart';
import '../widgets/responsive.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

Future<void> showSignInPopup(BuildContext context) async {
  bool isLoading = false;
  Future.delayed(
    Duration.zero,
    () => showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: SizedBox(
            width: min(context.width * 0.9, 400),
            child: Material(
              color: bgColor,
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 5,
                        top: 5,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: SizedBox(),
                            ),
                            Expanded(
                              child: Image.asset(
                                "assets/images/icon.png",
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: SizedBox(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        AutoSizeText(
                          "Sign In To Continue",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          minFontSize: 1,
                          style: kHeading18w600.copyWith(
                            fontWeight: Responsive.isSmallScreen(context)
                                ? FontWeight.w500
                                : FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BlocProvider.value(
                          value: BlocProvider.of<AuthenticationBloc>(context),
                          child: BlocConsumer<AuthenticationBloc,
                              AuthenticationState>(
                            listener: (_, state) {
                              if (state is AuthenticationSignInLoadingState) {
                                isLoading = true;
                              }
                              if (state is AuthenticationSignInErrorState) {
                                isLoading = false;
                                showErrorToast(
                                    context: context, error: state.error);
                              }
                              if (state is AuthenticationSignedInState) {
                                Navigator.of(context).pop();
                                context
                                    .read<AuthenticationBloc>()
                                    .add(AuthenticationAppStartEvent());
                              }
                            },
                            builder: (_, state) {
                              return ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context
                                            .read<AuthenticationBloc>()
                                            .add(AuthenticationSignInEvent());
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  disabledBackgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 2,
                                    right: 15,
                                    top: 2,
                                    bottom: 2,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: bgColor,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: SvgPicture.asset(
                                          "assets/images/google.svg",
                                          height: 30,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: isLoading
                                            ? const SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : AutoSizeText(
                                                "Sign in with Google",
                                                style: kHeading18w600.copyWith(
                                                  fontSize: 16,
                                                  color: bgColor,
                                                  fontWeight:
                                                      Responsive.isSmallScreen(
                                                              context)
                                                          ? FontWeight.w500
                                                          : FontWeight.w600,
                                                ),
                                                minFontSize: 1,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().slideY(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 300),
                begin: 2,
                end: 0,
              ),
        );
      },
    ),
  );
}
