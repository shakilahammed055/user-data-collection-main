
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_me/screens/basenav_layout.dart';
import 'package:test_me/utils/app_color.dart';
import 'package:test_me/widgets/custom_back_button.dart';
import 'package:test_me/widgets/custom_button.dart';
import 'package:test_me/widgets/custom_textfield.dart';
enum Gender { Male, Female }  
class SignUpScreen extends StatefulWidget {
   static const String path = "/SignUpScreen";
  const SignUpScreen({ Key? key }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Gender? _gender = Gender.Male; 
  var imagePath;
  var imageUrl;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  bool isLoading = false;

  Future signUp()async{
    setState(() {
      isLoading = true;
    });
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
      );
      if(userCredential.user != null){
        createProfile(
          nameController.text,
          emailController.text,
          mobileController.text,
          _gender!.index.toString(),
          imageUrl.toString()
        );
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



  Future pickedImage()async{
    final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
      if(image != null){
        setState(() {
          imagePath = File(image.path);
        });
        uploadProfileImage();
      }
    }

    Future uploadProfileImage() async {
      String image = imagePath.toString();
      var _image = image.split("/")[6];
      
      Reference reference = FirebaseStorage.instance.ref()
          .child('profileImage/${_image}');
      UploadTask uploadTask = reference.putFile(imagePath);

      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();

    }

   Future createProfile(fullName, email, mobile, gender,profileImage )async{
    
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    try{
      return users
        .add({
          'full_name': fullName,
          'email': email, 
          'mobile': mobile ,
          'gender': gender,
          'profile_image': profileImage
        })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
      }catch(e){
        print(e);
      }

    }


  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.primaryColor,
          leadingWidth: 100,
          leading: CustomBackButton(),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 32, 
                    fontWeight: FontWeight.w400,
                    color: AppColor.secondaryColor
                  ),
                ),
                Center(
                  child: Stack(
                    children: [
                     imagePath != null ? CircleAvatar(
                        radius: 36,
                        backgroundImage :  FileImage(imagePath) 
                      ) : CircleAvatar(
                        radius: 36,
                        backgroundImage :  AssetImage("assets/image/profile.jpg")  
                      ),
                      Transform.translate(
                        offset: Offset(
                          -20, 45
                        ),
                        child: ElevatedButton(
                           onPressed: () {
                             pickedImage();
                           },
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(), 
                              primary: AppColor.secondaryColor
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 102,),
                CustomTextField(
                  controller: nameController,
                  hintText: "Name",
                ),
                SizedBox(height: 12,),
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
                SizedBox(height: 12,),
                CustomTextField(
                  controller: mobileController,
                  hintText: "Enter Mobile Number",
                ),
               SizedBox(height: 14,),
                 Text(
                  "Gender",
                  style: TextStyle(
                    fontSize: 19, 
                    fontWeight: FontWeight.w400,
                    color: AppColor.secondaryColor
                  ),
                ),
                SizedBox(height: 12,),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Male",
                          style: TextStyle(
                            fontSize: 19, 
                            fontWeight: FontWeight.w400,
                            color: AppColor.secondaryColor
                          ),
                        ),
                        Radio(  
                          value: Gender.Male,  
                          groupValue: _gender,  
                          onChanged: (Gender? value) {  
                            setState(() {  
                              _gender = value;  
                            });  
                          },  
                        ),
                      ],
                    ), 
                    SizedBox(width: 43,),
                    Row(
                      children: [
                        Text(
                          "Female",
                          style: TextStyle(
                            fontSize: 19, 
                            fontWeight: FontWeight.w400,
                            color: AppColor.secondaryColor
                          ),
                        ),
                        Radio(  
                          value: Gender.Female,  
                          groupValue: _gender,  
                          onChanged: (Gender? value) {  
                            setState(() {  
                              _gender = value;  
                            });  
                          },  
                        ),
                      ],
                    ),  
                  ],
                ),
                SizedBox(height: 32,),
                isLoading ? Center(child: CircularProgressIndicator()) : CustomButton(
                  onTap: (){
                    signUp();
                  },
                  color: AppColor.secondaryColor,
                  levelColor: AppColor.primaryColor,
                  buttonLevel: "Sign up",
                ),
                SizedBox(height: 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.w500,
                        color: AppColor.secondaryColor
                      ),
                    ),
                    TextButton(
                      onPressed: (){}, 
                      child:  Text(
                      "Login",
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
      ),
    );
  }
}