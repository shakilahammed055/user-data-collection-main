import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_me/screens/basenav_layout.dart';
import 'package:test_me/utils/app_color.dart';
import 'package:test_me/widgets/custom_back_button.dart';
import 'package:test_me/widgets/custom_button.dart';
import 'package:test_me/widgets/custom_textfield.dart';
class SignInScreen extends StatefulWidget {
  static const String path = "/SignInScreen";
  const SignInScreen({ Key? key }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;
  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future signIn()async{
    setState(() {
      isLoading = true;
    });
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
      );
      if(userCredential.user != null){
        Route route = MaterialPageRoute(builder: (ctx)=> BaseNavLayout());
        Navigator.push(context, route);
      }
    }catch(e){
      print("Error: $e");
    }
    setState(() {
      isLoading = false;
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.primaryColor,
        leadingWidth: 100,
        leading: CustomBackButton(
          onTap: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.w400,
                  color: AppColor.secondaryColor
                ),
              ),
              SizedBox(height: 12,),
              Text(
                "Enter your email address and password to access your account",
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.w400,
                  color: AppColor.secondaryColor
                ),
              ),
              SizedBox(height: 102,),
              CustomTextField(
                controller: emailController,
                hintText: "Email",
              ),
              SizedBox(height: 12,),
              CustomTextField(
                controller: passwordController,
                obscureText: true,
                hintText: "Password",
                suffixIcon: Icon(Icons.visibility),
              ),
              SizedBox(height: 59,),
              isLoading? Center(child: CircularProgressIndicator()) : CustomButton(
                onTap: (){
                  signIn();
                },
                color: AppColor.secondaryColor,
                levelColor: AppColor.primaryColor,
                buttonLevel: "Login",
              ),
              // Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Text(
                    "Don’t have an account?",
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w500,
                      color: AppColor.secondaryColor
                    ),
                  ),
                  TextButton(
                    onPressed: (){}, 
                    child:  Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w500,
                      color: AppColor.accentColor
                    ),
                  ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


