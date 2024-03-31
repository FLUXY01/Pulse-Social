import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulse_social/models/user.dart' as model;
import 'package:pulse_social/resources/storage_methods.dart';

class AuthMethod{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetail() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }


  // signUp method
    Future<String>signUp({
  required String email,
  required String password,
  required String username,
  required String bio,
  required Uint8List file,
})async{
      String res = "Some error occured";
      try{
        if(email.isNotEmpty || password.isNotEmpty
            || username.isNotEmpty || bio.isNotEmpty){
          // register user
          UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
          print(cred.user!.uid);

          String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);
          //add user to our database

          model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            photoUrl: photoUrl,
            followers: [],
            following: [],
          );


          await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson(),);
          res = "Success";
        }
      }
      catch(err){
        res = err.toString();
      }
      return res;
    }
    // Logging in user
    Future<String>loginUser({
      required String email,
      required String password,
    })async{
      String res = "Some error occured";
      try{
        if(email.isNotEmpty || password.isNotEmpty){
         _auth.signInWithEmailAndPassword(email: email, password: password);
         res = "Success";
        }
        else{
          res = "Please enter all the fields";
        }
      }
      catch(err){
        res = err.toString();
      }
      return res;
    }
  Future<void> signOut() async {
    await _auth.signOut();
  }
}