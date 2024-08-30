// viewer_profile_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewerProfilePage extends StatelessWidget {
  final String userDocumentId;

  ViewerProfilePage({required this.userDocumentId});

  Future<DocumentSnapshot> getUserData() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocumentId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var profilePicUrl = userData['photoURL'];
          var followersCount = userData['followers'] ?? 0; // Get follower count

          return Scaffold(
            appBar: AppBar(
              title: Text("Viewer Profile Page"),
            ),
            body: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(profilePicUrl),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Name: ${userData['name'] ?? 'N/A'}",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    // Display the follower count
                    Text(
                      "Followers: $followersCount",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
