import 'package:flutter/material.dart';
import 'package:work_together_flutter/models/user_models/new_user.dart';

import '../../../http_request.dart';
import '../../../main_container.dart';
import '../../../models/user_models/user.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  void validateInformation() {
    bool areAnyFieldsEmpty = emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        nameController.text.isEmpty;

    bool arePasswordsNotTheSame =
        passwordController.text != confirmPasswordController.text;

    if (areAnyFieldsEmpty || arePasswordsNotTheSame) {
      isButtonActive = false;
    } else {
      isButtonActive = true;
    }

    setState(() {});
  }

  bool isButtonActive = false;
  bool showErrorMessage = false;

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
            controller: nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            onChanged: (name) {
              validateInformation();
            },
            decoration: InputDecoration(
                hintText: "name",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Color(0xFF1192DC), width: 5.0))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: (email) {
              validateInformation();
            },
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
            onChanged: (password) {
              validateInformation();
            },
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
            controller: confirmPasswordController,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            onChanged: (confirmedPassword) {
              validateInformation();
            },
            obscureText: true,
            decoration: InputDecoration(
                hintText: "confirm password",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Color(0xFF1192DC), width: 5.0))),
          ),
        ),
        if (showErrorMessage)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "An error has occurred while registering.",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ElevatedButton(
            onPressed: !isButtonActive
                ? null
                : () async {
                    NewUser newUser = NewUser(
                        name: nameController.text,
                        password: passwordController.text,
                        email: emailController.text,
                        bio: "",
                        employmentStatus: "Unemployed",
                        studentStatus: "Full Time Student",
                        interests: [],
                        major: "Undeclared");

                    if (await HttpService().registerUser(newUser)) {
                      if (context.mounted) {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return const MainContainer();
                          },
                        ));
                      }
                    } else {
                      showErrorMessage = true;
                      setState(() {});
                    }
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
