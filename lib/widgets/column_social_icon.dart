import 'package:flutter/material.dart';

import '../theme/colors.dart';


Widget getAlbum(albumImg) {
  return Container(
    width: 38,
    height: 38,
    decoration: const BoxDecoration(
        // shape: BoxShape.circle,
        // color: black
        ),
    child: Stack(
      children: <Widget>[
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
        ),
        Center(
          child: Container(
            width: 33,
            height: 33,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(albumImg), fit: BoxFit.cover)),
          ),
        )
      ],
    ),
  );
}

Widget getIcons(icon, count, size) {
  // ignore: avoid_unnecessary_containers
  return Container(
    child: Column(
      children: <Widget>[
        Icon(icon, color: white, size: size),
        const SizedBox(
          height: 5,
        ),
        Text(
          count,
          style: const TextStyle(
              color: white, fontSize: 12, fontWeight: FontWeight.w700),
        )
      ],
    ),
  );
}

Widget getProfile(img) {
  // ignore: sized_box_for_whitespace
  return Container(
    width: 35,
    height: 45,
    child: Stack(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image:
                  DecorationImage(image: NetworkImage(img), fit: BoxFit.cover)),
        ),

      ],
    ),
  );
}
