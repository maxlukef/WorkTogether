import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:work_together_flutter/pages/signup/components/signup_form.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                width: 250,
                child: SvgPicture.asset("assets/images/logo.svg"),
              ),
              Row(
                children: const [
                  Spacer(),
                  Expanded(
                    flex: 8,
                    child: SignupForm(),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ));
  }
}
