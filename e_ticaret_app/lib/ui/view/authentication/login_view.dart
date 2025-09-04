import 'package:e_ticaret_app/core/color/color.dart';
import 'package:e_ticaret_app/core/model/user/user_auth_error.dart';
import 'package:e_ticaret_app/core/model/user/user_request.dart';
import 'package:e_ticaret_app/core/padding/padding.dart';
import 'package:e_ticaret_app/core/services/frebase_service.dart';
import 'package:e_ticaret_app/core/sized_box/sized_box.dart';
import 'package:e_ticaret_app/main.dart';

import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscureText = true;
  late String username;
  late String password;
  final String imageLogoURL = "assets/png/loginImage.png";
  final String titleAccount = "Login to your Account";
  final String userName = "User Name";
  final String passwordTitle = "Password";
  final String loginButton = "Login";
  final String errorText = "Unknown error";

  FirebaseService service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CostumColor.red,
      body: Stack(
        children: [
          Padding(
            padding: CustomPadding.leftPadding10 + CustomPadding.topPadding35,
            child: backIconButtonMethod(context),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: CustomPadding.topPadding50,
              child: Image.asset(imageLogoURL, fit: BoxFit.cover, height: CustomSizedBox.height250),
            ),
          ),
          Padding(
            padding: CustomPadding.topPadding300,
            child: CostumContainerWidget(titleAccount: titleAccount),
          ),

          Padding(
            padding: CustomPadding.topPadding380,
            child: Container(
              decoration: BoxDecoration(
                color: CostumColor.white,
                boxShadow: [BoxShadow(color: CostumColor.grey300, offset: const Offset(0.1, 1), blurRadius: 4)],

                borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              ),
              child: Padding(
                padding: CustomPadding.horizontalPadding60,
                child: Column(
                  children: [
                    Padding(
                      padding: CustomPadding.topPadding100 + CustomPadding.bottomPadding30,
                      child: usernameTextFieldMethod(context),
                    ),
                    passwordTextFieldMethod(context),
                    Spacer(),
                    Padding(padding: CustomPadding.verticalPadding50, child: elevatedButtonMethod(context)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton elevatedButtonMethod(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: CostumColor.blue900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Daha yuvarlak yapmak için sayıyı artırabilirsin
        ),
      ),
      onPressed: () => dataControlMethod(context),
      child: Center(
        child: Padding(
          padding: CustomPadding.paddingAll10,
          child: Text(
            loginButton,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: CostumColor.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<void> dataControlMethod(BuildContext context) async {
    {
      var result = await service.postUser(UserRequest(email: username, password: password, returnSecureToken: true));
      if (result is FirebaseAuthError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.error?.message ?? errorText)));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage()));
      }
    }
  }

  TextField passwordTextFieldMethod(BuildContext context) {
    return TextField(
      onChanged: (value) {
        setState(() {
          password = value;
        });
      },
      obscureText: _obscureText,

      decoration: InputDecoration(
        isDense: true, // daha kompakt yapars
        contentPadding: CustomPadding.verticalPadding5 + CustomPadding.horizontalPadding12,

        suffix: IconButton(
          padding: CustomPadding.zeroPadding,
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(_obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined),
        ),

        labelText: passwordTitle,
        labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: CostumColor.grey600),
        floatingLabelStyle: TextStyle(color: CostumColor.blue900),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: CostumColor.grey600, width: 1)),

        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: CostumColor.blue900, width: 2)),
      ),
    );
  }

  TextField usernameTextFieldMethod(BuildContext context) {
    return TextField(
      onChanged: (value) {
        setState(() {
          username = value;
        });
      },
      decoration: InputDecoration(
        labelText: userName,
        labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: CostumColor.grey600),
        floatingLabelStyle: TextStyle(color: CostumColor.blue900),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: CostumColor.grey600, width: 1)),

        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: CostumColor.blue900, width: 2)),
        border: OutlineInputBorder(),
      ),
    );
  }

  IconButton backIconButtonMethod(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_outlined, color: CostumColor.white),
    );
  }
}

class CostumContainerWidget extends StatelessWidget {
  const CostumContainerWidget({super.key, required this.titleAccount});

  final String titleAccount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CustomSizedBox.height200,
      decoration: BoxDecoration(
        color: CostumColor.grey300,
        boxShadow: [BoxShadow(color: CostumColor.grey300, offset: const Offset(0.1, 1), blurRadius: 4)],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      ),
      child: Center(
        child: Padding(
          padding: CustomPadding.bottomPadding110,
          child: Text(titleAccount, style: Theme.of(context).textTheme.headlineSmall),
        ),
      ),
    );
  }
}
