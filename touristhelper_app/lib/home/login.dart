import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:touristhelper_app/home/user.dart';
import 'package:touristhelper_app/screens/home_screen.dart';

import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();

  List<User> _users = [];

  final _formKey = GlobalKey<FormState>();
  bool _logState = false;
  String _logTextButton = 'Sign Up';
  String _logText = "Login";
  String _logScript = 'Already have an account ';
  void login() async {
    final url = Uri.https(firebaseUrl, "users.json");
    final response = await http.get(url);
    try {
      List<User> myUserList = [];
      if (response.statusCode == 200) {
        //  print(response.body);
        Map<String, dynamic> temp = json.decode(response.body);
        temp.forEach((key, value) {
          print(value['username']);
          myUserList.add(User(
              userId: key,
              displayName: value['username'],
              email: value['email'],
              password: value['password']));
        });
        for (final tempUser in myUserList) {
          if (tempUser.email.toString() == emailController.text.toString() &&
              tempUser.password.toString() ==
                  passwordController.text.toString()) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Successfully Logged in')));
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return HomePage(user: tempUser);
            }));
            return;
          }
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid username or password")));
      }
    } catch (e) {
      print(e);
    }
  }

  void signup() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.https(firebaseUrl, "users.json");

      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'username': usernameController.text,
              'email': emailController.text,
              'password': passwordController.text,
            },
          ));

      if (response.statusCode == 200) {
        Map<String, dynamic> userKey = json.decode(response.body);
        User signUpUser = User(
            userId: userKey['name'],
            displayName: usernameController.text,
            email: emailController.text,
            password: passwordController.text);

        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
          return HomePage(
            user: signUpUser,
          );
        }));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(_logTextButton),
        backgroundColor: Theme.of(context).primaryColorLight,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).orientation == Orientation.landscape
              ? MediaQuery.of(context).size.height * 2
              : MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('images/tugunegara.jpg'),
            fit: BoxFit.cover,
            opacity: 0.6,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: _logState
                        ? [
                            TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Email';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                            ),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Password';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                            )
                          ]
                        : [
                            TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Email';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                            ),
                            TextFormField(
                              controller: usernameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Username';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                            ),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Password';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                            ),
                            TextFormField(
                              controller: repasswordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Repassword';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Confirm password:'),
                            )
                          ],
                  ),
                ),
              ),
              SizedBox(height: !_logState ? 50 : 110),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(2.0, 7.0),
                              blurRadius: 30.0,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[100]),
                          child: Text(
                            _logTextButton,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          onPressed: () {
                            if (_logTextButton == "Sign Up") {
                              signup();
                            } else {
                              login();
                            }
                          },
                        ),
                      ),
                      SizedBox(height: !_logState ? 100 : 50),
                      TextButton(
                        child: RichText(
                          text: TextSpan(
                            text: _logScript,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: _logText,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _logState = !_logState;
                            _logTextButton = (_logState) ? "Login" : "Sign Up";
                            _logText = (!_logState) ? "Login" : "Sign Up";
                            _logScript = (!_logState)
                                ? 'Already have an account '
                                : 'Become a member and ';
                            usernameController.text = "";
                            repasswordController.text = "";
                          });
                        },
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
