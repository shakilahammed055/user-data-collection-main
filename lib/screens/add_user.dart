import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_me/utils/app_color.dart';
import 'package:test_me/widgets/custom_button.dart';
import 'package:test_me/widgets/custom_textfield.dart';
enum Gender { Male, Female }  
class AddUserScreen extends StatefulWidget {
    static const String path = "/AddUserScreen";
  const AddUserScreen({ Key? key }) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
    Gender? _gender = Gender.Male; 
  var imagePath;
  var imageUrl;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  bool isLoading = false;

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
    setState(() {
      isLoading = true;
    });
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
          .then((value) => Navigator.pop(context))
          .catchError((error) => print("Failed to add user: $error"));
      }catch(e){
        print(e);
      }

      setState(() {
        isLoading = false;
      });

    }







  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          centerTitle: true,
          title: Text(
            "Add new user",
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w500,
              color: AppColor.secondaryColor
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                isLoading ? Center(child:  CircularProgressIndicator(),) :  CustomButton(
                  onTap: (){
                     createProfile(
                      nameController.text,
                      emailController.text,
                      mobileController.text,
                      _gender!.index.toString(),
                      imageUrl.toString()
                    );
                  },
                  color: AppColor.secondaryColor,
                  levelColor: AppColor.primaryColor,
                  buttonLevel: "Save",
                ),
                SizedBox(height: 24,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}