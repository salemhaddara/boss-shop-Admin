// ignore_for_file: must_be_immutable, camel_case_types

import 'package:bossshopadmin/config/Models/MyUser.dart';
import 'package:bossshopadmin/config/Widgets/text600normal.dart';
import 'package:bossshopadmin/core/theme/MyColors.dart';
import 'package:flutter/material.dart';

class basicInfo extends StatefulWidget {
  MyUser user;
  basicInfo({super.key, required this.user});

  @override
  State<basicInfo> createState() => _basicInfoState();
}

class _basicInfoState extends State<basicInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: homebackgrey,
          borderRadius: const BorderRadius.all(Radius.circular(14))),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        Divider(
          height: 2,
          color: darkblack,
        ),
        text600normal(
          text: 'Name: ${widget.user.name}',
          fontsize: 18.0,
          color: Colors.black,
          align: TextAlign.center,
        ),
        text600normal(
          text: 'ID: ${widget.user.id}',
          fontsize: 18.0,
          color: Colors.black,
          align: TextAlign.center,
        ),
        text600normal(
          text: 'Email: ${widget.user.email}',
          fontsize: 18.0,
          color: Colors.black,
          align: TextAlign.center,
        ),
      ]),
    );
  }
}
