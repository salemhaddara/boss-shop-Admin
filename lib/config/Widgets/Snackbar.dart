import 'package:bossshopadmin/config/Widgets/text400normal.dart';
import 'package:bossshopadmin/core/theme/MyColors.dart';
import 'package:flutter/material.dart';

SnackBar showSnackbar(String text, Size size) {
  return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        width: size.width,
        constraints: const BoxConstraints(maxHeight: 100, minHeight: 50),
        decoration: BoxDecoration(
            color: orange,
            borderRadius: const BorderRadius.all(Radius.circular(25))),
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: text400normal(
            text: text,
            align: TextAlign.center,
            color: white,
            fontsize: 16,
          )),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 150,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.white),
          )
        ]),
      ));
}
