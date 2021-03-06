import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_storage.dart';
import '../models/post.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload Post
  Future<String> uploadPost(
    String uid,
    String description,
    Uint8List image,    //đây là file truyền vô để upload lên storage
  ) async {

    String res = 'Upload Failed';

    try{
      String photoUrl = await StorageMethods().uploadImgToStorage('postPics', image, true); //up ảnh bài post lên storage
      String postId = const Uuid().v1();

      Post post = Post(
          uid: uid,
          postId: postId,
          description: description,
          uploadDate: DateTime.now(),
          postUrl: photoUrl,
          likes: []);

      _firestore.collection('posts').doc(postId).set(post.toJSON());    //up post lên firebase

      res = 'Upload Succeed';
    } 
    catch(error){
      res = error.toString();
    }

    return res;
  }


  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      }
      else{
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } 
    catch(error){
      log(error.toString());
    }
  }

  Future<void> uploadComment(
    String postId, 
    String uid, 
    String username,
    String avatarUrl, 
    String comment) async {

    try{
      if (comment.isNotEmpty){
        String commentId = const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'commentId':commentId,
          'uid': uid,
          'username': username,
          'avatarUrl': avatarUrl,
          'comment': comment,
          'uploadDate': DateTime.now(),
        });
      }
      else{
        log('Comment is empty!!');
      }
    }
    catch(error){
      log(error.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try{
      await _firestore.collection('posts').doc(postId).delete();
    } 
    catch(error){
      log(error.toString());
    }
  }

  Future<void> updateCaption(String postId, String newCaption) async {
    try {
      if (newCaption.isNotEmpty) {
        await _firestore.collection('posts').doc(postId).update({
          'description': newCaption,
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> followUser(String currentUser, String followUser) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(followUser).get();
      List followers = (snapshot.data() as dynamic)['followers'];

      if (followers.contains(currentUser)){
        await _firestore.collection('users').doc(followUser).update({'followers' : FieldValue.arrayRemove([currentUser])});
        
        await _firestore.collection('users').doc(currentUser).update({'following' : FieldValue.arrayRemove([followUser])});

      }
      else{
        await _firestore.collection('users').doc(followUser).update({'followers' : FieldValue.arrayUnion([currentUser])});

        await _firestore.collection('users').doc(currentUser).update({'following' : FieldValue.arrayUnion([followUser])});
      }
    }
    catch (error) {
      log(error.toString());
    }
  }
}