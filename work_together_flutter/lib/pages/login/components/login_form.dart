import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        const Text("Welcome Back!"),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onSaved: (email) {},
          decoration: const InputDecoration(hintText: "email"),
        ),
        TextFormField(
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          onSaved: (password) {},
          obscureText: true,
          decoration: const InputDecoration(hintText: "password"),
        ),
        TextButton(
            onPressed: () => {},
            child: const Text(
              "Login",
            )),
        TextButton(
            onPressed: () => {},
            child: const Text(
              "Create an Account",
            ))
      ],
    ));
  }
}
