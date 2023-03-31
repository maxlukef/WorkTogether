import 'package:flutter/material.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        const Text(
          "Welcome!",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            onSaved: (confirmedPassword) {},
            obscureText: true,
            decoration: const InputDecoration(hintText: "confirm password"),
          ),
        ),
        TextButton(
            onPressed: () => {},
            child: const Text(
              "Create an Account",
            )),
        TextButton(
            onPressed: () => {Navigator.pop(context)},
            child: const Text(
              "Already Have an Account?",
            )),
      ],
    ));
  }
}
