import 'package:e_ticaret_app/core/model/user/user_auth_error.dart';
import 'package:e_ticaret_app/core/model/user/user_request.dart';
import 'package:e_ticaret_app/core/services/frebase_service.dart';
import 'package:e_ticaret_app/ui/view/home/fire_home_view.dart';

import 'package:flutter/material.dart';

class LoginPageDemo extends StatefulWidget {
  const LoginPageDemo({super.key});

  @override
  State<LoginPageDemo> createState() => _LoginPageDemoState();
}

class _LoginPageDemoState extends State<LoginPageDemo> {
  bool _obscureText = true;
  late String username;
  late String password;
  FirebaseService service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Image.asset("assets/png/loginImage.png", fit: BoxFit.cover, height: 250),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 300),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                boxShadow: const [
                  BoxShadow(color: Color.fromARGB(255, 192, 192, 192), offset: Offset(0.1, 1), blurRadius: 4),
                ],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 110),
                  child: Text("Login to your Account", style: Theme.of(context).textTheme.headlineSmall),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 380),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Color.fromARGB(255, 192, 192, 192), offset: Offset(0.1, 1), blurRadius: 4),
                ],

                borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100, bottom: 30),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "User Name",
                          labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                          floatingLabelStyle: TextStyle(color: Colors.greenAccent.shade700),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1)),

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent.shade700, width: 2),
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      obscureText: _obscureText,

                      decoration: InputDecoration(
                        isDense: true, // daha kompakt yapars
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),

                        suffix: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(_obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        ),

                        labelText: "Password",
                        labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                        floatingLabelStyle: TextStyle(color: Colors.greenAccent.shade700),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1)),

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.greenAccent.shade700, width: 2),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent.shade700),
                        onPressed: () async {
                          var result = await service.postUser(
                            UserRequest(email: username, password: password, returnSecureToken: true),
                          );
                          if (result is FirebaseAuthError) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(result.error?.message ?? "Unknown error")));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => FireHomeView()));
                          }
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Login",
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
