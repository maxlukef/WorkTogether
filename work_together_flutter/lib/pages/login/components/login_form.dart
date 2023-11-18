import 'package:flutter/material.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';
import 'package:work_together_flutter/pages/signup/signup_page.dart';

import '../../../http_request.dart';
import '../../../main_container.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    Key? key,
  }) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Welcome Back!",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onSaved: (email) {},
            cursorColor: Colors.black,
            decoration: InputDecoration(
                hintText: "email",
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: ourSecondaryColor(), width: 3.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: ourSecondaryColor(), width: 3.0),
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            onSaved: (password) {},
            obscureText: true,
            cursorColor: Colors.black,
            decoration: InputDecoration(
                hintText: "password",
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: ourSecondaryColor(), width: 3.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: ourSecondaryColor(), width: 3.0),
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: ourLightColor()),
              onPressed: () async {
                if (await HttpService()
                    .login(emailController.text, passwordController.text)) {
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                            Animation<double> animation1,
                            Animation<double> animation2) {
                          return const MainContainer();
                        },
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 24, color: Colors.white),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: ourLightColor()),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation1,
                        Animation<double> animation2) {
                      return const SignupPage();
                    },
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: const Text(
                "Create an Account",
                style: TextStyle(fontSize: 24, color: Colors.white),
              )),
        )
      ],
    ));
  }
}
