import 'package:endterm/constants/colors.dart';
import 'package:endterm/views/profile_screen.dart';
import 'package:flutter/material.dart';

class LikeCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const LikeCard({Key? key, required this.snap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                uid: snap['uid'],
                myProfile: false,
              ),
            ),
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                snap['photoUrl'],
              ),
              radius: 18,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: snap['username'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: cblack)),
                      ],
                    ),
                  ),
                  Text(snap['bio'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, color: subText))
                ],
              ),
            )),
            // Padding(
            //   padding: const EdgeInsets.only(top: 2),
            //   child: TextButton(
            //     //  Follow người dùng
            //     onPressed: () {},
            //     child: const Text("Follow"),
            //     style: TextButton.styleFrom(
            //       padding: const EdgeInsets.only(left: 10, right: 10),
            //       backgroundColor: secondary,
            //       primary: Colors.white,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(5.0)),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
