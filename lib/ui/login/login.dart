import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kampusku/ui/login/textfield_login.dart';
import 'package:kampusku/utils/shimmer/login/shimmer_login.dart';
import 'package:kampusku/utils/theme/light_and_dark.dart';
import 'package:kampusku/viewmodels/login_view_model.dart';
import 'package:logger/logger.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginViewModel loginViewModel = LoginViewModel();
  final logger = Logger();

  Future<void> fakeAPI() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      // logger.i('Data login Loaded');
      loginViewModel.loginModel.isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fakeAPI();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: LightAndDarkMode.primaryColor(context),
      systemNavigationBarColor: LightAndDarkMode.bottomNavBar(context),
    ));

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: loginViewModel.loginModel.isLoading
            ? ShimmerLogin() : buildLoginContent(),
      ),
    );
  }

  Widget buildLoginContent() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.42,
                      decoration: BoxDecoration(
                        color: LightAndDarkMode.primaryColor(context),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1,
                        left: MediaQuery.of(context).size.width * 0.25,
                      ),
                      child: Image.asset(
                        'assets/stmik.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: MediaQuery.of(context).size.width * 0.05,
                      child: Column(
                        children: [
                          TextFieldLogin(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
