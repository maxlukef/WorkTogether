import 'package:flutter/material.dart';
import 'package:work_together_flutter/pages/signup/signup_page.dart';

import '../../../http_request.dart';
import '../../../main.dart';
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
            decoration: InputDecoration(
                hintText: "email",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Color(0xFF1192DC), width: 5.0))),
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
            decoration: InputDecoration(
                hintText: "password",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Color(0xFF1192DC), width: 5.0))),
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              if (await HttpService()
                  .login(emailController.text, passwordController.text)) {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return const MainContainer();
                  },
                ));
              }
            },
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 24),
            )),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const SignupPage();
                },
              ));
            },
            child: const Text(
              "Create an Account",
              style: TextStyle(fontSize: 24),
            ))
      ],
    ));
  }
}
