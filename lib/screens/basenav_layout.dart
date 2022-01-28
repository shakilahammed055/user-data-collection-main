import 'package:flutter/material.dart';
import 'package:test_me/screens/profile.dart';
import 'package:test_me/screens/user/user_list.dart';
import 'package:test_me/utils/app_color.dart';


class BaseNavLayout extends StatefulWidget {
    static const String path = "/BaseNavLayout";
  const BaseNavLayout({ Key? key }) : super(key: key);

  @override
  State<BaseNavLayout> createState() => _BaseNavLayoutState();
}

class _BaseNavLayoutState extends State<BaseNavLayout> {
  int _currentIndex = 1;
  List<Widget> _pages = [
    ProfileScreen(),
    UserListScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_currentIndex),
      bottomNavigationBar: Container(                                             
        decoration: BoxDecoration(                                            
          borderRadius: BorderRadius.only(                                           
            topRight: Radius.circular(30), 
            topLeft: Radius.circular(30),
          ),            
          boxShadow: [                                                               
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),       
          ],                                                                         
        ),                                                                           
        child: ClipRRect(                                                            
          borderRadius: BorderRadius.only(                                           
          topLeft: Radius.circular(30.0),                                            
          topRight: Radius.circular(30.0),                                           
          ),                                                                         
          child: BottomNavigationBar( 
            currentIndex: _currentIndex,
            onTap: (int index){
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor:  AppColor.secondaryColor,    
            selectedItemColor: AppColor.primaryColor,  
            unselectedItemColor: AppColor.primaryColor,                                         
            items: [                                        
              BottomNavigationBarItem(                                               
                icon: Icon(Icons.exit_to_app), 
                label: "Exit".toUpperCase()
              ), 
               BottomNavigationBarItem(                                               
                icon: Icon(Icons.person), 
                label: "User".toUpperCase()
              ),            
              BottomNavigationBarItem(                                               
                icon: Icon(Icons.person), 
                label: "Profile".toUpperCase()
              )                
            ],                                                                       
          ),                                                                         
        )                                                                            
      )
    );
  }
}