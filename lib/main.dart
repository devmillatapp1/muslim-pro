import 'package:flutter/material.dart';
import 'package:muslim/app.dart';
import 'package:muslim/init_services.dart';

void main() async {
  await initServices();

  runApp(const App());
}
