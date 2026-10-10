import 'package:flutter/material.dart';

const brandTeal = Color.fromARGB(255, 58, 181, 183);
const brandPink = Color.fromARGB(255, 243, 0, 196);
const brandBlue = Color.fromARGB(255 ,67,0,252);

const brandGradient = LinearGradient(
  colors: [brandPink, brandBlue],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const cornerRadius = BorderRadius.all(Radius.circular(12));