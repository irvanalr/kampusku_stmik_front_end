import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kampusku/utils/routes/route_paths.dart';
import 'package:kampusku/utils/theme/light_and_dark.dart';
import 'package:kampusku/viewmodels/login_view_model.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TextFieldLogin extends StatefulWidget {
  const TextFieldLogin({super.key});

  @override
  State<TextFieldLogin> createState() => _TextFieldLoginState();
}

class _TextFieldLoginState extends State<TextFieldLogin> {
  LoginViewModel loginViewModel = LoginViewModel();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final logger = Logger();
  final String lgnTkn1 = dotenv.get('LOGINTOKENISSUER');
  final String lgnTkn2 = dotenv.get('LOGINTOKENSECRETKEY');
  final String lgnTkn3 = dotenv.get('LOGINTOKENSHAREDPREFERENCES');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void validateInput() {
    loginViewModel.login().then((result) async {
      Map<String, dynamic> responseBody = result['responseBody'];
      int statusCode = result['statusCode'];

      if (statusCode == 200) {
        loginViewModel.loginModel.timeStamp = responseBody['timestamp'];
        loginViewModel.loginModel.status = responseBody['status'];
        loginViewModel.loginModel.message = responseBody['message'];
        loginViewModel.loginModel.token = responseBody['token'];
        await loginViewModel.saveValue(loginViewModel.loginModel.token, lgnTkn1, lgnTkn2, lgnTkn3);
        if (mounted) {
          Navigator.pushReplacementNamed(context, RoutePaths.dashboard);
        }
      } else {
        loginViewModel.loginModel.timeStamp = responseBody['timestamp'];
        loginViewModel.loginModel.status = responseBody['status'];
        loginViewModel.loginModel.message = responseBody['message'];
        if(
        loginViewModel.loginModel.message == "email atau password anda salah !!!" ||
            loginViewModel.loginModel.message == "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!"
        ) {
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "INFROMASI",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    loginViewModel.loginModel.message,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'OK',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: LightAndDarkMode.primaryColor(context)
                            )
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          throw Exception('Error selain 403 dengan message Username Atau Password salah silahkan coba lagi !!!');
        }
      }
    }).catchError((error) {
      logger.e(error);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            key: const Key('AlertGetApiKey'),
            title: const Center(
              child:Text(
                "Perhatian",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            content: const Text(
              'SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: LightAndDarkMode.primaryColor(context)
                      )
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              controller: emailController,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[$`]'))],
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(passwordFocusNode);
              },
              onChanged: (value) {
                setState(() {
                  loginViewModel.updateEmail(value);
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Email',
                labelStyle: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 72, 72, 72),
                ),
              ),
              cursorColor: Colors.black,
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              controller: passwordController,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[$`]'))],
              keyboardType: TextInputType.text,
              focusNode: passwordFocusNode,
              obscureText: !loginViewModel.loginModel.kataSandiVisible,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                setState(() {
                  loginViewModel.updatePassword(value);
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Password',
                labelStyle: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Color.fromARGB(255, 72, 72, 72),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    loginViewModel.kataSandiVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      loginViewModel.kataSandiVisibility();
                    });
                  },
                ),
              ),
              cursorColor: Colors.black,
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: loginViewModel.loginModel.isButtonEnabled
                  ? LightAndDarkMode.primaryColor(context)
                  : Colors.grey,
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: loginViewModel.loginModel.isButtonEnabled ? validateInput : null,
              child: Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: loginViewModel.loginModel.isButtonEnabled ? Colors.white : Colors.blueGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
