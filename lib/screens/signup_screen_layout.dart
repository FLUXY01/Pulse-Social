import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pulse_social/resources/auth_method.dart';
import 'package:pulse_social/responsive/mobile_screen_layout.dart';
import 'package:pulse_social/responsive/responsive_screen_layout.dart';
import 'package:pulse_social/responsive/web_screen_layout.dart';
import 'package:pulse_social/screens/login_screen_layout.dart';
import 'package:pulse_social/utils/utils.dart';
import 'package:pulse_social/utils/colors.dart';
import 'package:pulse_social/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  Future<void> selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }
  void signUpUser()async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethod().signUp(
      email: _emailController.text,
      password: _passwordController.text,
      username: _userNameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if(res!='Success'){
      showSnackBar(res,context);
    }
    else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }
  void navigateToLogin(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const loginScreen(),
      ),
    );
  }



  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
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
                Image(image: AssetImage("assets/pulse_signup.png")),
                const SizedBox(height: 5,),
                //circular widget
                Stack(
                  children: [
                    _image != null
                    ?CircleAvatar(
                      radius: 50,
                      backgroundImage: MemoryImage(_image!),
                    )
                    : const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage("https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg"),
                    ),
                    Positioned(
                    bottom: -9,
                    left: 60,
                      child: IconButton(onPressed: selectImage,
                      icon: const Icon
                      (Icons.add_a_photo
                      ),
                    ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                //TextFieldInput
                TextFieldInput(
                  textEditingController: _userNameController,
                  hintText: 'Enter Your username',
                  textInputType: TextInputType.text,),
                const SizedBox(height:30,),
                // Textfield input for email
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Enter Your Email',
                  textInputType: TextInputType.emailAddress,),
                const SizedBox(height:30,),
                //textfield input for password
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Enter Your password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height:30,),
                // for user input bio
                TextFieldInput(
                  textEditingController: _bioController,
                  hintText: 'Enter Your bio',
                  textInputType: TextInputType.text,),
                const SizedBox(height:30,),
                //button login
                InkWell(
                  onTap:signUpUser,
                  child: Container(
                    child: _isLoading? const
                    Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ):
                    const Text("Sign up"),
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
                const SizedBox(height: 10,),
                //Transitioning to signup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text('Already have an account?'),
                      padding: const EdgeInsets.symmetric(vertical: 8,),
                    ),
                    GestureDetector(
                      onTap: ()=> Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const loginScreen(),
                      ),
                    ),

                      child: Container(
                        child: const Text('Login.',
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