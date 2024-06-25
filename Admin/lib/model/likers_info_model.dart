import 'package:flutter/material.dart';
import 'package:hookup4u_admin/model/user_model.dart';

class LikersInfoModel {
  final String? svgSrc, title;
  final int? count;
  final Color? color;
  final User? userIndex;

  LikersInfoModel({
    this.userIndex,
    this.svgSrc,
    this.title,
    this.count,
    this.color,
  });
}
