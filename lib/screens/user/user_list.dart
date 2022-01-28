import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_me/screens/add_user.dart';
import 'package:test_me/utils/app_color.dart';
import 'package:test_me/widgets/custom_textfield.dart';

class UserListScreen extends StatefulWidget {  
  static const String path = "/UserListScreen";
  const UserListScreen({ Key? key }) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List _users = [];

  Future getUsers()async{
   CollectionReference  instance =  FirebaseFirestore.instance.collection('users');
    instance.get().then((QuerySnapshot querySnapshot) {
        setState(() {
          _users = querySnapshot.docs;
        });
    });
  }
  int countTotalUser(List users){
    return users.length;
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        title: Text(
          "User List",
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.w500,
            color: AppColor.secondaryColor
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(Icons.person),
                    Text(
                      "Total User",
                      style: TextStyle(
                        fontSize: 14, 
                        fontWeight: FontWeight.w500,
                        color: AppColor.secondaryColor
                      ),
                    ),
                    Text(
                      "${countTotalUser(_users)}",
                      style: TextStyle(
                        fontSize: 14, 
                        fontWeight: FontWeight.w500,
                        color: AppColor.secondaryColor
                      ),
                    ),
                  ],
                ),

              ElevatedButton.icon(
                icon: Icon(
                  Icons.person_add,
                  color: AppColor.primaryColor,
                  size: 24.0,
                ),
                label: Text('Add new User'),
                onPressed: () {
                  Navigator.pushNamed(context, AddUserScreen.path);
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColor.secondaryColor,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(7.0),
                  ),
                ),
                ),
              ],
            ),
            SizedBox(height: 16,),
            CustomTextField(
              hintText: "Search...",
              prefixIcon: Icon(Icons.search),
            ),
            Divider(
              thickness: 1,
              color: AppColor.secondaryColor.withOpacity(0.25),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _users.length,
                itemBuilder: (context, index){
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage("${_users[index]["profile_image"]}")
                    ),
                    title: Text(
                      "${_users[index]["full_name"]}",
                      style: TextStyle(
                        fontSize: 17, 
                        fontWeight: FontWeight.w400,
                        color: AppColor.secondaryColor
                      ),
                    ),
                    subtitle:  Text(
                      "${_users[index]["email"]}",
                      style: TextStyle(
                        fontSize: 13, 
                        fontWeight: FontWeight.w400,
                        color: AppColor.secondaryColor.withOpacity(0.4)
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: (){
                        showDialog(
                          context: context, 
                          builder: (context)=> AlertDialog(
                            title: Text(
                              "Are you sure ?",
                            ),
                            content: Container(
                              height: 188,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Divider(
                                    thickness: 1,
                                    color: AppColor.secondaryColor,
                                  ),
                                ],
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.spaceBetween,
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey
                                ),
                                onPressed: (){}, 
                                child: Text("Cancel")
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent
                                ),
                                onPressed: (){}, 
                                child: Text("Confirm")
                              )
                            ],
                          )
                        );
                      },
                      child: Text(
                        'Remove',
                        style: TextStyle(
                          fontSize: 13, 
                          fontWeight: FontWeight.w400,
                          color: AppColor.secondaryColor
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(71, 32),
                        primary: AppColor.greyColor.withOpacity(0.50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7), // <-- Radius
                        ),
                      ),
                    ),
                  );
                }
              ),
            )
          ],
        ),
      ),

    );
  }
}