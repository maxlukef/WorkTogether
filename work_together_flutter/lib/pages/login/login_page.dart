import 'package:flutter/material.dart';
import 'package:work_together_flutter/pages/login/components/login_form.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 675,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: SvgPicture.asset("assets/images/logo.svg"),
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 8,
                      child: LoginForm(),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
