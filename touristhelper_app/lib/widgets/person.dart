import 'package:flutter/material.dart';
import 'package:touristhelper_app/home/user.dart';
import 'package:touristhelper_app/home_bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PersonPage extends StatefulWidget {
  final User user;

  PersonPage({super.key, required this.user});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  TextEditingController passwordController = TextEditingController();

  TextEditingController usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isEditing = false;
  Icon edit = Icon(Icons.edit),
      delete = Icon(Icons.disabled_by_default_outlined);

  @override
  void initState() {
    usernameController = TextEditingController(text: widget.user.displayName);
    passwordController = TextEditingController(text: widget.user.password);
    super.initState();
  }

  void SubmitUserInfo() async {
    final url = Uri.https(firebaseUrl, "users/${widget.user.userId}.json");
    if (_formKey.currentState!.validate()) {
      final response = await http.patch(url,
          body: json.encode({
            "username": usernameController.text,
            'password': passwordController.text,
          }));
      if (response.statusCode == 200) {
        setState(() {
          widget.user.displayName = usernameController.text;
          widget.user.password = passwordController.text;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User info updated successfully")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      bottomNavigationBar: HomeBottomBar(
        user: widget.user,
      ),

      

      backgroundColor: Color.fromARGB(255, 140, 140, 226),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: ElevatedButton(
                          onPressed: () {
                            if (!isEditing) {
                              setState(() {
                                isEditing = true;
                              });
                            } else {
                              setState(() {
                                isEditing = false;
                              });
                            }
                          },
                          child: isEditing ? delete : edit),
                    )
                  ],
                ),
                CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 64,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome ${widget.user.displayName.toUpperCase()} 👋🏻',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tourist Helper App',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                if (isEditing)
                  Form(
                      key: _formKey,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: usernameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Username can not be empty';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                            ),
                            TextFormField(
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password can not be empty';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      SubmitUserInfo();
                                    },
                                    child: Text("Submit")),
                                ElevatedButton(
                                    onPressed: () {
                                      if (!isEditing) {
                                        setState(() {
                                          isEditing = true;
                                        });
                                      } else {
                                        setState(() {
                                          isEditing = false;
                                        });
                                      }
                                    },
                                    child: Text("Cancel"))
                              ],
                            )
                          ],
                        ),
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
