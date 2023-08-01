import '../../../../application/authentication/authentication_bloc.dart';
import '../../../../data/localDb/local_db.dart';
import '../../../../presentation/authentication/signin_popup.dart';
import '../../../../presentation/widgets/responsive.dart';
import '../../../../application/chatbot/chatbot_bloc.dart';
import '../../../utils/color_helpers.dart';
import '../../../utils/font_style_helpers.dart';
import 'trapezium_clipper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            bgColor,
            bgColor,
            bgColor.withOpacity(0),
          ],
        ),
      ),
      child: Column(
        children: [
          const Divider(
            color: primaryColor4,
            thickness: 5,
            height: 5,
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 35,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            title: ClipPath(
              clipper: TrapeziumClipper(cornerRadius: 10),
              child: Container(
                height: 35,
                decoration: const BoxDecoration(
                  color: Color(0xFFf8edfa),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/icon.png",
                        fit: BoxFit.fitHeight,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: AutoSizeText(
                          "AnythingGPT",
                          style: s22kPcw600.copyWith(
                            color: primaryColor1,
                          ),
                          minFontSize: 1,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 2,
                ),
                child: DropdownButton2(
                  value: 0,
                  underline: const SizedBox(),
                  dropdownStyleData: DropdownStyleData(
                    width: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    offset: const Offset(-145, 0),
                  ),
                  customButton: Padding(
                    padding: const EdgeInsets.all(4),
                    child: context.read<AuthenticationBloc>().isSignedIn
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              LocalDb.user!.image,
                              height: 26,
                              width: 26,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.account_circle_rounded,
                            color: Colors.grey.shade700,
                            size: 26,
                          ),
                  ),
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    customHeights: context.read<AuthenticationBloc>().isSignedIn
                        ? [70, 40, 40]
                        : null,
                    height: 40,
                  ),
                  items: [
                    if (context.read<AuthenticationBloc>().isSignedIn)
                      DropdownMenuItem(
                        enabled: false,
                        value: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              flex: 2,
                              child: AutoSizeText(
                                "Google Account",
                                style: kHeading10.copyWith(
                                  color: Colors.grey,
                                ),
                                minFontSize: 1,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Expanded(
                              flex: 3,
                              child: AutoSizeText(
                                LocalDb.user!.name,
                                style: kHeading13.copyWith(
                                  fontWeight: Responsive.isSmallScreen(context)
                                      ? FontWeight.w500
                                      : FontWeight.w600,
                                  fontSize: 12,
                                ),
                                minFontSize: 1,
                                maxLines: 1,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: AutoSizeText(
                                LocalDb.user!.email,
                                style: kHeading10,
                                minFontSize: 1,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                              height: 1,
                              thickness: 1,
                            ),
                          ],
                        ),
                      ),
                    if (!context.read<AuthenticationBloc>().isSignedIn)
                      DropdownMenuItem(
                        value: 0,
                        onTap: () {
                          showSignInPopup(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.login,
                              size: 18,
                              color: primaryColor2,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            AutoSizeText(
                              'Sign In',
                              style: kHeading13.copyWith(
                                fontWeight: Responsive.isSmallScreen(context)
                                    ? FontWeight.w500
                                    : FontWeight.w600,
                              ),
                              minFontSize: 1,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    DropdownMenuItem(
                      value: 1,
                      onTap: () {
                        context.read<ChatbotBloc>().add(ResetChatsEvent());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: primaryColor2,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          AutoSizeText(
                            'Clear Chat',
                            style: kHeading13.copyWith(
                              fontWeight: Responsive.isSmallScreen(context)
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                            ),
                            minFontSize: 1,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    if (context.read<AuthenticationBloc>().isSignedIn)
                      DropdownMenuItem(
                        value: 3,
                        onTap: () {
                          context
                              .read<AuthenticationBloc>()
                              .add(AuthenticationLogoutEvent());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.logout,
                              size: 18,
                              color: primaryColor2,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            AutoSizeText(
                              'Logout',
                              style: kHeading13.copyWith(
                                fontWeight: Responsive.isSmallScreen(context)
                                    ? FontWeight.w500
                                    : FontWeight.w600,
                              ),
                              minFontSize: 1,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (val) {},
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 48);
}
