import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cybersquare/core/constants/colors.dart';

Widget progressIndicator(){
  return LoadingAnimationWidget.fourRotatingDots(
    color: color_cybersquare_red, size: 40);
}