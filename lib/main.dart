import 'package:animes/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AnimeApp',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.getHome(),
      getPages: AppRoutes.routes,
      theme: ThemeData(fontFamily: GoogleFonts.lato().fontFamily),
    );
  }
}
