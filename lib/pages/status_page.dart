import 'package:animes/controllers/series_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusPage extends StatelessWidget {
  StatusPage({super.key});

  final controller = Get.put(SeriesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Obx(() {
              return Text(
                'Server Status: ${controller.serverStatus.name}',
                style: TextStyle(color: Colors.black),
              );
            })
          ],
        ),
      ),
    );
  }
}
