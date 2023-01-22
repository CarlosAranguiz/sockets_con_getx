import 'package:animes/models/anime.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SeriesController extends GetxController {
  Rx<List<Serie>> seriesList = Rx<List<Serie>>([]);

  Rx<ServerStatus> _serverStatus = ServerStatus.Connecting.obs;
  RxInt itemCount = 0.obs;

  late IO.Socket _socket;

  List<Serie> get series => seriesList.value;
  ServerStatus get serverStatus => this._serverStatus.value;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  @override
  void onInit() {
    _initConfig();
    super.onInit();
  }

  @override
  void onClose() {
    _socket.disconnect();
    super.onClose();
  }

  void _initConfig() {
    this._socket = IO.io('http://localhost:3001', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    this._socket.on('connect', (data) {
      print('Connect');
      this._serverStatus.value = ServerStatus.Online;
    });
    this._socket.on('disconnect', (_) {
      print('Disconnect');
      this._serverStatus.value = ServerStatus.Offline;
      update();
    });
    this._socket.on('nuevo-mensaje', (payload) {
      print('Nuevo Mensaje: $payload');
    });
    this._socket.on('active-series', (payload) {
      this.seriesList.value =
          (payload as List).map((e) => Serie.fromMap(e)).toList();
      this.itemCount.value = this.seriesList.value.length;
    });
  }

  addNewSerie(String nombre) {
    // var newId = int.parse(this.series.last.id) + 1;
    this._socket.emit('add-serie', {'name': nombre});
  }

  addVoteSerie(String idSerie) {
    this._socket.emit('vote-serie', {'id': idSerie});
  }

  removeSerie(String id) {
    this.series.removeWhere((element) => element.id == id);
    this._socket.emit('delete-serie', {'id': id});
  }
}
