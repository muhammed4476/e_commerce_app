import 'package:e_ticaret_app/core/color/color.dart';
import 'package:e_ticaret_app/core/padding/padding.dart';
import 'package:e_ticaret_app/ui/view/authentication/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginFirst extends StatelessWidget {
  const LoginFirst({super.key});
  final String loginText = "Login to E_Ticaret";
  final String appName = "E_Ticaret";
  final String loginImagePath = "assets/png/loginImage.png";
  final String fontFamily = "Anton";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(systemOverlayStyle: SystemUiOverlayStyle.light, backgroundColor: Colors.transparent),
      backgroundColor: CostumColor.red,
      body: Center(
        child: Column(
          children: [
            textMethod(context),
            Padding(padding: CustomPadding.verticalPadding70, child: Image.asset(loginImagePath)),
            Expanded(
              child: Container(
                padding: CustomPadding.verticalPadding70 + CustomPadding.horizontalPadding20,
                decoration: containerDecarationMethod(),
                child: ElevatedButton(
                  style: ElevatedButtonStyleMethod(),
                  onPressed: () {
                    onPresedMethod(context);
                  },
                  child: Center(child: LoginTextMethod(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle ElevatedButtonStyleMethod() {
    return ElevatedButton.styleFrom(
      backgroundColor: CostumColor.blue900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Daha yuvarlak yapmak için sayıyı artırabilirsin
      ),
    );
  }

  Text LoginTextMethod(BuildContext context) {
    return Text(
      loginText,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: CostumColor.white, fontWeight: FontWeight.w900),
    );
  }

  void onPresedMethod(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0); // sağdan başla
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.ease);

          return SlideTransition(position: tween.animate(curvedAnimation), child: child);
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  BoxDecoration containerDecarationMethod() {
    return BoxDecoration(
      color: CostumColor.white,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
    );
  }

  Text textMethod(BuildContext context) {
    return Text(
      appName,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(fontFamily: fontFamily, color: CostumColor.white),
    );
  }
}
