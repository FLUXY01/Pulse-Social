import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pulse_social/responsive/mobile_screen_layout.dart';
import 'package:pulse_social/responsive/responsive_screen_layout.dart';
import 'package:pulse_social/responsive/web_screen_layout.dart';
import 'package:pulse_social/screens/signup_screen_layout.dart';
import 'package:pulse_social/utils/utils.dart';
import 'package:pulse_social/widgets/text_field_input.dart';
import 'package:pulse_social/resources/auth_method.dart';
import 'package:pulse_social/utils/colors.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser()async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethod().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });
    if(res =="Success"){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
    else{
      showSnackBar(res, context);
    }
  }

  void navigateToSignup(){
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Container(), flex:0),
                //Image
                Image(image: AssetImage("assets/pulse.png")),
                const SizedBox(height: 50,),
                //TextFieldInput
                TextFieldInput(
                    textEditingController: _emailController,
                    hintText: 'Enter Your Email',
                    textInputType: TextInputType.emailAddress,),
                const SizedBox(height:40,),
                //textfield input for password
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Enter Your password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height:40,),
                //button login
                InkWell(
                  onTap: loginUser,
                  child: Container(
                    child: _isLoading? const
                    Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ):
                      const Text("Log in"),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4),
                        ),
                      ),
                      color: blueColor
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                //Transitioning to signup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text('Dont have an account?'),
                      padding: const EdgeInsets.symmetric(vertical: 8,),
                    ),
                    GestureDetector(
                      onTap: navigateToSignup,
                      child: Container(
                        child: const Text('Sign Up.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                        padding: const EdgeInsets.symmetric(vertical: 8,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}