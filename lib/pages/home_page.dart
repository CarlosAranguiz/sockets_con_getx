import 'package:animes/controllers/series_controller.dart';
import 'package:animes/models/anime.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final SeriesController seriesController = Get.put(SeriesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 7,
        title: Text(
          'Anime App',
          style: TextStyle(
              color: Colors.orange.shade700,
              fontFamily: GoogleFonts.lato().fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: 26),
        ),
        backgroundColor: Colors.grey.shade900,
        actions: [
          Obx(
            () => Container(
              margin: EdgeInsets.only(right: 10),
              child: seriesController.serverStatus == ServerStatus.Online
                  ? Icon(
                      Icons.flash_on_outlined,
                      color: Colors.orange,
                    )
                  : Icon(
                      Icons.offline_bolt,
                      color: Colors.white,
                    ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey.shade900,
      body: Column(
        children: [
          Expanded(child: Obx(() => _showGraph())),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: seriesController.itemCount.value != 0
                    ? seriesController.itemCount.value
                    : seriesController.series.length,
                itemBuilder: (context, index) =>
                    _serieTile(seriesController.series[index]),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openDialogForm,
        backgroundColor: Colors.orange.shade100,
        elevation: 1,
        child: Icon(
          Icons.add,
          color: Colors.orange.shade900,
          size: 30,
        ),
      ),
    );
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    seriesController.seriesList.value.forEach((serie) {
      dataMap.putIfAbsent(
          serie.name, () => double.parse(serie.votes.toString()));
    });

    return seriesController.serverStatus == ServerStatus.Online
        ? Container(
            height: 300,
            child: PieChart(
              dataMap: dataMap,
              chartType: ChartType.disc,
              chartLegendSpacing: 10,
              legendOptions: LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.right,
                  legendTextStyle: TextStyle(color: Colors.white)),
            ))
        : CircularProgressIndicator();
  }

  Widget _serieTile(Serie serie) {
    return Dismissible(
      key: Key(serie.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => seriesController.removeSerie(serie.id),
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text("Delete Anime", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange[100],
          child: Text(
            serie.name.substring(0, 1).toUpperCase(),
            style: TextStyle(color: Colors.orange.shade900),
          ),
        ),
        title: Text(
          serie.name,
          style: TextStyle(
              color: Colors.orange.shade900, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(serie.type == 1 ? 'Anime' : 'Pelicula',
            style: TextStyle(
                color: Colors.orange.shade700, fontWeight: FontWeight.w700)),
        trailing: Text(serie.votes.toString(),
            style: TextStyle(
                color: Colors.orange.shade900, fontWeight: FontWeight.w700)),
        onTap: () => seriesController.addVoteSerie(serie.id),
      ),
    );
  }

  openDialogForm() {
    TextEditingController _nombre = TextEditingController();
    Get.defaultDialog(
      title: 'Add New Anime',
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _nombre,
        ),
      ),
      textConfirm: 'Add',
      confirmTextColor: Colors.white,
      onConfirm: () {
        seriesController.addNewSerie(_nombre.text.trim());
        Get.back();
      },
    );
  }
}
