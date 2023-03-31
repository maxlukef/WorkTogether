import 'package:flutter/material.dart';
import 'package:work_together_flutter/pages/signup/signup_page.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

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
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onSaved: (email) {},
            decoration: const InputDecoration(hintText: "email"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            onSaved: (password) {},
            obscureText: true,
            decoration: const InputDecoration(hintText: "password"),
          ),
        ),
        TextButton(
            onPressed: () => {},
            child: const Text(
              "Login",
            )),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return SignupPage();
                },
              ));
            },
            child: const Text(
              "Create an Account",
            ))
      ],
    ));
  }
}
