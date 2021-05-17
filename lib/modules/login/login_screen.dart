import 'package:flutter/material.dart';
import 'package:udemy_flutter/shared/components/components.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  defaultFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'email Address Must not be empty';
                        }
                        return null;
                      },
                      label: 'Email Address',
                      prefix: Icons.email),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                    isPass: isPassword,
                    controller: passwordController,
                    type: TextInputType.visiblePassword,
                    suffix:
                        isPassword ? Icons.visibility : Icons.visibility_off,
                    suffixPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    validate: (value) {
                      if (value.isEmpty) {
                        return 'Password Must not be empty';
                      }
                      return null;
                    },
                    label: 'Password',
                    prefix: Icons.lock,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  defaultButton(
                    radius: 5.0,
                    text: 'Login',
                    function: () {
                      if (formKey.currentState.validate()) {
                        print('h');
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\t have an account'),
                      TextButton(onPressed: () {}, child: Text('Register Now'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
