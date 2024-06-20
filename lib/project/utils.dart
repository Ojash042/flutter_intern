import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_intern/project/technical_models.dart' as t_models;

String getPrefixText(List<t_models.PostLikedBy> postLikedBy){
    return postLikedBy.isEmpty ?  "No one liked this" : postLikedBy.length==1 ? "1 person liked this." : '${postLikedBy.length} people liked this.';
}

Color getRndPastelColour() => HSLColor.fromAHSL(1, Random().nextInt(12).toDouble() * 28, (Random().nextInt(50)+30) /100, (Random().nextInt(20) + 70) / 100).toColor();
