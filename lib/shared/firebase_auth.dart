import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:endterm/models/user.dart' as model;        //user của class này trùng tên với instance user của firebase nên phải as
import 'package:endterm/shared/firebase_storage.dart';

class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance; 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SIGN UP METHOD
  Future<String> signUp({
    required String email,
    required String username,
    required String password,
    Uint8List? image    
    //có thể truyền vô file null (tức là không có ảnh)
    //khi đó thì gọi hàm uploadImgToStorage sẽ check, nếu có ảnh thì sẽ upload lên và trả về url của ảnh đó
    //nếu image mà null thì sẽ trả về String 'default avatar'
    //sau này trong profile của user sẽ check xem nếu photoUrl của user đó mà là 'default avatar'
    //thì networkImage của ng đó sẽ truyền link avt mặc định vô (lên mạng kiếm)
    }) async {
      String res = 'Sign Up Failed';
      try{
        if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty ){
          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
          //print(userCredential.user!.uid.toString());   //đăng kí, chưa lưu các thông tin khác lên database

          String photoUrl = await StorageMethods().uploadImgToStorage('avatarPics', image, false);

          model.User user = model.User(
            uid: userCredential.user!.uid,
            email: email,
            username: username,
            bio: '',
            followers: [],
            following: [],
            photoUrl: photoUrl,
          );
          //lưu thông tin username, avatar vô db
          await _firestore.collection('users').doc(userCredential.user!.uid).set(user.toJSON());
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);             //Bắt buộc phải có
          res = 'Sign Up Succeed';
        }
      } on FirebaseAuthException catch (error){
        if (error.code == 'email-already-in-use'){
          res = 'The email address is already in use by another account.';
        }
        else if (error.code == 'weak-password'){
          res = 'Password should be at least 6 characters.';
        }
        else if (error.code == 'invalid-email'){
          res = 'The email address is badly formatted.';
        }
        else{
          res = error.toString();
        }
      }
      return res;
  }

}