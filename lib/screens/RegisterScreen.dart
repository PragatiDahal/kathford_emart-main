import 'package:emart/services/Auth.dart';
import 'package:emart/widgets/Esnackbar.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // controllers
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // form key
  final _formKey = GlobalKey<FormState>();

  void _register() {
    Auth()
        .register(
          _firstnameController.text,
          _lastnameController.text,
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        )
        .then((value) => {
              if (value == true)
                {Esnackbar.show(context, "Register successfull")}
            })
        .catchError((error) => Esnackbar.show(context, "Register Failed!"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter firstname';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter your firstname',
                    hintText: 'Enter your firstname  ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _lastnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter lastname';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter your lastname',
                    hintText: 'Enter your lastname  ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter your username',
                    hintText: 'Enter your username  ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    hintText: 'Enter your email  ',
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
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _register();
                      }
                    },
                    child: Text('Register')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
