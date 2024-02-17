import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touristhelper_app/home/user.dart';
import 'package:touristhelper_app/screens/home_screen.dart';
import 'package:touristhelper_app/themes/app_theme.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool loading = false;
  bool _hidePassword = true;

  void _registerUser() async {
    firstName = _firstNameController.text;
    _email = _emailController.text;
    _password = _passwordController.text;

    final url = Uri.https(firebaseUrl, 'users.json');
    try {
      final request = await http.get(url);
      final Map<String, dynamic> usersJson = json.decode(request.body);
      List<User> users = [];
      if (request.statusCode == 200) {
        for (final tempUsers in usersJson.entries) {
          users.add(
            User(
                userId: tempUsers.key.toString(),
                displayName: tempUsers.value['username'].toString(),
                email: tempUsers.value['email'].toString(),
                password: tempUsers.value['password'].toString()),
          );
          print("#Debug login_page.dart -> key for users = ${tempUsers.value['email']}");
        }
        bool repeatedUser = false;
        for(User user in users){
          print("Comparing: ${user.email} with $_email");
          if(user.email == _email){
            repeatedUser = true;
          }
        }
        print("Debug repeated user = $repeatedUser");
        if(!repeatedUser){
          final response = await http.post(url,
              headers: {
                'Content-Type': 'application/json',
              },
              body: json.encode(
                {
                  'username': "$firstName",
                  'email': _email,
                  'password': _password,
                },
              ));

          if (response.statusCode == 200) {
            final Map<String, dynamic> registerUser = json.decode(response.body);

            User user = User(
                userId: registerUser['name'],
                displayName: "$firstName",
                email: _email,
                password: _password);
            print(
                "#Debug signup_page.dart -> username is '$firstName'");
            print(
                "#Debug signup_page.dart -> userid is '${registerUser['name']}' ");
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (ctx) {
                  return HomePage(user: user);
                }), (route) => false);
          } else {
            print(
                'Debug sign up => Failed to load data. Status code: ${response.statusCode}');
            setState(() {
              _error = 'Failed to load data. Status code: ${response.statusCode}';
              loading = false;
            });
          }
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User Already in database')),
          );
        }
      } else {
        print("Debug signup -> can not load data for user auth");
      }
    } catch (error) {
      print('Error loading items: $error');
      setState(() {
        _error = error.toString();
        loading = false;
      });
    }
  }

  String firstName = '';
  String _error = '';
  String _password = '';
  String _email = '';

  Widget _buildFirstNameTF(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('First Name', style: theme.subtitleStyle),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: theme.textFieldDecoration,
          height: 60.0,
          child: TextFormField(
            controller: _firstNameController,
            validator: (val) => val == null || val.isEmpty
                ? 'First name cannot be empty.'
                : null,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: InputBorder.none,
                // contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(Icons.person, color: theme.blueDark),
                hintText: 'Enter your first name',
                hintStyle: theme.hintStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildLastNameTF(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Last Name',
          style: theme.subtitleStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: theme.textFieldDecoration,
          height: 60.0,
          child: TextFormField(
            onChanged: (value) => firstName = value,
            controller: _lastNameController,
            validator: (val) => val == null || val.isEmpty
                ? 'Last name cannot be empty.'
                : null,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: InputBorder.none,
                // contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(Icons.person, color: theme.blueDark),
                hintText: 'Enter your last name',
                hintStyle: theme.hintStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTF(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Email', style: theme.subtitleStyle),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: theme.textFieldDecoration,
          height: 60.0,
          child: TextFormField(
            onChanged: (value) => setState(() {
              _email = value;
            }),
            controller: _emailController,
            validator: (val) => val == null || val.isEmpty
                // ||!RegExp(r"^[A-Za-z0-9._%+-]+@pitt\.edu$").hasMatch(val)
                ? 'Please enter valid email.'
                : null,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: InputBorder.none,
                // contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(Icons.email, color: theme.blueDark),
                hintText: 'Enter your Email',
                hintStyle: theme.hintStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Password', style: theme.subtitleStyle),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: theme.textFieldDecoration,
          height: 60.0,
          child: TextFormField(
            onChanged: (value) => _password = value,
            controller: _passwordController,
            obscureText: _hidePassword,
            validator: (val) =>
                val == null || val.isEmpty ? 'Enter valid password' : null,
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.lock, color: theme.blueDark),
                suffixIcon: IconButton(
                  icon: Icon(
                      color: theme.blueDark,
                      _hidePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () async {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                ),
                hintText: 'Enter your Password',
                hintStyle: theme.hintStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpBtn(
    AppTheme theme,
    bool loading,
    // AuthService authService
  ) {
    return loading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            child: Container(
              decoration: theme.cardBodyDecoration,
              child: TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    _registerUser();
                  }
                },
                child: Text('SIGN UP', style: theme.titleStyle),
              ),
            ),
          );
  }

  Widget _buildSignInBtn(AppTheme theme) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route route) => false);
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: 'Already have an Account? ',
                style: theme.regularStyle.copyWith(color: theme.veryLight)),
            TextSpan(
                text: 'Sign In',
                style: theme.regularStyle.copyWith(
                    fontWeight: FontWeight.bold, color: theme.veryLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMsg(AppTheme theme) => Text(_error,
      style: theme.regularStyle.copyWith(color: Colors.red),
      textAlign: TextAlign.center);

  Widget _buildSpacing() => const SizedBox(height: 30);

  Widget _buildTitle(AppTheme theme) =>
      Text('Sign Up', style: theme.titleStyle.copyWith(fontSize: 40));

  @override
  Widget build(BuildContext context) {
    // final AuthService authService = Provider.of<AuthService>(context);
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    //const Widget spacing = SizedBox(height: 30);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: theme.boxDecorationWithBackgroudnImage),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildTitle(theme),
                        _buildSpacing(),
                        _buildFirstNameTF(theme),
                        _buildSpacing(),
                        _buildLastNameTF(theme),
                        _buildSpacing(),
                        _buildEmailTF(theme),
                        _buildSpacing(),
                        _buildPasswordTF(theme),
                        _buildSignUpBtn(
                          theme,
                          loading,
                        ),
                        _buildSignInBtn(theme),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}