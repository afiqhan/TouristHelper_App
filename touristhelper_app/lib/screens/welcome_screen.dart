import 'package:flutter/material.dart';
import 'package:touristhelper_app/home/login.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/bendera.jpg'),
          fit: BoxFit.cover,
          opacity: 0.8,
        )),
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(vertical: 65, horizontal: 25),
          child: Column(
            children: [
              Text(
                "MALAYSIA",
                style: TextStyle(
                  color: Color.fromARGB(255, 4, 91, 126),
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Truly Asia !",
                style: TextStyle(
                  color: Color.fromARGB(255, 4, 91, 126).withOpacity(0.9),
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Welcome to the Malaysia " +
                    "Discover the rich tapestry of our heritage, savor the tantalizing flavors of Malaysian cuisine, and immerse yourself in the warmth of our people. Whether you're exploring ancient rainforests, marveling at modern architecture, or simply enjoying the laid-back atmosphere, Malaysia offers a kaleidoscope of experiences. The adventure is waiting !",
                style: TextStyle(
                  color: Colors.black.withOpacity(0),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 30),
              Material(
                color: Color.fromARGB(255, 2, 40, 88).withOpacity(0.7),
                clipBehavior: Clip.hardEdge, //when click that border, the inkwell will be smooth 
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(), //when click this get started it will go to the sign up
                          ));
                    },
                    child: Ink(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 20,
                        ))),
              )
            ],
          ),
        )),
      ),
    );
  }
}
