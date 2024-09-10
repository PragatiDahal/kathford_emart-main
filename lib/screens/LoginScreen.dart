import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:emart/services/Auth.dart';
import 'package:emart/widgets/Esnackbar.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // form key
  final _formKey = GlobalKey<FormState>();

  Future _login() async {
    await Auth()
        .login(_emailController.text, _passwordController.text)
        .then((value) => {
              if (value == true)
                {
                  Navigator.pushNamed(context, '/navbar'),
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                          id: 1,
                          channelKey: 'basic_channel',
                          title: 'Hey Man!',
                          body: 'Welcome to emart',))
                }
              else
                Esnackbar.show(context, "Login Failed!")
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                  hintText: 'Enter your password  ',
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  child: Text('Login')),
              Text("Dont have an account?"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text("Register"))
            ],
          ),
        ),
      ),
    );
  }
}
