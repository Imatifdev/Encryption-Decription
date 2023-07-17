// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'editprofile.dart';
import 'forgot.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileView extends StatelessWidget {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  ProfileView({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('UsersData')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;
          if (user == null) {
            return Text('User not found');
          }

          final name = user['First Name'];
          final email = user['Email'];

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 60,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  name,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 30.0),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    'Change Email',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    email,
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfile()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    'Change Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    name,
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfile()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    'Change Password',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '********',
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgitPassword()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                InkWell(
                  onTap: () => _signOut(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: Colors.red,
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Log out',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
