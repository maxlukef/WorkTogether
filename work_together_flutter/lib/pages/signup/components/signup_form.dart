import 'package:flutter/material.dart';

import '../../../main_container.dart';

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
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            onSaved: (confirmedPassword) {},
            obscureText: true,
            decoration: InputDecoration(
                hintText: "confirm password",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Color(0xFF1192DC), width: 5.0))),
          ),
        ),
        ElevatedButton(
            onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const MainContainer();
                    },
                  ))
                },
            child: const Text(
              "Create an Account",
              style: TextStyle(fontSize: 24),
            )),
        TextButton(
            onPressed: () => {Navigator.pop(context)},
            child: const Text(
              "Already Have an Account?",
              style: TextStyle(fontSize: 24),
            )),
      ],
    ));
  }
}
